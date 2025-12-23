import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/adminProvider.dart';
import '../constants/adminConstants.dart';
class AdminReportsScreen extends ConsumerWidget {
 const AdminReportsScreen({super.key});
 IconData _getIcon(String iconName) {
  switch (iconName) {
   case 'attachMoney':
    return Icons.attach_money;
   case 'trendingUp':
    return Icons.trending_up;
   case 'shoppingCart':
    return Icons.shopping_cart;
   case 'receipt':
    return Icons.receipt;
   default:
    return Icons.description;
  }
 }
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final reportTypesAsync = ref.watch(reportTypesProvider);
  final revenueStatsAsync = ref.watch(adminRevenueStatsProvider);
  return Scaffold(
   appBar: AppBar(title: const Text(AdminConstants.reportsTitle)),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      revenueStatsAsync.when(
       data: (stats) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_buildQuickStat(AdminConstants.totalRevenueLabel, '\$${(stats['total'] as num).toStringAsFixed(0)}'), _buildQuickStat(AdminConstants.thisMonthLabel, '\$${(stats['month'] as num).toStringAsFixed(0)}'), _buildQuickStat(AdminConstants.todayLabel, '\$${(stats['today'] as num).toStringAsFixed(0)}')]),
       ),
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (_, __) => const SizedBox.shrink(),
      ),
      const SizedBox(height: 24),
      const Text(AdminConstants.availableReportsTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      reportTypesAsync.when(
       data: (reportTypes) => Column(
        children: reportTypes
          .map(
           (report) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
             leading: Icon(_getIcon(report['icon'] as String), color: AppColors.primary),
             title: Text(report['name'] as String),
             trailing: IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AdminConstants.generatingReportPrefix}${report['name']}...')));
              },
             ),
            ),
           ),
          )
          .toList(),
       ),
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (_, __) => const Center(child: Text(AdminConstants.errorLoadingReportTypes)),
      ),
     ],
    ),
   ),
  );
 }
 Widget _buildQuickStat(String label, String value) {
  return Column(
   children: [
    Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
    const SizedBox(height: 4),
    Text(
     value,
     style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    ),
   ],
  );
 }
}