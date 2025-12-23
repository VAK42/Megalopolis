import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/socialProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/socialConstants.dart';
class SocialFriendsScreen extends ConsumerWidget {
 const SocialFriendsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final friendsAsync = ref.watch(friendsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(SocialConstants.friends),
    actions: [IconButton(icon: const Icon(Icons.person_add), onPressed: () {})],
   ),
   body: friendsAsync.when(
    data: (friends) {
     if (friends.isEmpty) {
      return const Center(child: Text(SocialConstants.noFriends));
     }
     return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: friends.length,
      itemBuilder: (c, i) => Card(
       margin: const EdgeInsets.only(bottom: 12),
       child: ListTile(
        leading: CircleAvatar(
         backgroundColor: AppColors.primary,
         child: Text(friends[i]['name']?.toString().substring(0, 1).toUpperCase() ?? 'U', style: const TextStyle(color: Colors.white)),
        ),
        title: Text(friends[i]['name']?.toString() ?? SocialConstants.user),
        subtitle: Text(friends[i]['status']?.toString() ?? SocialConstants.online),
        trailing: Row(
         mainAxisSize: MainAxisSize.min,
         children: [
          IconButton(icon: const Icon(Icons.message), onPressed: () {}),
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
      ),
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(SocialConstants.errorLoadingFriends)),
   ),
  );
 }
}