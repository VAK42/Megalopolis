import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/foodProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/foodConstants.dart';
class FoodOrderHistoryScreen extends ConsumerWidget {
 const FoodOrderHistoryScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final ordersAsync = ref.watch(foodOrdersProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.foodHome)),
    title: const Text(FoodConstants.orderHistoryTitle),
   ),
   body: ordersAsync.when(
    data: (orders) => orders.isEmpty
      ? const Center(child: Text(FoodConstants.noOrdersYet))
      : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
         final order = orders[index];
         final status = order['status']?.toString() ?? 'pending';
         final canCancel = status == 'pending' || status == 'confirmed';
         return Dismissible(
          key: Key(order['id'].toString()),
          direction: DismissDirection.endToStart,
          background: Container(
           alignment: Alignment.centerRight,
           padding: const EdgeInsets.only(right: 20),
           color: AppColors.error,
           child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) => _showDeleteDialog(context, ref, order['id'].toString(), userId),
          child: GestureDetector(
           onTap: () => context.go('${Routes.foodOrderDetail}/${order['id']}'),
           onLongPress: canCancel ? () => _showCancelDialog(context, ref, order['id'].toString(), userId) : null,
           child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
             padding: const EdgeInsets.all(12),
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 Text('${FoodConstants.orderPrefix}${order['id']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                 Row(
                  children: [
                   Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: _getStatusColor(status).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                    child: Text(
                     status.toUpperCase(),
                     style: TextStyle(fontSize: 12, color: _getStatusColor(status), fontWeight: FontWeight.bold),
                    ),
                   ),
                   if (canCancel) IconButton(icon: const Icon(Icons.cancel_outlined, size: 20), color: AppColors.error, onPressed: () => _showCancelDialog(context, ref, order['id'].toString(), userId)),
                  ],
                 ),
                ],
               ),
               const SizedBox(height: 8),
               Text(order['sellerName']?.toString() ?? FoodConstants.defaultRestaurant, style: const TextStyle(fontSize: 14)),
               const SizedBox(height: 8),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 Text(order['createdAt'] != null ? DateTime.fromMillisecondsSinceEpoch(order['createdAt'] as int).toString().substring(0, 10) : FoodConstants.today, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                 Text('\$${order['total']?.toString() ?? '0'}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
               ),
              ],
             ),
            ),
           ),
          ),
         );
        },
       ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (error, stack) => Center(child: Text('${FoodConstants.errorPrefix}$error')),
   ),
  );
 }
 Color _getStatusColor(String status) {
  switch (status) {
   case 'delivered':
    return AppColors.success;
   case 'cancelled':
    return AppColors.error;
   default:
    return AppColors.primary;
  }
 }
 void _showCancelDialog(BuildContext context, WidgetRef ref, String orderId, String userId) {
  showDialog(
   context: context,
   builder: (ctx) => AlertDialog(
    title: const Text(FoodConstants.cancelOrder),
    content: const Text(FoodConstants.cancelOrderMessage),
    actions: [
     TextButton(onPressed: () => Navigator.pop(ctx), child: Text(FoodConstants.cancel)),
     TextButton(
      onPressed: () async {
       await ref.read(foodOrdersProvider(userId).notifier).cancelOrder(orderId);
       if (ctx.mounted) Navigator.pop(ctx);
       if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(FoodConstants.orderCancelled)));
       }
      },
      child: Text(FoodConstants.confirm, style: TextStyle(color: AppColors.error)),
     ),
    ],
   ),
  );
 }
 Future<bool> _showDeleteDialog(BuildContext context, WidgetRef ref, String orderId, String userId) async {
  final result = await showDialog<bool>(
   context: context,
   builder: (ctx) => AlertDialog(
    title: const Text(FoodConstants.deleteOrderTitle),
    content: const Text(FoodConstants.deleteOrderMessage),
    actions: [
     TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(FoodConstants.cancel)),
     TextButton(
      onPressed: () async {
       await ref.read(foodOrdersProvider(userId).notifier).deleteOrder(orderId);
       if (ctx.mounted) Navigator.pop(ctx, true);
       if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(FoodConstants.orderDeleted)));
       }
      },
      child: Text(FoodConstants.delete, style: TextStyle(color: AppColors.error)),
     ),
    ],
   ),
  );
  return result ?? false;
 }
}