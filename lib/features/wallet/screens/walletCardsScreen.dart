import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/walletProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/walletConstants.dart';
class WalletCardsScreen extends ConsumerWidget {
 const WalletCardsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? WalletConstants.defaultUserId;
  final cardsAsync = ref.watch(walletCardsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(WalletConstants.myCards),
    actions: [IconButton(icon: const Icon(Icons.add), onPressed: () => context.go(Routes.walletAddCard))],
   ),
   body: cardsAsync.when(
    data: (cards) => cards.isEmpty
      ? Center(
        child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
          const Icon(Icons.credit_card_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(WalletConstants.noTransactions),
         ],
        ),
       )
      : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: cards.length,
        itemBuilder: (context, index) {
         final card = cards[index];
         return GestureDetector(
          onTap: () => context.go(Routes.walletCardDetail),
          child: Container(
           margin: const EdgeInsets.only(bottom: 16),
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
         );
        },
       ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(WalletConstants.errorLoadingCards)),
   ),
  );
 }
}