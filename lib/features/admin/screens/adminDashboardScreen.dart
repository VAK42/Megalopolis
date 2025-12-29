import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/routeNames.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/adminProvider.dart';
import '../../../data/repositories/adminRepository.dart';
import '../widgets/adminScaffold.dart';
import '../constants/adminConstants.dart';
class AdminDashboardScreen extends ConsumerWidget {
 const AdminDashboardScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final dashboardStatsAsync = ref.watch(adminDashboardStatsProvider);
  final repository = AdminRepository();
  return AdminScaffold(
   title: AdminConstants.dashboardTitle,
   actions: [IconButton(icon: const Icon(Icons.refresh_rounded, color: Colors.white), onPressed: () => ref.invalidate(adminDashboardStatsProvider))],
   body: RefreshIndicator(
    onRefresh: () async => ref.invalidate(adminDashboardStatsProvider),
    child: SingleChildScrollView(
     physics: const AlwaysScrollableScrollPhysics(),
     padding: const EdgeInsets.all(20),
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Text(AdminConstants.overviewTitle, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.grey[800])),
       const SizedBox(height: 8),
       Text(AdminConstants.welcomeBackMessage, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
       const SizedBox(height: 24),
       dashboardStatsAsync.when(
        data: (stats) => Column(
         children: [
          Row(
           children: [
            Expanded(child: _buildStatCard(AdminConstants.totalUsersLabel, '${stats['totalUsers']}', Icons.people_rounded, const Color(0xFF6366F1), const Color(0xFF818CF8), () => context.go(Routes.adminUsers))),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard(AdminConstants.activeOrdersLabel, '${stats['activeOrders']}', Icons.shopping_cart_rounded, const Color(0xFFF59E0B), const Color(0xFFFBBF24), () => context.go(Routes.adminOrders))),
           ],
          ),
          const SizedBox(height: 16),
          Row(
           children: [
            Expanded(child: _buildStatCard(AdminConstants.revenueLabel, '\$${(stats['revenue'] as num).toStringAsFixed(0)}', Icons.attach_money_rounded, const Color(0xFF10B981), const Color(0xFF34D399), () => context.go(Routes.adminAnalytics))),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard(AdminConstants.supportTicketsLabel, '${stats['supportTickets']}', Icons.support_agent_rounded, const Color(0xFFEF4444), const Color(0xFFF87171), () => context.go(Routes.adminSupport))),
           ],
          ),
         ],
        ),
        loading: () => const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator())),
        error: (e, __) => Center(child: Column(children: [const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error), const SizedBox(height: 16), Text(AdminConstants.errorLoadingStats), const SizedBox(height: 8), Text('$e', style: TextStyle(color: Colors.grey[600], fontSize: 12)), const SizedBox(height: 16), ElevatedButton.icon(onPressed: () => ref.invalidate(adminDashboardStatsProvider), icon: const Icon(Icons.refresh_rounded), label: Text(AdminConstants.retryButton), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary))])),
       ),
       const SizedBox(height: 32),
       Text(AdminConstants.quickActionsTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800])),
       const SizedBox(height: 16),
       Row(
        children: [
         Expanded(child: _buildQuickAction(context, Icons.people_rounded, AdminConstants.manageUsersAction, const Color(0xFF6366F1), () => context.go(Routes.adminUsers))),
         const SizedBox(width: 12),
         Expanded(child: _buildQuickAction(context, Icons.shopping_bag_rounded, AdminConstants.viewOrdersAction, const Color(0xFFF59E0B), () => context.go(Routes.adminOrders))),
        ],
       ),
       const SizedBox(height: 12),
       Row(
        children: [
         Expanded(child: _buildQuickAction(context, Icons.analytics_rounded, AdminConstants.drawerAnalytics, const Color(0xFF10B981), () => context.go(Routes.adminAnalytics))),
         const SizedBox(width: 12),
         Expanded(child: _buildQuickAction(context, Icons.campaign_rounded, AdminConstants.drawerPromotions, const Color(0xFFEC4899), () => context.go(Routes.adminPromotions))),
        ],
       ),
       const SizedBox(height: 12),
       Row(
        children: [
         Expanded(child: _buildQuickAction(context, Icons.notifications_rounded, AdminConstants.sendNotificationAction, const Color(0xFF8B5CF6), () => context.go(Routes.adminNotifications))),
         const SizedBox(width: 12),
         Expanded(child: _buildQuickAction(context, Icons.settings_rounded, AdminConstants.drawerSettings, const Color(0xFF64748B), () => context.go(Routes.adminConfig))),
        ],
       ),
       const SizedBox(height: 32),
       Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         Text(AdminConstants.recentActivityTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800])),
         TextButton.icon(onPressed: () => context.go(Routes.adminOrders), icon: const Icon(Icons.arrow_forward_rounded, size: 18), label: Text(AdminConstants.viewAllButton), style: TextButton.styleFrom(foregroundColor: AppColors.primary)),
        ],
       ),
       const SizedBox(height: 16),
       FutureBuilder<List<Map<String, dynamic>>>(
        future: repository.getAllOrders(),
        builder: (context, snapshot) {
         if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
         final orders = snapshot.data!.take(5).toList();
         if (orders.isEmpty) return Center(child: Padding(padding: const EdgeInsets.all(40), child: Column(children: [Icon(Icons.inbox_rounded, size: 48, color: Colors.grey[300]), const SizedBox(height: 16), Text(AdminConstants.noRecentOrders, style: TextStyle(color: Colors.grey[600]))])));
         return Column(
          children: orders.map((order) {
           final status = order['status']?.toString() ?? 'pending';
           Color statusColor = status == 'completed' ? AppColors.success : (status == 'cancelled' ? Colors.grey : (status == 'processing' ? AppColors.info : AppColors.warning));
           return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100)),
            child: Row(
             children: [
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.receipt_long_rounded, color: AppColors.primary, size: 20)),
              const SizedBox(width: 16),
              Expanded(
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Text('${AdminConstants.orderPrefix}${order['id'].toString()}', style: const TextStyle(fontWeight: FontWeight.w600)),
                 const SizedBox(height: 2),
                 Text('\$${(order['total'] as num).toStringAsFixed(2)}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                ],
               ),
              ),
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Text(status.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor))),
             ],
            ),
           );
          }).toList(),
         );
        },
       ),
      ],
     ),
    ),
   ),
  );
 }
 Widget _buildStatCard(String title, String value, IconData icon, Color color1, Color color2, VoidCallback onTap) {
  return GestureDetector(
   onTap: onTap,
   child: Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(gradient: LinearGradient(colors: [color1, color2], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: color1.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))]),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: Colors.white, size: 24)),
        Icon(Icons.arrow_forward_rounded, color: Colors.white.withValues(alpha: 0.7), size: 20),
       ],
      ),
      const SizedBox(height: 16),
      Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      Text(title, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
     ],
    ),
   ),
  );
 }
 Widget _buildQuickAction(BuildContext context, IconData icon, String title, Color color, VoidCallback onTap) {
  return Material(
   color: Colors.white,
   borderRadius: BorderRadius.circular(16),
   child: InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
     padding: const EdgeInsets.all(20),
     decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
     child: Column(
      children: [
       Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 28)),
       const SizedBox(height: 12),
       Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[800]), textAlign: TextAlign.center),
      ],
     ),
    ),
   ),
  );
 }
}