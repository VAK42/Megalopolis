import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/analyticsProvider.dart';
import '../constants/analyticsConstants.dart';
class AnalyticsComparisonScreen extends ConsumerWidget {
 const AnalyticsComparisonScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Scaffold(body: Center(child: Text(AnalyticsConstants.loginRequired)));
  final comparisonAsync = ref.watch(comparisonProvider(userId));
  return Scaffold(
   appBar: AppBar(title: const Text(AnalyticsConstants.comparisonTitle)),
   body: comparisonAsync.when(
    data: (comparison) => ListView(padding: const EdgeInsets.all(16), children: comparison.map((c) => _buildMonth(c['month'] as String, (c['spending'] as num).toInt(), (c['income'] as num).toInt())).toList()),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, s) => Center(child: Text('${AnalyticsConstants.errorPrefix}$e')),
   ),
  );
 }
 Widget _buildMonth(String month, int spending, int income) => Card(
  margin: const EdgeInsets.only(bottom: 16),
  child: Padding(
   padding: const EdgeInsets.all(16),
   child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     Text(month, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
       Column(
        children: [
         const Text(AnalyticsConstants.spendingLabel, style: TextStyle(color: Colors.grey)),
         Text(
          '\$$spending',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.error),
         ),
        ],
       ),
       Column(
        children: [
         const Text(AnalyticsConstants.incomeLabel, style: TextStyle(color: Colors.grey)),
         Text(
          '\$$income',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.success),
         ),
        ],
       ),
       Column(
        children: [
         const Text(AnalyticsConstants.netLabel, style: TextStyle(color: Colors.grey)),
         Text(
          '\$${income - spending}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
         ),
        ],
       ),
      ],
     ),
    ],
   ),
  ),
 );
}