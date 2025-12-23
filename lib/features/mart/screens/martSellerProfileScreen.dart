import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/martProvider.dart';
import '../../../shared/models/itemModel.dart';
import '../constants/martConstants.dart';
class MartSellerProfileScreen extends ConsumerWidget {
 final String sellerId;
 const MartSellerProfileScreen({super.key, required this.sellerId});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final sellerAsync = ref.watch(martSellerProvider(sellerId));
  final productsAsync = ref.watch(sellerProductsProvider(sellerId));
  return Scaffold(
   body: sellerAsync.when(
    data: (seller) {
     if (seller == null) {
      return Center(child: Text(MartConstants.errorLoadingSeller));
     }
     return CustomScrollView(
      slivers: [
       SliverAppBar(
        expandedHeight: 200,
        leading: IconButton(
         icon: const Icon(Icons.arrow_back, color: Colors.white),
         onPressed: () => context.pop(),
        ),
        flexibleSpace: FlexibleSpaceBar(
         background: Container(
          decoration: BoxDecoration(gradient: AppColors.primaryGradient),
          child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
            Container(
             width: 80,
             height: 80,
             decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
             ),
             child: seller['avatar'] != null ? ClipOval(child: Image.network(seller['avatar'] as String, fit: BoxFit.cover)) : const Icon(Icons.store, size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            Text(
             seller['name'] as String,
             style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text('${seller['rating']}', style: const TextStyle(color: Colors.white)),
              const SizedBox(width: 8),
              Text('${_formatCount(seller['reviewCount'] as int)} ${MartConstants.reviewsTitle}', style: const TextStyle(color: Colors.white70)),
             ],
            ),
           ],
          ),
         ),
        ),
       ),
       SliverToBoxAdapter(
        child: Padding(
         padding: const EdgeInsets.all(16),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(
            children: [
             Expanded(child: _buildStatCard(MartConstants.products, '${seller['productCount']}')),
             const SizedBox(width: 12),
             Expanded(child: _buildStatCard(MartConstants.followers, _formatCount(seller['followerCount'] as int))),
             const SizedBox(width: 12),
             Expanded(child: _buildStatCard(MartConstants.rating, '${seller['rating']}')),
            ],
           ),
           const SizedBox(height: 16),
           Row(
            children: [
             Expanded(
              child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.chat), label: const Text(MartConstants.chat)),
             ),
             const SizedBox(width: 12),
             Expanded(
              child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.person_add), label: const Text(MartConstants.follow)),
             ),
            ],
           ),
           const SizedBox(height: 24),
           const Text(MartConstants.about, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
           const SizedBox(height: 8),
           Text(seller['description'] as String? ?? MartConstants.noDescription),
           const SizedBox(height: 24),
           const Text(MartConstants.products, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
           const SizedBox(height: 12),
          ],
         ),
        ),
       ),
       SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: productsAsync.when(
         data: (products) => SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.7),
          delegate: SliverChildBuilderDelegate((context, index) => _buildProductCard(context, products[index]), childCount: products.length),
         ),
         loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
         error: (err, stack) => const SliverToBoxAdapter(child: Center(child: Text(MartConstants.errorLoadingProducts))),
        ),
       ),
      ],
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (err, stack) => const Center(child: Text(MartConstants.errorLoadingSeller)),
   ),
  );
 }
 String _formatCount(int count) {
  if (count >= 1000) {
   return '${(count / 1000).toStringAsFixed(1)}K';
  }
  return count.toString();
 }
 Widget _buildStatCard(String label, String value) {
  return Container(
   padding: const EdgeInsets.all(12),
   decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
   child: Column(
    children: [
     Text(
      value,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
     ),
     const SizedBox(height: 4),
     Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
    ],
   ),
  );
 }
 Widget _buildProductCard(BuildContext context, ItemModel product) {
  return GestureDetector(
   onTap: () {
    final route = Routes.martProductDetail.replaceFirst(':id', product.id.toString());
    context.push(route);
   },
   child: Card(
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Container(
       height: 140,
       decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        image: product.images.isNotEmpty ? DecorationImage(image: NetworkImage(product.images.first), fit: BoxFit.cover) : null,
       ),
       child: product.images.isEmpty ? Center(child: Icon(Icons.image, size: 50, color: Colors.grey[400])) : null,
      ),
      Padding(
       padding: const EdgeInsets.all(8),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(
          product.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
         ),
         const SizedBox(height: 4),
         Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
         ),
        ],
       ),
      ),
     ],
    ),
   ),
  );
 }
}