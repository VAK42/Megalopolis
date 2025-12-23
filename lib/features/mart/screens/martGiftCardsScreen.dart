import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/walletProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/martConstants.dart';
class MartGiftCardsScreen extends ConsumerWidget {
 const MartGiftCardsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final giftCardsAsync = ref.watch(giftCardsProvider(userId));
  final totalBalanceAsync = ref.watch(giftCardTotalBalanceProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(MartConstants.giftCardsTitle),
    actions: [IconButton(icon: const Icon(Icons.add), onPressed: () {})],
   ),
   body: ListView(
    padding: const EdgeInsets.all(16),
    children: [
     Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
      child: Column(
       children: [
        const Icon(Icons.card_giftcard, size: 60, color: Colors.white),
        const SizedBox(height: 16),
        const Text(
         MartConstants.myGiftCards,
         style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        totalBalanceAsync.when(
         data: (total) => Text('${MartConstants.giftCardBalance}: \$${total.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 18)),
         loading: () => const Text(MartConstants.loadingText, style: TextStyle(color: Colors.white, fontSize: 18)),
         error: (err, stack) => const Text(MartConstants.errorGeneric, style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
       ],
      ),
     ),
     const SizedBox(height: 24),
     giftCardsAsync.when(
      data: (cards) {
       if (cards.isEmpty) {
        return Center(
         child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
           children: [
            Icon(Icons.card_giftcard, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(MartConstants.noGiftCards, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(MartConstants.noGiftCards, style: TextStyle(color: Colors.grey[600])),
           ],
          ),
         ),
        );
       }
       return Column(children: cards.map((card) => _buildGiftCard(card)).toList());
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('${MartConstants.errorPrefix}$err')),
     ),
     const SizedBox(height: 16),
     OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.add),
      label: const Text(MartConstants.buyGiftCard),
      style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
     ),
    ],
   ),
  );
 }
 Widget _buildGiftCard(Map<String, dynamic> card) {
  final gradients = [AppColors.primaryGradient, AppColors.secondaryGradient, AppColors.accentGradient];
  final gradientIndex = (card['brand'] as String).hashCode % gradients.length;
  return Container(
   margin: const EdgeInsets.only(bottom: 12),
   padding: const EdgeInsets.all(16),
   decoration: BoxDecoration(gradient: gradients[gradientIndex.abs()], borderRadius: BorderRadius.circular(16)),
   child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       Text(
        card['brand'] as String,
        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
       ),
       const Icon(Icons.card_giftcard, color: Colors.white, size: 32),
      ],
     ),
     const SizedBox(height: 16),
     Text(MartConstants.giftCardBalance, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
     Text(
      '\$${(card['balance'] as num).toStringAsFixed(2)}',
      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
     ),
     const SizedBox(height: 8),
     Text(card['cardNumber'] as String, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), letterSpacing: 2)),
    ],
   ),
  );
 }
}