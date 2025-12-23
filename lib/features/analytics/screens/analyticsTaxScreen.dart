import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/analyticsProvider.dart';
import '../constants/analyticsConstants.dart';
class AnalyticsTaxScreen extends ConsumerWidget {
 const AnalyticsTaxScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Scaffold(body: Center(child: Text(AnalyticsConstants.loginRequired)));
  final taxAsync = ref.watch(taxProvider(userId));
  return Scaffold(
   appBar: AppBar(title: const Text(AnalyticsConstants.taxTitle)),
   body: taxAsync.when(
    data: (tax) => ListView(
     padding: const EdgeInsets.all(16),
     children: [
      Container(
       padding: const EdgeInsets.all(20),
       decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(16)),
       child: Column(
        children: [
         const Text(AnalyticsConstants.estimatedTaxLabel, style: TextStyle(color: Colors.white70)),
         const SizedBox(height: 8),
         Text(
          '\$${(tax['estimated'] as num).toStringAsFixed(0)}',
          style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
         ),
        ],
       ),
      ),
      const SizedBox(height: 24),
      ...(tax['breakdown'] as List).map((t) => _buildTaxItem(t['name'] as String, (t['amount'] as num).toDouble())),
     ],
    ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, s) => Center(child: Text('${AnalyticsConstants.errorPrefix}$e')),
   ),
  );
 }
 Widget _buildTaxItem(String name, double amount) => Card(
  margin: const EdgeInsets.only(bottom: 12),
  child: ListTile(
   title: Text(name),
   trailing: Text('\$${amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
  ),
 );
}