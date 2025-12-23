import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/walletProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/walletConstants.dart';
class WalletAnalyticsScreen extends ConsumerWidget {
 const WalletAnalyticsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? WalletConstants.defaultUserId;
  final analyticsAsync = ref.watch(walletAnalyticsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(WalletConstants.analytics),
   ),
   body: analyticsAsync.when(
    data: (analytics) {
     final totalSpent = (analytics['totalSpent'] as num?)?.toDouble() ?? 0.0;
     final totalIncome = (analytics['totalIncome'] as num?)?.toDouble() ?? 0.0;
     return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Container(
         padding: const EdgeInsets.all(20),
         decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
         child: Column(
          children: [
           const Text(WalletConstants.spending, style: TextStyle(color: Colors.white70)),
           const SizedBox(height: 8),
           Text(
            '${WalletConstants.currencySymbol}${totalSpent.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
           ),
           const SizedBox(height: 8),
           const Text(WalletConstants.thisMonth, style: TextStyle(color: Colors.white70)),
          ],
         ),
        ),
        const SizedBox(height: 24),
        Row(
         children: [
          Expanded(child: _buildStatCard(WalletConstants.income, '${WalletConstants.currencySymbol}${totalIncome.toStringAsFixed(2)}', AppColors.success)),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard(WalletConstants.expenses, '${WalletConstants.currencySymbol}${totalSpent.toStringAsFixed(2)}', AppColors.error)),
         ],
        ),
       ],
      ),
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(WalletConstants.errorLoadingWallet)),
   ),
  );
 }
 Widget _buildStatCard(String label, String value, Color color) {
  return Container(
   padding: const EdgeInsets.all(16),
   decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
   child: Column(
    children: [
     Text(
      value,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
     ),
     const SizedBox(height: 4),
     Text(label, style: TextStyle(color: color)),
    ],
   ),
  );
 }
}