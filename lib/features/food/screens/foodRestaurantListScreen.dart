import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/foodProvider.dart';
import '../constants/foodConstants.dart';
class FoodRestaurantListScreen extends ConsumerWidget {
 const FoodRestaurantListScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final restaurantsAsync = ref.watch(restaurantsProvider);
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.foodHome)),
    title: const Text(FoodConstants.restaurantListTitle),
    actions: [IconButton(icon: const Icon(Icons.filter_list), onPressed: () {})],
   ),
   body: restaurantsAsync.when(
    data: (restaurants) => restaurants.isEmpty
      ? Center(child: Text(FoodConstants.noRestaurantsAvailable))
      : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
         final restaurant = restaurants[index];
         return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
           onTap: () => context.go('/food/restaurant/${restaurant['sellerId']}'),
           borderRadius: BorderRadius.circular(12),
           child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Container(
              height: 150,
              decoration: BoxDecoration(
               color: AppColors.primary,
               borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: const Center(child: Icon(Icons.restaurant, size: 50, color: Colors.white)),
             ),
             Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                Row(
                 children: [
                  Expanded(
                   child: Text(restaurant['sellerName']?.toString() ?? FoodConstants.defaultRestaurant, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                   decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                   child: Row(
                    children: [
                     Icon(Icons.star, size: 16, color: Colors.amber[700]),
                     const SizedBox(width: 4),
                     Text('${restaurant['sellerRating'] ?? 4.5}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                   ),
                  ),
                 ],
                ),
                const SizedBox(height: 8),
                Row(
                 children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(FoodConstants.defaultDeliveryTime, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(width: 16),
                  const Icon(Icons.local_offer, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(FoodConstants.defaultFood, style: const TextStyle(color: Colors.grey)),
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
    error: (e, _) => Center(child: Text('${FoodConstants.errorPrefix}$e')),
   ),
  );
 }
}