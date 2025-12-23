import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/socialProvider.dart';
import '../constants/socialConstants.dart';
class SocialProfileScreen extends ConsumerWidget {
 final String? userId;
 const SocialProfileScreen({super.key, this.userId});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final currentUserId = ref.watch(currentUserIdProvider) ?? 'user1';
  final profileUserId = userId ?? currentUserId;
  final profileAsync = ref.watch(userProfileProvider(profileUserId));
  final statsAsync = ref.watch(userStatsProvider(profileUserId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(SocialConstants.profile),
   ),
   body: profileAsync.when(
    data: (profile) {
     if (profile == null) {
      return const Center(child: Text(SocialConstants.noFriends));
     }
     return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
       children: [
        CircleAvatar(
         radius: 50,
         backgroundColor: AppColors.primary,
         child: Text(profile['name']?.toString().substring(0, 1).toUpperCase() ?? 'U', style: const TextStyle(fontSize: 36, color: Colors.white)),
        ),
        const SizedBox(height: 16),
        Text(profile['name']?.toString() ?? SocialConstants.user, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(profile['email']?.toString() ?? '', style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),
        Text('${SocialConstants.joined}: ${profile['createdAt'] ?? ''}', style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 24),
        statsAsync.when(
         data: (stats) => Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildStatCard(SocialConstants.ridesCompleted, '${stats['ridesCompleted'] ?? 0}'), _buildStatCard(SocialConstants.ordersPlaced, '${stats['ordersPlaced'] ?? 0}'), _buildStatCard(SocialConstants.totalSpent, '\$${(stats['totalSpent'] ?? 0).toStringAsFixed(0)}')]),
         loading: () => const CircularProgressIndicator(),
         error: (_, __) => const SizedBox.shrink(),
        ),
        const SizedBox(height: 24),
        if (profileUserId != currentUserId)
         Row(
          children: [
           Expanded(
            child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.message), label: const Text(SocialConstants.message)),
           ),
           const SizedBox(width: 12),
           Expanded(
            child: ElevatedButton.icon(
             onPressed: () {},
             icon: const Icon(Icons.person_remove),
             label: const Text(SocialConstants.unfriend),
             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
           ),
          ],
         ),
       ],
      ),
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(SocialConstants.errorLoadingFriends)),
   ),
  );
 }
 Widget _buildStatCard(String label, String value) => Card(
  child: Padding(
   padding: const EdgeInsets.all(16),
   child: Column(
    children: [
     Text(
      value,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
     ),
     const SizedBox(height: 4),
     Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    ],
   ),
  ),
 );
}