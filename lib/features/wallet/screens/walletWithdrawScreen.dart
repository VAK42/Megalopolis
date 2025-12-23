import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/walletProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/walletConstants.dart';
class WalletWithdrawScreen extends ConsumerStatefulWidget {
 const WalletWithdrawScreen({super.key});
 @override
 ConsumerState<WalletWithdrawScreen> createState() => _WalletWithdrawScreenState();
}
class _WalletWithdrawScreenState extends ConsumerState<WalletWithdrawScreen> {
 final TextEditingController amountController = TextEditingController();
 String? selectedAccount;
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider) ?? WalletConstants.defaultUserId;
  final balanceAsync = ref.watch(walletBalanceProvider(userId));
  final bankAccountsAsync = ref.watch(bankAccountsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(WalletConstants.withdraw),
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
         const Text(WalletConstants.availableBalance, style: TextStyle(color: Colors.white70)),
         balanceAsync.when(
          data: (balance) => Text(
           '${WalletConstants.currencySymbol}${balance.toStringAsFixed(2)}',
           style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          loading: () => const Text(WalletConstants.loading, style: TextStyle(color: Colors.white)),
          error: (_, __) => const Text(WalletConstants.errorLoadingWallet, style: TextStyle(color: Colors.white)),
         ),
        ],
       ),
      ),
      const SizedBox(height: 24),
      const Text(WalletConstants.withdraw, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
        Expanded(child: _buildQuickAmount(WalletConstants.quickAmount100)),
        const SizedBox(width: 8),
        Expanded(child: _buildQuickAmount(WalletConstants.quickAmount500)),
        const SizedBox(width: 8),
        Expanded(child: _buildQuickAmount(WalletConstants.quickAmount1000)),
       ],
      ),
      const SizedBox(height: 24),
      const Text(WalletConstants.withdrawTo, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      bankAccountsAsync.when(
       data: (accounts) {
        if (accounts.isEmpty)
         return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
           border: Border.all(color: Colors.grey[300]!),
           borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(WalletConstants.linkBankAccount),
         );
        final items = accounts.map((acc) => '${acc[WalletConstants.bankName.toLowerCase()] ?? WalletConstants.unknown}').toList();
        selectedAccount ??= items.first;
        return DropdownButtonFormField<String>(
         initialValue: selectedAccount,
         decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          prefixIcon: const Icon(Icons.account_balance),
         ),
         items: items.map((acc) => DropdownMenuItem(value: acc, child: Text(acc))).toList(),
         onChanged: (value) => setState(() => selectedAccount = value),
        );
       },
       loading: () => const CircularProgressIndicator(),
       error: (_, __) => const Text(WalletConstants.errorLoadingWallet),
      ),
      const SizedBox(height: 32),
      AppButton(text: WalletConstants.withdraw, onPressed: () => context.pop(), icon: Icons.south_east),
     ],
    ),
   ),
  );
 }
 Widget _buildQuickAmount(String amount) {
  return OutlinedButton(onPressed: () => setState(() => amountController.text = amount.substring(1)), child: Text(amount));
 }
}