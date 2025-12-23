import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/adminProvider.dart';
import '../../../data/repositories/adminRepository.dart';
import '../../admin/constants/adminConstants.dart';
class AdminOrdersScreen extends ConsumerWidget {
 const AdminOrdersScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final repository = AdminRepository();
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
   await repository.updateOrderStatus(orderId, newStatus);
   ref.invalidate(adminOrdersProvider);
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AdminConstants.statusUpdatedPrefix}$newStatus')));
  }
  Future<void> showStatusDialog(Map<String, dynamic> order) async {
   await showDialog(
    context: context,
    builder: (context) => AlertDialog(
     title: const Text(AdminConstants.updateStatusTitle),
     content: RadioGroup<String>(
      groupValue: order['status'] as String?,
      onChanged: (value) {
       if (value != null) {
        Navigator.pop(context);
        updateOrderStatus(order['id'].toString(), value);
       }
      },
      child: Column(
       mainAxisSize: MainAxisSize.min,
       children: AdminConstants.orderStatuses.map((status) {
        return ListTile(
         title: Text(status[0].toUpperCase() + status.substring(1)),
         leading: Radio<String>(value: status),
         onTap: () {
          Navigator.pop(context);
          updateOrderStatus(order['id'].toString(), status);
         },
        );
       }).toList(),
      ),
     ),
    ),
   );
  }
  return DefaultTabController(
   length: 4,
   child: Scaffold(
    appBar: AppBar(
     title: const Text(AdminConstants.orderManagementTitle),
     bottom: const TabBar(
      tabs: [
       Tab(text: AdminConstants.tabAll),
       Tab(text: AdminConstants.tabFood),
       Tab(text: AdminConstants.tabMart),
       Tab(text: AdminConstants.tabServices),
      ],
     ),
    ),
    body: ref
      .watch(adminOrdersProvider)
      .when(
       data: (orders) => TabBarView(
        children: AdminConstants.orderTypes.map((type) {
         final filteredOrders = type == 'all' ? orders : orders.where((o) => o['orderType'] == type).toList();
         if (filteredOrders.isEmpty) {
          return const Center(child: Text(AdminConstants.noOrdersFound));
         }
         return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredOrders.length,
          itemBuilder: (context, index) {
           final order = filteredOrders[index];
           final status = order['status'] ?? 'pending';
           Color statusColor;
           switch (status) {
            case 'completed':
             statusColor = Colors.green;
             break;
            case 'cancelled':
             statusColor = Colors.grey;
             break;
            case 'processing':
             statusColor = Colors.blue;
             break;
            default:
             statusColor = Colors.orange;
           }
           return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
             padding: const EdgeInsets.all(12),
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 Text('${AdminConstants.orderPrefix}${order['id'].toString().substring(0, 8)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                 Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                  child: Text(
                   status.toString().toUpperCase(),
                   style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.bold),
                  ),
                 ),
                ],
               ),
               const SizedBox(height: 8),
               Text('${AdminConstants.customerIdPrefix}${order['userId']}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
               Text('${AdminConstants.totalPrefix}\$${(order['total'] as num).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600)),
               const SizedBox(height: 12),
               Row(
                children: [
                 Expanded(
                  child: OutlinedButton.icon(onPressed: () => showStatusDialog(order), icon: const Icon(Icons.edit, size: 16), label: const Text(AdminConstants.updateStatusButton)),
                 ),
                 const SizedBox(width: 8),
                 if (status != 'cancelled' && status != 'completed')
                  Expanded(
                   child: OutlinedButton.icon(
                    onPressed: () => updateOrderStatus(order['id'].toString(), 'cancelled'),
                    icon: const Icon(Icons.cancel, size: 16),
                    label: const Text(AdminConstants.cancelOrderButton),
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
                   ),
                  ),
                ],
               ),
              ],
             ),
            ),
           );
          },
         );
        }).toList(),
       ),
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (err, stack) => const Center(child: Text(AdminConstants.errorLoadingOrders)),
      ),
   ),
  );
 }
}