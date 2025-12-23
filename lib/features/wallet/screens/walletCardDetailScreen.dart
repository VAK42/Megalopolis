import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/walletProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/walletConstants.dart';
class WalletCardDetailScreen extends ConsumerWidget {
 const WalletCardDetailScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? WalletConstants.defaultUserId;
  final cardsAsync = ref.watch(walletCardsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(WalletConstants.cardDetails),
    actions: [IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})],
   ),
   body: cardsAsync.when(
    data: (cards) {
     if (cards.isEmpty) return const Center(child: Text(WalletConstants.cardNotFound));
     final card = cards.first;
     return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Container(
         padding: const EdgeInsets.all(20),
         decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Text(card['cardType']?.toString() ?? WalletConstants.creditCard, style: const TextStyle(color: Colors.white70)),
             const Icon(Icons.credit_card, color: Colors.white),
            ],
           ),
           const SizedBox(height: 24),
           Text(card['cardNumber']?.toString() ?? WalletConstants.unknown, style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 2)),
           const SizedBox(height: 16),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               const Text(WalletConstants.cardHolderName, style: TextStyle(color: Colors.white70, fontSize: 10)),
               Text(card['holderName']?.toString() ?? WalletConstants.unknown, style: const TextStyle(color: Colors.white)),
              ],
             ),
             Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               const Text(WalletConstants.expiryDate, style: TextStyle(color: Colors.white70, fontSize: 10)),
               Text(card['expiryDate']?.toString() ?? WalletConstants.unknown, style: const TextStyle(color: Colors.white)),
              ],
             ),
            ],
           ),
          ],
         ),
        ),
        const SizedBox(height: 24),
        _buildDetailRow(WalletConstants.cardNumber, card['cardNumber']?.toString() ?? WalletConstants.unknown),
        _buildDetailRow(WalletConstants.cvv, card['cvv']?.toString() ?? WalletConstants.unknown),
        _buildDetailRow(WalletConstants.expiryDate, card['expiryDate']?.toString() ?? WalletConstants.unknown),
        const SizedBox(height: 24),
        ListTile(
         leading: const Icon(Icons.ac_unit, color: Colors.blue),
         title: const Text(WalletConstants.freezeCard),
         trailing: Switch(value: false, onChanged: (value) {}),
        ),
        ListTile(leading: const Icon(Icons.edit), title: const Text(WalletConstants.editCard), onTap: () {}),
        ListTile(
         leading: const Icon(Icons.delete, color: AppColors.error),
         title: const Text(WalletConstants.deleteCard, style: TextStyle(color: AppColors.error)),
         onTap: () {},
        ),
       ],
      ),
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(WalletConstants.errorLoadingCards)),
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