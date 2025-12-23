import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/walletProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/walletConstants.dart';
class WalletBillPaymentsScreen extends ConsumerWidget {
 const WalletBillPaymentsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? WalletConstants.defaultUserId;
  final billSummaryAsync = ref.watch(billSummaryProvider(userId));
  final billsAsync = ref.watch(billsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(WalletConstants.billPayments),
   ),
   body: ListView(
    padding: const EdgeInsets.all(16),
    children: [
     billSummaryAsync.when(
      data: (summary) => Row(
       children: [
        Expanded(child: _buildSummaryCard(WalletConstants.pending, summary['pending']?.toString() ?? '0', AppColors.accent)),
        const SizedBox(width: 12),
        Expanded(child: _buildSummaryCard(WalletConstants.paid, summary['paid']?.toString() ?? '0', AppColors.success)),
       ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Text(WalletConstants.errorLoadingBills),
     ),
     const SizedBox(height: 24),
     const Text(WalletConstants.recentBills, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     billsAsync.when(
      data: (bills) => bills.isEmpty ? const Center(child: Text(WalletConstants.noRecentBills)) : Column(children: bills.take(5).map((bill) => _buildBillCard(context, bill)).toList()),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Text(WalletConstants.errorLoadingBills),
     ),
    ],
   ),
  );
 }
 Widget _buildSummaryCard(String label, String value, Color color) {
  return Container(
   padding: const EdgeInsets.all(16),
   decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
   child: Column(
    children: [
     Text(
      value,
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
     ),
     const SizedBox(height: 4),
     Text(label, style: TextStyle(color: color)),
    ],
   ),
  );
 }
 Widget _buildBillCard(BuildContext context, Map<String, dynamic> bill) {
  final name = bill['name']?.toString() ?? WalletConstants.unknown;
  final amount = (bill['amount'] as num?)?.toDouble() ?? 0.0;
  final status = bill['status']?.toString() ?? WalletConstants.pending;
  return Card(
   margin: const EdgeInsets.only(bottom: 12),
   child: ListTile(
    leading: Container(
     padding: const EdgeInsets.all(10),
     decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
     child: const Icon(Icons.receipt, color: AppColors.primary),
    ),
    title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text(status),
    trailing: Text('${WalletConstants.currencySymbol}${amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
    onTap: () => context.go(Routes.walletPayBill),
   ),
  );
 }
}