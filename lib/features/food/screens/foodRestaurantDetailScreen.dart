import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/foodProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/foodConstants.dart';
class FoodRestaurantDetailScreen extends ConsumerWidget {
 final String restaurantId;
 const FoodRestaurantDetailScreen({super.key, required this.restaurantId});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final restaurantsAsync = ref.watch(restaurantsProvider);
  final menuAsync = ref.watch(restaurantMenuProvider(restaurantId));
  final userIdStr = ref.watch(currentUserIdProvider);
  final userId = userIdStr ?? '1';
  return Scaffold(
   body: restaurantsAsync.when(
    data: (restaurants) {
     final restaurant = restaurants.firstWhere((r) => r['sellerId'].toString() == restaurantId, orElse: () => <String, dynamic>{});
     if (restaurant.isEmpty) {
      return const Center(child: Text(FoodConstants.errorLoadingDetails));
     }
     return CustomScrollView(
      slivers: [
       SliverAppBar(
        expandedHeight: 200,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
         title: Text(restaurant['sellerName']?.toString() ?? FoodConstants.defaultRestaurant),
         background: Container(
          decoration: BoxDecoration(gradient: AppColors.primaryGradient),
          child: const Center(child: Icon(Icons.restaurant, size: 64, color: Colors.white)),
         ),
        ),
        actions: [
         IconButton(icon: const Icon(Icons.favorite_border), onPressed: () => ref.read(foodFavoritesProvider(int.tryParse(userId) ?? 1).notifier).addFavorite(restaurantId)),
         IconButton(icon: const Icon(Icons.info_outline), onPressed: () => context.go('/food/restaurant/$restaurantId/info')),
        ],
       ),
       SliverToBoxAdapter(
        child: Padding(
         padding: const EdgeInsets.all(16),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(
            children: [
             Icon(Icons.star, color: Colors.amber[700]),
             const SizedBox(width: 4),
             Text('${restaurant['sellerRating'] ?? 4.5}', style: const TextStyle(fontWeight: FontWeight.bold)),
             const Spacer(),
             Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Row(
               children: [
                const Icon(Icons.access_time, size: 16, color: AppColors.success),
                const SizedBox(width: 4),
                Text(
                 FoodConstants.defaultDeliveryTime,
                 style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold),
                ),
               ],
              ),
             ),
            ],
           ),
           const SizedBox(height: 24),
           Text(FoodConstants.menu, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
         ),
        ),
       ),
       menuAsync.when(
        data: (menu) => SliverList(
         delegate: SliverChildBuilderDelegate((context, index) {
          final item = menu[index];
          return Card(
           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
           child: ListTile(
            leading: Container(
             width: 60,
             height: 60,
             decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
             child: const Icon(Icons.restaurant_menu, color: AppColors.primary),
            ),
            title: Text(item['name'] as String? ?? FoodConstants.defaultDish, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item['description'] as String? ?? FoodConstants.deliciousAndFresh),
            trailing: Text('\$${item['price'] ?? 0}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
            onTap: () => context.go('/food/item/${item['id']}'),
           ),
          );
         }, childCount: menu.length),
        ),
        loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
        error: (_, __) => SliverToBoxAdapter(child: Center(child: Text(FoodConstants.noItems))),
       ),
      ],
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(child: Text('${FoodConstants.errorPrefix}$e')),
   ),
  );
 }
}