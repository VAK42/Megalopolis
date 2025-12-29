import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/routeNames.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../constants/analyticsConstants.dart';
class AnalyticsScaffold extends ConsumerWidget {
 final String title;
 final Widget body;
 final List<Widget>? actions;
 final Widget? floatingActionButton;
 const AnalyticsScaffold({super.key, required this.title, required this.body, this.actions, this.floatingActionButton});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final user = ref.watch(currentUserProvider).value;
  final currentRoute = GoRouterState.of(context).uri.toString();
  return Scaffold(
   appBar: AppBar(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    elevation: 0,
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    actions: actions,
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
          child: const Icon(Icons.analytics_rounded, color: Colors.white, size: 32),
         ),
         const SizedBox(height: 16),
         const Text(AnalyticsConstants.analyticsTitle, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
         const SizedBox(height: 4),
         Text(user?.email ?? '', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
        ],
       ),
      ),
      Expanded(
       child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
         _buildNavItem(context, Icons.trending_down_rounded, AnalyticsConstants.spendingTitle, Routes.analyticsSpending, currentRoute),
         _buildNavItem(context, Icons.trending_up_rounded, AnalyticsConstants.incomeTitle, Routes.analyticsIncome, currentRoute),
         _buildNavItem(context, Icons.account_balance_wallet_rounded, AnalyticsConstants.budgetTitle, Routes.analyticsBudget, currentRoute),
         _buildNavItem(context, Icons.savings_rounded, AnalyticsConstants.savingsTitle, Routes.analyticsSavings, currentRoute),
         _buildNavItem(context, Icons.show_chart_rounded, AnalyticsConstants.investmentTitle, Routes.analyticsInvestment, currentRoute),
         _buildNavItem(context, Icons.receipt_long_rounded, AnalyticsConstants.taxTitle, Routes.analyticsTax, currentRoute),
         _buildNavItem(context, Icons.flag_rounded, AnalyticsConstants.goalsTitle, Routes.analyticsGoals, currentRoute),
         _buildNavItem(context, Icons.assessment_rounded, AnalyticsConstants.reportsTitle, Routes.analyticsReports, currentRoute),
         _buildNavItem(context, Icons.category_rounded, AnalyticsConstants.categoryTitle, Routes.analyticsCategory, currentRoute),
         _buildNavItem(context, Icons.compare_arrows_rounded, AnalyticsConstants.comparisonTitle, Routes.analyticsComparison, currentRoute),
         _buildNavItem(context, Icons.timeline_rounded, AnalyticsConstants.trendsTitle, Routes.analyticsTrends, currentRoute),
         const Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Divider(color: Colors.white24)),
         _buildNavItem(context, Icons.arrow_back_rounded, AnalyticsConstants.backToHome, Routes.adminDashboard, currentRoute, isBack: true),
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
 Widget _buildNavItem(BuildContext context, IconData icon, String title, String route, String currentRoute, {bool isBack = false}) {
  final isActive = currentRoute == route;
  return Container(
   margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
   decoration: BoxDecoration(
    color: isActive ? AppColors.primary.withValues(alpha: 0.2) : Colors.transparent,
    borderRadius: BorderRadius.circular(12),
   ),
   child: ListTile(
    leading: Icon(icon, color: isBack ? Colors.white70 : (isActive ? AppColors.primary : Colors.white70), size: 22),
    title: Text(title, style: TextStyle(color: isActive ? AppColors.primary : Colors.white, fontWeight: isActive ? FontWeight.w600 : FontWeight.normal, fontSize: 14)),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    onTap: () {
     Navigator.pop(context);
     context.go(route);
    },
   ),
  );
 }
}