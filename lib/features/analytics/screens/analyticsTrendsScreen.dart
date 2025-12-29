import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/analyticsProvider.dart';
import '../../../core/theme/colors.dart';
import '../../analytics/constants/analyticsConstants.dart';
import '../widgets/analyticsScaffold.dart';
class AnalyticsTrendsScreen extends ConsumerStatefulWidget {
 const AnalyticsTrendsScreen({super.key});
 @override
 ConsumerState<AnalyticsTrendsScreen> createState() => _AnalyticsTrendsScreenState();
}
class _AnalyticsTrendsScreenState extends ConsumerState<AnalyticsTrendsScreen> {
 String _selectedPeriod = 'Week';
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Scaffold(body: Center(child: Text(AnalyticsConstants.loginRequired)));
  final trendsAsync = ref.watch(trendsProvider(userId));
  return AnalyticsScaffold(
   title: AnalyticsConstants.trendsTitle,
   body: RefreshIndicator(
    onRefresh: () async => ref.invalidate(trendsProvider(userId)),
    child: trendsAsync.when(
     data: (trends) {
      final totalSpending = trends.fold<double>(0, (sum, t) => sum + (t['amount'] as num).toDouble());
      final avgSpending = trends.isNotEmpty ? totalSpending / trends.length : 0;
      final maxSpending = trends.isNotEmpty ? trends.map((t) => (t['amount'] as num).toDouble()).reduce((a, b) => a > b ? a : b) : 0;
      return ListView(
       padding: const EdgeInsets.all(16),
       children: [
        Container(
         padding: const EdgeInsets.all(6),
         decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
         child: Row(children: AnalyticsConstants.trendPeriods.map((period) => Expanded(
          child: GestureDetector(
           onTap: () => setState(() => _selectedPeriod = period),
           child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(color: _selectedPeriod == period ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(8), boxShadow: _selectedPeriod == period ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)] : null),
            child: Center(child: Text(period, style: TextStyle(fontWeight: _selectedPeriod == period ? FontWeight.bold : FontWeight.normal, color: _selectedPeriod == period ? AppColors.primary : Colors.grey[600]))),
           ),
          ),
         )).toList()),
        ),
        const SizedBox(height: 24),
        Row(children: [
         Expanded(child: _buildStatCard(AnalyticsConstants.total, '\$${totalSpending.toStringAsFixed(0)}', Icons.account_balance_wallet_rounded, AppColors.primary)),
         const SizedBox(width: 12),
         Expanded(child: _buildStatCard(AnalyticsConstants.average, '\$${avgSpending.toStringAsFixed(0)}', Icons.trending_flat_rounded, AppColors.accent)),
         const SizedBox(width: 12),
         Expanded(child: _buildStatCard(AnalyticsConstants.peak, '\$${maxSpending.toStringAsFixed(0)}', Icons.trending_up_rounded, AppColors.warning)),
        ]),
        const SizedBox(height: 24),
        Container(
         padding: const EdgeInsets.all(20),
         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12)]),
         child: Column(
          children: [
           Row(children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.bar_chart_rounded, color: AppColors.primary, size: 24)),
            const SizedBox(width: 12),
            const Text(AnalyticsConstants.spendingTrend, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
           ]),
           const SizedBox(height: 24),
           SizedBox(
            height: 220,
            child: BarChart(
             BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: (maxSpending > 0 ? maxSpending : 100) * 1.2,
              barTouchData: BarTouchData(
               touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) => BarTooltipItem('\$${rod.toY.toStringAsFixed(0)}', const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
               ),
              ),
              titlesData: FlTitlesData(
               show: true,
               bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                if (value.toInt() < trends.length) return Padding(padding: const EdgeInsets.only(top: 10), child: Text(trends[value.toInt()]['day'] as String, style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500, fontSize: 12)));
                return const SizedBox();
               })),
               leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
               topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
               rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: (maxSpending > 0 ? maxSpending : 100) / 4, getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withValues(alpha: 0.2), strokeWidth: 1)),
              borderData: FlBorderData(show: false),
              barGroups: trends.asMap().entries.map((e) {
               final amount = (e.value['amount'] as num).toDouble();
               return BarChartGroupData(x: e.key, barRods: [BarChartRodData(toY: amount, gradient: LinearGradient(colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.6)], begin: Alignment.bottomCenter, end: Alignment.topCenter), width: 28, borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)))]);
              }).toList(),
             ),
            ),
           ),
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
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.list_alt_rounded, color: AppColors.success, size: 24)),
            const SizedBox(width: 12),
            const Text(AnalyticsConstants.dailyBreakdown, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
           ]),
           const SizedBox(height: 16),
           ...trends.map((t) => _buildDayItem(t['day'] as String, (t['amount'] as num).toDouble(), maxSpending.toDouble())),
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
 Widget _buildStatCard(String title, String value, IconData icon, Color color) {
  return Container(
   padding: const EdgeInsets.all(14),
   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
   child: Column(children: [
    Icon(icon, color: color, size: 24),
    const SizedBox(height: 8),
    Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
    Text(title, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
   ]),
  );
 }
 Widget _buildDayItem(String day, double amount, double max) {
  final percent = max > 0 ? amount / max : 0;
  return Container(
   margin: const EdgeInsets.only(bottom: 12),
   child: Row(children: [
    SizedBox(width: 40, child: Text(day, style: const TextStyle(fontWeight: FontWeight.w500))),
    const SizedBox(width: 12),
    Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: percent.toDouble(), backgroundColor: Colors.grey[200], valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary), minHeight: 20))),
    const SizedBox(width: 12),
    SizedBox(width: 60, child: Text('\$${amount.toStringAsFixed(0)}', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold))),
   ]),
  );
 }
}