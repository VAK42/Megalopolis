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
     const Text(WalletConstants.bills, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     billsAsync.when(
      data: (bills) => bills.isEmpty ? const Center(child: Text(WalletConstants.noRecentBills)) : Column(children: bills.take(10).map((bill) => _buildBillCard(context, ref, bill, userId)).toList()),
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
     Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
     const SizedBox(height: 4),
     Text(label, style: TextStyle(color: color)),
    ],
   ),
  );
 }
 Widget _buildBillCard(BuildContext context, WidgetRef ref, Map<String, dynamic> bill, String userId) {
  final name = bill['provider']?.toString() ?? WalletConstants.unknown;
  final amount = (bill['amount'] as num?)?.toDouble() ?? 0.0;
  final status = bill['status']?.toString() ?? WalletConstants.pending;
  final isPaid = status.toLowerCase() == 'paid';
  return Card(
   margin: const EdgeInsets.only(bottom: 12),
   child: ListTile(
    leading: Container(
     padding: const EdgeInsets.all(10),
     decoration: BoxDecoration(color: (isPaid ? AppColors.success : AppColors.accent).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
     child: Icon(isPaid ? Icons.check_circle : Icons.receipt, color: isPaid ? AppColors.success : AppColors.accent),
    ),
    title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text(status.isNotEmpty ? '${status[0].toUpperCase()}${status.substring(1)}' : status, style: TextStyle(color: isPaid ? AppColors.success : AppColors.accent)),
    trailing: Text('${WalletConstants.currencySymbol}${amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
    onTap: () {
     if (isPaid) {
      _showReceiptDialog(context, bill);
     } else {
      context.go(Routes.walletPayBill, extra: {
       'provider': name,
       'amount': amount,
       'billId': bill['id']?.toString() ?? '',
      });
     }
    },
   ),
  );
 }
 void _showReceiptDialog(BuildContext context, Map<String, dynamic> bill) {
  final name = bill['provider']?.toString() ?? WalletConstants.unknown;
  final amount = (bill['amount'] as num?)?.toDouble() ?? 0.0;
  final billId = bill['id']?.toString() ?? '';
  showDialog(
   context: context,
   builder: (context) => AlertDialog(
    title: Row(
     children: [
      const Icon(Icons.receipt_long, color: AppColors.success),
      const SizedBox(width: 8),
      const Text(WalletConstants.receipt),
     ],
    ),
    content: Column(
     mainAxisSize: MainAxisSize.min,
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      _buildReceiptRow(WalletConstants.provider, name),
      const Divider(),
      _buildReceiptRow(WalletConstants.amount, '${WalletConstants.currencySymbol}${amount.toStringAsFixed(2)}'),
      const Divider(),
      _buildReceiptRow(WalletConstants.status, WalletConstants.paid),
      const Divider(),
      _buildReceiptRow(WalletConstants.reference, billId),
     ],
    ),
    actions: [
     TextButton(onPressed: () => Navigator.pop(context), child: const Text(WalletConstants.close)),
    ],
   ),
  );
 }
 Widget _buildReceiptRow(String label, String value) {
  return Padding(
   padding: const EdgeInsets.symmetric(vertical: 4),
   child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
     Text(label, style: const TextStyle(color: Colors.grey)),
     Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
    ],
   ),
  );
 }
}