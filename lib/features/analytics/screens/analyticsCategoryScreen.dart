import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/analyticsProvider.dart';
import '../../analytics/constants/analyticsConstants.dart';
import '../widgets/analyticsScaffold.dart';
class AnalyticsCategoryScreen extends ConsumerWidget {
 const AnalyticsCategoryScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Scaffold(body: Center(child: Text(AnalyticsConstants.loginRequired)));
  final totalAsync = ref.watch(totalSpendingProvider(userId));
  final categoriesAsync = ref.watch(spendingByCategoryProvider(userId));
  return AnalyticsScaffold(
   title: AnalyticsConstants.categoryTitle,
   body: RefreshIndicator(
    onRefresh: () async {
     ref.invalidate(totalSpendingProvider(userId));
     ref.invalidate(spendingByCategoryProvider(userId));
    },
    child: categoriesAsync.when(
     data: (categories) => totalAsync.when(
      data: (total) {
       if (categories.isEmpty) return const Center(child: Text(AnalyticsConstants.noSpendingData));
       return ListView(
        padding: const EdgeInsets.all(16),
        children: [
         Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12)]),
          child: Column(
           children: [
            Row(children: [
             Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.pie_chart_rounded, color: AppColors.primary, size: 24)),
             const SizedBox(width: 12),
             const Text(AnalyticsConstants.spendingDistribution, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 24),
            SizedBox(
             height: 220,
             child: PieChart(
              PieChartData(
               sectionsSpace: 4,
               centerSpaceRadius: 50,
               sections: categories.entries.toList().asMap().entries.map((e) {
                final color = AnalyticsConstants.categoryColors[e.value.key.toLowerCase()] ?? AnalyticsConstants.defaultCategoryColor;
                final value = e.value.value;
                final percent = total > 0 ? (value / total * 100) : 0;
                return PieChartSectionData(
                 color: color,
                 value: value,
                 title: '${percent.toStringAsFixed(0)}%',
                 radius: 45,
                 titleStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                 badgeWidget: e.key == 0 ? Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)]), child: const Icon(Icons.star, size: 12, color: AppColors.warning)) : null,
                 badgePositionPercentageOffset: 1.2,
                );
               }).toList(),
              ),
             ),
            ),
            const SizedBox(height: 20),
            Container(
             padding: const EdgeInsets.all(12),
             decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
             child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${AnalyticsConstants.totalSpendingLabel}: ', style: const TextStyle(fontSize: 16)),
              Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
             ]),
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
             Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.list_alt_rounded, color: AppColors.accent, size: 24)),
             const SizedBox(width: 12),
             const Text(AnalyticsConstants.categoryDetails, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 20),
            ...categories.entries.map((e) => _buildCategoryItem(e.key, e.value, total)),
           ],
          ),
         ),
        ],
       );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox(),
     ),
     loading: () => const Center(child: CircularProgressIndicator()),
     error: (_, __) => const Center(child: Text(AnalyticsConstants.errorLoadingCategories)),
    ),
   ),
  );
 }
 Widget _buildCategoryItem(String name, double amount, double total) {
  final color = AnalyticsConstants.categoryColors[name.toLowerCase()] ?? AnalyticsConstants.defaultCategoryColor;
  final percent = total > 0 ? (amount / total) : 0.0;
  return Container(
   margin: const EdgeInsets.only(bottom: 16),
   padding: const EdgeInsets.all(16),
   decoration: BoxDecoration(color: color.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withValues(alpha: 0.2))),
   child: Column(
    children: [
     Row(children: [
      Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)), child: Center(child: Text(name.substring(0, 1).toUpperCase(), style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)))),
      const SizedBox(width: 16),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
       Text(name[0].toUpperCase() + name.substring(1), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
       const SizedBox(height: 2),
       Text('${(percent * 100).toStringAsFixed(1)}%${AnalyticsConstants.ofTotal}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ])),
      Text('\$${amount.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 18)),
     ]),
     const SizedBox(height: 12),
     ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: percent, backgroundColor: color.withValues(alpha: 0.2), valueColor: AlwaysStoppedAnimation<Color>(color), minHeight: 8)),
    ],
   ),
  );
 }
}