import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/foodProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/foodConstants.dart';
class FoodCartScreen extends ConsumerWidget {
 const FoodCartScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final cartAsync = ref.watch(foodCartProvider(userId));
  return Scaffold(
   appBar: AppBar(
    title: const Text(FoodConstants.cartTitle),
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.foodHome)),
    actions: [IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => ref.read(foodCartProvider(userId).notifier).clearCart())],
   ),
   body: cartAsync.when(
    data: (cartItems) {
     if (cartItems.isEmpty) {
      return Center(
       child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         const Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey),
         const SizedBox(height: 16),
         const Text(FoodConstants.cartEmpty, style: TextStyle(fontSize: 18, color: Colors.grey)),
         const SizedBox(height: 24),
         ElevatedButton(onPressed: () => context.go(Routes.foodHome), child: const Text(FoodConstants.startShopping)),
        ],
       ),
      );
     }
     double total = cartItems.fold(0, (sum, item) => sum + (((item['price'] ?? 0) as num) * ((item['quantity'] ?? 1) as int)));
     return Column(
      children: [
       Expanded(
        child: ListView.builder(
         padding: const EdgeInsets.all(16),
         itemCount: cartItems.length,
         itemBuilder: (c, i) {
          final item = cartItems[i];
          return Card(
           margin: const EdgeInsets.only(bottom: 12),
           child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
             children: [
              Container(
               width: 60,
               height: 60,
               decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
               child: const Icon(Icons.restaurant, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Text((item['name'] as String?) ?? FoodConstants.defaultItem, style: const TextStyle(fontWeight: FontWeight.bold)),
                 const SizedBox(height: 4),
                 Text('\$${item['price']}', style: const TextStyle(color: AppColors.primary)),
                ],
               ),
              ),
              Row(
               children: [
                IconButton(
                 icon: const Icon(Icons.remove_circle_outline),
                 onPressed: () {
                  if (((item['quantity'] ?? 1) as int) > 1) {
                   ref.read(foodCartProvider(userId).notifier).updateQuantity((item['id'] as String?) ?? '0', ((item['quantity'] as int?) ?? 1) - 1);
                  }
                 },
                ),
                Text('${item['quantity']}'),
                IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => ref.read(foodCartProvider(userId).notifier).updateQuantity((item['id'] as String?) ?? '0', ((item['quantity'] as int?) ?? 1) + 1)),
               ],
              ),
              IconButton(
               icon: const Icon(Icons.delete, color: AppColors.error),
               onPressed: () => ref.read(foodCartProvider(userId).notifier).removeItem((item['id'] as String?) ?? '0'),
              ),
             ],
            ),
           ),
          );
         },
        ),
       ),
       Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
         color: Colors.white,
         boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)],
        ),
        child: Column(
         children: [
          Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
            const Text(FoodConstants.total, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
             '\$${total.toStringAsFixed(2)}',
             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
           ],
          ),
          const SizedBox(height: 16),
          SizedBox(
           width: double.infinity,
           child: ElevatedButton(
            onPressed: () => context.go(Routes.foodCheckoutAddress),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
            child: const Text(FoodConstants.proceedToCheckout),
           ),
          ),
         ],
        ),
       ),
      ],
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (error, stack) => Center(child: Text('${FoodConstants.errorPrefix}$error')),
   ),
  );
 }
}