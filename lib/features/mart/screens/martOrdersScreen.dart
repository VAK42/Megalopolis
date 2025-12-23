import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/martProvider.dart';
import '../../../providers/authProvider.dart';
import '../../mart/constants/martConstants.dart';
class MartOrdersScreen extends ConsumerWidget {
 const MartOrdersScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final ordersAsync = ref.watch(martOrdersProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(MartConstants.myOrdersTitle),
   ),
   body: ordersAsync.when(
    data: (orders) {
     if (orders.isEmpty) {
      return const Center(child: Text(MartConstants.noOrders));
     }
     return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
       final order = orders[index];
       final status = order['status']?.toString() ?? MartConstants.processing;
       final canCancel = status == MartConstants.processing || status == 'pending';
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
        child: Card(
         margin: const EdgeInsets.only(bottom: 12),
         child: ListTile(
          title: Text('${MartConstants.orderPrefix}${order['id']}', style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Text(DateFormat('MMM dd, yyyy').format(DateTime.fromMillisecondsSinceEpoch(order['createdAt'] as int))),
            Row(
             children: [
              Text(
               '${MartConstants.status}: $status',
               style: TextStyle(color: _getStatusColor(status), fontWeight: FontWeight.bold),
              ),
              if (canCancel) IconButton(icon: const Icon(Icons.cancel_outlined, size: 18), color: AppColors.error, onPressed: () => _showCancelDialog(context, ref, order['id'].toString(), userId)),
             ],
            ),
           ],
          ),
          trailing: Text(
           '\$${(order['total'] as num).toStringAsFixed(2)}',
           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
          ),
          onTap: () {},
         ),
        ),
       );
      },
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, stack) => Center(child: Text('${MartConstants.errorPrefix}$e')),
   ),
  );
 }
 Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
   case 'delivered':
    return AppColors.success;
   case 'cancelled':
    return AppColors.error;
   case 'shipped':
    return Colors.blue;
   default:
    return AppColors.primary;
  }
 }
 void _showCancelDialog(BuildContext context, WidgetRef ref, String orderId, String userId) {
  showDialog(
   context: context,
   builder: (ctx) => AlertDialog(
    title: const Text(MartConstants.cancelOrder),
    content: const Text(MartConstants.confirmCancel),
    actions: [
     TextButton(onPressed: () => Navigator.pop(ctx), child: const Text(MartConstants.cancel)),
     TextButton(
      onPressed: () async {
       await ref.read(martOrdersProvider(userId).notifier).cancelOrder(orderId);
       if (ctx.mounted) Navigator.pop(ctx);
       if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(MartConstants.orderCancelled)));
       }
      },
      child: Text(MartConstants.confirm, style: TextStyle(color: AppColors.error)),
     ),
    ],
   ),
  );
 }
 Future<bool> _showDeleteDialog(BuildContext context, WidgetRef ref, String orderId, String userId) async {
  final result = await showDialog<bool>(
   context: context,
   builder: (ctx) => AlertDialog(
    title: const Text(MartConstants.deleteOrder),
    content: const Text(MartConstants.confirmDelete),
    actions: [
     TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text(MartConstants.cancel)),
     TextButton(
      onPressed: () async {
       await ref.read(martOrdersProvider(userId).notifier).deleteOrder(orderId);
       if (ctx.mounted) Navigator.pop(ctx, true);
       if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(MartConstants.orderDeleted)));
       }
      },
      child: Text(MartConstants.delete, style: TextStyle(color: AppColors.error)),
     ),
    ],
   ),
  );
  return result ?? false;
 }
}