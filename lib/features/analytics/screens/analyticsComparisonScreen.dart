import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/analyticsProvider.dart';
import '../constants/analyticsConstants.dart';
import '../widgets/analyticsScaffold.dart';
class AnalyticsComparisonScreen extends ConsumerWidget {
 const AnalyticsComparisonScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Scaffold(body: Center(child: Text(AnalyticsConstants.loginRequired)));
  final comparisonAsync = ref.watch(comparisonProvider(userId));
  return AnalyticsScaffold(
   title: AnalyticsConstants.comparisonTitle,
   body: RefreshIndicator(
    onRefresh: () async => ref.invalidate(comparisonProvider(userId)),
    child: comparisonAsync.when(
     data: (comparison) {
      if (comparison.isEmpty) return const Center(child: Text(AnalyticsConstants.noComparisonData));
      final totalSpending = comparison.fold<double>(0, (sum, c) => sum + (c['spending'] as num).toDouble());
      final totalIncome = comparison.fold<double>(0, (sum, c) => sum + (c['income'] as num).toDouble());
      final netSavings = totalIncome - totalSpending;
      return ListView(
       padding: const EdgeInsets.all(16),
       children: [
        Row(children: [
         Expanded(child: _buildSummaryCard(AnalyticsConstants.incomeLabel, '\$${totalIncome.toStringAsFixed(0)}', Icons.arrow_downward_rounded, AppColors.success)),
         const SizedBox(width: 12),
         Expanded(child: _buildSummaryCard(AnalyticsConstants.spendingLabel, '\$${totalSpending.toStringAsFixed(0)}', Icons.arrow_upward_rounded, AppColors.error)),
        ]),
        const SizedBox(height: 12),
        _buildSummaryCard(AnalyticsConstants.netSavings, '${netSavings >= 0 ? '+' : ''}\$${netSavings.toStringAsFixed(0)}', Icons.savings_rounded, netSavings >= 0 ? AppColors.primary : AppColors.error),
        const SizedBox(height: 24),
        Container(
         padding: const EdgeInsets.all(20),
         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12)]),
         child: Column(
          children: [
           Row(children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.bar_chart_rounded, color: AppColors.primary, size: 24)),
            const SizedBox(width: 12),
            const Text(AnalyticsConstants.comparisonTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
           ]),
           const SizedBox(height: 24),
           SizedBox(
            height: 220,
            child: BarChart(
             BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: comparison.map((c) => [(c['spending'] as num).toDouble(), (c['income'] as num).toDouble()]).expand((x) => x).reduce((a, b) => a > b ? a : b) * 1.2,
              barTouchData: BarTouchData(
               touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) => BarTooltipItem('\$${rod.toY.toStringAsFixed(0)}', const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
               ),
              ),
              titlesData: FlTitlesData(
               show: true,
               bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                if (value.toInt() < comparison.length) return Padding(padding: const EdgeInsets.only(top: 10), child: Text((comparison[value.toInt()]['month'] as String).substring(0, 3), style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500, fontSize: 12)));
                return const SizedBox();
               })),
               leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
               topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
               rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 1000, getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withValues(alpha: 0.2), strokeWidth: 1)),
              borderData: FlBorderData(show: false),
              barGroups: comparison.asMap().entries.map((e) {
               final spending = (e.value['spending'] as num).toDouble();
               final income = (e.value['income'] as num).toDouble();
               return BarChartGroupData(x: e.key, barsSpace: 4, barRods: [
                BarChartRodData(toY: income, color: AppColors.success, width: 16, borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4))),
                BarChartRodData(toY: spending, color: AppColors.error, width: 16, borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4))),
               ]);
              }).toList(),
             ),
            ),
           ),
           const SizedBox(height: 16),
           Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _buildLegendItem(AnalyticsConstants.incomeLabel, AppColors.success),
            const SizedBox(width: 24),
            _buildLegendItem(AnalyticsConstants.spendingLabel, AppColors.error),
           ]),
          ],
         ),
        ),
        const SizedBox(height: 24),
        Container(
         padding: const EdgeInsets.all(20),
         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12)]),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.calendar_month_rounded, color: AppColors.accent, size: 24)),
            const SizedBox(width: 12),
            const Text(AnalyticsConstants.monthlyDetails, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
           ]),
           const SizedBox(height: 20),
           ...comparison.map((c) => _buildMonthDetail(c['month'] as String, (c['spending'] as num).toDouble(), (c['income'] as num).toDouble())),
          ],
         ),
        ),
       ],
      );
     },
     loading: () => const Center(child: CircularProgressIndicator()),
     error: (e, s) => Center(child: Text('${AnalyticsConstants.errorPrefix}$e')),
    ),
   ),
  );
 }
 Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
  return Container(
   padding: const EdgeInsets.all(16),
   decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withValues(alpha: 0.3))),
   child: Row(children: [
    Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 24)),
    const SizedBox(width: 12),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
     Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
     Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
    ]),
   ]),
  );
 }
 Widget _buildLegendItem(String label, Color color) {
  return Row(children: [Container(width: 16, height: 16, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))), const SizedBox(width: 8), Text(label, style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500))]);
 }
 Widget _buildMonthDetail(String month, double spending, double income) {
  final net = income - spending;
  return Container(
   margin: const EdgeInsets.only(bottom: 16),
   padding: const EdgeInsets.all(16),
   decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16)),
   child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     Text(month, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Column(children: [Text(AnalyticsConstants.incomeLabel, style: const TextStyle(color: Colors.grey, fontSize: 12)), Text('\$${income.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.success))]),
      Container(width: 1, height: 40, color: Colors.grey[300]),
      Column(children: [Text(AnalyticsConstants.spendingLabel, style: const TextStyle(color: Colors.grey, fontSize: 12)), Text('\$${spending.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.error))]),
      Container(width: 1, height: 40, color: Colors.grey[300]),
      Column(children: [Text(AnalyticsConstants.netLabel, style: const TextStyle(color: Colors.grey, fontSize: 12)), Text('${net >= 0 ? '+' : ''}\$${net.toStringAsFixed(0)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: net >= 0 ? AppColors.primary : AppColors.error))]),
     ]),
    ],
   ),
  );
 }
}