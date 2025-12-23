import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/walletProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/walletConstants.dart';
class WalletPayBillScreen extends ConsumerStatefulWidget {
 const WalletPayBillScreen({super.key});
 @override
 ConsumerState<WalletPayBillScreen> createState() => _WalletPayBillScreenState();
}
class _WalletPayBillScreenState extends ConsumerState<WalletPayBillScreen> {
 String? selectedBill;
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider) ?? WalletConstants.defaultUserId;
  final pendingBillsAsync = ref.watch(pendingBillsProvider(userId));
  final balanceAsync = ref.watch(walletBalanceProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(WalletConstants.payBill),
   ),
   body: ListView(
    padding: const EdgeInsets.all(16),
    children: [
     const Text(WalletConstants.upcomingBills, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     pendingBillsAsync.when(
      data: (bills) => bills.isEmpty ? const Center(child: Text(WalletConstants.noUpcomingBills)) : Column(children: bills.map((bill) => _buildBillCard(bill)).toList()),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Text(WalletConstants.errorLoadingBills),
     ),
     const SizedBox(height: 24),
     Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
      child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
        const Text(WalletConstants.balance),
        balanceAsync.when(
         data: (balance) => Text('${WalletConstants.currencySymbol}${balance.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
         loading: () => const Text(WalletConstants.loading),
         error: (_, __) => const Text(WalletConstants.errorLoadingWallet),
        ),
       ],
      ),
     ),
     const SizedBox(height: 24),
     AppButton(text: WalletConstants.payNow, onPressed: () => context.pop(), icon: Icons.payment),
    ],
   ),
  );
 }
 Widget _buildBillCard(Map<String, dynamic> bill) {
  final name = bill['name']?.toString() ?? WalletConstants.unknown;
  final amount = (bill['amount'] as num?)?.toDouble() ?? 0.0;
  final isSelected = selectedBill == name;
  return GestureDetector(
   onTap: () => setState(() => selectedBill = name),
   child: Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
     border: Border.all(color: isSelected ? AppColors.primary : Colors.grey[300]!),
     borderRadius: BorderRadius.circular(12),
     color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : null,
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
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
       ],
      ),
      Text('${WalletConstants.currencySymbol}${amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
     ],
    ),
   ),
  );
 }
}