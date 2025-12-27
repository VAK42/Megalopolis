import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/foodProvider.dart';
import '../constants/foodConstants.dart';
class FoodFavoritesScreen extends ConsumerWidget {
 const FoodFavoritesScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userIdStr = ref.watch(currentUserIdProvider);
  if (userIdStr == null) {
   return Scaffold(
    appBar: AppBar(title: const Text(FoodConstants.favoritesTitle)),
    body: Center(child: Text(FoodConstants.loginToViewFavorites)),
   );
  }
  final userId = int.tryParse(userIdStr) ?? 1;
  final restaurantFavoritesAsync = ref.watch(foodFavoritesProvider(userId));
  final foodFavoritesAsync = ref.watch(foodItemFavoritesProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(FoodConstants.favoritesTitle),
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Text(FoodConstants.favoriteRestaurants, style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 8),
      restaurantFavoritesAsync.when(
       data: (favorites) {
        if (favorites.isEmpty) {
         return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(child: Text(FoodConstants.noFavoriteRestaurants, style: TextStyle(color: Colors.grey[600]))),
         );
        }
        return Column(
         children: favorites.map((fav) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
           leading: Container(
            width: 60, height: 60,
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.restaurant, color: Colors.white),
           ),
           title: Text(fav['name']?.toString() ?? FoodConstants.defaultRestaurant, style: const TextStyle(fontWeight: FontWeight.bold)),
           subtitle: const Text(FoodConstants.defaultDeliveryTime),
           trailing: IconButton(
            icon: const Icon(Icons.favorite, color: AppColors.error),
            onPressed: () async {
             await ref.read(foodFavoritesProvider(userId).notifier).removeFavorite(fav['itemId'].toString());
             if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(FoodConstants.removedFromFavorites)));
            },
           ),
           onTap: () => context.go('/food/restaurant/${fav['itemId']}'),
          ),
         )).toList(),
        );
       },
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (e, _) => Center(child: Text('${FoodConstants.errorPrefix}$e')),
      ),
      const SizedBox(height: 24),
      Text(FoodConstants.favoriteFoods, style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 8),
      foodFavoritesAsync.when(
       data: (favorites) {
        if (favorites.isEmpty) {
         return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(child: Text(FoodConstants.noFavoriteFoods, style: TextStyle(color: Colors.grey[600]))),
         );
        }
        return Column(
         children: favorites.map((fav) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
           leading: Container(
            width: 60, height: 60,
            decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.fastfood, color: Colors.white),
           ),
           title: Text(fav['name']?.toString() ?? FoodConstants.defaultDish, style: const TextStyle(fontWeight: FontWeight.bold)),
           subtitle: Text('\$${fav['price'] ?? 0}', style: const TextStyle(color: AppColors.primary)),
           trailing: IconButton(
            icon: const Icon(Icons.favorite, color: AppColors.error),
            onPressed: () async {
             await ref.read(foodItemFavoritesProvider(userId).notifier).removeFavorite(fav['itemId'].toString());
             if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(FoodConstants.removedFromFavorites)));
            },
           ),
           onTap: () => context.go('/food/item/${fav['itemId']}'),
          ),
         )).toList(),
        );
       },
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (e, _) => Center(child: Text('${FoodConstants.errorPrefix}$e')),
      ),
     ],
    ),
   ),
  );
 }
}