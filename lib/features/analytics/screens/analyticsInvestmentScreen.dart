import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/analyticsProvider.dart';
import '../constants/analyticsConstants.dart';
class AnalyticsInvestmentScreen extends ConsumerWidget {
 const AnalyticsInvestmentScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Scaffold(body: Center(child: Text(AnalyticsConstants.loginRequired)));
  final investmentsAsync = ref.watch(investmentsProvider(userId));
  return Scaffold(
   appBar: AppBar(title: const Text(AnalyticsConstants.investmentTitle)),
   body: investmentsAsync.when(
    data: (data) => ListView(
     padding: const EdgeInsets.all(16),
     children: [
      Container(
       padding: const EdgeInsets.all(20),
       decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
       child: Column(
        children: [
         const Text(AnalyticsConstants.portfolioValueLabel, style: TextStyle(color: Colors.white70)),
         const SizedBox(height: 8),
         Text(
          '\$${(data['total'] as num).toStringAsFixed(2)}',
          style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
         ),
         const SizedBox(height: 8),
         Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           const Icon(Icons.trending_up, color: Colors.green, size: 16),
           const SizedBox(width: 4),
           Text(
            '+\$${(data['growth'] as num).toStringAsFixed(0)} (${data['growthPercentage']}%)',
            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
           ),
          ],
         ),
        ],
       ),
      ),
      const SizedBox(height: 24),
      ...(data['portfolio'] as List).map((t) {
       final growth = (t['growth'] as num).toDouble();
       return Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
         title: Text(t['name'] as String),
         trailing: Text(
          '${growth > 0 ? '+' : ''}$growth%',
          style: TextStyle(color: growth >= 0 ? AppColors.success : AppColors.error, fontWeight: FontWeight.bold),
         ),
        ),
       );
      }),
     ],
    ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, s) => Center(child: Text('${AnalyticsConstants.errorPrefix}$e')),
   ),
  );
 }
}