import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/chatProvider.dart';
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
      : ListView.builder(itemCount: chats.length, itemBuilder: (context, index) => _buildChatItem(context, chats[index])),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(ChatConstants.errorLoading)),
   ),
   floatingActionButton: FloatingActionButton(onPressed: () => context.go(Routes.contacts), child: const Icon(Icons.add)),
  );
 }
 Widget _buildChatItem(BuildContext context, Chat chat) {
  final time = (chat.lastMessageAt != null && chat.lastMessageAt! > 0) ? _formatTime(DateTime.fromMillisecondsSinceEpoch(chat.lastMessageAt!)) : '';
  return ListTile(
   leading: Container(
    width: 50,
    height: 50,
    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
    child: const Icon(Icons.person, color: Colors.white, size: 25),
   ),
   title: Text(chat.participants.length > 1 ? ChatConstants.defaultChatTitle : ChatConstants.defaultConversationTitle, style: const TextStyle(fontWeight: FontWeight.w600)),
   subtitle: Text(chat.lastMessage ?? ChatConstants.noLastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
   trailing: Text(time, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
   onTap: () => context.go('${Routes.chatConversation}/${chat.id}'),
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