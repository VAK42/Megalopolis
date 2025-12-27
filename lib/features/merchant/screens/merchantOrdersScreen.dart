import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/merchantProvider.dart';
import '../../../providers/authProvider.dart';
import '../../merchant/constants/merchantConstants.dart';
class MerchantOrdersScreen extends ConsumerWidget {
 const MerchantOrdersScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final merchantId = ref.watch(currentUserIdProvider) ?? 'user1';
  final ordersAsync = ref.watch(merchantOrdersProvider(merchantId));
  return Scaffold(
   appBar: AppBar(title: const Text(MerchantConstants.ordersTitle)),
   body: ordersAsync.when(
    data: (orders) {
     if (orders.isEmpty) {
      return const Center(child: Text(MerchantConstants.noOrdersFound));
     }
     return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
       final order = orders[index];
       final status = order['status'].toString();
       final displayStatus = status.isNotEmpty ? status[0].toUpperCase() + status.substring(1) : status;
       return Dismissible(
        key: Key(order['id'].toString()),
        direction: status == 'pending' ? DismissDirection.endToStart : DismissDirection.none,
        background: Container(
         alignment: Alignment.centerRight,
         padding: const EdgeInsets.only(right: 20),
         color: AppColors.error,
         child: const Icon(Icons.cancel, color: Colors.white),
        ),
        confirmDismiss: (direction) async {
         return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
           title: const Text(MerchantConstants.cancelled),
           content: Text('${MerchantConstants.orderPrefix}${order['id']}?'),
           actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text(MerchantConstants.cancel)),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text(MerchantConstants.success)),
           ],
          ),
         );
        },
        onDismissed: (direction) {
         ref.read(merchantRepositoryProvider).cancelOrder(order['id'].toString());
         ref.invalidate(merchantOrdersProvider(merchantId));
        },
        child: Card(
         margin: const EdgeInsets.only(bottom: 12),
         child: ListTile(
          title: Text('${MerchantConstants.orderPrefix}${order['id']}', style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Text(DateFormat('MMM dd, yyyy').format(DateTime.fromMillisecondsSinceEpoch(order['createdAt'] as int))),
            Text(
             '${MerchantConstants.statusLabel}$displayStatus',
             style: TextStyle(color: _getStatusColor(status), fontWeight: FontWeight.bold),
            ),
           ],
          ),
          trailing: Row(
           mainAxisSize: MainAxisSize.min,
           children: [
            if (status == 'pending')
             PopupMenuButton<String>(
              onSelected: (newStatus) {
               ref.read(merchantRepositoryProvider).updateOrderStatus(order['id'].toString(), newStatus);
               ref.invalidate(merchantOrdersProvider(merchantId));
              },
              itemBuilder: (ctx) => [PopupMenuItem(value: MerchantConstants.delivered, child: Text(MerchantConstants.delivered)), PopupMenuItem(value: MerchantConstants.cancelled, child: Text(MerchantConstants.cancelled))],
             ),
            Text(
             '\$${(order['total'] as num).toStringAsFixed(2)}',
             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
            ),
           ],
          ),
         ),
        ),
       );
      },
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, s) => Center(child: Text('${MerchantConstants.errorGeneric}: $e')),
   ),
  );
 }
 Color _getStatusColor(String status) {
  switch (status) {
   case 'delivered':
   case 'completed':
    return Colors.green;
   case 'cancelled':
    return AppColors.error;
   case 'pending':
   case 'preparing':
    return Colors.orange;
   default:
    return AppColors.primary;
  }
 }
}