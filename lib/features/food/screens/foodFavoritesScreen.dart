import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/foodProvider.dart';
import '../../../core/routes/routeNames.dart';
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
  final favoritesAsync = ref.watch(foodFavoritesProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(FoodConstants.favoritesTitle),
   ),
   body: favoritesAsync.when(
    data: (favorites) {
     if (favorites.isEmpty) {
      return Center(
       child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         const Icon(Icons.favorite_border, size: 80, color: Colors.grey),
         const SizedBox(height: 16),
         const Text(FoodConstants.noFavorites, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
         const SizedBox(height: 8),
         Text(FoodConstants.addToFavorites, style: const TextStyle(color: Colors.grey)),
        ],
       ),
      );
     }
     return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
       final fav = favorites[index];
       return Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
         leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.restaurant, color: Colors.white),
         ),
         title: Text(fav['name']?.toString() ?? FoodConstants.defaultRestaurant, style: const TextStyle(fontWeight: FontWeight.bold)),
         subtitle: const Text(FoodConstants.defaultDeliveryTime),
         trailing: IconButton(
          icon: const Icon(Icons.favorite, color: AppColors.error),
          onPressed: () async {
           await ref.read(foodFavoritesProvider(userId).notifier).removeFavorite(fav['itemId'].toString());
           if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(FoodConstants.removedFromFavorites)));
           }
          },
         ),
         onTap: () => context.go('${Routes.foodRestaurantDetail}/${fav['itemId']}'),
        ),
       );
      },
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(child: Text('${FoodConstants.errorPrefix}$e')),
   ),
  );
 }
}