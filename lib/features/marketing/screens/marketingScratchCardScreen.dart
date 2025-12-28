import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/marketingProvider.dart';
import '../../marketing/constants/marketingConstants.dart';
class MarketingScratchCardScreen extends ConsumerStatefulWidget {
 const MarketingScratchCardScreen({super.key});
 @override
 ConsumerState<MarketingScratchCardScreen> createState() => _MarketingScratchCardScreenState();
}
class _MarketingScratchCardScreenState extends ConsumerState<MarketingScratchCardScreen> {
 bool isScratched = false;
 bool isClaimed = false;
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider) ?? '';
  final cardAsync = ref.watch(scratchCardProvider(userId));
  return Scaffold(
   appBar: AppBar(title: const Text(MarketingConstants.scratchCardTitle)),
   body: cardAsync.when(
    data: (card) {
     final reward = (card['reward'] as num?)?.toInt() ?? 0;
     final cardId = card['id']?.toString();
     final cardAlreadyScratched = card['isScratched'] == true || card['isScratched'] == 1;
     final canScratch = cardId != null && !isScratched && !cardAlreadyScratched;
     return Center(
      child: Padding(
       padding: const EdgeInsets.all(24),
       child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         GestureDetector(
          onTap: canScratch
            ? () {
              setState(() => isScratched = true);
              ref.read(scratchCardProvider(userId).notifier).scratchCard(cardId);
             }
            : null,
          onPanUpdate: canScratch
            ? (details) {
              setState(() => isScratched = true);
              ref.read(scratchCardProvider(userId).notifier).scratchCard(cardId);
             }
            : null,
          child: Container(
           width: 280,
           height: 200,
           decoration: BoxDecoration(
            gradient: isScratched ? null : AppColors.primaryGradient,
            color: isScratched ? AppColors.success.withValues(alpha: 0.1) : null,
            borderRadius: BorderRadius.circular(20),
            border: isScratched ? Border.all(color: AppColors.success, width: 3) : null,
           ),
           child: isScratched
             ? Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                const Icon(Icons.celebration, size: 60, color: AppColors.success),
                const SizedBox(height: 16),
                Text(
                 '\$$reward',
                 style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.success),
                ),
                const Text(MarketingConstants.scratchCardWon, style: TextStyle(color: AppColors.success)),
               ],
              )
             : Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                const Icon(Icons.card_giftcard, size: 60, color: Colors.white),
                const SizedBox(height: 16),
                const Text(
                 MarketingConstants.scratchCardScratchToWin,
                 style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
               ],
              ),
          ),
         ),
         const SizedBox(height: 32),
         if (isScratched && !isClaimed && cardId != null)
          ElevatedButton(
           onPressed: () async {
            await ref.read(scratchCardProvider(userId).notifier).claimReward(cardId);
            setState(() => isClaimed = true);
            if (context.mounted) {
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${MarketingConstants.scratchCardClaimed} \$$reward!')));
            }
           },
           style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
           child: const Text(MarketingConstants.scratchCardClaimButton),
          ),
         if (isClaimed)
          ElevatedButton(
           onPressed: () async {
            if (cardId != null) {
             await ref.read(scratchCardProvider(userId).notifier).deleteCard(cardId);
            }
            ref.invalidate(scratchCardProvider(userId));
            setState(() {
             isScratched = false;
             isClaimed = false;
            });
           },
           style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
           child: const Text(MarketingConstants.scratchCardNewCard),
          ),
        ],
       ),
      ),
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(child: Text('${MarketingConstants.errorPrefix}$e')),
   ),
  );
 }
}