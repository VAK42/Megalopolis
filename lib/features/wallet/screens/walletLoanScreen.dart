import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/walletProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/walletConstants.dart';
class WalletLoanScreen extends ConsumerWidget {
 const WalletLoanScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? WalletConstants.defaultUserId;
  final loanAsync = ref.watch(loanOffersProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(WalletConstants.personalLoan),
   ),
   body: loanAsync.when(
    data: (loan) {
     final amount = (loan['amount'] as num?)?.toDouble() ?? 0.0;
     final interestRate = (loan['interestRate'] as num?)?.toDouble() ?? 0.0;
     final tenure = (loan['tenure'] as num?)?.toInt() ?? 0;
     final emi = (loan['emi'] as num?)?.toDouble() ?? 0.0;
     final totalRepayment = (loan['totalRepayment'] as num?)?.toDouble() ?? amount + (amount * interestRate / 100);
     return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Container(
         padding: const EdgeInsets.all(20),
         decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
         child: Column(
          children: [
           const Text(
            WalletConstants.applyForLoan,
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
           ),
           const SizedBox(height: 16),
           Text(
            '${WalletConstants.currencySymbol}${amount.toStringAsFixed(0)}',
            style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
           ),
           const SizedBox(height: 8),
           Text('${WalletConstants.interestRate}: ${interestRate.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.white70)),
          ],
         ),
        ),
        const SizedBox(height: 24),
        const Text(WalletConstants.loan, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildDetailRow(WalletConstants.loanAmount, '${WalletConstants.currencySymbol}${amount.toStringAsFixed(0)}'),
        _buildDetailRow(WalletConstants.interestRate, '${interestRate.toStringAsFixed(1)}%'),
        _buildDetailRow(WalletConstants.tenure, '$tenure ${WalletConstants.monthly}'),
        _buildDetailRow(WalletConstants.emi, '${WalletConstants.currencySymbol}${emi.toStringAsFixed(2)}'),
        const SizedBox(height: 24),
        Container(
         padding: const EdgeInsets.all(16),
         decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue[200]!),
         ),
         child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           const Text(WalletConstants.totalRepayment),
           Text('${WalletConstants.currencySymbol}${totalRepayment.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
         ),
        ),
        const SizedBox(height: 32),
        AppButton(text: WalletConstants.applyForLoan, onPressed: () => context.pop(), icon: Icons.check),
       ],
      ),
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(WalletConstants.errorLoadingWallet)),
   ),
  );
 }
 Widget _buildDetailRow(String label, String value) {
  return Container(
   margin: const EdgeInsets.only(bottom: 12),
   padding: const EdgeInsets.all(12),
   decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
   child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
     Text(label),
     Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
    ],
   ),
  );
 }
}