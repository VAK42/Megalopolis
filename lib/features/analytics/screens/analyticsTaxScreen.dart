import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/analyticsProvider.dart';
import '../constants/analyticsConstants.dart';
import '../widgets/analyticsScaffold.dart';
class AnalyticsTaxScreen extends ConsumerWidget {
 const AnalyticsTaxScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Scaffold(body: Center(child: Text(AnalyticsConstants.loginRequired)));
  final taxAsync = ref.watch(taxProvider(userId));
  return AnalyticsScaffold(
   title: AnalyticsConstants.taxTitle,
   body: RefreshIndicator(
    onRefresh: () async => ref.invalidate(taxProvider(userId)),
    child: taxAsync.when(
     data: (tax) {
      final estimated = (tax['estimated'] as num).toDouble();
      final breakdown = tax['breakdown'] as List;
      return ListView(
       padding: const EdgeInsets.all(16),
       children: [
        Container(
         padding: const EdgeInsets.all(24),
         decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.secondary, AppColors.secondary.withValues(alpha: 0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: AppColors.secondary.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 8))],
         ),
         child: Column(
          children: [
           Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.receipt_long_rounded, color: Colors.white, size: 28)),
            const SizedBox(width: 12),
            const Text(AnalyticsConstants.estimatedTaxLabel, style: TextStyle(color: Colors.white70, fontSize: 16)),
           ]),
           const SizedBox(height: 16),
           Text('\$${estimated.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold)),
           const SizedBox(height: 12),
           Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
            child: const Text(AnalyticsConstants.annualEstimate, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
           ),
          ],
         ),
        ),
        const SizedBox(height: 24),
        Container(
         padding: const EdgeInsets.all(20),
         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
         child: Column(
          children: [
           Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.pie_chart_rounded, color: AppColors.secondary, size: 20)),
            const SizedBox(width: 12),
            const Text(AnalyticsConstants.taxBreakdown, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
           ]),
           const SizedBox(height: 20),
           SizedBox(
            height: 180,
            child: PieChart(
             PieChartData(
              sectionsSpace: 3,
              centerSpaceRadius: 45,
              sections: breakdown.asMap().entries.map((e) {
               final colors = [AppColors.primary, AppColors.success, AppColors.warning];
               final amount = (e.value['amount'] as num).toDouble();
               final percent = estimated > 0 ? (amount / estimated * 100) : 0;
               return PieChartSectionData(
                color: colors[e.key % colors.length],
                value: amount,
                title: '${percent.toStringAsFixed(0)}%',
                radius: 40,
                titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
               );
              }).toList(),
             ),
            ),
           ),
           const SizedBox(height: 20),
           ...breakdown.asMap().entries.map((e) {
            final colors = [AppColors.primary, AppColors.success, AppColors.warning];
            return Padding(
             padding: const EdgeInsets.only(bottom: 8),
             child: Row(children: [
              Container(width: 16, height: 16, decoration: BoxDecoration(color: colors[e.key % colors.length], borderRadius: BorderRadius.circular(4))),
              const SizedBox(width: 12),
              Text(e.value['name'] as String, style: const TextStyle(fontSize: 14)),
              const Spacer(),
              Text('\$${(e.value['amount'] as num).toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.bold, color: colors[e.key % colors.length])),
             ]),
            );
           }),
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
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.calendar_month_rounded, color: AppColors.warning, size: 20)),
            const SizedBox(width: 12),
            const Text(AnalyticsConstants.quarterlyPayments, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
           ]),
           const SizedBox(height: 16),
           Row(children: [
            Expanded(child: _buildQuarterCard('Q1', estimated / 4, true)),
            const SizedBox(width: 12),
            Expanded(child: _buildQuarterCard('Q2', estimated / 4, true)),
           ]),
           const SizedBox(height: 12),
           Row(children: [
            Expanded(child: _buildQuarterCard('Q3', estimated / 4, false)),
            const SizedBox(width: 12),
            Expanded(child: _buildQuarterCard('Q4', estimated / 4, false)),
           ]),
          ],
         ),
        ),
        const SizedBox(height: 24),
        Container(
         padding: const EdgeInsets.all(20),
         decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.info.withValues(alpha: 0.3))),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(children: [Icon(Icons.lightbulb_rounded, color: AppColors.info, size: 24), const SizedBox(width: 8), const Text(AnalyticsConstants.taxTips, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),
           const SizedBox(height: 12),
           _buildTip(AnalyticsConstants.taxTip1),
           _buildTip(AnalyticsConstants.taxTip2),
           _buildTip(AnalyticsConstants.taxTip3),
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
 Widget _buildQuarterCard(String quarter, double amount, bool isPaid) {
  return Container(
   padding: const EdgeInsets.all(16),
   decoration: BoxDecoration(color: isPaid ? AppColors.success.withValues(alpha: 0.1) : Colors.grey[100], borderRadius: BorderRadius.circular(12), border: Border.all(color: isPaid ? AppColors.success.withValues(alpha: 0.3) : Colors.grey.shade300)),
   child: Column(children: [
    Text(quarter, style: TextStyle(fontWeight: FontWeight.bold, color: isPaid ? AppColors.success : Colors.grey[700])),
    const SizedBox(height: 8),
    Text('\$${amount.toStringAsFixed(0)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isPaid ? AppColors.success : Colors.grey[700])),
    const SizedBox(height: 4),
    Icon(isPaid ? Icons.check_circle_rounded : Icons.schedule_rounded, color: isPaid ? AppColors.success : Colors.grey[500], size: 20),
   ]),
  );
 }
 Widget _buildTip(String tip) {
  return Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.check_rounded, color: AppColors.info, size: 18), const SizedBox(width: 8), Expanded(child: Text(tip, style: TextStyle(color: Colors.grey[700])))]));
 }
}