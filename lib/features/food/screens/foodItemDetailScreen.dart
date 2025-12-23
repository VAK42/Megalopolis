import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/foodProvider.dart';
import '../constants/foodConstants.dart';
class FoodItemDetailScreen extends ConsumerWidget {
 final String itemId;
 const FoodItemDetailScreen({super.key, required this.itemId});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final itemAsync = ref.watch(foodItemProvider(itemId));
  return Scaffold(
   body: itemAsync.when(
    data: (item) {
     if (item == null) {
      return Center(child: Text(FoodConstants.noItems));
     }
     return CustomScrollView(
      slivers: [
       SliverAppBar(
        expandedHeight: 250,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
         background: Container(
          decoration: BoxDecoration(gradient: AppColors.primaryGradient),
          child: Center(child: Icon(Icons.restaurant, size: 80, color: Colors.white)),
         ),
        ),
       ),
       SliverToBoxAdapter(
        child: Padding(
         padding: const EdgeInsets.all(16),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Text(item['name']?.toString() ?? FoodConstants.defaultItem, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
           const SizedBox(height: 8),
           Text(item['description']?.toString() ?? FoodConstants.deliciousAndFresh, style: TextStyle(color: Colors.grey[600])),
           const SizedBox(height: 16),
           Row(
            children: [
             Text(
              '\$${item['price'] ?? 0}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
             ),
             const Spacer(),
             Row(
              children: [
               Icon(Icons.star, color: Colors.amber[700]),
               const SizedBox(width: 4),
               Text('${item['rating'] ?? 4.5}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
             ),
            ],
           ),
           const SizedBox(height: 24),
           SizedBox(
            width: double.infinity,
            child: ElevatedButton(
             onPressed: () async {
              await ref.read(foodCartProvider('1').notifier).addItem(itemId, 1);
              if (context.mounted) {
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(FoodConstants.addToCart)));
              }
             },
             style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
             child: const Text(FoodConstants.addToCart),
            ),
           ),
          ],
         ),
        ),
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