import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/merchantProvider.dart';
import '../../../providers/authProvider.dart';
import '../../merchant/constants/merchantConstants.dart';
class MerchantReviewsScreen extends ConsumerWidget {
 const MerchantReviewsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final merchantId = ref.watch(currentUserIdProvider) ?? 'user1';
  final reviewsAsync = ref.watch(merchantReviewsProvider(merchantId));
  return Scaffold(
   appBar: AppBar(title: const Text(MerchantConstants.reviewsTitle)),
   body: reviewsAsync.when(
    data: (reviews) {
     if (reviews.isEmpty) {
      return const Center(child: Text(MerchantConstants.noReviewsFound));
     }
     return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
       final review = reviews[index];
       return Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
         padding: const EdgeInsets.all(12),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Text(review['userName'] ?? MerchantConstants.user, style: const TextStyle(fontWeight: FontWeight.bold)),
             Row(children: List.generate(5, (starIndex) => Icon(starIndex < (review['rating'] as int? ?? 0) ? Icons.star : Icons.star_border, size: 16, color: Colors.amber))),
            ],
           ),
           const SizedBox(height: 8),
           Text(review['comment'] ?? ''),
          ],
         ),
        ),
       );
      },
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, s) => Center(child: Text('${MerchantConstants.errorGeneric}: $e')),
   ),
  );
 }
}