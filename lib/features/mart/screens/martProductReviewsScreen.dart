import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/martProvider.dart';
import '../../mart/constants/martConstants.dart';
class MartProductReviewsScreen extends ConsumerWidget {
 final String productId;
 const MartProductReviewsScreen({super.key, required this.productId});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final reviewsAsync = ref.watch(productReviewsProvider(productId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(MartConstants.reviewsTitle),
   ),
   body: reviewsAsync.when(
    data: (reviews) {
     if (reviews.isEmpty) {
      return const Center(child: Text(MartConstants.zeroReviews));
     }
     double totalRating = 0;
     for (var review in reviews) {
      totalRating += (review['rating'] as num).toDouble();
     }
     final averageRating = totalRating / reviews.length;
     return ListView(
      padding: const EdgeInsets.all(16),
      children: [
       Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
        child: Column(
         children: [
          Text(
           averageRating.toStringAsFixed(1),
           style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
            Icon(Icons.star, color: Colors.amber, size: 20),
            Icon(Icons.star, color: Colors.amber, size: 20),
            Icon(Icons.star, color: Colors.amber, size: 20),
            Icon(Icons.star, color: Colors.amber, size: 20),
            Icon(Icons.star_half, color: Colors.amber, size: 20),
           ],
          ),
          const SizedBox(height: 8),
          Text('Based On ${reviews.length} ${MartConstants.reviewsTitle}', style: const TextStyle(color: Colors.white70)),
         ],
        ),
       ),
       const SizedBox(height: 16),
       const Divider(height: 32),
       ...reviews.map((review) => _buildReview(context, review)),
      ],
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, stack) => Center(child: Text('${MartConstants.errorPrefix}$e')),
   ),
  );
 }
 Widget _buildReview(BuildContext context, Map<String, dynamic> review) {
  return Card(
   margin: const EdgeInsets.only(bottom: 12),
   child: Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Row(
       children: [
        Container(
         width: 40,
         height: 40,
         decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
         child: const Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Text(review['userName']?.toString() ?? MartConstants.user, style: const TextStyle(fontWeight: FontWeight.bold)),
           Text(review['createdAt'] != null ? DateTime.fromMillisecondsSinceEpoch(review['createdAt'] as int).toString().substring(0, 10) : '', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
         ),
        ),
        Row(children: List.generate(5, (i) => Icon(i < ((review['rating'] as num?) ?? 0) ? Icons.star : Icons.star_border, size: 16, color: Colors.amber))),
       ],
      ),
      const SizedBox(height: 12),
      Text(review['comment']?.toString() ?? ''),
     ],
    ),
   ),
  );
 }
}