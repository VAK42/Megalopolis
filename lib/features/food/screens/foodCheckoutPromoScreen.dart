import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/foodProvider.dart';
import '../../../providers/authProvider.dart';
import '../../../shared/widgets/appButton.dart';
import '../constants/foodConstants.dart';
class FoodCheckoutPromoScreen extends ConsumerStatefulWidget {
 const FoodCheckoutPromoScreen({super.key});
 @override
 ConsumerState<FoodCheckoutPromoScreen> createState() => _FoodCheckoutPromoScreenState();
}
class _FoodCheckoutPromoScreenState extends ConsumerState<FoodCheckoutPromoScreen> {
 final promoController = TextEditingController();
 String? appliedPromo;
 bool promoValid = false;
 @override
 void dispose() {
  promoController.dispose();
  super.dispose();
 }
 void _checkPromo() {
  final code = promoController.text.trim().toUpperCase();
  if (code.isNotEmpty) {
   setState(() {
    appliedPromo = code;
    promoValid = true;
   });
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${FoodConstants.promoApplied} $code'), backgroundColor: AppColors.success));
  }
 }
 Future<void> _placeOrder() async {
  final userId = ref.read(currentUserIdProvider) ?? '1';
  final cartItems = ref.read(foodCartProvider(userId)).valueOrNull ?? [];
  if (cartItems.isEmpty) {
   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(FoodConstants.cartEmpty)));
   return;
  }
  final total = cartItems.fold<double>(0, (sum, item) => sum + (((item['price'] ?? 0) as num) * ((item['quantity'] ?? 1) as int)));
  final order = {
   'id': 'food_${DateTime.now().millisecondsSinceEpoch}',
   'userId': userId,
   'total': total,
   'status': FoodConstants.statusPending,
   'orderType': 'food',
   'address': 'Delivery Address',
   'paymentMethod': 'Cash On Delivery',
   'promoCode': appliedPromo,
   'createdAt': DateTime.now().millisecondsSinceEpoch,
  };
  await ref.read(foodRepositoryProvider).placeOrder(order);
  await ref.read(foodCartProvider(userId).notifier).clearCart();
  if (mounted) context.go(Routes.foodOrderPlaced);
 }
 @override
 Widget build(BuildContext context) {
  final promotionsAsync = ref.watch(foodPromotionsProvider);
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.foodCheckoutAddress)),
    title: const Text(FoodConstants.promoTitle),
   ),
   body: Column(
    children: [
     Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
       children: [
        Expanded(
         child: TextField(
          controller: promoController,
          decoration: InputDecoration(
           hintText: FoodConstants.promoHint,
           prefixIcon: const Icon(Icons.local_offer),
           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
           suffixIcon: promoValid ? const Icon(Icons.check_circle, color: AppColors.success) : null,
          ),
          textCapitalization: TextCapitalization.characters,
         ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(onPressed: _checkPromo, child: const Text(FoodConstants.check)),
       ],
      ),
     ),
     if (appliedPromo != null)
      Container(
       margin: const EdgeInsets.symmetric(horizontal: 16),
       padding: const EdgeInsets.all(12),
       decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
       child: Row(
        children: [
         const Icon(Icons.check_circle, color: AppColors.success),
         const SizedBox(width: 8),
         Text('${FoodConstants.promoApplied} $appliedPromo', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
        ],
       ),
      ),
     Expanded(
      child: promotionsAsync.when(
       data: (promos) => promos.isEmpty
         ? const Center(child: Text(FoodConstants.noPromosAvailable))
         : ListView.builder(
           padding: const EdgeInsets.all(16),
           itemCount: promos.length,
           itemBuilder: (context, index) {
            final promo = promos[index];
            final code = promo['code']?.toString() ?? '';
            return Card(
             margin: const EdgeInsets.only(bottom: 12),
             child: ListTile(
              leading: const Icon(Icons.local_offer, color: AppColors.primary),
              title: Text(code, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(promo['description']?.toString() ?? FoodConstants.specialOffer),
              trailing: ElevatedButton(
               onPressed: () {
                promoController.text = code;
                _checkPromo();
               },
               child: const Text(FoodConstants.use),
              ),
             ),
            );
           },
          ),
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (_, __) => const Center(child: Text(FoodConstants.noPromosAvailable)),
      ),
     ),
     Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)]),
      child: AppButton(text: FoodConstants.placeOrder, onPressed: _placeOrder),
     ),
    ],
   ),
  );
 }
}