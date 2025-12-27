import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/martProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/martConstants.dart';
class MartWishlistScreen extends ConsumerWidget {
 const MartWishlistScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final wishlistAsync = ref.watch(wishlistProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.martHome)),
    title: const Text(MartConstants.wishlistTitle),
   ),
   body: wishlistAsync.when(
    data: (items) {
     if (items.isEmpty) {
      return Center(
       child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
         const SizedBox(height: 16),
         const Text(MartConstants.wishlistEmpty, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
         const SizedBox(height: 8),
         Text(MartConstants.saveItemsForLater, style: TextStyle(color: Colors.grey[600])),
         const SizedBox(height: 24),
         ElevatedButton(onPressed: () => context.go(Routes.martHome), child: const Text(MartConstants.startShopping)),
        ],
       ),
      );
     }
     return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.65),
      itemCount: items.length,
      itemBuilder: (context, index) {
       final item = items[index];
       return Dismissible(
        key: Key(item['itemId'].toString()),
        direction: DismissDirection.endToStart,
        background: Container(
         alignment: Alignment.centerRight,
         padding: const EdgeInsets.only(right: 20),
         color: AppColors.error,
         child: const Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (direction) {
         ref.read(wishlistProvider(userId).notifier).removeFromWishlist(item['itemId'].toString());
        },
        child: GestureDetector(
         onTap: () {
          final route = Routes.martProductDetail.replaceFirst(':id', item['itemId'].toString());
          context.push(route);
         },
         child: Card(
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Stack(
             children: [
              Container(
               height: 140,
               decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                image: _getValidImageUrl(item['images']) != null
                  ? DecorationImage(image: NetworkImage(_getValidImageUrl(item['images'])!), fit: BoxFit.cover)
                  : null,
               ),
               child: _getValidImageUrl(item['images']) == null ? Center(child: Icon(Icons.image, size: 50, color: Colors.grey[400])) : null,
              ),
              Positioned(
               top: 8,
               right: 8,
               child: IconButton(
                icon: const Icon(Icons.favorite, color: AppColors.error),
                onPressed: () async {
                 await ref.read(wishlistProvider(userId).notifier).removeFromWishlist(item['itemId'].toString());
                },
                style: IconButton.styleFrom(backgroundColor: Colors.white),
               ),
              ),
             ],
            ),
            Padding(
             padding: const EdgeInsets.all(8),
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Text(
                item['name'] as String,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
               ),
               const SizedBox(height: 4),
               Text(
                '\$${(item['price'] as num).toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
               ),
               const SizedBox(height: 8),
               SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                 onPressed: () async {
                  await ref.read(martCartProvider(userId).notifier).addItem(item['itemId'].toString(), 1);
                  if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(MartConstants.addedToCart)));
                  }
                 },
                 style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8)),
                 child: const Text(MartConstants.addToCart, style: TextStyle(fontSize: 12)),
                ),
               ),
              ],
             ),
            ),
           ],
          ),
         ),
        ),
       );
      },
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (err, stack) => const Center(child: Text(MartConstants.errorLoadingWishlist)),
   ),
  );
 }
 String? _getValidImageUrl(dynamic images) {
  if (images == null || images.toString().isEmpty) return null;
  final url = images.toString().split(',').first.trim();
  if (url.startsWith('http://') || url.startsWith('https://')) {
   return url;
  }
  return null;
 }
}