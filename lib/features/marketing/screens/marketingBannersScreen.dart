import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/marketingProvider.dart';
import '../../marketing/constants/marketingConstants.dart';
class MarketingBannersScreen extends ConsumerWidget {
 const MarketingBannersScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final promotionsAsync = ref.watch(promotionsProvider);
  return Scaffold(
   appBar: AppBar(title: const Text(MarketingConstants.promotionsTitle)),
   body: promotionsAsync.when(
    data: (promotions) => promotions.isEmpty
      ? const Center(child: Text(MarketingConstants.noPromotions))
      : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: promotions.length,
        itemBuilder: (context, i) {
         final promo = promotions[i];
         final colors = [AppColors.primary, AppColors.secondary, AppColors.accent];
         return Container(
          height: 150,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(color: colors[i % colors.length], borderRadius: BorderRadius.circular(16)),
          child: Center(
           child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Text(
              promo['title']?.toString() ?? MarketingConstants.specialOffer,
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
             ),
             const SizedBox(height: 8),
             Text(promo['description']?.toString() ?? MarketingConstants.limitedTimeOffer, style: const TextStyle(color: Colors.white70)),
            ],
           ),
          ),
         );
        },
       ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(MarketingConstants.errorLoadingPromotions)),
   ),
  );
 }
}