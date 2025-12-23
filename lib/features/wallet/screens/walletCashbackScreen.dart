import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/walletProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/walletConstants.dart';
class WalletCashbackScreen extends ConsumerWidget {
 const WalletCashbackScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? WalletConstants.defaultUserId;
  final cashbackTotalAsync = ref.watch(cashbackTotalProvider(userId));
  final offersAsync = ref.watch(cashbackOffersProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(WalletConstants.cashbackOffers),
   ),
   body: ListView(
    padding: const EdgeInsets.all(16),
    children: [
     Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
      child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
        Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
          const Text(WalletConstants.totalCashback, style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          cashbackTotalAsync.when(
           data: (total) => Text(
            '${WalletConstants.currencySymbol}${total.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
           ),
           loading: () => const Text(
            WalletConstants.loading,
            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
           ),
           error: (_, __) => const Text(
            WalletConstants.errorText,
            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
           ),
          ),
         ],
        ),
        const Icon(Icons.account_balance_wallet, size: 60, color: Colors.white),
       ],
      ),
     ),
     const SizedBox(height: 24),
     const Text(WalletConstants.cashback, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     offersAsync.when(
      data: (offers) => Column(children: offers.map((offer) => _buildCashbackCard(offer)).toList()),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Text(WalletConstants.errorLoadingWallet),
     ),
    ],
   ),
  );
 }
 Widget _buildCashbackCard(Map<String, dynamic> offer) {
  final name = offer['name'] as String? ?? WalletConstants.cashback;
  final percent = offer['percent']?.toString() ?? '0%';
  final maxAmount = offer['maxAmount']?.toString() ?? WalletConstants.unknown;
  final status = offer['status'] as String? ?? WalletConstants.active;
  return Card(
   margin: const EdgeInsets.only(bottom: 12),
   child: ListTile(
    leading: Container(
     padding: const EdgeInsets.all(10),
     decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
     child: const Icon(Icons.local_offer, color: AppColors.primary),
    ),
    title: Text('$percent $name', style: const TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text('${WalletConstants.currencySymbol}$maxAmount'),
    trailing: Container(
     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
     decoration: BoxDecoration(color: status == WalletConstants.active ? AppColors.success.withValues(alpha: 0.2) : AppColors.error.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
     child: Text(status == WalletConstants.active ? WalletConstants.active : WalletConstants.pending, style: TextStyle(color: status == WalletConstants.active ? AppColors.success : AppColors.error, fontSize: 10)),
    ),
   ),
  );
 }
}