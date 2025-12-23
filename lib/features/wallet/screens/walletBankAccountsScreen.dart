import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/walletProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/walletConstants.dart';
class WalletBankAccountsScreen extends ConsumerWidget {
 const WalletBankAccountsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? WalletConstants.defaultUserId;
  final bankAccountsAsync = ref.watch(bankAccountsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(WalletConstants.bankAccounts),
   ),
   body: bankAccountsAsync.when(
    data: (accounts) => ListView(
     padding: const EdgeInsets.all(16),
     children: [
      ...accounts.asMap().entries.map((entry) => _buildBankAccount(entry.key, entry.value)),
      const SizedBox(height: 8),
      OutlinedButton.icon(
       onPressed: () {},
       icon: const Icon(Icons.add),
       label: const Text(WalletConstants.linkBankAccount),
       style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
      ),
     ],
    ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(WalletConstants.errorLoadingWallet)),
   ),
  );
 }
 Widget _buildBankAccount(int index, Map<String, dynamic> account) {
  final bankName = account['bankName'] as String? ?? WalletConstants.unknown;
  final accountNumber = account['accountNumber']?.toString() ?? WalletConstants.unknown;
  final isPrimary = account['isPrimary'] == true || index == 0;
  return Card(
   margin: const EdgeInsets.only(bottom: 12),
   child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
        Row(
         children: [
          Container(
           padding: const EdgeInsets.all(10),
           decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
           child: const Icon(Icons.account_balance, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Text(bankName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('${WalletConstants.accountNumber} $accountNumber', style: TextStyle(color: Colors.grey[600])),
           ],
          ),
         ],
        ),
        if (isPrimary)
         Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
          child: const Text(WalletConstants.cardDetails, style: TextStyle(color: AppColors.success, fontSize: 10)),
         ),
       ],
      ),
      const SizedBox(height: 12),
      Row(
       children: [
        Expanded(
         child: OutlinedButton(onPressed: () {}, child: const Text(WalletConstants.details)),
        ),
        const SizedBox(width: 8),
        Expanded(
         child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
          child: const Text(WalletConstants.remove),
         ),
        ),
       ],
      ),
     ],
    ),
   ),
  );
 }
}