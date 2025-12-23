import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/analyticsProvider.dart';
import '../constants/analyticsConstants.dart';
class AnalyticsIncomeScreen extends ConsumerWidget {
 const AnalyticsIncomeScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Scaffold(body: Center(child: Text(AnalyticsConstants.loginRequired)));
  final totalIncomeAsync = ref.watch(incomeProvider(userId));
  final sourcesAsync = ref.watch(incomeSourcesProvider(userId));
  return Scaffold(
   appBar: AppBar(title: const Text(AnalyticsConstants.incomeTitle)),
   body: ListView(
    padding: const EdgeInsets.all(16),
    children: [
     totalIncomeAsync.when(
      data: (total) => Container(
       padding: const EdgeInsets.all(20),
       decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(16)),
       child: Column(
        children: [
         const Text(AnalyticsConstants.totalIncomeLabel, style: TextStyle(color: Colors.white70)),
         const SizedBox(height: 8),
         Text(
          '\$${total.toStringAsFixed(2)}',
          style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
         ),
        ],
       ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox(),
     ),
     const SizedBox(height: 24),
     sourcesAsync.when(
      data: (sources) => Column(
       children: sources
         .map(
          (s) => Card(
           margin: const EdgeInsets.only(bottom: 12),
           child: ListTile(
            title: Text(s['reference']?.toString() ?? AnalyticsConstants.incomeSourceDefault),
            trailing: Text(
             '\$${(s['amount'] as num).toStringAsFixed(2)}',
             style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success),
            ),
           ),
          ),
         )
         .toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox(),
     ),
    ],
   ),
  );
 }
}