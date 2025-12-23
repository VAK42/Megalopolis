import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../constants/walletConstants.dart';
class WalletSendConfirmScreen extends ConsumerWidget {
 final String recipientName;
 final String recipientEmail;
 final double amount;
 const WalletSendConfirmScreen({super.key, required this.recipientName, required this.recipientEmail, required this.amount});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final fee = 0.0;
  final total = amount + fee;
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(WalletConstants.confirmTransfer),
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
       child: const Icon(Icons.person, color: Colors.white, size: 50),
      ),
      const SizedBox(height: 16),
      Text(recipientName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      Text(recipientEmail, style: const TextStyle(color: Colors.grey)),
      const SizedBox(height: 32),
      const Text(WalletConstants.transferAmount, style: TextStyle(color: Colors.grey)),
      const SizedBox(height: 8),
      Text(
       '${WalletConstants.currencySymbol}${amount.toStringAsFixed(2)}',
       style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.primary),
      ),
      const SizedBox(height: 32),
      Container(
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
       child: Column(children: [_buildInfoRow(WalletConstants.from, WalletConstants.wallet), const Divider(height: 24), _buildInfoRow(WalletConstants.to, recipientName), const Divider(height: 24), _buildInfoRow(WalletConstants.transactionFee, '${WalletConstants.currencySymbol}${fee.toStringAsFixed(2)}'), const Divider(height: 24), _buildInfoRow(WalletConstants.totalAmount, '${WalletConstants.currencySymbol}${total.toStringAsFixed(2)}', isTotal: true)]),
      ),
      const Spacer(),
      AppButton(text: WalletConstants.confirmTransfer, onPressed: () => context.go(Routes.walletSendSuccess), icon: Icons.check_circle),
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