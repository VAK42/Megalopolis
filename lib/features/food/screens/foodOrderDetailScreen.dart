import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/foodProvider.dart';
import '../constants/foodConstants.dart';
class FoodOrderDetailScreen extends ConsumerWidget {
 final String orderId;
 const FoodOrderDetailScreen({super.key, required this.orderId});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userIdStr = ref.watch(currentUserIdProvider);
  final userId = userIdStr ?? '1';
  final ordersAsync = ref.watch(foodOrdersProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(FoodConstants.orderDetails),
   ),
   body: ordersAsync.when(
    data: (orders) {
     final order = orders.firstWhere((o) => o['id'].toString() == orderId, orElse: () => <String, dynamic>{});
     if (order.isEmpty) {
      return Center(child: Text(FoodConstants.orderNotFound));
     }
     return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Card(
         child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Row(
             children: [
              Text('${FoodConstants.orderPrefix}${order['id'].toString().substring(0, 8)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const Spacer(),
              Container(
               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
               decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
               child: Text(
                order['status']?.toString() ?? FoodConstants.pending,
                style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold),
               ),
              ),
             ],
            ),
            const Divider(height: 32),
            Text(
             '${FoodConstants.total}: \$${order['total'] ?? 0}',
             style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
           ],
          ),
         ),
        ),
        const SizedBox(height: 16),
        Text(FoodConstants.orderItems, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(
         child: ListTile(
          leading: Container(
           width: 48,
           height: 48,
           decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
           child: const Icon(Icons.restaurant, color: AppColors.primary),
          ),
          title: Text(FoodConstants.orderItems),
          subtitle: Text('${FoodConstants.quantity}: ${order['quantity'] ?? 1}'),
         ),
        ),
       ],
      ),
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(child: Text('${FoodConstants.errorPrefix}$e')),
   ),
  );
 }
}