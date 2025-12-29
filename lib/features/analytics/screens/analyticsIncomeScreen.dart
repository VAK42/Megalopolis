import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/analyticsProvider.dart';
import '../constants/analyticsConstants.dart';
import '../widgets/analyticsScaffold.dart';
class AnalyticsIncomeScreen extends ConsumerWidget {
 const AnalyticsIncomeScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Scaffold(body: Center(child: Text(AnalyticsConstants.loginRequired)));
  final totalIncomeAsync = ref.watch(incomeProvider(userId));
  final sourcesAsync = ref.watch(incomeSourcesProvider(userId));
  return AnalyticsScaffold(
   title: AnalyticsConstants.incomeTitle,
   body: RefreshIndicator(
    onRefresh: () async {
     ref.invalidate(incomeProvider(userId));
     ref.invalidate(incomeSourcesProvider(userId));
    },
    child: ListView(
     padding: const EdgeInsets.all(16),
     children: [
      totalIncomeAsync.when(
       data: (total) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
         gradient: LinearGradient(colors: [AppColors.success, AppColors.success.withValues(alpha: 0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
         borderRadius: BorderRadius.circular(20),
         boxShadow: [BoxShadow(color: AppColors.success.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        child: Column(
         children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
           Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.trending_up_rounded, color: Colors.white, size: 28)),
           const SizedBox(width: 12),
           const Text(AnalyticsConstants.totalIncomeLabel, style: TextStyle(color: Colors.white70, fontSize: 16)),
          ]),
          const SizedBox(height: 16),
          Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
           decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
           child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 16), SizedBox(width: 4), Text(AnalyticsConstants.vsLastMonth, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500))]),
          ),
         ],
        ),
       ),
       loading: () => const SizedBox(height: 160, child: Center(child: CircularProgressIndicator())),
       error: (_, __) => const SizedBox(),
      ),
      const SizedBox(height: 24),
      sourcesAsync.when(
       data: (sources) {
        if (sources.isEmpty) return const SizedBox();
        return Container(
         padding: const EdgeInsets.all(20),
         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.bar_chart_rounded, color: AppColors.success, size: 20)),
            const SizedBox(width: 12),
            const Text(AnalyticsConstants.incomeSources, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
           ]),
           const SizedBox(height: 20),
           SizedBox(
            height: 200,
            child: BarChart(
             BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: sources.map((s) => (s['amount'] as num).toDouble()).reduce((a, b) => a > b ? a : b) * 1.2,
              barTouchData: BarTouchData(
               touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) => BarTooltipItem('\$${rod.toY.toStringAsFixed(0)}', const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
               ),
              ),
              titlesData: FlTitlesData(
               show: true,
               bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                if (value.toInt() < sources.length) {
                 final ref = sources[value.toInt()]['reference']?.toString() ?? '';
                 return Padding(padding: const EdgeInsets.only(top: 8), child: Text(ref.length > 8 ? '${ref.substring(0, 8)}...' : ref, style: TextStyle(color: Colors.grey[600], fontSize: 10)));
                }
                return const SizedBox();
               })),
               leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
               topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
               rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: sources.asMap().entries.map((e) {
               return BarChartGroupData(x: e.key, barRods: [BarChartRodData(toY: (e.value['amount'] as num).toDouble(), color: AppColors.success, width: 24, borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)))]);
              }).toList(),
             ),
            ),
           ),
          ],
         ),
        );
       },
       loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
       error: (_, __) => const SizedBox(),
      ),
      const SizedBox(height: 24),
      Container(
       padding: const EdgeInsets.all(20),
       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Row(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.receipt_long_rounded, color: AppColors.accent, size: 20)),
          const SizedBox(width: 12),
          const Text(AnalyticsConstants.recentTransactions, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
         ]),
         const SizedBox(height: 16),
         sourcesAsync.when(
          data: (sources) => Column(
           children: sources.map((s) {
            final amount = (s['amount'] as num).toDouble();
            final reference = s['reference']?.toString() ?? AnalyticsConstants.incomeSourceDefault;
            return Container(
             margin: const EdgeInsets.only(bottom: 12),
             padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
             child: Row(
              children: [
               Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.arrow_downward_rounded, color: AppColors.success, size: 20)),
               const SizedBox(width: 16),
               Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(reference, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 4),
                Text(AnalyticsConstants.incomeType, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
               ])),
               Text('+\$${amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success, fontSize: 16)),
              ],
             ),
            );
           }).toList(),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox(),
         ),
        ],
       ),
      ),
     ],
    ),
   ),
  );
 }
}