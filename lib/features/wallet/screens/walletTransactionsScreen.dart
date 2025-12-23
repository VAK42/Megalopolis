import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/walletProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/walletConstants.dart';
class WalletTransactionsScreen extends ConsumerWidget {
 const WalletTransactionsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? WalletConstants.defaultUserId;
  final transactionsAsync = ref.watch(transactionsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(WalletConstants.allTransactions),
    actions: [IconButton(icon: const Icon(Icons.download), onPressed: () {})],
   ),
   body: transactionsAsync.when(
    data: (transactions) => transactions.isEmpty
      ? const Center(child: Text(WalletConstants.noTransactions))
      : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
         final tx = transactions[index];
         final isCredit = (tx['type']?.toString() ?? '') == 'credit';
         return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
           leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: isCredit ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(isCredit ? Icons.arrow_downward : Icons.arrow_upward, color: isCredit ? AppColors.success : AppColors.error),
           ),
           title: Text(tx['description']?.toString() ?? WalletConstants.transactions, style: const TextStyle(fontWeight: FontWeight.w600)),
           subtitle: Text(tx['createdAt'] != null ? DateTime.fromMillisecondsSinceEpoch(tx['createdAt'] as int).toString().substring(0, 16) : WalletConstants.today),
           trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
             Text(
              '${isCredit ? '+' : '-'}${WalletConstants.currencySymbol}${tx['amount']?.toString() ?? '0'}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isCredit ? AppColors.success : AppColors.error),
             ),
             const SizedBox(height: 4),
             Text(isCredit ? WalletConstants.income : WalletConstants.expenses, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
            ],
           ),
          ),
         );
        },
       ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(WalletConstants.errorLoadingTransactions)),
   ),
  );
 }
}