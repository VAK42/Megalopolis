import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/marketingProvider.dart';
import '../../marketing/constants/marketingConstants.dart';
class MarketingLeaderboardScreen extends ConsumerWidget {
 const MarketingLeaderboardScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? '';
  final leaderboardAsync = ref.watch(leaderboardProvider);
  final userRankAsync = ref.watch(userRankProvider(userId));
  return Scaffold(
   appBar: AppBar(title: const Text(MarketingConstants.leaderboardTitle)),
   body: ListView(
    padding: const EdgeInsets.all(16),
    children: [
     userRankAsync.when(
      data: (rank) => Container(
       padding: const EdgeInsets.all(20),
       decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(16)),
       child: Column(
        children: [
         const Text(MarketingConstants.yourRankLabel, style: TextStyle(color: Colors.white70)),
         const SizedBox(height: 8),
         Text(
          '${MarketingConstants.rankPrefix}$rank',
          style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
         ),
        ],
       ),
      ),
      loading: () => Container(
       height: 120,
       decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(16)),
       child: const Center(child: CircularProgressIndicator(color: Colors.white)),
      ),
      error: (_, __) => const SizedBox(),
     ),
     const SizedBox(height: 24),
     leaderboardAsync.when(
      data: (users) => Column(
       children: users.asMap().entries.map((entry) {
        final i = entry.key;
        final user = entry.value;
        return Card(
         margin: const EdgeInsets.only(bottom: 12),
         child: ListTile(
          leading: Container(
           width: 40,
           height: 40,
           decoration: BoxDecoration(color: i < 3 ? [Colors.amber, Colors.grey, Colors.brown][i] : AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
           child: Center(
            child: Text(
             '${i + 1}',
             style: TextStyle(fontWeight: FontWeight.bold, color: i < 3 ? Colors.white : AppColors.primary),
            ),
           ),
          ),
          title: Text(user['name']?.toString() ?? '${MarketingConstants.userDefaultName}${i + 1}'),
          trailing: Text('${user['points'] ?? 0}', style: const TextStyle(fontWeight: FontWeight.bold)),
         ),
        );
       }).toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text(MarketingConstants.errorLoadingLeaderboard)),
     ),
    ],
   ),
  );
 }
}