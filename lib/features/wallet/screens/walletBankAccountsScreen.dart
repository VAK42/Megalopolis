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
  final cardsAsync = ref.watch(walletCardsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(WalletConstants.bankAccounts),
   ),
   body: cardsAsync.when(
    data: (accounts) => ListView(
     padding: const EdgeInsets.all(16),
     children: [
      ...accounts.asMap().entries.map((entry) => _buildBankAccount(context, ref, userId, entry.key, entry.value)),
      const SizedBox(height: 8),
      OutlinedButton.icon(
       onPressed: () => context.go('/wallet/addCard'),
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
 Widget _buildBankAccount(BuildContext context, WidgetRef ref, String userId, int index, Map<String, dynamic> account) {
  final bankName = (account['type']?.toString().toUpperCase() ?? 'VISA').replaceAll('MASTERCARD', 'Mastercard').replaceAll('VISA', 'Visa');
  final fullNumber = account['number']?.toString().replaceAll(' ', '') ?? '****';
  final accountNumber = fullNumber.length >= 4 ? fullNumber.substring(fullNumber.length - 4) : fullNumber;
  final accountHolder = account['holder']?.toString() ?? WalletConstants.unknown;
  final balance = (account['balance'] as num?)?.toDouble() ?? 0.0;
  final isPrimary = index == 0;
  final cardId = account['id']?.toString() ?? '';
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
           child: const Icon(Icons.credit_card, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Text('$bankName •••• $accountNumber', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(accountHolder, style: TextStyle(color: Colors.grey[600])),
            Text('\$${balance.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 14)),
           ],
          ),
         ],
        ),
        if (isPrimary)
         Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
          child: const Text('Primary', style: TextStyle(color: AppColors.success, fontSize: 10)),
         ),
       ],
      ),
      const SizedBox(height: 12),
      Row(
       children: [
        Expanded(
         child: OutlinedButton(
          onPressed: () => context.go('/wallet/card/$cardId'),
          child: const Text(WalletConstants.details),
         ),
        ),
        const SizedBox(width: 8),
        Expanded(
         child: OutlinedButton(
          onPressed: () => _showRemoveDialog(context, ref, userId, cardId),
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
 void _showRemoveDialog(BuildContext context, WidgetRef ref, String userId, String cardId) {
  showDialog(
   context: context,
   builder: (context) => AlertDialog(
    title: const Text(WalletConstants.remove),
    content: const Text(WalletConstants.msgConfirmDeleteCard),
    actions: [
     TextButton(onPressed: () => Navigator.pop(context), child: const Text(WalletConstants.cancel)),
     TextButton(
      onPressed: () async {
       Navigator.pop(context);
       await ref.read(walletCardsProvider(userId).notifier).removeCard(cardId);
      },
      child: const Text(WalletConstants.delete, style: TextStyle(color: Colors.red)),
     ),
    ],
   ),
  );
 }
}