import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/walletProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/walletConstants.dart';
class WalletRecurringPaymentsScreen extends ConsumerWidget {
 const WalletRecurringPaymentsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? WalletConstants.defaultUserId;
  final recurringAsync = ref.watch(recurringPaymentsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(WalletConstants.recurringPayments),
   ),
   body: recurringAsync.when(
    data: (payments) => payments.isEmpty
      ? const Center(child: Text(WalletConstants.noTransactions))
      : ListView(
        padding: const EdgeInsets.all(16),
        children: [
         const Text(WalletConstants.recurringPayments, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
         const SizedBox(height: 12),
         ...payments.map((payment) => _buildPaymentCard(payment)),
        ],
       ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(WalletConstants.errorLoadingWallet)),
   ),
  );
 }
 Widget _buildPaymentCard(Map<String, dynamic> payment) {
  final name = payment['name'] as String? ?? WalletConstants.unknown;
  final amount = (payment['amount'] as num?)?.toDouble() ?? 0.0;
  final date = payment['nextPayDate']?.toString() ?? '';
  final status = payment['status'] as String? ?? WalletConstants.active;
  return Card(
   margin: const EdgeInsets.only(bottom: 12),
   child: ListTile(
    leading: Container(
     padding: const EdgeInsets.all(10),
     decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
     child: const Icon(Icons.autorenew, color: AppColors.primary),
    ),
    title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text('${WalletConstants.monthly} $date'),
    trailing: Column(
     mainAxisAlignment: MainAxisAlignment.center,
     crossAxisAlignment: CrossAxisAlignment.end,
     children: [
      Text(
       '${WalletConstants.currencySymbol}${amount.toStringAsFixed(2)}',
       style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
      ),
      Container(
       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
       decoration: BoxDecoration(color: status == WalletConstants.active ? AppColors.success.withValues(alpha: 0.2) : AppColors.error.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
       child: Text(status == WalletConstants.active ? WalletConstants.active : WalletConstants.pending, style: TextStyle(fontSize: 10, color: status == WalletConstants.active ? AppColors.success : AppColors.error)),
      ),
     ],
    ),
   ),
  );
 }
}