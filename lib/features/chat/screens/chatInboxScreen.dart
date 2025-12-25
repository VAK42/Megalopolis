import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/chatProvider.dart';
import '../../../shared/widgets/sharedBottomNav.dart';
import '../../chat/constants/chatConstants.dart';
class ChatInboxScreen extends ConsumerWidget {
 const ChatInboxScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userAsync = ref.watch(authProvider);
  final userId = userAsync.value?.id.toString() ?? '';
  final chatsAsync = ref.watch(chatProvider(userId));
  return Scaffold(
   appBar: AppBar(
    title: const Text(ChatConstants.inboxTitle),
    actions: [
     IconButton(icon: const Icon(Icons.search), onPressed: () => context.go(Routes.contacts)),
     IconButton(icon: const Icon(Icons.contacts), onPressed: () => context.go(Routes.contacts)),
    ],
   ),
   body: chatsAsync.when(
    data: (chats) => chats.isEmpty
      ? const Center(
        child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(ChatConstants.noMessages, style: TextStyle(color: Colors.grey)),
         ],
        ),
       )
      : ListView.builder(itemCount: chats.length, itemBuilder: (context, index) => _ChatItem(chat: chats[index], currentUserId: userId)),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(ChatConstants.errorLoading)),
   ),
   floatingActionButton: FloatingActionButton(onPressed: () => context.go(Routes.contacts), child: const Icon(Icons.add)),
   bottomNavigationBar: const SharedBottomNavBar(),
  );
 }
}
class _ChatItem extends ConsumerWidget {
 final Chat chat;
 final String currentUserId;
 const _ChatItem({required this.chat, required this.currentUserId});
 void _showDeleteDialog(BuildContext context, WidgetRef ref) {
  showDialog(
   context: context,
   builder: (ctx) => AlertDialog(
    title: const Text(ChatConstants.deleteChatTitle),
    content: const Text(ChatConstants.deleteChatConfirm),
    actions: [
     TextButton(onPressed: () => Navigator.pop(ctx), child: const Text(ChatConstants.cancelButton)),
     ElevatedButton(
      onPressed: () async {
       Navigator.pop(ctx);
       final notifier = ref.read(chatProvider(currentUserId).notifier);
       await notifier.deleteChat(chat.id);
       if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(ChatConstants.chatDeleted)));
       }
      },
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
      child: const Text(ChatConstants.deleteButton),
     ),
    ],
   ),
  );
 }
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final otherParticipantId = chat.participants.firstWhere((p) => p != currentUserId, orElse: () => chat.participants.first);
  final userAsync = ref.watch(userByIdProvider(otherParticipantId));
  final time = (chat.lastMessageAt != null && chat.lastMessageAt! > 0) ? _formatTime(DateTime.fromMillisecondsSinceEpoch(chat.lastMessageAt!)) : '';
  return userAsync.when(
   data: (user) => ListTile(
    leading: Container(
     width: 50,
     height: 50,
     decoration: BoxDecoration(
      color: AppColors.primary,
      shape: BoxShape.circle,
      image: user?['avatar'] != null && (user!['avatar'] as String).isNotEmpty
        ? DecorationImage(image: NetworkImage(user['avatar'] as String), fit: BoxFit.cover)
        : null,
     ),
     child: user?['avatar'] == null || (user!['avatar'] as String).isEmpty
       ? const Icon(Icons.person, color: Colors.white, size: 25)
       : null,
    ),
    title: Text(user?['name'] ?? ChatConstants.defaultChatTitle, style: const TextStyle(fontWeight: FontWeight.w600)),
    subtitle: Text(chat.lastMessage ?? ChatConstants.noLastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
    trailing: Text(time, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
    onTap: () => context.go('/chat/${chat.id}'),
    onLongPress: () => _showDeleteDialog(context, ref),
   ),
   loading: () => ListTile(
    leading: Container(
     width: 50,
     height: 50,
     decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
     child: const Icon(Icons.person, color: Colors.white, size: 25),
    ),
    title: const Text(ChatConstants.loading),
    subtitle: Text(chat.lastMessage ?? ChatConstants.noLastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
    trailing: Text(time, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
   ),
   error: (_, __) => ListTile(
    leading: Container(
     width: 50,
     height: 50,
     decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
     child: const Icon(Icons.person, color: Colors.white, size: 25),
    ),
    title: const Text(ChatConstants.defaultChatTitle),
    subtitle: Text(chat.lastMessage ?? ChatConstants.noLastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
    trailing: Text(time, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
    onTap: () => context.go('/chat/${chat.id}'),
    onLongPress: () => _showDeleteDialog(context, ref),
   ),
  );
 }
 String _formatTime(DateTime dateTime) {
  final now = DateTime.now();
  final diff = now.difference(dateTime);
  if (diff.inMinutes < 60) {
   return '${diff.inMinutes}${ChatConstants.suffixMinAgo}';
  } else if (diff.inHours < 24) {
   return '${diff.inHours}${ChatConstants.suffixHourAgo}';
  } else {
   return '${diff.inDays}${ChatConstants.suffixDayAgo}';
  }
 }
}