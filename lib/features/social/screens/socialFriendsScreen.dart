import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/socialProvider.dart';
import '../../../providers/authProvider.dart';
import '../../../shared/widgets/sharedBottomNav.dart';
import '../constants/socialConstants.dart';
class SocialFriendsScreen extends ConsumerWidget {
 const SocialFriendsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final friendsAsync = ref.watch(friendsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.home), onPressed: () => context.go(Routes.superDashboard)),
    title: const Text(SocialConstants.friends),
    actions: [IconButton(icon: const Icon(Icons.person_add), onPressed: () => context.push(Routes.socialAddFriend))],
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      GridView.count(
       shrinkWrap: true,
       physics: const NeverScrollableScrollPhysics(),
       crossAxisCount: 4,
       mainAxisSpacing: 12,
       crossAxisSpacing: 12,
       childAspectRatio: 0.85,
       children: [
        _buildQuickAction(context, SocialConstants.friendActivity, Icons.rss_feed, () => context.push(Routes.socialActivity)),
        _buildQuickAction(context, SocialConstants.challenges, Icons.emoji_events, () => context.push(Routes.socialChallenges)),
        _buildQuickAction(context, SocialConstants.sendGift, Icons.card_giftcard, () => context.push(Routes.socialGift)),
        _buildQuickAction(context, SocialConstants.splitExpense, Icons.call_split, () => context.push(Routes.socialSplit)),
        _buildQuickAction(context, SocialConstants.shareLocation, Icons.location_on, () => context.push(Routes.socialLocation)),
        _buildQuickAction(context, SocialConstants.addFriend, Icons.person_add, () => context.push(Routes.socialAddFriend)),
       ],
      ),
      const SizedBox(height: 24),
      Text(SocialConstants.friends, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      friendsAsync.when(
       data: (friends) {
        if (friends.isEmpty) {
         return Container(
          padding: const EdgeInsets.all(32),
          child: const Center(child: Text(SocialConstants.noFriends)),
         );
        }
        return ListView.builder(
         shrinkWrap: true,
         physics: const NeverScrollableScrollPhysics(),
         itemCount: friends.length,
          itemBuilder: (c, i) {
           final avatar = friends[i]['avatar']?.toString();
           return Card(
           margin: const EdgeInsets.only(bottom: 12),
           child: ListTile(
            leading: CircleAvatar(
             backgroundColor: AppColors.primary,
             backgroundImage: avatar != null && avatar.isNotEmpty ? NetworkImage(avatar) : null,
             child: avatar == null || avatar.isEmpty ? Text(friends[i]['name']?.toString().substring(0, 1).toUpperCase() ?? 'U', style: const TextStyle(color: Colors.white)) : null,
            ),
           title: Text(friends[i]['name']?.toString() ?? SocialConstants.user),
           subtitle: Text(_toTitleCase(friends[i]['status']?.toString() ?? SocialConstants.online)),
           trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
             IconButton(icon: const Icon(Icons.message), onPressed: () => context.push('/chat/chat${userId}${friends[i]['id']}')),
             IconButton(
              icon: const Icon(Icons.person_remove, color: Colors.red),
              onPressed: () async {
               await ref.read(socialRepositoryProvider).removeFriend(userId, friends[i]['id']?.toString() ?? '');
               ref.invalidate(friendsProvider);
               if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(SocialConstants.friendRemoved)));
              },
             ),
            ],
           ),
          ),
         );
        },
       );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text(SocialConstants.errorLoadingFriends)),
     ),
     ],
    ),
   ),
   bottomNavigationBar: const SharedBottomNavBar(),
  );
 }
 Widget _buildQuickAction(BuildContext context, String title, IconData icon, VoidCallback onTap) {
  return GestureDetector(
   onTap: onTap,
   child: Container(
    decoration: BoxDecoration(
     color: Colors.white,
     borderRadius: BorderRadius.circular(12),
     boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
    ),
    child: Column(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
      Icon(icon, size: 24, color: AppColors.primary),
      const SizedBox(height: 4),
      Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
     ],
    ),
   ),
  );
 }
 String _toTitleCase(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
 }
}