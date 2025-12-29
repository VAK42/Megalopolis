import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/analyticsProvider.dart';
import '../constants/analyticsConstants.dart';
import '../widgets/analyticsScaffold.dart';
class AnalyticsSavingsScreen extends ConsumerWidget {
 const AnalyticsSavingsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Scaffold(body: Center(child: Text(AnalyticsConstants.loginRequired)));
  final savingsAsync = ref.watch(savingsProvider(userId));
  return AnalyticsScaffold(
   title: AnalyticsConstants.savingsTitle,
   body: RefreshIndicator(
    onRefresh: () async => ref.invalidate(savingsProvider(userId)),
    child: savingsAsync.when(
     data: (savings) {
      final total = (savings['total'] as num).toDouble();
      final goal = (savings['goal'] as num).toDouble();
      final month = (savings['month'] as num).toDouble();
      final progress = goal > 0 ? (total / goal) : 0.0;
      return ListView(
       padding: const EdgeInsets.all(16),
       children: [
        Container(
         padding: const EdgeInsets.all(24),
         decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.accent, AppColors.accent.withValues(alpha: 0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: AppColors.accent.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 8))],
         ),
         child: Column(
          children: [
           SizedBox(
            height: 180,
            width: 180,
            child: Stack(alignment: Alignment.center, children: [
             SizedBox(height: 180, width: 180, child: CircularProgressIndicator(value: progress.clamp(0.0, 1.0), strokeWidth: 12, backgroundColor: Colors.white.withValues(alpha: 0.2), valueColor: const AlwaysStoppedAnimation<Color>(Colors.white))),
             Column(mainAxisSize: MainAxisSize.min, children: [
              Text('\$${total.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('${AnalyticsConstants.ofLabel}\$${goal.toStringAsFixed(0)}', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
             ]),
            ]),
           ),
           const SizedBox(height: 20),
           Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)), child: Text('${(progress * 100).toStringAsFixed(1)}% ${AnalyticsConstants.completeLabel}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
          ],
         ),
        ),
        const SizedBox(height: 24),
        Row(children: [
         Expanded(child: _buildStatCard(AnalyticsConstants.totalSavingsLabel, '\$${total.toStringAsFixed(0)}', Icons.savings_rounded, AppColors.success)),
         const SizedBox(width: 12),
         Expanded(child: _buildStatCard(AnalyticsConstants.thisMonthLabel, '\$${month.toStringAsFixed(0)}', Icons.calendar_month_rounded, AppColors.primary)),
        ]),
        const SizedBox(height: 12),
        Row(children: [
         Expanded(child: _buildStatCard(AnalyticsConstants.goalLabel, '\$${goal.toStringAsFixed(0)}', Icons.flag_rounded, AppColors.warning)),
         const SizedBox(width: 12),
         Expanded(child: _buildStatCard(AnalyticsConstants.remainingLabel, '\$${(goal - total).clamp(0, double.infinity).toStringAsFixed(0)}', Icons.trending_up_rounded, AppColors.secondary)),
        ]),
        const SizedBox(height: 24),
        Container(
         padding: const EdgeInsets.all(20),
         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.show_chart_rounded, color: AppColors.accent, size: 20)),
            const SizedBox(width: 12),
            const Text(AnalyticsConstants.savingsGrowth, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
           ]),
           const SizedBox(height: 20),
           SizedBox(
            height: 150,
            child: LineChart(
             LineChartData(
              gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 5000, getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withValues(alpha: 0.2), strokeWidth: 1)),
              titlesData: FlTitlesData(
               leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
               topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
               rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
               bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                if (value.toInt() < months.length) return Text(months[value.toInt()], style: TextStyle(color: Colors.grey[500], fontSize: 10));
                return const SizedBox();
               })),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
               LineChartBarData(
                spots: [const FlSpot(0, 5000), const FlSpot(1, 8000), const FlSpot(2, 12000), const FlSpot(3, 15000), const FlSpot(4, 20000), FlSpot(5, total)],
                isCurved: true,
                color: AppColors.accent,
                barWidth: 3,
                dotData: FlDotData(show: true, getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(radius: 4, color: Colors.white, strokeWidth: 2, strokeColor: AppColors.accent)),
                belowBarData: BarAreaData(show: true, color: AppColors.accent.withValues(alpha: 0.1)),
               ),
              ],
             ),
            ),
           ),
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
   padding: const EdgeInsets.all(16),
   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
   child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 20)),
    const SizedBox(height: 12),
    Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
    const SizedBox(height: 4),
    Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
   ]),
  );
 }
}