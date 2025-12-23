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
   body: restaurantsAsync.when(
    data: (restaurants) {
     final filtered = query.isEmpty ? restaurants : restaurants.where((r) => (r['sellerName']?.toString().toLowerCase() ?? '').contains(query)).toList();
     if (filtered.isEmpty) {
      return const Center(child: Text(FoodConstants.noResults));
     }
     return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
       final restaurant = filtered[index];
       return Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
         leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.restaurant, color: Colors.white),
         ),
         title: Text(restaurant['sellerName']?.toString() ?? FoodConstants.defaultRestaurant, style: const TextStyle(fontWeight: FontWeight.bold)),
         subtitle: Row(
          children: [
           Icon(Icons.star, size: 14, color: Colors.amber[700]),
           const SizedBox(width: 4),
           Text('${restaurant['sellerRating'] ?? 4.5}'),
          ],
         ),
         trailing: const Icon(Icons.chevron_right),
         onTap: () => context.push('/food/restaurant/${restaurant['sellerId']}'),
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