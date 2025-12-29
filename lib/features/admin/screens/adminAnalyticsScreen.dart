import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/adminProvider.dart';
import '../../../data/repositories/adminRepository.dart';
import '../widgets/adminScaffold.dart';
import '../constants/adminConstants.dart';
final adminRevenueStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
 final repository = AdminRepository();
 return await repository.getRevenueStats();
});
final adminModuleRevenueProvider = FutureProvider<Map<String, double>>((ref) async {
 final repository = AdminRepository();
 return await repository.getModuleRevenue();
});
class AdminAnalyticsScreen extends ConsumerWidget {
 const AdminAnalyticsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final statsAsync = ref.watch(adminDashboardStatsProvider);
  final revenueAsync = ref.watch(adminRevenueStatsProvider);
  final moduleRevenueAsync = ref.watch(adminModuleRevenueProvider);
  return AdminScaffold(
   title: AdminConstants.analyticsOverviewTitle,
   actions: [IconButton(icon: const Icon(Icons.refresh_rounded, color: Colors.white), onPressed: () { ref.invalidate(adminDashboardStatsProvider); ref.invalidate(adminRevenueStatsProvider); ref.invalidate(adminModuleRevenueProvider); })],
   body: RefreshIndicator(
    onRefresh: () async { ref.invalidate(adminDashboardStatsProvider); ref.invalidate(adminRevenueStatsProvider); ref.invalidate(adminModuleRevenueProvider); },
    child: SingleChildScrollView(
     physics: const AlwaysScrollableScrollPhysics(),
     padding: const EdgeInsets.all(20),
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Text(AdminConstants.businessAnalyticsTitle, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[800])),
       const SizedBox(height: 8),
       Text(AdminConstants.businessAnalyticsSubtitle, style: TextStyle(color: Colors.grey[600])),
       const SizedBox(height: 24),
       statsAsync.when(
        data: (stats) => Column(
         children: [
          Row(
           children: [
            Expanded(child: _buildMetricCard(AdminConstants.totalRevenueMetric, '\$${(stats['revenue'] as num).toStringAsFixed(0)}', Icons.attach_money_rounded, const Color(0xFF10B981))),
            const SizedBox(width: 16),
            Expanded(child: _buildMetricCard(AdminConstants.activeUsersMetric, '${stats['totalUsers']}', Icons.people_rounded, const Color(0xFF6366F1))),
           ],
          ),
          const SizedBox(height: 16),
          Row(
           children: [
            Expanded(child: _buildMetricCard(AdminConstants.ordersMetric, '${stats['activeOrders']}', Icons.shopping_bag_rounded, const Color(0xFFF59E0B))),
            const SizedBox(width: 16),
            Expanded(child: _buildMetricCard(AdminConstants.supportTicketsLabel, '${stats['supportTickets']}', Icons.support_agent_rounded, const Color(0xFFEF4444))),
           ],
          ),
         ],
        ),
        loading: () => const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator())),
        error: (e, __) => Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Row(children: [const Icon(Icons.error_outline_rounded, color: AppColors.error), const SizedBox(width: 12), Expanded(child: Text('${AdminConstants.errorLoadingAnalytics}: $e', style: const TextStyle(color: AppColors.error)))])),
       ),
       const SizedBox(height: 32),
       Text(AdminConstants.revenueOverviewTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[800])),
       const SizedBox(height: 16),
       revenueAsync.when(
        data: (revenue) => Container(
         padding: const EdgeInsets.all(20),
         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade100)),
         child: Column(
          children: [
           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(AdminConstants.totalRevenueLabel, style: TextStyle(color: Colors.grey[600])), Text('\$${(revenue['total'] as num).toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary))]),
           const Divider(height: 32),
           Row(
            children: [
             Expanded(child: _buildRevenueItem(AdminConstants.todayLabel, '\$${(revenue['today'] as num).toStringAsFixed(0)}', const Color(0xFF10B981))),
             Container(width: 1, height: 40, color: Colors.grey[200]),
             Expanded(child: _buildRevenueItem(AdminConstants.thisWeekLabel, '\$${(revenue['week'] as num).toStringAsFixed(0)}', const Color(0xFF6366F1))),
             Container(width: 1, height: 40, color: Colors.grey[200]),
             Expanded(child: _buildRevenueItem(AdminConstants.thisMonthLabel, '\$${(revenue['month'] as num).toStringAsFixed(0)}', const Color(0xFFF59E0B))),
            ],
           ),
          ],
         ),
        ),
        loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
        error: (_, __) => Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)), child: Text(AdminConstants.errorLoadingRevenue, style: TextStyle(color: Colors.grey[600]))),
       ),
       const SizedBox(height: 32),
       Text(AdminConstants.revenueByModuleTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[800])),
       const SizedBox(height: 16),
       moduleRevenueAsync.when(
        data: (moduleRevenue) {
         final total = moduleRevenue.values.fold(0.0, (a, b) => a + b);
         final sortedEntries = moduleRevenue.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
         return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade100)),
          child: Column(
           children: sortedEntries.map((entry) {
            final percentage = total > 0 ? entry.value / total : 0.0;
            Color color;
            IconData icon;
            String label;
            switch (entry.key) { case 'food': color = const Color(0xFFF59E0B); icon = Icons.restaurant_rounded; label = AdminConstants.foodDeliveryLabel; break; case 'ride': color = const Color(0xFF6366F1); icon = Icons.local_taxi_rounded; label = AdminConstants.rideHailingLabel; break; case 'mart': color = const Color(0xFF10B981); icon = Icons.shopping_cart_rounded; label = AdminConstants.eCommerceLabel; break; case 'service': color = const Color(0xFFEC4899); icon = Icons.handyman_rounded; label = AdminConstants.servicesLabel; break; case 'wallet': color = const Color(0xFF8B5CF6); icon = Icons.wallet_rounded; label = AdminConstants.walletLabel; break; default: color = Colors.grey; icon = Icons.circle; label = entry.key; }
            return Padding(
             padding: const EdgeInsets.only(bottom: 16),
             child: Column(
              children: [
               Row(
                children: [
                 Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 20)),
                 const SizedBox(width: 12),
                 Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
                 Text('\$${entry.value.toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                 const SizedBox(width: 8),
                 Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Text('${(percentage * 100).toStringAsFixed(1)}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color))),
                ],
               ),
               const SizedBox(height: 8),
               ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: percentage, minHeight: 8, backgroundColor: Colors.grey[200], valueColor: AlwaysStoppedAnimation(color))),
              ],
             ),
            );
           }).toList(),
          ),
         );
        },
        loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
        error: (_, __) => Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)), child: Text(AdminConstants.errorLoadingModuleRevenue, style: TextStyle(color: Colors.grey[600]))),
       ),
       const SizedBox(height: 32),
       Text(AdminConstants.topCategoriesTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[800])),
       const SizedBox(height: 16),
       Container(
        height: 200,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade100)),
        child: moduleRevenueAsync.when(
         data: (moduleRevenue) {
          final maxValue = moduleRevenue.values.fold(0.0, (a, b) => a > b ? a : b);
          return Row(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           crossAxisAlignment: CrossAxisAlignment.end,
           children: moduleRevenue.entries.map((entry) {
            final height = maxValue > 0 ? (entry.value / maxValue) : 0.0;
            Color color;
            switch (entry.key) { case 'food': color = const Color(0xFFF59E0B); break; case 'ride': color = const Color(0xFF6366F1); break; case 'mart': color = const Color(0xFF10B981); break; case 'service': color = const Color(0xFFEC4899); break; case 'wallet': color = const Color(0xFF8B5CF6); break; default: color = Colors.grey; }
            return Column(
             mainAxisAlignment: MainAxisAlignment.end,
             children: [
              Text('\$${entry.value.toStringAsFixed(0)}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 4),
              Container(width: 32, height: 120 * height, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6))),
              const SizedBox(height: 8),
              Text(entry.key[0].toUpperCase() + entry.key.substring(1), style: TextStyle(color: Colors.grey[600], fontSize: 11)),
             ],
            );
           }).toList(),
          );
         },
         loading: () => const Center(child: CircularProgressIndicator()),
         error: (_, __) => const Center(child: Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error)),
        ),
       ),
      ],
     ),
    ),
   ),
  );
 }
 Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
  return Container(
   padding: const EdgeInsets.all(20),
   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade100), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2))]),
   child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 24)),
     const SizedBox(height: 16),
     Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[800])),
     const SizedBox(height: 4),
     Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
    ],
   ),
  );
 }
 Widget _buildRevenueItem(String label, String value, Color color) {
  return Column(children: [Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)), const SizedBox(height: 4), Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12))]);
 }
}