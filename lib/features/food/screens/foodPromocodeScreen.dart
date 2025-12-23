import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/foodProvider.dart';
import '../constants/foodConstants.dart';
class FoodPromocodeScreen extends ConsumerStatefulWidget {
 const FoodPromocodeScreen({super.key});
 @override
 ConsumerState<FoodPromocodeScreen> createState() => _FoodPromocodeScreenState();
}
class _FoodPromocodeScreenState extends ConsumerState<FoodPromocodeScreen> {
 final TextEditingController codeController = TextEditingController();
 String? appliedCode;
 @override
 Widget build(BuildContext context) {
  final promotionsAsync = ref.watch(foodPromotionsProvider);
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(FoodConstants.promocodeTitle),
   ),
   body: Column(
    children: [
     Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
       children: [
        Expanded(
         child: TextField(
          controller: codeController,
          decoration: InputDecoration(
           hintText: FoodConstants.promoHint,
           prefixIcon: const Icon(Icons.local_offer),
           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          textCapitalization: TextCapitalization.characters,
         ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(onPressed: () => setState(() => appliedCode = codeController.text), child: const Text(FoodConstants.applyPromo)),
       ],
      ),
     ),
     if (appliedCode != null)
      Container(
       margin: const EdgeInsets.symmetric(horizontal: 16),
       padding: const EdgeInsets.all(12),
       decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success),
       ),
       child: Row(
        children: [
         const Icon(Icons.check_circle, color: AppColors.success),
         const SizedBox(width: 12),
         Expanded(
          child: Text('Code "$appliedCode" Applied!', style: const TextStyle(fontWeight: FontWeight.bold)),
         ),
         IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => setState(() => appliedCode = null)),
        ],
       ),
      ),
     const SizedBox(height: 16),
     Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
       alignment: Alignment.centerLeft,
       child: Text(FoodConstants.availablePromos, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
     ),
     const SizedBox(height: 12),
     Expanded(
      child: promotionsAsync.when(
       data: (promotions) => promotions.isEmpty
         ? const Center(child: Text(FoodConstants.noPromosAvailable))
         : ListView.builder(
           padding: const EdgeInsets.all(16),
           itemCount: promotions.length,
           itemBuilder: (context, index) {
            final promo = promotions[index];
            return Card(
             margin: const EdgeInsets.only(bottom: 12),
             child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
               children: [
                Container(
                 padding: const EdgeInsets.all(12),
                 decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(8)),
                 child: const Icon(Icons.local_offer, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                 child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Text(
                    promo['code']?.toString() ?? FoodConstants.promo,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                   ),
                   const SizedBox(height: 4),
                   Text(promo['description']?.toString() ?? FoodConstants.specialOffer, style: const TextStyle(fontWeight: FontWeight.w600)),
                   Text('Valid Until ${promo['endDate'] ?? 'N/A'}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                 ),
                ),
                OutlinedButton(
                 onPressed: () {
                  codeController.text = promo['code']?.toString() ?? '';
                  setState(() => appliedCode = promo['code']?.toString());
                 },
                 child: const Text(FoodConstants.applyPromo),
                ),
               ],
              ),
             ),
            );
           },
          ),
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (_, __) => Center(child: Text(FoodConstants.noPromosAvailable)),
      ),
     ),
    ],
   ),
  );
 }
}