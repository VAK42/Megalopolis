import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/analyticsProvider.dart';
import '../constants/analyticsConstants.dart';
class AnalyticsSavingsScreen extends ConsumerWidget {
 const AnalyticsSavingsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Scaffold(body: Center(child: Text(AnalyticsConstants.loginRequired)));
  final savingsAsync = ref.watch(savingsProvider(userId));
  return Scaffold(
   appBar: AppBar(title: const Text(AnalyticsConstants.savingsTitle)),
   body: savingsAsync.when(
    data: (savings) => ListView(
     padding: const EdgeInsets.all(16),
     children: [
      Container(
       padding: const EdgeInsets.all(20),
       decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(16)),
       child: Column(
        children: [
         const Text(AnalyticsConstants.totalSavingsLabel, style: TextStyle(color: Colors.white70)),
         const SizedBox(height: 8),
         Text(
          '\$${(savings['total'] as num).toStringAsFixed(0)}',
          style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
         ),
         const SizedBox(height: 16),
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
           Column(
            children: [
             const Text(AnalyticsConstants.thisMonthLabel, style: TextStyle(color: Colors.white70, fontSize: 12)),
             Text(
              '\$${(savings['month'] as num).toStringAsFixed(0)}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
             ),
            ],
           ),
           Column(
            children: [
             const Text(AnalyticsConstants.goalLabel, style: TextStyle(color: Colors.white70, fontSize: 12)),
             Text(
              '\$${(savings['goal'] as num).toStringAsFixed(0)}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
             ),
            ],
           ),
          ],
         ),
        ],
       ),
      ),
      const SizedBox(height: 24),
      LinearProgressIndicator(value: (savings['goal'] as num) > 0 ? ((savings['total'] as num) / (savings['goal'] as num)).clamp(0.0, 1.0) : 0, backgroundColor: Colors.grey[300], valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success), minHeight: 12, borderRadius: BorderRadius.circular(6)),
     ],
    ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, s) => Center(child: Text('${AnalyticsConstants.errorPrefix}$e')),
   ),
  );
 }
}