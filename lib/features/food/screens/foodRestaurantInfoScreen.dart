import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/foodProvider.dart';
import '../constants/foodConstants.dart';
class FoodRestaurantInfoScreen extends ConsumerWidget {
 final String restaurantId;
 const FoodRestaurantInfoScreen({super.key, required this.restaurantId});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final restaurantsAsync = ref.watch(restaurantsProvider);
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(FoodConstants.restaurantInfoTitle),
   ),
   body: restaurantsAsync.when(
    data: (restaurants) {
     final restaurant = restaurants.firstWhere((r) => r['sellerId'].toString() == restaurantId, orElse: () => <String, dynamic>{});
     if (restaurant.isEmpty) {
      return Center(child: Text(FoodConstants.noRestaurantsAvailable));
     }
     return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Container(
         height: 200,
         decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
         child: const Center(child: Icon(Icons.restaurant, size: 64, color: Colors.white)),
        ),
        const SizedBox(height: 16),
        Text(restaurant['sellerName']?.toString() ?? FoodConstants.defaultRestaurant, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
         children: [
          Icon(Icons.star, color: Colors.amber[700]),
          const SizedBox(width: 4),
          Text('${restaurant['sellerRating'] ?? 4.5}', style: const TextStyle(fontWeight: FontWeight.bold)),
         ],
        ),
        const SizedBox(height: 24),
        _buildInfoRow(Icons.location_on, FoodConstants.address, '123 Main Street, City'),
        _buildInfoRow(Icons.access_time, FoodConstants.openingHours, '9:00 AM - 10:00 PM'),
        _buildInfoRow(Icons.phone, FoodConstants.phone, '+1 234 567 8900'),
        _buildInfoRow(Icons.delivery_dining, FoodConstants.delivery, FoodConstants.defaultDeliveryTime),
       ],
      ),
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(child: Text('${FoodConstants.errorPrefix}$e')),
   ),
  );
 }
 Widget _buildInfoRow(IconData icon, String label, String value) {
  return Padding(
   padding: const EdgeInsets.only(bottom: 16),
   child: Row(
    children: [
     Icon(icon, color: AppColors.primary),
     const SizedBox(width: 16),
     Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
       Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
     ),
    ],
   ),
  );
 }
}