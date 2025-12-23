import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/adminProvider.dart';
import '../constants/adminConstants.dart';
class AdminAnalyticsScreen extends ConsumerWidget {
 const AdminAnalyticsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final revenueStatsAsync = ref.watch(adminRevenueStatsProvider);
  final moduleRevenueAsync = ref.watch(adminModuleRevenueProvider);
  return Scaffold(
   appBar: AppBar(title: const Text(AdminConstants.analyticsTitle)),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      revenueStatsAsync.when(
       data: (stats) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
        child: Column(
         children: [
          const Text(AdminConstants.totalRevenueLabel, style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Text(
           '\$${(stats['total'] as num).toStringAsFixed(2)}',
           style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: [
            Column(
             children: [
              const Text(AdminConstants.todayLabel, style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text(
               '\$${(stats['today'] as num).toStringAsFixed(2)}',
               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
             ],
            ),
            Column(
             children: [
              const Text(AdminConstants.thisWeekLabel, style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text(
               '\$${(stats['week'] as num).toStringAsFixed(2)}',
               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
             ],
            ),
            Column(
             children: [
              const Text(AdminConstants.thisMonthLabel, style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text(
               '\$${(stats['month'] as num).toStringAsFixed(2)}',
               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
             ],
            ),
           ],
          ),
         ],
        ),
       ),
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (err, stack) => const Text(AdminConstants.errorLoadingRevenue),
      ),
      const SizedBox(height: 24),
      const Text(AdminConstants.revenueByModuleTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      moduleRevenueAsync.when(
       data: (moduleRevenue) => Column(children: [_buildRevenueItem(AdminConstants.foodDeliveryLabel, moduleRevenue['food'] ?? 0, moduleRevenue.values.fold(0.0, (sum, val) => sum + val)), _buildRevenueItem(AdminConstants.rideHailingLabel, moduleRevenue['ride'] ?? 0, moduleRevenue.values.fold(0.0, (sum, val) => sum + val)), _buildRevenueItem(AdminConstants.eCommerceLabel, moduleRevenue['mart'] ?? 0, moduleRevenue.values.fold(0.0, (sum, val) => sum + val)), _buildRevenueItem(AdminConstants.walletLabel, moduleRevenue['wallet'] ?? 0, moduleRevenue.values.fold(0.0, (sum, val) => sum + val)), _buildRevenueItem(AdminConstants.servicesLabel, moduleRevenue['service'] ?? 0, moduleRevenue.values.fold(0.0, (sum, val) => sum + val))]),
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (err, stack) => const Text(AdminConstants.errorLoadingModuleRevenue),
      ),
     ],
    ),
   ),
  );
 }
 Widget _buildRevenueItem(String name, double revenue, double total) {
  final value = total > 0 ? revenue / total : 0.0;
  return Container(
   margin: const EdgeInsets.only(bottom: 12),
   padding: const EdgeInsets.all(12),
   decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
   child: Column(
    children: [
     Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
       Text(
        '\$${revenue.toStringAsFixed(2)}',
        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
       ),
      ],
     ),
     const SizedBox(height: 8),
     LinearProgressIndicator(value: value, backgroundColor: Colors.grey[300], valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary), minHeight: 6, borderRadius: BorderRadius.circular(3)),
    ],
   ),
  );
 }
}