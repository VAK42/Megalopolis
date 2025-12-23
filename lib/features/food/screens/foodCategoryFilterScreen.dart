import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/foodProvider.dart';
import '../constants/foodConstants.dart';
class FoodCategoryFilterScreen extends ConsumerWidget {
 final String category;
 const FoodCategoryFilterScreen({super.key, required this.category});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final restaurantsAsync = ref.watch(restaurantsProvider);
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.foodHome)),
    title: Text(category.toUpperCase()),
    actions: [IconButton(icon: const Icon(Icons.tune), onPressed: () {})],
   ),
   body: Column(
    children: [
     Container(
      padding: const EdgeInsets.all(16),
      child: Row(
       children: [
        Expanded(child: _buildFilterChip(FoodConstants.sort, Icons.sort)),
        const SizedBox(width: 8),
        Expanded(child: _buildFilterChip(FoodConstants.rating, Icons.star)),
        const SizedBox(width: 8),
        Expanded(child: _buildFilterChip(FoodConstants.price, Icons.attach_money)),
       ],
      ),
     ),
     Expanded(
      child: restaurantsAsync.when(
       data: (restaurants) => restaurants.isEmpty
         ? const Center(child: Text(FoodConstants.noRestaurantsAvailable))
         : GridView.builder(
           padding: const EdgeInsets.all(16),
           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 16, mainAxisSpacing: 16),
           itemCount: restaurants.length,
           itemBuilder: (context, index) {
            final restaurant = restaurants[index];
            return GestureDetector(
             onTap: () => context.go('${Routes.foodRestaurantDetail}/${restaurant['sellerId']}'),
             child: Card(
              child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                Expanded(
                 child: Container(
                  decoration: const BoxDecoration(
                   color: AppColors.primary,
                   borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: const Center(child: Icon(Icons.restaurant, size: 40, color: Colors.white)),
                 ),
                ),
                Padding(
                 padding: const EdgeInsets.all(8),
                 child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Text(restaurant['sellerName']?.toString() ?? FoodConstants.defaultRestaurant, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1),
                   Row(
                    children: [
                     Icon(Icons.star, size: 14, color: Colors.amber[700]),
                     const SizedBox(width: 4),
                     Text('${restaurant['sellerRating'] ?? 4.5}', style: const TextStyle(fontSize: 12)),
                    ],
                   ),
                  ],
                 ),
                ),
               ],
              ),
             ),
            );
           },
          ),
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (_, __) => Center(child: Text(FoodConstants.noRestaurantsAvailable)),
      ),
     ),
    ],
   ),
  );
 }
 Widget _buildFilterChip(String label, IconData icon) {
  return OutlinedButton.icon(
   onPressed: () {},
   icon: Icon(icon, size: 16),
   label: Text(label, style: const TextStyle(fontSize: 12)),
   style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8)),
  );
 }
}