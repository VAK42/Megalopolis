import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/walletProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/walletConstants.dart';
class WalletCardDetailScreen extends ConsumerWidget {
 final String cardId;
 const WalletCardDetailScreen({super.key, required this.cardId});
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
     final card = cards.firstWhere((c) => c['id'] == cardId, orElse: () => <String, dynamic>{});
     if (card.isEmpty) return const Center(child: Text(WalletConstants.cardNotFound));
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
             Text(card['type']?.toString().toUpperCase() ?? WalletConstants.creditCard, style: const TextStyle(color: Colors.white70)),
             const Icon(Icons.credit_card, color: Colors.white),
            ],
           ),
           const SizedBox(height: 24),
           Text(card['number']?.toString() ?? WalletConstants.unknown, style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 2)),
           const SizedBox(height: 16),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               const Text(WalletConstants.cardHolderName, style: TextStyle(color: Colors.white70, fontSize: 10)),
               Text(card['holder']?.toString() ?? WalletConstants.unknown, style: const TextStyle(color: Colors.white)),
              ],
             ),
             Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               const Text(WalletConstants.expiryDate, style: TextStyle(color: Colors.white70, fontSize: 10)),
               Text(card['expiry']?.toString() ?? WalletConstants.unknown, style: const TextStyle(color: Colors.white)),
              ],
             ),
            ],
           ),
          ],
         ),
        ),
        const SizedBox(height: 24),
        _buildDetailRow(WalletConstants.cardNumber, card['number']?.toString() ?? WalletConstants.unknown),
        _buildDetailRow(WalletConstants.cvv, card['cvv']?.toString() ?? WalletConstants.unknown),
        _buildDetailRow(WalletConstants.expiryDate, card['expiry']?.toString() ?? WalletConstants.unknown),
        const SizedBox(height: 24),
        ListTile(
         leading: const Icon(Icons.ac_unit, color: Colors.blue),
         title: const Text(WalletConstants.freezeCard),
         trailing: Switch(value: false, onChanged: (value) {}),
        ),
        ListTile(
         leading: const Icon(Icons.edit),
         title: const Text(WalletConstants.editCard),
         onTap: () => _showEditCardDialog(context, ref, userId, card),
        ),
        ListTile(
         leading: const Icon(Icons.delete, color: AppColors.error),
         title: const Text(WalletConstants.deleteCard, style: TextStyle(color: AppColors.error)),
         onTap: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text(WalletConstants.deleteCard),
                content: const Text(WalletConstants.msgConfirmDeleteCard),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text(WalletConstants.cancel)),
                  TextButton(onPressed: () => Navigator.pop(context, true), child: const Text(WalletConstants.delete, style: TextStyle(color: Colors.red))),
                ],
              ),
            );
            if (confirm == true) {
              await ref.read(walletCardsProvider(userId).notifier).removeCard(card['id']);
              if (context.mounted) context.pop();
            }
         },
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
  void _showEditCardDialog(BuildContext context, WidgetRef ref, String userId, Map<String, dynamic> card) {
    final holderController = TextEditingController(text: card['holder']);
    final expiryController = TextEditingController(text: card['expiry']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(WalletConstants.editCard),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: holderController, decoration: const InputDecoration(labelText: WalletConstants.cardHolderName)),
            TextField(controller: expiryController, decoration: const InputDecoration(labelText: WalletConstants.expiryDate)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text(WalletConstants.cancel)),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final updatedCard = {
                'holder': holderController.text,
                'expiry': expiryController.text,
              };
              await ref.read(walletCardsProvider(userId).notifier).updateCard(card['id'], updatedCard);
            },
            child: const Text(WalletConstants.save),
          ),
        ],
      ),
    );
  }
}