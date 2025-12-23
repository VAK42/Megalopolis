import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/profileProvider.dart';
import '../../ride/constants/rideConstants.dart';
class RidePaymentMethodScreen extends ConsumerWidget {
 const RidePaymentMethodScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final methodsAsync = ref.watch(paymentMethodsProvider(userId));
  final statsAsync = ref.watch(userStatsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(RideConstants.paymentTitle),
   ),
   body: methodsAsync.when(
    data: (methods) {
     final walletBalance = statsAsync.valueOrNull?['walletBalance'] ?? 0.0;
     return ListView(
      padding: const EdgeInsets.all(16),
      children: [
       _buildPaymentOption(context, Icons.money, RideConstants.cash, 'Pay with cash', true),
       ...methods.map((m) => _buildPaymentOption(context, Icons.credit_card, m['cardType'] ?? RideConstants.card, '${m['cardType'] ?? 'Card'} ${m['lastFour'] ?? '****'}', false)),
       _buildPaymentOption(context, Icons.account_balance_wallet, RideConstants.wallet, 'Balance: \$${walletBalance.toStringAsFixed(2)}', false),
       const SizedBox(height: 16),
       OutlinedButton.icon(
        onPressed: () => context.go(Routes.rideAddPayment),
        icon: const Icon(Icons.add),
        label: const Text(RideConstants.addPaymentMethodTitle),
        style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
       ),
      ],
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(RideConstants.errorGeneric)),
   ),
  );
 }
 Widget _buildPaymentOption(BuildContext context, IconData icon, String title, String subtitle, bool isSelected) {
  return Card(
   margin: const EdgeInsets.only(bottom: 12),
   child: ListTile(
    leading: Container(
     padding: const EdgeInsets.all(10),
     decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
     child: Icon(icon, color: AppColors.primary),
    ),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text(subtitle),
    trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.success) : const Icon(Icons.circle_outlined, color: Colors.grey),
    onTap: () {},
   ),
  );
 }
}