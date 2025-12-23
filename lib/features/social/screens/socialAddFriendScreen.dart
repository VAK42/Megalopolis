import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/socialProvider.dart';
import '../constants/socialConstants.dart';
class SocialAddFriendScreen extends ConsumerStatefulWidget {
 const SocialAddFriendScreen({super.key});
 @override
 ConsumerState<SocialAddFriendScreen> createState() => _SocialAddFriendScreenState();
}
class _SocialAddFriendScreenState extends ConsumerState<SocialAddFriendScreen> {
 final searchController = TextEditingController();
 String searchQuery = '';
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final usersAsync = ref.watch(userSearchProvider(searchQuery));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(SocialConstants.addFriend),
   ),
   body: Column(
    children: [
     Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
       controller: searchController,
       decoration: InputDecoration(
        hintText: SocialConstants.searchByNameOrUsername,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
       ),
       onChanged: (value) => setState(() => searchQuery = value),
      ),
     ),
     Expanded(
      child: usersAsync.when(
       data: (users) {
        if (users.isEmpty && searchQuery.isNotEmpty) {
         return const Center(child: Text(SocialConstants.noFriends));
        }
        return ListView.builder(
         padding: const EdgeInsets.symmetric(horizontal: 16),
         itemCount: users.length,
         itemBuilder: (c, i) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
           leading: CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Text(users[i]['name']?.toString().substring(0, 1).toUpperCase() ?? 'U', style: const TextStyle(color: Colors.white)),
           ),
           title: Text(users[i]['name']?.toString() ?? SocialConstants.user),
           trailing: ElevatedButton(
            onPressed: () async {
             await ref.read(socialRepositoryProvider).addFriend(userId, users[i]['id']?.toString() ?? '');
             ref.invalidate(friendsProvider);
             if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(SocialConstants.friendAdded)));
            },
            child: const Text(SocialConstants.add),
           ),
          ),
         ),
        );
       },
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (_, __) => const Center(child: Text(SocialConstants.errorLoadingFriends)),
      ),
     ),
    ],
   ),
  );
 }
}