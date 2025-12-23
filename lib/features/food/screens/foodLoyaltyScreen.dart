import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/foodProvider.dart';
import '../constants/foodConstants.dart';
final loyaltyStatusProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
 final repository = ref.watch(foodRepositoryProvider);
 final orders = await repository.getOrders(userId);
 final totalSpent = orders.fold<double>(0, (sum, order) => sum + ((order['total'] as num?)?.toDouble() ?? 0));
 final points = (totalSpent / 10).floor();
 String tier = FoodConstants.bronze;
 int nextTier = 500;
 if (points >= 2000) {
  tier = FoodConstants.platinum;
  nextTier = 0;
 } else if (points >= 1000) {
  tier = FoodConstants.gold;
  nextTier = 2000;
 } else if (points >= 500) {
  tier = FoodConstants.silver;
  nextTier = 1000;
 }
 return {'tier': tier, 'points': points, 'nextTier': nextTier, 'progress': nextTier > 0 ? points / nextTier : 1.0, 'pointsToNext': nextTier > points ? nextTier - points : 0};
});
class FoodLoyaltyScreen extends ConsumerWidget {
 const FoodLoyaltyScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userIdStr = ref.watch(currentUserIdProvider);
  final userId = userIdStr ?? '1';
  final loyaltyAsync = ref.watch(loyaltyStatusProvider(userId));
  final rewardsAsync = ref.watch(foodLoyaltyRewardsProvider);
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(FoodConstants.loyaltyTitle),
   ),
   body: loyaltyAsync.when(
    data: (loyalty) => SingleChildScrollView(
     padding: const EdgeInsets.all(16),
     child: Column(
      children: [
       Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
        child: Column(
         children: [
          Text(
           '${loyalty['tier']} Member',
           style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
           '${loyalty['points']} ${FoodConstants.points}',
           style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(value: (loyalty['progress'] as num).toDouble().clamp(0.0, 1.0), backgroundColor: Colors.white.withValues(alpha: 0.3), valueColor: const AlwaysStoppedAnimation<Color>(Colors.white), minHeight: 8, borderRadius: BorderRadius.circular(4)),
          const SizedBox(height: 8),
          Text(loyalty['nextTier'] > 0 ? '${loyalty['pointsToNext']} More Points To ${_nextTierName(loyalty['tier'])}' : 'You Have Reached The Highest Tier!', style: const TextStyle(color: Colors.white70, fontSize: 12)),
         ],
        ),
       ),
       const SizedBox(height: 24),
       Align(
        alignment: Alignment.centerLeft,
        child: Text(FoodConstants.redeemPoints, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
       ),
       const SizedBox(height: 12),
       rewardsAsync.when(
        data: (rewards) => Column(
         children: rewards
           .map(
            (reward) => Card(
             margin: const EdgeInsets.only(bottom: 12),
             child: ListTile(
              leading: const Icon(Icons.card_giftcard, color: AppColors.primary, size: 32),
              title: Text(reward['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${reward['points']} ${FoodConstants.points}'),
              trailing: ElevatedButton(
               onPressed: (loyalty['points'] as int) >= (reward['points'] as int)
                 ? () {
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${reward['name']} Redeemed!')));
                  }
                 : null,
               child: const Text(FoodConstants.redeem),
              ),
             ),
            ),
           )
           .toList(),
        ),
        loading: () => const CircularProgressIndicator(),
        error: (_, __) => const Text(FoodConstants.errorLoadingRewards),
       ),
      ],
     ),
    ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(child: Text('${FoodConstants.errorPrefix}$e')),
   ),
  );
 }
 String _nextTierName(String current) {
  switch (current) {
   case 'Bronze':
    return FoodConstants.silver;
   case 'Silver':
    return FoodConstants.gold;
   case 'Gold':
    return FoodConstants.platinum;
   default:
    return FoodConstants.next;
  }
 }
}