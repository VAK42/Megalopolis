import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/walletProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/walletConstants.dart';
class WalletPayBillScreen extends ConsumerStatefulWidget {
 final String provider;
 final double amount;
 final String billId;
 const WalletPayBillScreen({super.key, required this.provider, required this.amount, required this.billId});
 @override
 ConsumerState<WalletPayBillScreen> createState() => _WalletPayBillScreenState();
}
class _WalletPayBillScreenState extends ConsumerState<WalletPayBillScreen> {
 bool isLoading = false;
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider) ?? WalletConstants.defaultUserId;
  final balanceAsync = ref.watch(walletBalanceProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(WalletConstants.payBill),
   ),
   body: ListView(
    padding: const EdgeInsets.all(16),
    children: [
     Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
       border: Border.all(color: AppColors.primary),
       borderRadius: BorderRadius.circular(12),
       color: AppColors.primary.withValues(alpha: 0.05),
      ),
      child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
        Row(
         children: [
          Container(
           padding: const EdgeInsets.all(10),
           decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
           child: const Icon(Icons.receipt, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Text(widget.provider, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(WalletConstants.pending, style: TextStyle(color: AppColors.accent, fontSize: 12)),
           ],
          ),
         ],
        ),
        Text('${WalletConstants.currencySymbol}${widget.amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
       ],
      ),
     ),
     const SizedBox(height: 24),
     Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
        const Text(WalletConstants.balance, style: TextStyle(fontWeight: FontWeight.w500)),
        balanceAsync.when(
         data: (balance) => Text('${WalletConstants.currencySymbol}${balance.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.success)),
         loading: () => const Text(WalletConstants.loading),
         error: (_, __) => const Text(WalletConstants.errorLoadingWallet),
        ),
       ],
      ),
     ),
     const SizedBox(height: 32),
     AppButton(
      text: isLoading ? WalletConstants.loading : WalletConstants.payNow,
      onPressed: isLoading ? null : () async {
       setState(() => isLoading = true);
       final success = await ref.read(walletNotifierProvider(userId).notifier).payBill(widget.amount, widget.provider);
       setState(() => isLoading = false);
       if (success && context.mounted) {
        ref.invalidate(walletBalanceProvider(userId));
        ref.invalidate(billsProvider(userId));
        ref.invalidate(pendingBillsProvider(userId));
        ref.invalidate(billSummaryProvider(userId));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(WalletConstants.billPaidSuccessfully)));
        context.pop();
       }
      },
      icon: Icons.payment,
     ),
    ],
   ),
  );
 }
}