import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/walletProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/walletConstants.dart';
class WalletTopUpScreen extends ConsumerStatefulWidget {
 const WalletTopUpScreen({super.key});
 @override
 ConsumerState<WalletTopUpScreen> createState() => _WalletTopUpScreenState();
}
class _WalletTopUpScreenState extends ConsumerState<WalletTopUpScreen> {
 final TextEditingController amountController = TextEditingController();
 String selectedMethod = WalletConstants.bankTransfer;
 bool isLoading = false;
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider) ?? WalletConstants.defaultUserId;
  final balanceAsync = ref.watch(walletBalanceProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(WalletConstants.topUp),
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Container(
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(12)),
       child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         const Text(WalletConstants.balance, style: TextStyle(color: Colors.white70)),
         balanceAsync.when(
          data: (balance) => Text(
           '${WalletConstants.currencySymbol}${balance.toStringAsFixed(2)}',
           style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          loading: () => const Text(WalletConstants.loading, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          error: (_, __) => const Text(WalletConstants.errorText, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
         ),
        ],
       ),
      ),
      const SizedBox(height: 24),
      const Text(WalletConstants.topUpAmount, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      TextField(
       controller: amountController,
       keyboardType: TextInputType.number,
       style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
       decoration: InputDecoration(
        prefixIcon: const Padding(
         padding: EdgeInsets.only(top: 12, left: 12),
         child: Text(WalletConstants.currencySymbol, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        ),
        hintText: WalletConstants.amountHint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
       ),
      ),
      const SizedBox(height: 16),
      Row(
       children: [
        Expanded(child: _buildQuickAmount(WalletConstants.quickAmount50)),
        const SizedBox(width: 8),
        Expanded(child: _buildQuickAmount(WalletConstants.quickAmount100)),
        const SizedBox(width: 8),
        Expanded(child: _buildQuickAmount(WalletConstants.quickAmount200)),
        const SizedBox(width: 8),
        Expanded(child: _buildQuickAmount(WalletConstants.quickAmount500)),
       ],
      ),
      const SizedBox(height: 24),
      const Text(WalletConstants.selectMethod, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      _buildPaymentMethod(Icons.account_balance, WalletConstants.bankTransfer, WalletConstants.free),
      _buildPaymentMethod(Icons.credit_card, WalletConstants.debitCard, WalletConstants.feePercentage25),
      _buildPaymentMethod(Icons.credit_card, WalletConstants.creditCard, WalletConstants.feePercentage3),
      const SizedBox(height: 32),
      AppButton(
       text: isLoading ? WalletConstants.loading : WalletConstants.confirmTopUp,
       onPressed: isLoading ? null : () async {
        if (amountController.text.isEmpty) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(WalletConstants.msgEnterAmount)));
         return;
        }
        final amount = double.tryParse(amountController.text) ?? 0.0;
        if (amount <= 0) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(WalletConstants.msgEnterValidAmount)));
         return;
        }
        setState(() => isLoading = true);
        final success = await ref.read(walletNotifierProvider(userId).notifier).topUp(amount, selectedMethod);
        setState(() => isLoading = false);
        if (success && context.mounted) {
         ref.invalidate(walletBalanceProvider(userId));
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${WalletConstants.topUpSuccessful} ${WalletConstants.currencySymbol}${amount.toStringAsFixed(2)}')));
         context.pop();
        }
       },
       icon: Icons.check_circle,
      ),
     ],
    ),
   ),
  );
 }
 Widget _buildQuickAmount(String amount) {
  return OutlinedButton(onPressed: () => setState(() => amountController.text = amount.substring(1)), child: Text(amount));
 }
 Widget _buildPaymentMethod(IconData icon, String title, String subtitle) {
  final isSelected = selectedMethod == title;
  return GestureDetector(
   onTap: () => setState(() => selectedMethod = title),
   child: Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
     border: Border.all(color: isSelected ? AppColors.primary : Colors.grey[300]!),
     borderRadius: BorderRadius.circular(12),
     color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : null,
    ),
    child: Row(
     children: [
      Container(
       padding: const EdgeInsets.all(10),
       decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
       child: Icon(icon, color: AppColors.primary),
      ),
      const SizedBox(width: 12),
      Expanded(
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
         Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
       ),
      ),
      if (isSelected) const Icon(Icons.check_circle, color: AppColors.primary),
     ],
    ),
   ),
  );
 }
}