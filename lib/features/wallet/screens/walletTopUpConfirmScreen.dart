import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/walletProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/walletConstants.dart';
class WalletTopUpConfirmScreen extends ConsumerWidget {
 final double amount;
 final String method;
 const WalletTopUpConfirmScreen({super.key, required this.amount, required this.method});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? WalletConstants.defaultUserId;
  final balanceAsync = ref.watch(walletBalanceProvider(userId));
  final fee = 0.0;
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(WalletConstants.confirmTopUp),
   ),
   body: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
     children: [
      const SizedBox(height: 24),
      Container(
       width: 100,
       height: 100,
       decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
       child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 50),
      ),
      const SizedBox(height: 16),
      Text(method, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const Text(WalletConstants.free, style: TextStyle(color: Colors.grey)),
      const SizedBox(height: 32),
      const Text(WalletConstants.topUpAmount, style: TextStyle(color: Colors.grey)),
      const SizedBox(height: 8),
      Text(
       '${WalletConstants.currencySymbol}${amount.toStringAsFixed(2)}',
       style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.primary),
      ),
      const SizedBox(height: 32),
      Container(
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
       child: balanceAsync.when(
        data: (currentBalance) {
         final newBalance = currentBalance + amount;
         return Column(children: [_buildInfoRow(WalletConstants.currentBalance, '${WalletConstants.currencySymbol}${currentBalance.toStringAsFixed(2)}'), const Divider(height: 24), _buildInfoRow(WalletConstants.topUpAmount, '${WalletConstants.currencySymbol}${amount.toStringAsFixed(2)}'), const Divider(height: 24), _buildInfoRow(WalletConstants.transactionFee, '${WalletConstants.currencySymbol}${fee.toStringAsFixed(2)}'), const Divider(height: 24), _buildInfoRow(WalletConstants.newBalance, '${WalletConstants.currencySymbol}${newBalance.toStringAsFixed(2)}', isTotal: true)]);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Text(WalletConstants.errorLoadingWallet),
       ),
      ),
      const Spacer(),
      AppButton(text: WalletConstants.confirmTopUp, onPressed: () => context.go(Routes.walletTopUpSuccess), icon: Icons.check_circle),
     ],
    ),
   ),
  );
 }
 Widget _buildInfoRow(String label, String value, {bool isTotal = false}) {
  return Row(
   mainAxisAlignment: MainAxisAlignment.spaceBetween,
   children: [
    Text(
     label,
     style: TextStyle(fontSize: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
    ),
    Text(
     value,
     style: TextStyle(fontSize: isTotal ? 18 : 14, fontWeight: FontWeight.bold, color: isTotal ? AppColors.primary : null),
    ),
   ],
  );
 }
}