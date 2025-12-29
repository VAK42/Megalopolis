import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/analyticsProvider.dart';
import '../constants/analyticsConstants.dart';
import '../widgets/analyticsScaffold.dart';
class AnalyticsInvestmentScreen extends ConsumerWidget {
 const AnalyticsInvestmentScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Scaffold(body: Center(child: Text(AnalyticsConstants.loginRequired)));
  final investmentsAsync = ref.watch(investmentsProvider(userId));
  return AnalyticsScaffold(
   title: AnalyticsConstants.investmentTitle,
   body: RefreshIndicator(
    onRefresh: () async => ref.invalidate(investmentsProvider(userId)),
    child: investmentsAsync.when(
     data: (data) {
      final total = (data['total'] as num).toDouble();
      final growth = (data['growth'] as num).toDouble();
      final growthPercent = (data['growthPercentage'] as num).toDouble();
      final portfolio = data['portfolio'] as List;
      return ListView(
       padding: const EdgeInsets.all(16),
       children: [
        Container(
         padding: const EdgeInsets.all(24),
         decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.primary, const Color(0xFF1E3A8A)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 8))],
         ),
         child: Column(
          children: [
           Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.show_chart_rounded, color: Colors.white, size: 28)),
            const SizedBox(width: 12),
            const Text(AnalyticsConstants.portfolioValueLabel, style: TextStyle(color: Colors.white70, fontSize: 16)),
           ]),
           const SizedBox(height: 16),
           Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold)),
           const SizedBox(height: 12),
           Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
             decoration: BoxDecoration(color: growth >= 0 ? Colors.green.withValues(alpha: 0.3) : Colors.red.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(20)),
             child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(growth >= 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded, color: Colors.white, size: 16), const SizedBox(width: 4), Text('${growth >= 0 ? '+' : ''}\$${growth.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600))]),
            ),
            const SizedBox(width: 8),
            Text('(${growthPercent.toStringAsFixed(1)}%)', style: TextStyle(color: growth >= 0 ? Colors.green[200] : Colors.red[200], fontWeight: FontWeight.w500)),
           ]),
          ],
         ),
        ),
        const SizedBox(height: 24),
        Container(
         padding: const EdgeInsets.all(20),
         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.area_chart_rounded, color: AppColors.primary, size: 20)),
            const SizedBox(width: 12),
            const Text(AnalyticsConstants.portfolioPerformance, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
           ]),
           const SizedBox(height: 20),
           SizedBox(
            height: 180,
            child: LineChart(
             LineChartData(
              gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 3000, getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withValues(alpha: 0.2), strokeWidth: 1)),
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
                spots: [const FlSpot(0, 10000), const FlSpot(1, 11200), const FlSpot(2, 10800), const FlSpot(3, 12500), const FlSpot(4, 13800), FlSpot(5, total)],
                isCurved: true,
                color: AppColors.primary,
                barWidth: 3,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(show: true, gradient: LinearGradient(colors: [AppColors.primary.withValues(alpha: 0.3), AppColors.primary.withValues(alpha: 0.0)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
               ),
              ],
             ),
            ),
           ),
          ],
         ),
        ),
        const SizedBox(height: 24),
        if (portfolio.isNotEmpty) Container(
         padding: const EdgeInsets.all(20),
         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.pie_chart_rounded, color: AppColors.accent, size: 20)),
            const SizedBox(width: 12),
            const Text(AnalyticsConstants.assetAllocation, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
           ]),
           const SizedBox(height: 20),
           SizedBox(
            height: 160,
            child: PieChart(
             PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: portfolio.asMap().entries.map((e) {
               final colors = [AppColors.primary, AppColors.accent, AppColors.success, AppColors.warning, AppColors.secondary];
               return PieChartSectionData(color: colors[e.key % colors.length], value: 1, title: '', radius: 30);
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
         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.list_alt_rounded, color: AppColors.success, size: 20)),
            const SizedBox(width: 12),
            const Text(AnalyticsConstants.holdings, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
           ]),
           const SizedBox(height: 16),
           ...portfolio.map((item) {
            final growthVal = (item['growth'] as num).toDouble();
            final isPositive = growthVal >= 0;
            return Container(
             margin: const EdgeInsets.only(bottom: 12),
             padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12)),
             child: Row(
              children: [
               Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: isPositive ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded, color: isPositive ? AppColors.success : AppColors.error, size: 20)),
               const SizedBox(width: 16),
               Expanded(child: Text(item['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15))),
               Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: isPositive ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                child: Text('${isPositive ? '+' : ''}$growthVal%', style: TextStyle(color: isPositive ? AppColors.success : AppColors.error, fontWeight: FontWeight.bold, fontSize: 13)),
               ),
              ],
             ),
            );
           }),
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
}