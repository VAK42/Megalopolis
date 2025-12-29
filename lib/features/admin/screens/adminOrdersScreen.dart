import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/adminProvider.dart';
import '../../../data/repositories/adminRepository.dart';
import '../widgets/adminScaffold.dart';
import '../constants/adminConstants.dart';
class AdminOrdersScreen extends ConsumerStatefulWidget {
 const AdminOrdersScreen({super.key});
 @override
 ConsumerState<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}
class _AdminOrdersScreenState extends ConsumerState<AdminOrdersScreen> with SingleTickerProviderStateMixin {
 late TabController _tabController;
 final AdminRepository repository = AdminRepository();
 String selectedStatus = 'all';
 @override
 void initState() {
  super.initState();
  _tabController = TabController(length: 4, vsync: this);
 }
 @override
 void dispose() {
  _tabController.dispose();
  super.dispose();
 }
 Future<void> _showUpdateStatusDialog(Map<String, dynamic> order) async {
  String currentStatus = order['status']?.toString() ?? 'pending';
  await showDialog(
   context: context,
   builder: (context) => StatefulBuilder(
    builder: (context, setDialogState) => AlertDialog(
     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
     title: Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.edit_rounded, color: AppColors.info)), const SizedBox(width: 12), Text(AdminConstants.updateStatusTitle)]),
     content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
       Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12)),
        child: Row(children: [const Icon(Icons.receipt_long_rounded, color: AppColors.primary), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${AdminConstants.orderPrefix}${order['id'].toString()}', style: const TextStyle(fontWeight: FontWeight.bold)), Text('\$${(order['total'] as num).toStringAsFixed(2)}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500))]))]),
       ),
       const SizedBox(height: 20),
       ...AdminConstants.orderStatuses.map((status) {
        final isSelected = currentStatus == status;
        Color statusColor = status == 'completed' ? AppColors.success : (status == 'cancelled' ? AppColors.error : (status == 'processing' ? AppColors.info : AppColors.warning));
        return Container(
         margin: const EdgeInsets.only(bottom: 8),
         child: ListTile(
          onTap: () => setDialogState(() => currentStatus = status),
          leading: Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? statusColor : Colors.grey),
          title: Text(status[0].toUpperCase() + status.substring(1), style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          trailing: Icon(status == 'completed' ? Icons.check_circle_rounded : (status == 'cancelled' ? Icons.cancel_rounded : (status == 'processing' ? Icons.autorenew_rounded : Icons.pending_rounded)), color: statusColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          tileColor: isSelected ? statusColor.withValues(alpha: 0.1) : Colors.grey[100],
         ),
        );
       }),
      ],
     ),
     actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: Text(AdminConstants.cancelButton, style: TextStyle(color: Colors.grey[600]))),
      ElevatedButton(
       onPressed: () async {
        await repository.updateOrderStatus(order['id'].toString(), currentStatus);
        if (mounted) {
         Navigator.pop(context);
         ref.invalidate(adminOrdersProvider);
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AdminConstants.statusUpdatedPrefix}${currentStatus[0].toUpperCase()}${currentStatus.substring(1)}'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
        }
       },
       style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
       child: Text(AdminConstants.updateStatusButton),
      ),
     ],
    ),
   ),
  );
 }
 Future<void> _confirmCancelOrder(Map<String, dynamic> order) async {
  final confirmed = await showDialog<bool>(
   context: context,
   builder: (context) => AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    title: Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.cancel_rounded, color: AppColors.error)), const SizedBox(width: 12), Text(AdminConstants.cancelOrderTitle)]),
    content: Column(
     mainAxisSize: MainAxisSize.min,
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Text(AdminConstants.cancelOrderConfirm),
      const SizedBox(height: 16),
      Container(
       padding: const EdgeInsets.all(12),
       decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('${AdminConstants.orderPrefix}${order['id'].toString()}', style: const TextStyle(fontWeight: FontWeight.bold)), Text('\$${(order['total'] as num).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary))]),
         const SizedBox(height: 8),
         Text('${AdminConstants.typeColumnPrefix}${order['orderType']?.toString().toUpperCase() ?? AdminConstants.unknownLabel}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        ],
       ),
      ),
     ],
    ),
    actions: [
     TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AdminConstants.cancelButton, style: TextStyle(color: Colors.grey[600]))),
     ElevatedButton(onPressed: () => Navigator.pop(context, true), style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: Text(AdminConstants.cancelOrderButton)),
    ],
   ),
  );
  if (confirmed == true) {
   await repository.cancelOrder(order['id'].toString());
   ref.invalidate(adminOrdersProvider);
   if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.orderCancelledSuccess), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
  }
 }
 void _showOrderDetails(Map<String, dynamic> order) {
  final status = order['status']?.toString() ?? 'pending';
  Color statusColor = status == 'completed' ? AppColors.success : (status == 'cancelled' ? AppColors.error : (status == 'processing' ? AppColors.info : AppColors.warning));
  showModalBottomSheet(
   context: context,
   isScrollControlled: true,
   shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
   builder: (context) => DraggableScrollableSheet(
    initialChildSize: 0.7,
    minChildSize: 0.5,
    maxChildSize: 0.95,
    expand: false,
    builder: (context, scrollController) => SingleChildScrollView(
     controller: scrollController,
     padding: const EdgeInsets.all(24),
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
       const SizedBox(height: 20),
       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('${AdminConstants.orderPrefix}${order['id'].toString()}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)), child: Text(status.toUpperCase(), style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)))]),
       const SizedBox(height: 24),
       _buildDetailRow(AdminConstants.typeLabel, order['orderType']?.toString().toUpperCase() ?? AdminConstants.unknownLabel, Icons.category_rounded),
       _buildDetailRow(AdminConstants.totalColumnLabel, '\$${(order['total'] as num).toStringAsFixed(2)}', Icons.attach_money_rounded),
       _buildDetailRow(AdminConstants.customerLabel, order['userId']?.toString() ?? AdminConstants.unknownText, Icons.person_rounded),
       _buildDetailRow(AdminConstants.createdPrefix.replaceAll(': ', ''), _formatDate(order['createdAt']), Icons.access_time_rounded),
       const SizedBox(height: 24),
       if (status != 'completed' && status != 'cancelled') ...[
        Row(
         children: [
          Expanded(child: ElevatedButton.icon(onPressed: () { Navigator.pop(context); _showUpdateStatusDialog(order); }, icon: const Icon(Icons.edit_rounded), label: Text(AdminConstants.updateStatusButton), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.all(16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
          const SizedBox(width: 12),
          Expanded(child: OutlinedButton.icon(onPressed: () { Navigator.pop(context); _confirmCancelOrder(order); }, icon: const Icon(Icons.cancel_rounded), label: Text(AdminConstants.cancelButton), style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, padding: const EdgeInsets.all(16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
         ],
        ),
       ],
      ],
     ),
    ),
   ),
  );
 }
 Widget _buildDetailRow(String label, String value, IconData icon) {
  return Container(
   padding: const EdgeInsets.symmetric(vertical: 12),
   decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
   child: Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: AppColors.primary, size: 20)), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)), const SizedBox(height: 2), Text(value, style: const TextStyle(fontWeight: FontWeight.w500))]))]),
  );
 }
 String _formatDate(dynamic timestamp) {
  if (timestamp == null) return AdminConstants.unknownText;
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp is int ? timestamp : int.tryParse(timestamp.toString()) ?? 0);
  return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
 }
 @override
 Widget build(BuildContext context) {
  return AdminScaffold(
   title: AdminConstants.orderManagementTitle,
   body: Column(
    children: [
     Container(
      color: Colors.white,
      child: Column(
       children: [
        Container(
         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
         child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
           children: ['all', ...AdminConstants.orderStatuses].map((status) {
            final isSelected = selectedStatus == status;
            return Padding(
             padding: const EdgeInsets.only(right: 8),
             child: FilterChip(
              label: Text(status[0].toUpperCase() + status.substring(1)),
              selected: isSelected,
              onSelected: (_) => setState(() => selectedStatus = status),
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey[700]),
              checkmarkColor: Colors.white,
             ),
            );
           }).toList(),
          ),
         ),
        ),
        TabBar(controller: _tabController, labelColor: AppColors.primary, unselectedLabelColor: Colors.grey, indicatorColor: AppColors.primary, tabs: [Tab(text: AdminConstants.tabAll), Tab(text: AdminConstants.tabFood), Tab(text: AdminConstants.tabMart), Tab(text: AdminConstants.tabServices)]),
       ],
      ),
     ),
     Expanded(
      child: ref.watch(adminOrdersProvider).when(
       data: (orders) => TabBarView(
        controller: _tabController,
        children: AdminConstants.orderTypes.map((type) {
         var filteredOrders = type == 'all' ? orders : orders.where((o) => o['orderType'] == type).toList();
         if (selectedStatus != 'all') filteredOrders = filteredOrders.where((o) => o['status'] == selectedStatus).toList();
         if (filteredOrders.isEmpty) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.inbox_rounded, size: 64, color: Colors.grey[300]), const SizedBox(height: 16), Text(AdminConstants.noOrdersFound, style: TextStyle(color: Colors.grey[600]))]));
         return RefreshIndicator(
          onRefresh: () async => ref.invalidate(adminOrdersProvider),
          child: ListView.builder(
           padding: const EdgeInsets.all(20),
           itemCount: filteredOrders.length,
           itemBuilder: (context, index) {
            final order = filteredOrders[index];
            final status = order['status'] ?? 'pending';
            Color statusColor = status == 'completed' ? AppColors.success : (status == 'cancelled' ? Colors.grey : (status == 'processing' ? AppColors.info : AppColors.warning));
            return GestureDetector(
             onTap: () => _showOrderDetails(order),
             child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2))]),
              child: Padding(
               padding: const EdgeInsets.all(16),
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   Row(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.receipt_long_rounded, color: AppColors.primary, size: 20)), const SizedBox(width: 12), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${AdminConstants.orderPrefix}${order['id'].toString()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), Text(order['orderType']?.toString().toUpperCase() ?? AdminConstants.unknownLabel, style: TextStyle(color: Colors.grey[500], fontSize: 12))])]),
                   Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)), child: Text(status.toString().toUpperCase(), style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.bold))),
                  ],
                 ),
                 const SizedBox(height: 16),
                 Row(
                  children: [
                   Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(AdminConstants.customerLabel, style: TextStyle(fontSize: 12, color: Colors.grey[500])), const SizedBox(height: 4), Text(order['userId']?.toString() ?? AdminConstants.unknownText, style: const TextStyle(fontWeight: FontWeight.w500))])),
                   Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(AdminConstants.totalColumnLabel, style: TextStyle(fontSize: 12, color: Colors.grey[500])), const SizedBox(height: 4), Text('\$${(order['total'] as num).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16))])),
                   Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(AdminConstants.dateColumnLabel, style: TextStyle(fontSize: 12, color: Colors.grey[500])), const SizedBox(height: 4), Text(_formatDate(order['createdAt']).split(' ')[0], style: const TextStyle(fontWeight: FontWeight.w500))])),
                  ],
                 ),
                 if (status != 'cancelled' && status != 'completed') ...[
                  const SizedBox(height: 16),
                  Row(
                   children: [
                    Expanded(child: OutlinedButton.icon(onPressed: () => _showUpdateStatusDialog(order), icon: const Icon(Icons.edit_rounded, size: 18), label: Text(AdminConstants.updateActionButton), style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
                    const SizedBox(width: 12),
                    Expanded(child: OutlinedButton.icon(onPressed: () => _confirmCancelOrder(order), icon: const Icon(Icons.cancel_rounded, size: 18), label: Text(AdminConstants.cancelActionButton), style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
                   ],
                  ),
                 ],
                ],
               ),
              ),
             ),
            );
           },
          ),
         );
        }).toList(),
       ),
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (_, __) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.error_outline_rounded, size: 64, color: Colors.grey[400]), const SizedBox(height: 16), Text(AdminConstants.errorLoadingOrders, style: TextStyle(color: Colors.grey[600])), const SizedBox(height: 16), ElevatedButton.icon(onPressed: () => ref.invalidate(adminOrdersProvider), icon: const Icon(Icons.refresh_rounded), label: Text(AdminConstants.retryButton), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary))])),
      ),
     ),
    ],
   ),
  );
 }
}