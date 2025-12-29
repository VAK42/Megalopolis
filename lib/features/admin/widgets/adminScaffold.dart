import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/routeNames.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../constants/adminConstants.dart';
class AdminScaffold extends ConsumerWidget {
 final String title;
 final Widget body;
 final List<Widget>? actions;
 final Widget? floatingActionButton;
 const AdminScaffold({super.key, required this.title, required this.body, this.actions, this.floatingActionButton});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final user = ref.watch(currentUserProvider).value;
  final currentRoute = GoRouterState.of(context).uri.toString();
  return Scaffold(
   appBar: AppBar(
    backgroundColor: const Color(0xFF1E1E2E),
    foregroundColor: Colors.white,
    elevation: 0,
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    actions: actions ?? [
     IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () => context.go(Routes.adminNotifications)),
     const SizedBox(width: 8),
    ],
   ),
   drawer: Drawer(
    backgroundColor: const Color(0xFF1E1E2E),
    child: Column(
     children: [
      Container(
       width: double.infinity,
       padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
       decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 32),
         ),
         const SizedBox(height: 16),
         const Text(AdminConstants.adminPanelTitle, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
         const SizedBox(height: 4),
         Text(user?.email ?? AdminConstants.defaultAdminEmail, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
        ],
       ),
      ),
      Expanded(
       child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
         _buildNavItem(context, ref, Icons.dashboard_rounded, AdminConstants.drawerDashboard, Routes.adminDashboard, currentRoute),
         _buildNavItem(context, ref, Icons.people_rounded, AdminConstants.drawerUsers, Routes.adminUsers, currentRoute),
         _buildNavItem(context, ref, Icons.shopping_bag_rounded, AdminConstants.drawerOrders, Routes.adminOrders, currentRoute),
         _buildAnalyticsExpansion(context, currentRoute),
         _buildNavItem(context, ref, Icons.campaign_rounded, AdminConstants.drawerPromotions, Routes.adminPromotions, currentRoute),
         _buildNavItem(context, ref, Icons.description_rounded, AdminConstants.drawerReports, Routes.adminReports, currentRoute),
         _buildNavItem(context, ref, Icons.support_agent_rounded, AdminConstants.drawerSupportTickets, Routes.adminSupport, currentRoute),
         _buildNavItem(context, ref, Icons.notifications_rounded, AdminConstants.drawerNotifications, Routes.adminNotifications, currentRoute),
         _buildNavItem(context, ref, Icons.shield_rounded, AdminConstants.drawerContentModeration, Routes.adminModeration, currentRoute),
         _buildNavItem(context, ref, Icons.settings_rounded, AdminConstants.drawerSettings, Routes.adminConfig, currentRoute),
         const Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Divider(color: Colors.white24)),
         _buildNavItem(context, ref, Icons.logout_rounded, AdminConstants.drawerLogout, Routes.welcome, currentRoute, isLogout: true),
        ],
       ),
      ),
     ],
    ),
   ),
   body: Container(color: const Color(0xFFF5F6FA), child: body),
   floatingActionButton: floatingActionButton,
  );
 }
 Widget _buildNavItem(BuildContext context, WidgetRef ref, IconData icon, String title, String route, String currentRoute, {bool isLogout = false}) {
  final isActive = currentRoute == route;
  return Container(
   margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
   decoration: BoxDecoration(
    color: isActive ? AppColors.primary.withValues(alpha: 0.2) : Colors.transparent,
    borderRadius: BorderRadius.circular(12),
   ),
   child: ListTile(
    leading: Icon(icon, color: isLogout ? AppColors.error : (isActive ? AppColors.primary : Colors.white70), size: 22),
    title: Text(title, style: TextStyle(color: isLogout ? AppColors.error : (isActive ? AppColors.primary : Colors.white), fontWeight: isActive ? FontWeight.w600 : FontWeight.normal, fontSize: 14)),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    onTap: () {
     Navigator.pop(context);
     if (isLogout) {
      ref.read(authProvider.notifier).logout();
     }
     context.go(route);
    },
   ),
  );
 }
 Widget _buildAnalyticsExpansion(BuildContext context, String currentRoute) {
  final analyticsRoutes = [
   Routes.analyticsSpending,
   Routes.analyticsIncome,
   Routes.analyticsBudget,
   Routes.analyticsSavings,
   Routes.analyticsInvestment,
   Routes.analyticsTax,
   Routes.analyticsGoals,
   Routes.analyticsReports,
   Routes.analyticsCategory,
   Routes.analyticsComparison,
   Routes.analyticsTrends,
  ];
  final isAnalyticsActive = analyticsRoutes.any((r) => currentRoute.contains(r));
  return Container(
   margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
   decoration: BoxDecoration(
    color: isAnalyticsActive ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
    borderRadius: BorderRadius.circular(12),
   ),
   child: Theme(
    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
    child: ExpansionTile(
     leading: Icon(Icons.analytics_rounded, color: isAnalyticsActive ? AppColors.primary : Colors.white70, size: 22),
     title: Text(AdminConstants.drawerAnalytics, style: TextStyle(color: isAnalyticsActive ? AppColors.primary : Colors.white, fontWeight: isAnalyticsActive ? FontWeight.w600 : FontWeight.normal, fontSize: 14)),
     iconColor: Colors.white70,
     collapsedIconColor: Colors.white70,
     initiallyExpanded: isAnalyticsActive,
     children: [
      _buildSubNavItem(context, AdminConstants.analyticsSpending, Routes.analyticsSpending, currentRoute),
      _buildSubNavItem(context, AdminConstants.analyticsIncome, Routes.analyticsIncome, currentRoute),
      _buildSubNavItem(context, AdminConstants.analyticsBudget, Routes.analyticsBudget, currentRoute),
      _buildSubNavItem(context, AdminConstants.analyticsSavings, Routes.analyticsSavings, currentRoute),
      _buildSubNavItem(context, AdminConstants.analyticsInvestment, Routes.analyticsInvestment, currentRoute),
      _buildSubNavItem(context, AdminConstants.analyticsTax, Routes.analyticsTax, currentRoute),
      _buildSubNavItem(context, AdminConstants.analyticsGoals, Routes.analyticsGoals, currentRoute),
      _buildSubNavItem(context, AdminConstants.analyticsReportsNav, Routes.analyticsReports, currentRoute),
      _buildSubNavItem(context, AdminConstants.analyticsCategory, Routes.analyticsCategory, currentRoute),
      _buildSubNavItem(context, AdminConstants.analyticsComparison, Routes.analyticsComparison, currentRoute),
      _buildSubNavItem(context, AdminConstants.analyticsTrends, Routes.analyticsTrends, currentRoute),
     ],
    ),
   ),
  );
 }
 Widget _buildSubNavItem(BuildContext context, String title, String route, String currentRoute) {
  final isActive = currentRoute == route;
  return ListTile(
   contentPadding: const EdgeInsets.only(left: 56),
   title: Text(title, style: TextStyle(color: isActive ? AppColors.primary : Colors.white60, fontSize: 13, fontWeight: isActive ? FontWeight.w600 : FontWeight.normal)),
   dense: true,
   visualDensity: const VisualDensity(vertical: -2),
   onTap: () {
    Navigator.pop(context);
    context.go(route);
   },
  );
 }
}