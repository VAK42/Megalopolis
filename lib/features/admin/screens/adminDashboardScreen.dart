import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/routeNames.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/adminProvider.dart';
import '../../admin/constants/adminConstants.dart';
class AdminDashboardScreen extends ConsumerWidget {
 const AdminDashboardScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final dashboardStatsAsync = ref.watch(adminDashboardStatsProvider);
  final user = ref.watch(currentUserProvider).value;
  return Scaffold(
   appBar: AppBar(
    title: const Text(AdminConstants.dashboardTitle),
    actions: [
     IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
     IconButton(icon: const Icon(Icons.person), onPressed: () {}),
    ],
   ),
   drawer: Drawer(
    child: ListView(
     children: [
      DrawerHeader(
       decoration: const BoxDecoration(color: AppColors.primary),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
         const Text(
          AdminConstants.adminPanelTitle,
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
         ),
         const SizedBox(height: 8),
         Text(user?.email ?? AdminConstants.defaultAdminEmail, style: const TextStyle(color: Colors.white70)),
        ],
       ),
      ),
      _buildDrawerItem(Icons.dashboard, AdminConstants.drawerDashboard, () => context.go(Routes.adminDashboard)),
      _buildDrawerItem(Icons.people, AdminConstants.drawerUsers, () => context.go(Routes.adminUsers)),
      _buildDrawerItem(Icons.shopping_bag, AdminConstants.drawerOrders, () => context.go(Routes.adminOrders)),
      _buildDrawerItem(Icons.analytics, AdminConstants.drawerAnalytics, () => context.go(Routes.adminAnalytics)),
      _buildDrawerItem(Icons.campaign, AdminConstants.drawerPromotions, () => context.go(Routes.adminPromotions)),
      _buildDrawerItem(Icons.settings, AdminConstants.drawerSettings, () => context.go(Routes.adminSettings)),
      const Divider(),
      _buildDrawerItem(Icons.logout, AdminConstants.drawerLogout, () => context.go(Routes.adminLogin)),
     ],
    ),
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      const Text(AdminConstants.overviewTitle, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 16),
      dashboardStatsAsync.when(
       data: (stats) => GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, children: [_buildStatCard(AdminConstants.totalUsersLabel, '${stats['totalUsers']}', Icons.people, AppColors.info), _buildStatCard(AdminConstants.activeOrdersLabel, '${stats['activeOrders']}', Icons.shopping_cart, AppColors.warning), _buildStatCard(AdminConstants.revenueLabel, '\$${(stats['revenue'] as num).toStringAsFixed(2)}', Icons.attach_money, AppColors.success), _buildStatCard(AdminConstants.supportTicketsLabel, '${stats['supportTickets']}', Icons.support_agent, AppColors.error)]),
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (err, stack) => const Text(AdminConstants.errorLoadingStats),
      ),
      const SizedBox(height: 24),
      const Text(AdminConstants.quickActionsTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      _buildActionButton(AdminConstants.manageUsersAction, Icons.people, () => context.go(Routes.adminUsers)),
      _buildActionButton(AdminConstants.viewOrdersAction, Icons.list_alt, () => context.go(Routes.adminOrders)),
      _buildActionButton(AdminConstants.sendNotificationAction, Icons.notifications_active, () {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AdminConstants.notificationComingSoon)));
      }),
      _buildActionButton(AdminConstants.generateReportAction, Icons.assessment, () {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AdminConstants.reportComingSoon)));
      }),
     ],
    ),
   ),
  );
 }
 Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
  return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
 }
 Widget _buildStatCard(String title, String value, IconData icon, Color color) {
  return Container(
   padding: const EdgeInsets.all(16),
   decoration: BoxDecoration(
    color: color.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: color.withValues(alpha: 0.3)),
   ),
   child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
     Icon(icon, size: 32, color: color),
     Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Text(
        value,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
       ),
       Text(title, style: const TextStyle(fontSize: 12)),
      ],
     ),
    ],
   ),
  );
 }
 Widget _buildActionButton(String title, IconData icon, VoidCallback onTap) {
  return Card(
   margin: const EdgeInsets.only(bottom: 8),
   child: ListTile(
    leading: Icon(icon, color: AppColors.primary),
    title: Text(title),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    onTap: onTap,
   ),
  );
 }
}