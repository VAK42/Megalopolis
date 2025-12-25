import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/foodProvider.dart';
import '../constants/foodConstants.dart';
class FoodRestaurantSearchScreen extends ConsumerStatefulWidget {
 const FoodRestaurantSearchScreen({super.key});
 @override
 ConsumerState<FoodRestaurantSearchScreen> createState() => _FoodRestaurantSearchScreenState();
}
class _FoodRestaurantSearchScreenState extends ConsumerState<FoodRestaurantSearchScreen> {
 final searchController = TextEditingController();
 String query = '';
 @override
 void dispose() {
  searchController.dispose();
  super.dispose();
 }
 @override
 Widget build(BuildContext context) {
  final restaurantsAsync = ref.watch(restaurantsProvider);
  final foodItemsAsync = ref.watch(foodItemsListProvider);
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: TextField(
     controller: searchController,
     autofocus: true,
     decoration: InputDecoration(hintText: FoodConstants.searchHint, border: InputBorder.none),
     onChanged: (value) => setState(() => query = value.toLowerCase()),
    ),
   ),
   body: query.isEmpty
     ? const Center(child: Text(FoodConstants.searchHintExample, style: TextStyle(color: Colors.grey)))
     : SingleChildScrollView(
       padding: const EdgeInsets.all(16),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(FoodConstants.restaurants, style: Theme.of(context).textTheme.titleMedium),
         const SizedBox(height: 8),
         restaurantsAsync.when(
          data: (restaurants) {
           final filtered = restaurants.where((r) => (r['sellerName']?.toString().toLowerCase() ?? '').contains(query)).toList();
           if (filtered.isEmpty) {
            return Padding(padding: const EdgeInsets.all(16), child: Text(FoodConstants.noRestaurantsFound, style: TextStyle(color: Colors.grey[600])));
           }
           return Column(
            children: filtered.take(5).map((restaurant) => Card(
             margin: const EdgeInsets.only(bottom: 8),
             child: ListTile(
              leading: Container(
               width: 48, height: 48,
               decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(8)),
               child: const Icon(Icons.restaurant, color: Colors.white),
              ),
              title: Text(restaurant['sellerName']?.toString() ?? FoodConstants.defaultRestaurant, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Row(children: [Icon(Icons.star, size: 14, color: Colors.amber[700]), const SizedBox(width: 4), Text('${restaurant['sellerRating'] ?? 4.5}')]),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/food/restaurant/${restaurant['sellerId']}'),
             ),
            )).toList(),
           );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox(),
         ),
         const SizedBox(height: 24),
         Text(FoodConstants.foodItems, style: Theme.of(context).textTheme.titleMedium),
         const SizedBox(height: 8),
         foodItemsAsync.when(
          data: (items) {
           final filtered = items.where((i) => (i['name']?.toString().toLowerCase() ?? '').contains(query) || (i['description']?.toString().toLowerCase() ?? '').contains(query)).toList();
           if (filtered.isEmpty) {
            return Padding(padding: const EdgeInsets.all(16), child: Text(FoodConstants.noFoodItemsFound, style: TextStyle(color: Colors.grey[600])));
           }
           return Column(
            children: filtered.take(10).map((item) => Card(
             margin: const EdgeInsets.only(bottom: 8),
             child: ListTile(
              leading: Container(
               width: 48, height: 48,
               decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(8)),
               child: const Icon(Icons.fastfood, color: Colors.white),
              ),
              title: Text(item['name']?.toString() ?? FoodConstants.defaultDish, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('\$${item['price'] ?? 0}', style: const TextStyle(color: AppColors.primary)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/food/item/${item['id']}'),
             ),
            )).toList(),
           );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox(),
         ),
        ],
       ),
      ),
  );
 }
}