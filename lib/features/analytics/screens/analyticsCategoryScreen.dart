import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/analyticsProvider.dart';
import '../../analytics/constants/analyticsConstants.dart';
class AnalyticsCategoryScreen extends ConsumerWidget {
 const AnalyticsCategoryScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Scaffold(body: Center(child: Text(AnalyticsConstants.loginRequired)));
  final totalAsync = ref.watch(totalSpendingProvider(userId));
  final categoriesAsync = ref.watch(spendingByCategoryProvider(userId));
  return Scaffold(
   appBar: AppBar(title: const Text(AnalyticsConstants.categoryTitle)),
   body: categoriesAsync.when(
    data: (categories) => totalAsync.when(
     data: (total) => ListView(
      padding: const EdgeInsets.all(16),
      children: categories.entries.map((e) {
       final percentage = total > 0 ? (e.value / total * 100).toInt() : 0;
       final color = AnalyticsConstants.categoryColors[e.key.toLowerCase()] ?? AnalyticsConstants.defaultCategoryColor;
       return _buildCat(e.key.toUpperCase(), percentage, color);
      }).toList(),
     ),
     loading: () => const Center(child: CircularProgressIndicator()),
     error: (_, __) => const SizedBox(),
    ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(AnalyticsConstants.errorLoadingCategories)),
   ),
  );
 }
 Widget _buildCat(String name, int percent, Color color) => Card(
  margin: const EdgeInsets.only(bottom: 16),
  child: Padding(
   padding: const EdgeInsets.all(16),
   child: Column(
    children: [
     Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
       Text(
        '$percent%',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
       ),
      ],
     ),
     const SizedBox(height: 12),
     LinearProgressIndicator(value: percent / 100, backgroundColor: Colors.grey[300], valueColor: AlwaysStoppedAnimation<Color>(color), minHeight: 10, borderRadius: BorderRadius.circular(5)),
    ],
   ),
  ),
 );
}