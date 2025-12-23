import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/analyticsProvider.dart';
import '../../analytics/constants/analyticsConstants.dart';
class AnalyticsSpendingScreen extends ConsumerWidget {
 const AnalyticsSpendingScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Scaffold(body: Center(child: Text(AnalyticsConstants.loginRequired)));
  final totalSpendingAsync = ref.watch(totalSpendingProvider(userId));
  final categorySpendingAsync = ref.watch(spendingByCategoryProvider(userId));
  return Scaffold(
   appBar: AppBar(title: const Text(AnalyticsConstants.spendingTitle)),
   body: totalSpendingAsync.when(
    data: (total) => ListView(
     padding: const EdgeInsets.all(16),
     children: [
      Container(
       padding: const EdgeInsets.all(20),
       decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
       child: Column(
        children: [
         const Text(AnalyticsConstants.totalSpendingLabel, style: TextStyle(color: Colors.white70)),
         const SizedBox(height: 8),
         Text(
          '\$${total.toStringAsFixed(2)}',
          style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
         ),
        ],
       ),
      ),
      const SizedBox(height: 24),
      categorySpendingAsync.when(
       data: (categories) {
        return Column(
         children: [
          SizedBox(
           height: 200,
           child: PieChart(
            PieChartData(
             sectionsSpace: 2,
             centerSpaceRadius: 40,
             sections: categories.entries.map((e) {
              final color = AnalyticsConstants.categoryColors[e.key.toLowerCase()] ?? AnalyticsConstants.defaultCategoryColor;
              final value = e.value;
              return PieChartSectionData(
               color: color,
               value: value,
               title: '${(value / total * 100).toStringAsFixed(0)}%',
               radius: 50,
               titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
              );
             }).toList(),
            ),
           ),
          ),
          const SizedBox(height: 24),
          ...categories.entries.map((e) => _buildCategory(e.key, e.value, total)).toList(),
         ],
        );
       },
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (_, __) => const SizedBox(),
      ),
     ],
    ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, s) => Center(child: Text('${AnalyticsConstants.errorPrefix}$e')),
   ),
  );
 }
 Widget _buildCategory(String name, double amount, double total) {
  final color = AnalyticsConstants.categoryColors[name.toLowerCase()] ?? AnalyticsConstants.defaultCategoryColor;
  final percentage = total > 0 ? amount / total : 0.0;
  return Card(
   margin: const EdgeInsets.only(bottom: 12),
   child: Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
     children: [
      Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
        Text(name[0].toUpperCase() + name.substring(1), style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(
         '\$${amount.toStringAsFixed(2)}',
         style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
       ],
      ),
      const SizedBox(height: 8),
      LinearProgressIndicator(value: percentage, backgroundColor: AppColors.backgroundLight, valueColor: AlwaysStoppedAnimation<Color>(color), minHeight: 6, borderRadius: BorderRadius.circular(3)),
     ],
    ),
   ),
  );
 }
}