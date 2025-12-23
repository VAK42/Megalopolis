import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/foodProvider.dart';
import '../constants/foodConstants.dart';
class FoodCheckoutPromoScreen extends ConsumerWidget {
 const FoodCheckoutPromoScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final promoController = TextEditingController();
  final promotionsAsync = ref.watch(foodPromotionsProvider);
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
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
          ),
          textCapitalization: TextCapitalization.characters,
         ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
         onPressed: () {
          context.pop(promoController.text);
         },
         child: const Text(FoodConstants.applyPromo),
        ),
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
            return Card(
             margin: const EdgeInsets.only(bottom: 12),
             child: ListTile(
              leading: const Icon(Icons.local_offer, color: AppColors.primary),
              title: Text(promo['code']?.toString() ?? FoodConstants.promo, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(promo['description']?.toString() ?? FoodConstants.specialOffer),
              trailing: ElevatedButton(onPressed: () => context.pop(promo['code']?.toString()), child: const Text(FoodConstants.use)),
             ),
            );
           },
          ),
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (_, __) => const Center(child: Text(FoodConstants.noPromosAvailable)),
      ),
     ),
    ],
   ),
  );
 }
}