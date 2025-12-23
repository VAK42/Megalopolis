import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../constants/walletConstants.dart';
class WalletSendSuccessScreen extends ConsumerWidget {
 final String recipientName;
 final double amount;
 final String transactionId;
 const WalletSendSuccessScreen({super.key, required this.recipientName, required this.amount, required this.transactionId});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final now = DateTime.now();
  final dateStr = '${now.day}/${now.month}/${now.year}';
  return Scaffold(
   body: SafeArea(
    child: Padding(
     padding: const EdgeInsets.all(24),
     child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.2), shape: BoxShape.circle),
        child: const Icon(Icons.check_circle, size: 60, color: AppColors.success),
       ),
       const SizedBox(height: 32),
       const Text(
        WalletConstants.sendSuccessful,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
       ),
       const SizedBox(height: 12),
       Text(
        WalletConstants.send,
        style: TextStyle(color: Colors.grey[600]),
        textAlign: TextAlign.center,
       ),
       const SizedBox(height: 32),
       Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(16)),
        child: Column(
         children: [
          Text(
           '${WalletConstants.currencySymbol}${amount.toStringAsFixed(2)}',
           style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          _buildDetailRow(WalletConstants.to, recipientName),
          const SizedBox(height: 8),
          _buildDetailRow(WalletConstants.transactionId, transactionId),
          const SizedBox(height: 8),
          _buildDetailRow(WalletConstants.date, dateStr),
         ],
        ),
       ),
       const Spacer(),
       AppButton(text: WalletConstants.share, onPressed: () {}, isOutline: true, icon: Icons.share),
       const SizedBox(height: 12),
       AppButton(text: WalletConstants.wallet, onPressed: () => context.go(Routes.walletHome), icon: Icons.wallet),
      ],
     ),
    ),
   ),
  );
 }
 Widget _buildDetailRow(String label, String value) {
  return Row(
   mainAxisAlignment: MainAxisAlignment.spaceBetween,
   children: [
    Text(label, style: TextStyle(color: Colors.grey[600])),
    Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
   ],
  );
 }
}