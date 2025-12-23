import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/walletProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/foodConstants.dart';
class FoodCheckoutPaymentScreen extends ConsumerWidget {
 const FoodCheckoutPaymentScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userIdStr = ref.watch(currentUserIdProvider);
  final userId = userIdStr ?? '1';
  final balanceAsync = ref.watch(walletBalanceProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(FoodConstants.paymentTitle),
   ),
   body: ListView(
    padding: const EdgeInsets.all(16),
    children: [
     balanceAsync.when(data: (balance) => _buildPaymentOption(context, Icons.account_balance_wallet, FoodConstants.wallet, '${FoodConstants.balance}: \$${balance.toStringAsFixed(2)}', true), loading: () => _buildPaymentOption(context, Icons.account_balance_wallet, FoodConstants.wallet, FoodConstants.loading, true), error: (_, __) => _buildPaymentOption(context, Icons.account_balance_wallet, FoodConstants.wallet, FoodConstants.errorGeneric, true)),
     _buildPaymentOption(context, Icons.credit_card, FoodConstants.creditCard, '**** **** **** 1234', false),
     _buildPaymentOption(context, Icons.payment, FoodConstants.debitCard, '**** **** **** 5678', false),
     _buildPaymentOption(context, Icons.money, FoodConstants.cashOnDelivery, FoodConstants.payWhenReceive, false),
    ],
   ),
  );
 }
 Widget _buildPaymentOption(BuildContext context, IconData icon, String title, String subtitle, bool isSelected) {
  return Card(
   margin: const EdgeInsets.only(bottom: 12),
   child: ListTile(
    leading: Icon(icon, color: isSelected ? AppColors.primary : Colors.grey, size: 32),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text(subtitle),
    trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
    onTap: () => context.pop(),
   ),
  );
 }
}