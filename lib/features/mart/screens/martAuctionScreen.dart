import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/martProvider.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/models/itemModel.dart';
import '../constants/martConstants.dart';
class MartAuctionScreen extends ConsumerWidget {
 const MartAuctionScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(MartConstants.liveAuctions),
   ),
   body: ref
     .watch(martProductsProvider(null))
     .when(
      data: (products) => GridView.builder(padding: const EdgeInsets.all(16), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.75), itemCount: products.length, itemBuilder: (context, index) => _buildAuctionCard(context, products[index])),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => const Center(child: Text(MartConstants.errorLoadingAuctions)),
     ),
  );
 }
 Widget _buildAuctionCard(BuildContext context, ItemModel product) {
  return GestureDetector(
   onTap: () {
    final route = Routes.martProductDetail.replaceFirst(':id', product.id.toString());
    context.push(route);
   },
   child: Card(
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Expanded(
       child: Container(
        decoration: BoxDecoration(
         color: Colors.grey[200],
         borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
         image: product.images.isNotEmpty ? DecorationImage(image: NetworkImage(product.images.first), fit: BoxFit.cover) : null,
        ),
        child: product.images.isEmpty ? Center(child: Icon(Icons.shopping_bag, size: 50, color: Colors.grey[400])) : null,
       ),
      ),
      Padding(
       padding: const EdgeInsets.all(8),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
         ),
         const SizedBox(height: 4),
         Text(MartConstants.currentBid, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
         Text(
          '\$${product.price}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
         ),
         const SizedBox(height: 4),
         Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(4)),
          child: const Text(MartConstants.timeLeftPlaceholder, style: TextStyle(color: Colors.white, fontSize: 10)),
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