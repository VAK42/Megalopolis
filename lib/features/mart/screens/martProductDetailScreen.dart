import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/martProvider.dart';
import '../../../providers/authProvider.dart';
import '../../mart/constants/martConstants.dart';
class MartProductDetailScreen extends ConsumerStatefulWidget {
 final int productId;
 const MartProductDetailScreen({super.key, required this.productId});
 @override
 ConsumerState<MartProductDetailScreen> createState() => _MartProductDetailScreenState();
}
class _MartProductDetailScreenState extends ConsumerState<MartProductDetailScreen> {
 int quantity = 1;
 int selectedImageIndex = 0;
 String selectedColor = MartConstants.colors[0];
 String selectedSize = MartConstants.sizes[1];
 @override
 Widget build(BuildContext context) {
  final productAsync = ref.watch(martProductProvider(widget.productId.toString()));
  final reviewsAsync = ref.watch(productReviewsProvider(widget.productId.toString()));
  return Scaffold(
   body: productAsync.when(
    data: (product) {
     if (product == null) {
      return const Center(child: Text(MartConstants.productNotFound));
     }
     return CustomScrollView(
      slivers: [
       SliverAppBar(
        expandedHeight: 300,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        actions: [
         IconButton(icon: const Icon(Icons.share), onPressed: () {}),
         IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () async {
           final userId = ref.read(currentUserIdProvider) ?? 'user1';
           await ref.read(wishlistProvider(userId).notifier).addToWishlist(product.id.toString());
           if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(MartConstants.addedToWishlist)));
           }
          },
         ),
        ],
        flexibleSpace: FlexibleSpaceBar(
         background: Stack(
          children: [
           Container(
            decoration: BoxDecoration(
             color: Colors.grey[200],
             image: product.images.isNotEmpty ? DecorationImage(image: NetworkImage(product.images.first), fit: BoxFit.cover) : null,
            ),
            child: product.images.isEmpty ? Center(child: Icon(Icons.image, size: 100, color: Colors.grey[400])) : null,
           ),
           if (product.stock > 0 && product.stock < 10)
            Positioned(
             top: 16,
             right: 16,
             child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(16)),
              child: Text(
               '${MartConstants.onlyLeftPrefix}${product.stock}${MartConstants.onlyLeftSuffix}',
               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
             ),
            ),
          ],
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
             const Icon(Icons.star, color: Colors.amber, size: 20),
             const SizedBox(width: 4),
             Text('${product.rating}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
             const SizedBox(width: 4),
             reviewsAsync.when(data: (reviews) => Text('(${reviews.length}${MartConstants.reviewsSuffix})'), loading: () => const Text(MartConstants.loadingText), error: (e, s) => const Text(MartConstants.zeroReviews)),
             const Spacer(),
             const Icon(Icons.local_shipping, size: 16),
             const SizedBox(width: 4),
             const Text(MartConstants.freeShipping, style: TextStyle(fontWeight: FontWeight.bold)),
            ],
           ),
           const SizedBox(height: 16),
           Text(product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
           const SizedBox(height: 12),
           Row(
            children: [
             Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary),
             ),
            ],
           ),
           const Divider(height: 32),
           const Text(MartConstants.colorTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
           const SizedBox(height: 12),
           Wrap(
            spacing: 8,
            children: MartConstants.colors.map((color) {
             final isSelected = selectedColor == color;
             return GestureDetector(
              onTap: () => setState(() => selectedColor = color),
              child: Container(
               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
               decoration: BoxDecoration(color: isSelected ? AppColors.primary : Colors.grey[200], borderRadius: BorderRadius.circular(8)),
               child: Text(
                color,
                style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.w600),
               ),
              ),
             );
            }).toList(),
           ),
           const SizedBox(height: 16),
           const Text(MartConstants.sizeTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
           const SizedBox(height: 12),
           Wrap(
            spacing: 8,
            children: MartConstants.sizes.map((size) {
             final isSelected = selectedSize == size;
             return GestureDetector(
              onTap: () => setState(() => selectedSize = size),
              child: Container(
               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
               decoration: BoxDecoration(color: isSelected ? AppColors.primary : Colors.grey[200], borderRadius: BorderRadius.circular(8)),
               child: Text(
                size,
                style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.w600),
               ),
              ),
             );
            }).toList(),
           ),
           const Divider(height: 32),
           const Text(MartConstants.descriptionTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
           const SizedBox(height: 8),
           Text(product.description ?? MartConstants.noDescription, style: const TextStyle(height: 1.5)),
           const SizedBox(height: 16),
           GestureDetector(
            onTap: () {
             final route = Routes.martProductReviews.replaceFirst(':id', product.id.toString());
             context.push(route);
            },
            child: Container(
             padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
             child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               reviewsAsync.when(
                data: (reviews) => Text('${MartConstants.customerReviewsPrefix} (${reviews.length})', style: const TextStyle(fontWeight: FontWeight.bold)),
                loading: () => const Text(MartConstants.customerReviewsPrefix, style: TextStyle(fontWeight: FontWeight.bold)),
                error: (e, s) => const Text(MartConstants.customerReviewsPrefix, style: TextStyle(fontWeight: FontWeight.bold)),
               ),
               const Icon(Icons.arrow_forward_ios, size: 16),
              ],
             ),
            ),
           ),
           const SizedBox(height: 100),
          ],
         ),
        ),
       ),
      ],
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (err, stack) => const Center(child: Text(MartConstants.errorLoadingProduct)),
   ),
   bottomNavigationBar: productAsync.when(
    data: (product) => product == null
      ? null
      : Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
         color: Colors.white,
         boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)],
        ),
        child: Row(
         children: [
          Container(
           decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
           ),
           child: Row(
            children: [
             IconButton(icon: const Icon(Icons.remove), onPressed: () => setState(() => quantity = quantity > 1 ? quantity - 1 : 1)),
             Text('$quantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
             IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() => quantity++)),
            ],
           ),
          ),
          const SizedBox(width: 12),
          Expanded(
           child: AppButton(
            text: MartConstants.addToCart,
            onPressed: () async {
             final userId = ref.read(currentUserIdProvider) ?? 'user1';
             await ref.read(martCartProvider(userId).notifier).addItem(product.id.toString(), quantity);
             if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(MartConstants.addedToCart)));
             }
            },
            icon: Icons.shopping_cart,
           ),
          ),
         ],
        ),
       ),
    loading: () => null,
    error: (e, s) => null,
   ),
  );
 }
}