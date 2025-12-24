import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/martProvider.dart';
import '../../../shared/models/itemModel.dart';
import '../../mart/constants/martConstants.dart';
import '../../../shared/widgets/sharedBottomNav.dart';
class MartHomeScreen extends ConsumerWidget {
 const MartHomeScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   body: SafeArea(
    child: CustomScrollView(
     slivers: [
      SliverAppBar(
       floating: true,
       leading: IconButton(icon: const Icon(Icons.menu), onPressed: () => context.go(Routes.superDashboard)),
       title: const Text(MartConstants.appTitle),
       actions: [
        IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () => context.go(Routes.martCart)),
        IconButton(icon: const Icon(Icons.notifications), onPressed: () => context.go(Routes.notifications)),
       ],
      ),
      SliverToBoxAdapter(
       child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
          GestureDetector(
           onTap: () => context.go(Routes.martSearch),
           child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
            child: const Row(
             children: [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 12),
              Text(MartConstants.searchHint, style: TextStyle(color: Colors.grey)),
             ],
            ),
           ),
          ),
          const SizedBox(height: 24),
          SizedBox(
           height: 180,
           child: ref
             .watch(martPromotionsProvider)
             .when(
              data: (promotions) => ListView.builder(
               scrollDirection: Axis.horizontal,
               itemCount: promotions.length,
               itemBuilder: (context, index) {
                final promo = promotions[index];
                return Container(
                 width: 340,
                 margin: const EdgeInsets.only(right: 16),
                 decoration: BoxDecoration(color: [AppColors.primary, AppColors.accent, AppColors.error][index % 3], borderRadius: BorderRadius.circular(16)),
                 child: Stack(
                  children: [
                   Positioned(right: -20, bottom: -20, child: Icon(Icons.shopping_bag, size: 120, color: Colors.white.withOpacity(0.2))),
                   Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                      Text(
                       promo['title'] as String,
                       style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(promo['subtitle'] as String, style: const TextStyle(color: Colors.white70, fontSize: 16)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                       onPressed: () => context.go(index == 0 ? Routes.martFlashSale : Routes.martCategories),
                       style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary),
                       child: const Text(MartConstants.shopNowButton),
                      ),
                     ],
                    ),
                   ),
                  ],
                 ),
                );
               },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => const SizedBox.shrink(),
             ),
          ),
          const SizedBox(height: 24),
          const Text(MartConstants.categoriesTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
           height: 100,
           child: ref
             .watch(martCategoriesProvider)
             .when(
              data: (categories) => ListView.builder(
               scrollDirection: Axis.horizontal,
               itemCount: categories.length,
               itemBuilder: (context, index) {
                final cat = categories[index];
                return _buildCategoryChip(context, Icons.category, _toTitleCase(cat['category'] as String), AppColors.primary);
               },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => const Text(MartConstants.errorGeneric),
             ),
          ),
          const SizedBox(height: 24),
          Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
            const Text(MartConstants.trendingTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () => context.go(Routes.martProducts), child: const Text(MartConstants.seeAllButton)),
           ],
          ),
         ],
        ),
       ),
      ),
      SliverPadding(
       padding: const EdgeInsets.all(16),
       sliver: ref
         .watch(martProductsProvider(null))
         .when(
          data: (products) => SliverGrid(
           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.7),
           delegate: SliverChildBuilderDelegate((context, index) => _buildProductCard(context, products[index]), childCount: products.length),
          ),
          loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
          error: (error, stack) => const SliverToBoxAdapter(child: Center(child: Text(MartConstants.errorLoadingProducts))),
         ),
      ),
     ],
    ),
   ),
  );
 }
 Widget _buildCategoryChip(BuildContext context, IconData icon, String label, Color color) {
  return GestureDetector(
   onTap: () => context.go(Routes.martProducts),
   child: Container(
    width: 80,
    margin: const EdgeInsets.only(right: 12),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
    child: Column(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
      Container(
       padding: const EdgeInsets.all(12),
       decoration: BoxDecoration(color: color.withValues(alpha: 0.2), shape: BoxShape.circle),
       child: Icon(icon, color: color, size: 28),
      ),
      const SizedBox(height: 8),
      Text(
       label,
       style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
       overflow: TextOverflow.ellipsis,
      ),
     ],
    ),
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
      Stack(
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
       ],
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
         Row(
          children: [
           const Icon(Icons.star, size: 14, color: Colors.amber),
           const SizedBox(width: 4),
           Text('${product.rating}', style: const TextStyle(fontSize: 12)),
           Text(' (${product.stock})', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
         ),
         const SizedBox(height: 4),
         Row(
          children: [
           Text(
            '\$${product.price}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
           ),
          ],
         ),
        ],
       ),
      ),
     ],
    ),
   ),
  );
 }
 String _toTitleCase(String text) {
  if (text.isEmpty) return text;
  return text.split(' ').map((word) => word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}').join(' ');
 }
}