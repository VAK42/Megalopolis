import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/foodProvider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../constants/foodConstants.dart';
class FoodHomeScreen extends ConsumerWidget {
 const FoodHomeScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.home), onPressed: () => context.go(Routes.superDashboard)),
    title: const Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Text(FoodConstants.homeDeliverTo, style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
      Row(
       children: [
        Text(FoodConstants.homeLocationHome, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Icon(Icons.keyboard_arrow_down, size: 20),
       ],
      ),
     ],
    ),
    actions: [
     IconButton(icon: const Icon(Icons.shopping_cart_outlined), onPressed: () => context.go(Routes.foodCart)),
     IconButton(icon: const Icon(Icons.favorite_outline), onPressed: () => context.go(Routes.foodFavorites)),
    ],
   ),
   body: SingleChildScrollView(
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Padding(
       padding: const EdgeInsets.all(16),
       child: GestureDetector(
        onTap: () => context.go(Routes.foodRestaurantSearch),
        child: Container(
         padding: const EdgeInsets.all(16),
         decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
         child: const Row(
          children: [
           Icon(Icons.search, color: Colors.grey),
           SizedBox(width: 12),
           Text(FoodConstants.searchHint, style: TextStyle(color: Colors.grey)),
          ],
         ),
        ),
       ),
      ),
      ref
        .watch(foodPromotionsProvider)
        .when(
         data: (promotions) {
          if (promotions.isEmpty) return const SizedBox.shrink();
          return CarouselSlider(
           items: promotions.map((promo) {
            Color cardColor;
            switch (promo['gradient']) {
             case 'primary':
              cardColor = AppColors.primary;
              break;
             case 'accent':
              cardColor = AppColors.accent;
              break;
             case 'error':
              cardColor = AppColors.error;
              break;
             case 'success':
              cardColor = AppColors.success;
              break;
             default:
              cardColor = AppColors.primary;
            }
            return _buildBannerCard(promo['title'] as String, promo['description'] as String, cardColor);
           }).toList(),
           options: CarouselOptions(height: 160, autoPlay: true, enlargeCenterPage: true, viewportFraction: 0.85),
          );
         },
         loading: () => const Center(child: CircularProgressIndicator()),
         error: (error, stack) => const SizedBox.shrink(),
        ),
      const SizedBox(height: 24),
      Padding(
       padding: const EdgeInsets.symmetric(horizontal: 16),
       child: Text(FoodConstants.categories, style: Theme.of(context).textTheme.titleLarge),
      ),
      const SizedBox(height: 12),
      SizedBox(
       height: 100,
       child: ref
         .watch(foodCategoriesProvider)
         .when(
          data: (categories) => ListView.builder(
           scrollDirection: Axis.horizontal,
           padding: const EdgeInsets.symmetric(horizontal: 12),
           itemCount: categories.length,
           itemBuilder: (context, index) {
            final category = categories[index]['category'] as String;
            return _buildCategoryChip(context, _toTitleCase(category), Icons.fastfood, () => context.go('/food/category/$category'));
           },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => const Center(child: Text(FoodConstants.errorLoadingCategories)),
         ),
      ),
      const SizedBox(height: 24),
      Padding(
       padding: const EdgeInsets.symmetric(horizontal: 16),
       child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         Text(FoodConstants.popularNearYou, style: Theme.of(context).textTheme.titleLarge),
         TextButton(onPressed: () => context.go('/food/restaurants'), child: const Text(FoodConstants.seeAll)),
        ],
       ),
      ),
      ref
        .watch(restaurantsProvider)
        .when(
         data: (restaurants) => ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: restaurants.length > 5 ? 5 : restaurants.length,
          itemBuilder: (context, index) {
           final restaurant = restaurants[index];
           return _buildRestaurantCard(context, restaurant['sellerName'] as String? ?? FoodConstants.defaultRestaurant, restaurant['sellerRating']?.toString() ?? '4.5', FoodConstants.defaultDeliveryTime, (restaurant['sellerId'] as String?) ?? '0');
          },
         ),
         loading: () => const Center(child: CircularProgressIndicator()),
         error: (_, __) => const Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(
           child: Column(
            children: [
             Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
             SizedBox(height: 16),
             Text(FoodConstants.noRestaurantsAvailable, style: TextStyle(fontSize: 16, color: Colors.grey)),
            ],
           ),
          ),
         ),
        ),
     ],
    ),
   ),
  );
 }
 Widget _buildBannerCard(String title, String subtitle, Color color) {
  return Container(
   margin: const EdgeInsets.symmetric(horizontal: 8),
   decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
   child: Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
     mainAxisAlignment: MainAxisAlignment.center,
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Text(
       title,
       style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 16)),
     ],
    ),
   ),
  );
 }
 Widget _buildCategoryChip(BuildContext context, String label, IconData icon, VoidCallback onTap) {
  return GestureDetector(
   onTap: onTap,
   child: Container(
    width: 80,
    margin: const EdgeInsets.symmetric(horizontal: 4),
    child: Column(
     children: [
      Container(
       width: 64,
       height: 64,
       decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(32)),
       child: Icon(icon, color: Colors.white, size: 32),
      ),
      const SizedBox(height: 8),
      Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
     ],
    ),
   ),
  );
 }
 Widget _buildRestaurantCard(BuildContext context, String name, String rating, String time, String id) {
  return GestureDetector(
   onTap: () => context.go('/food/restaurant/$id'),
   child: Card(
    margin: const EdgeInsets.only(bottom: 16),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Container(
       height: 160,
       decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
       ),
       child: const Center(child: Icon(Icons.restaurant, size: 60, color: Colors.white)),
      ),
      Padding(
       padding: const EdgeInsets.all(12),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
         const SizedBox(height: 4),
         Row(
          children: [
           Icon(Icons.star, size: 16, color: Colors.amber[700]),
           const SizedBox(width: 4),
           Text(rating),
           const SizedBox(width: 16),
           const Icon(Icons.access_time, size: 16),
           const SizedBox(width: 4),
           Text(time),
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