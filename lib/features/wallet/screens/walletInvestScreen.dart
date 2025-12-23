import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/walletProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/walletConstants.dart';
class WalletInvestScreen extends ConsumerWidget {
 const WalletInvestScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? WalletConstants.defaultUserId;
  final investmentsAsync = ref.watch(investmentsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(WalletConstants.invest),
   ),
   body: investmentsAsync.when(
    data: (data) {
     final totalValue = (data['totalValue'] as num?)?.toDouble() ?? 0.0;
     final totalReturns = (data['totalReturns'] as num?)?.toDouble() ?? 0.0;
     final returnPercent = totalValue > 0 ? (totalReturns / totalValue) * 100 : 0.0;
     final investments = data['investments'] as List<dynamic>? ?? [];
     return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Container(
         padding: const EdgeInsets.all(20),
         decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           const Text(WalletConstants.investments, style: TextStyle(color: Colors.white70)),
           const SizedBox(height: 8),
           Text(
            '${WalletConstants.currencySymbol}${totalValue.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
           ),
           const SizedBox(height: 8),
           Row(
            children: [
             Icon(totalReturns >= 0 ? Icons.trending_up : Icons.trending_down, color: totalReturns >= 0 ? Colors.green : Colors.red, size: 16),
             const SizedBox(width: 4),
             Text(
              '${totalReturns >= 0 ? '+' : ''}${WalletConstants.currencySymbol}${totalReturns.toStringAsFixed(2)} (${returnPercent.toStringAsFixed(1)}%)',
              style: TextStyle(color: totalReturns >= 0 ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
             ),
            ],
           ),
          ],
         ),
        ),
        const SizedBox(height: 24),
        const Text(WalletConstants.investments, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...investments.map((inv) => _buildInvestmentCard(inv as Map<String, dynamic>)),
        if (investments.isEmpty) ...[
         _buildInvestmentCard({'name': WalletConstants.lowRisk, 'returns': '5-7%', 'risk': 'low'}),
         _buildInvestmentCard({'name': WalletConstants.mediumRisk, 'returns': '10-15%', 'risk': 'medium'}),
         _buildInvestmentCard({'name': WalletConstants.highRisk, 'returns': '20-30%', 'risk': 'high'}),
        ],
       ],
      ),
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(WalletConstants.errorLoadingWallet)),
   ),
  );
 }
 Widget _buildInvestmentCard(Map<String, dynamic> inv) {
  final name = inv['name'] as String? ?? WalletConstants.unknown;
  final returns = inv['returns']?.toString() ?? '0%';
  final risk = inv['risk'] as String? ?? 'low';
  Color color;
  switch (risk) {
   case 'high':
    color = AppColors.error;
    break;
   case 'medium':
    color = AppColors.accent;
    break;
   default:
    color = AppColors.success;
  }
  return Card(
   margin: const EdgeInsets.only(bottom: 12),
   child: ListTile(
    leading: Container(
     padding: const EdgeInsets.all(10),
     decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
     child: Icon(Icons.trending_up, color: color),
    ),
    title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text(returns),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
   ),
  );
 }
}