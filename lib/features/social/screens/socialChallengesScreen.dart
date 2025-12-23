import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/socialProvider.dart';
import '../constants/socialConstants.dart';
class SocialChallengesScreen extends ConsumerWidget {
 const SocialChallengesScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
   return Scaffold(
    appBar: AppBar(
     leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
     title: const Text(SocialConstants.challenges),
    ),
    body: const Center(child: Text(SocialConstants.pleaseLoginToViewChallenges)),
   );
  }
  final challengesAsync = ref.watch(challengesProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(SocialConstants.challenges),
   ),
   body: challengesAsync.when(
    data: (challenges) {
     if (challenges.isEmpty) {
      return const Center(child: Text(SocialConstants.noActiveChallenges));
     }
     return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: challenges.length,
      itemBuilder: (context, index) {
       final challenge = challenges[index];
       final current = challenge['currentProgress'] as int? ?? 0;
       final target = challenge['target'] as int? ?? 100;
       return _buildChallenge(challenge['title'] as String? ?? SocialConstants.challenge, challenge['reward'] as String? ?? SocialConstants.reward, current, target);
      },
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(SocialConstants.errorLoadingChallenges)),
   ),
  );
 }
 Widget _buildChallenge(String title, String reward, int current, int total) => Card(
  margin: const EdgeInsets.only(bottom: 16),
  child: Padding(
   padding: const EdgeInsets.all(16),
   child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       Expanded(
        child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
       ),
       Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
        child: Text(
         reward,
         style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.accent),
        ),
       ),
      ],
     ),
     const SizedBox(height: 12),
     LinearProgressIndicator(value: current / total, backgroundColor: Colors.grey[300], valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent), minHeight: 10, borderRadius: BorderRadius.circular(5)),
     const SizedBox(height: 8),
     Text('$current / $total', style: const TextStyle(fontWeight: FontWeight.w600)),
    ],
   ),
  ),
 );
}