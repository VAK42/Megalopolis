import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/analyticsProvider.dart';
import '../../analytics/constants/analyticsConstants.dart';
import '../widgets/analyticsScaffold.dart';
class AnalyticsSpendingScreen extends ConsumerWidget {
 const AnalyticsSpendingScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Scaffold(body: Center(child: Text(AnalyticsConstants.loginRequired)));
  final totalSpendingAsync = ref.watch(totalSpendingProvider(userId));
  final categorySpendingAsync = ref.watch(spendingByCategoryProvider(userId));
  final recentTransactionsAsync = ref.watch(recentTransactionsProvider(userId));
  return AnalyticsScaffold(
   title: AnalyticsConstants.spendingTitle,
   body: RefreshIndicator(
    onRefresh: () async {
     ref.invalidate(totalSpendingProvider(userId));
     ref.invalidate(spendingByCategoryProvider(userId));
     ref.invalidate(recentTransactionsProvider(userId));
    },
    child: totalSpendingAsync.when(
     data: (total) => ListView(
      padding: const EdgeInsets.all(16),
      children: [
       Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
         gradient: LinearGradient(colors: [AppColors.primary, const Color(0xFF1E40AF)], begin: Alignment.topLeft, end: Alignment.bottomRight),
         borderRadius: BorderRadius.circular(24),
         boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 8))],
        ),
        child: Column(
         children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
           Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 28)),
           const SizedBox(width: 12),
           const Text(AnalyticsConstants.totalSpendingLabel, style: TextStyle(color: Colors.white70, fontSize: 16)),
          ]),
          const SizedBox(height: 16),
          Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
           decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
           child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.calendar_today_rounded, color: Colors.white, size: 16), SizedBox(width: 6), Text(AnalyticsConstants.thisPeriod, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500))]),
          ),
         ],
        ),
       ),
       const SizedBox(height: 24),
       categorySpendingAsync.when(
        data: (categories) {
         if (categories.isEmpty) return const SizedBox();
         return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12)]),
          child: Column(
           children: [
            Row(children: [
             Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.pie_chart_rounded, color: AppColors.primary, size: 24)),
             const SizedBox(width: 12),
             const Text(AnalyticsConstants.byCategory, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 20),
            SizedBox(
             height: 200,
             child: PieChart(
              PieChartData(
               sectionsSpace: 4,
               centerSpaceRadius: 50,
               sections: categories.entries.map((e) {
                final color = AnalyticsConstants.categoryColors[e.key.toLowerCase()] ?? AnalyticsConstants.defaultCategoryColor;
                final percent = total > 0 ? (e.value / total * 100) : 0;
                return PieChartSectionData(color: color, value: e.value, title: '${percent.toStringAsFixed(0)}%', radius: 40, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white));
               }).toList(),
              ),
             ),
            ),
            const SizedBox(height: 16),
            Wrap(spacing: 16, runSpacing: 8, children: categories.entries.map((e) {
             final color = AnalyticsConstants.categoryColors[e.key.toLowerCase()] ?? AnalyticsConstants.defaultCategoryColor;
             return Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 14, height: 14, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))), const SizedBox(width: 6), Text(e.key[0].toUpperCase() + e.key.substring(1), style: TextStyle(fontSize: 12, color: Colors.grey[600]))]);
            }).toList()),
           ],
          ),
         );
        },
        loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
        error: (_, __) => const SizedBox(),
       ),
       const SizedBox(height: 24),
       categorySpendingAsync.when(
        data: (categories) => Container(
         padding: const EdgeInsets.all(20),
         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12)]),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.list_alt_rounded, color: AppColors.accent, size: 24)),
            const SizedBox(width: 12),
            const Text(AnalyticsConstants.categoryDetails, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
           ]),
           const SizedBox(height: 16),
           ...categories.entries.map((e) => _buildCategory(e.key, e.value, total)),
          ],
         ),
        ),
        loading: () => const SizedBox(),
        error: (_, __) => const SizedBox(),
       ),
       const SizedBox(height: 24),
       recentTransactionsAsync.when(
        data: (transactions) {
         if (transactions.isEmpty) return const SizedBox();
         return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12)]),
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Row(children: [
             Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.receipt_long_rounded, color: AppColors.warning, size: 24)),
             const SizedBox(width: 12),
             const Text(AnalyticsConstants.recentOrders, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 16),
            ...transactions.take(5).map((t) => Container(
             margin: const EdgeInsets.only(bottom: 12),
             padding: const EdgeInsets.all(14),
             decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12)),
             child: Row(children: [
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.shopping_bag_rounded, color: AppColors.error, size: 20)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
               Text(t['orderType']?.toString().toUpperCase() ?? AnalyticsConstants.order, style: const TextStyle(fontWeight: FontWeight.w600)),
               Text(t['id']?.toString() ?? '', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
              ])),
              Text('-\$${(t['total'] as num).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.error)),
             ]),
            )),
           ],
          ),
         );
        },
        loading: () => const SizedBox(),
        error: (_, __) => const SizedBox(),
       ),
      ],
     ),
     loading: () => const Center(child: CircularProgressIndicator()),
     error: (e, s) => Center(child: Text('${AnalyticsConstants.errorPrefix}$e')),
    ),
   ),
  );
 }
 Widget _buildCategory(String name, double amount, double total) {
  final color = AnalyticsConstants.categoryColors[name.toLowerCase()] ?? AnalyticsConstants.defaultCategoryColor;
  final percentage = total > 0 ? amount / total : 0.0;
  return Container(
   margin: const EdgeInsets.only(bottom: 14),
   padding: const EdgeInsets.all(14),
   decoration: BoxDecoration(color: color.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withValues(alpha: 0.2))),
   child: Column(
    children: [
     Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [Container(width: 8, height: 32, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))), const SizedBox(width: 12), Text(name[0].toUpperCase() + name.substring(1), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15))]),
      Text('\$${amount.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16)),
     ]),
     const SizedBox(height: 10),
     ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: percentage, backgroundColor: color.withValues(alpha: 0.2), valueColor: AlwaysStoppedAnimation<Color>(color), minHeight: 6)),
    ],
   ),
  );
 }
}