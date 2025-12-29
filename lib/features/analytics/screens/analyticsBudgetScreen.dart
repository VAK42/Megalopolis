import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/analyticsProvider.dart';
import '../constants/analyticsConstants.dart';
import '../widgets/analyticsScaffold.dart';
class AnalyticsBudgetScreen extends ConsumerWidget {
 const AnalyticsBudgetScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Scaffold(body: Center(child: Text(AnalyticsConstants.loginRequired)));
  final budgetsAsync = ref.watch(budgetsProvider(userId));
  return AnalyticsScaffold(
   title: AnalyticsConstants.budgetTitle,
   body: RefreshIndicator(
    onRefresh: () async => ref.invalidate(budgetsProvider(userId)),
    child: budgetsAsync.when(
     data: (budgets) {
      if (budgets.isEmpty) return const Center(child: Text(AnalyticsConstants.noBudgetsSet));
      final totalBudget = budgets.fold<double>(0, (sum, b) => sum + (b['limit'] as num).toDouble());
      final totalSpent = budgets.fold<double>(0, (sum, b) => sum + (b['spent'] as num).toDouble());
      final remaining = totalBudget - totalSpent;
      return ListView(
       padding: const EdgeInsets.all(16),
       children: [
        Row(children: [
         Expanded(child: _buildSummaryCard(AnalyticsConstants.totalBudgetLabel, '\$${totalBudget.toStringAsFixed(0)}', Icons.account_balance_wallet_rounded, AppColors.primary)),
         const SizedBox(width: 12),
         Expanded(child: _buildSummaryCard(AnalyticsConstants.totalSpentLabel, '\$${totalSpent.toStringAsFixed(0)}', Icons.shopping_cart_rounded, AppColors.warning)),
        ]),
        const SizedBox(height: 12),
        _buildSummaryCard(AnalyticsConstants.remainingLabel, '\$${remaining.toStringAsFixed(0)}', Icons.savings_rounded, remaining >= 0 ? AppColors.success : AppColors.error),
        const SizedBox(height: 24),
        Container(
         padding: const EdgeInsets.all(20),
         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
         child: Column(
          children: [
           Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.pie_chart_rounded, color: AppColors.primary, size: 20)),
            const SizedBox(width: 12),
            const Text(AnalyticsConstants.budgetAllocation, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
           ]),
           const SizedBox(height: 20),
           SizedBox(
            height: 200,
            child: PieChart(
             PieChartData(
              sectionsSpace: 3,
              centerSpaceRadius: 50,
              sections: budgets.asMap().entries.map((e) {
               final colors = [AppColors.primary, AppColors.accent, AppColors.success, AppColors.warning, AppColors.secondary];
               final color = colors[e.key % colors.length];
               final limit = (e.value['limit'] as num).toDouble();
               return PieChartSectionData(color: color, value: limit, title: '', radius: 35, badgeWidget: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)]), child: Text('\$${limit.toStringAsFixed(0)}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color))), badgePositionPercentageOffset: 1.3);
              }).toList(),
             ),
            ),
           ),
           const SizedBox(height: 16),
           Wrap(spacing: 12, runSpacing: 8, children: budgets.asMap().entries.map((e) {
            final colors = [AppColors.primary, AppColors.accent, AppColors.success, AppColors.warning, AppColors.secondary];
            return Row(mainAxisSize: MainAxisSize.min, children: [
             Container(width: 12, height: 12, decoration: BoxDecoration(color: colors[e.key % colors.length], borderRadius: BorderRadius.circular(3))),
             const SizedBox(width: 6),
             Text((e.value['category'] as String).toUpperCase(), style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            ]);
           }).toList()),
          ],
         ),
        ),
        const SizedBox(height: 24),
        ...budgets.map((b) => _buildBudgetItem(b['category'] as String, (b['limit'] as num).toDouble(), (b['spent'] as num).toDouble())),
       ],
      );
     },
     loading: () => const Center(child: CircularProgressIndicator()),
     error: (_, __) => const Center(child: Text(AnalyticsConstants.errorLoadingBudgets)),
    ),
   ),
  );
 }
 Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
  return Container(
   padding: const EdgeInsets.all(16),
   decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withValues(alpha: 0.3))),
   child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Icon(icon, color: color, size: 24),
    const SizedBox(height: 12),
    Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
    const SizedBox(height: 4),
    Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold)),
   ]),
  );
 }
 Widget _buildBudgetItem(String category, double budget, double spent) {
  final percentage = budget > 0 ? (spent / budget) : 0.0;
  final isOver = spent > budget;
  final color = isOver ? AppColors.error : (percentage > 0.8 ? AppColors.warning : AppColors.success);
  return Container(
   margin: const EdgeInsets.only(bottom: 16),
   padding: const EdgeInsets.all(20),
   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
   child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
     Row(children: [
      Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.category_rounded, color: color, size: 20)),
      const SizedBox(width: 12),
      Text(category.toUpperCase(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
     ]),
     Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)), child: Text('${(percentage * 100).toStringAsFixed(0)}%', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12))),
    ]),
    const SizedBox(height: 16),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
     Text('${AnalyticsConstants.spentLabel}\$${spent.toStringAsFixed(0)}', style: TextStyle(color: Colors.grey[600])),
     Text('${AnalyticsConstants.budgetPrefix}\$${budget.toStringAsFixed(0)}', style: TextStyle(color: Colors.grey[600])),
    ]),
    const SizedBox(height: 12),
    ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: percentage.clamp(0.0, 1.0), backgroundColor: Colors.grey[200], valueColor: AlwaysStoppedAnimation<Color>(color), minHeight: 10)),
    if (isOver) Padding(padding: const EdgeInsets.only(top: 8), child: Row(children: [Icon(Icons.warning_rounded, color: AppColors.error, size: 16), const SizedBox(width: 4), Text('${AnalyticsConstants.overBudgetBy}\$${(spent - budget).toStringAsFixed(0)}', style: const TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.w500))])),
   ]),
  );
 }
}