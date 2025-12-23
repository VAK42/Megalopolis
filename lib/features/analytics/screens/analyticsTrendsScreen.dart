import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/analyticsProvider.dart';
import '../../../core/theme/colors.dart';
import '../../analytics/constants/analyticsConstants.dart';
class AnalyticsTrendsScreen extends ConsumerWidget {
 const AnalyticsTrendsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Scaffold(body: Center(child: Text(AnalyticsConstants.loginRequired)));
  final trendsAsync = ref.watch(trendsProvider(userId));
  return Scaffold(
   appBar: AppBar(title: const Text(AnalyticsConstants.trendsTitle)),
   body: trendsAsync.when(
    data: (trends) => ListView(
     padding: const EdgeInsets.all(16),
     children: [
      Container(
       height: 300,
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
       ),
       child: BarChart(
        BarChartData(
         alignment: BarChartAlignment.spaceAround,
         maxY: 200,
         barTouchData: BarTouchData(enabled: false),
         titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
           sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, TitleMeta meta) {
             if (value.toInt() >= 0 && value.toInt() < trends.length) {
              return Padding(
               padding: const EdgeInsets.only(top: 8.0),
               child: Text(
                trends[value.toInt()]['day'] as String,
                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12),
               ),
              );
             }
             return const SizedBox();
            },
           ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
         ),
         gridData: const FlGridData(show: false),
         borderData: FlBorderData(show: false),
         barGroups: trends.asMap().entries.map((e) {
          return BarChartGroupData(
           x: e.key,
           barRods: [BarChartRodData(toY: (e.value['amount'] as num).toDouble(), color: AppColors.primary, width: 16, borderRadius: BorderRadius.circular(4))],
          );
         }).toList(),
        ),
       ),
      ),
      const SizedBox(height: 24),
      ...AnalyticsConstants.trendPeriods.map(
       (p) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(title: Text('$p${AnalyticsConstants.overviewSuffix}'), trailing: const Icon(Icons.arrow_forward_ios, size: 16)),
       ),
      ),
     ],
    ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, s) => Center(child: Text('${AnalyticsConstants.errorPrefix}$e')),
   ),
  );
 }
}