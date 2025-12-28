import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/chatProvider.dart';
import '../../chat/constants/chatConstants.dart';
import 'package:intl/intl.dart';
class ChatConversationScreen extends ConsumerStatefulWidget {
 final String chatId;
 const ChatConversationScreen({super.key, required this.chatId});
 @override
 ConsumerState<ChatConversationScreen> createState() => _ChatConversationScreenState();
}
class _ChatConversationScreenState extends ConsumerState<ChatConversationScreen> {
 final TextEditingController messageController = TextEditingController();
 final ScrollController _scrollController = ScrollController();
 @override
 void dispose() {
  messageController.dispose();
  _scrollController.dispose();
  super.dispose();
 }
 String _formatTime(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return DateFormat('h:mm a').format(date);
 }
 @override
 Widget build(BuildContext context) {
  final userAsync = ref.watch(authProvider);
  final userId = userAsync.value?.id.toString() ?? '';
  final notifier = ref.read(chatProvider(userId).notifier);
  final chatDetailsAsync = ref.watch(chatDetailsProvider(widget.chatId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(
     icon: const Icon(Icons.arrow_back),
     onPressed: () => context.pop(),
    ),
    title: chatDetailsAsync.when(
     data: (chat) {
      final participants = (chat?['participants'] as String?)?.split(',') ?? [];
      final otherParticipantId = participants.firstWhere((p) => p != userId, orElse: () => participants.isNotEmpty ? participants.first : '');
      return _ChatAppBarTitle(otherUserId: otherParticipantId);
     },
     loading: () => const Text(ChatConstants.loading),
     error: (_, __) => const Text(ChatConstants.defaultChatTitle),
    ),
    actions: [
     IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
     IconButton(icon: const Icon(Icons.phone), onPressed: () {}),
    ],
   ),
   body: Column(
    children: [
     Expanded(
      child: FutureBuilder<List<Message>>(
       future: notifier.getMessages(widget.chatId),
       builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
         return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
         return Center(child: Text('${ChatConstants.errorGeneric}: ${snapshot.error}'));
        }
        final messages = snapshot.data ?? [];
        if (messages.isEmpty) {
         return const Center(child: Text(ChatConstants.noMessages));
        }
        return ListView.builder(
         controller: _scrollController,
         padding: const EdgeInsets.all(16),
         itemCount: messages.length,
         itemBuilder: (context, index) {
          final message = messages[index];
          return _buildMessage(message, message.senderId == userId);
         },
        );
       },
      ),
     ),
     Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
       color: Colors.white,
       boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)],
      ),
      child: Row(
       children: [
        IconButton(icon: const Icon(Icons.emoji_emotions_outlined), onPressed: () {}),
        IconButton(icon: const Icon(Icons.attach_file), onPressed: () {}),
        Expanded(
         child: TextField(
          controller: messageController,
          decoration: InputDecoration(
           hintText: ChatConstants.typeMessage,
           border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
         ),
        ),
        const SizedBox(width: 8),
        Container(
         decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
         child: IconButton(
          icon: const Icon(Icons.send, color: Colors.white),
          onPressed: () async {
           if (messageController.text.isNotEmpty) {
            final content = messageController.text;
            messageController.clear();
            await notifier.sendMessage(widget.chatId, content);
            setState(() {});
           }
          },
         ),
        ),
       ],
      ),
     ),
    ],
   ),
  );
 }
 Future<void> _showDeleteDialog(Message message) async {
  final userAsync = ref.read(authProvider);
  final userId = userAsync.value?.id.toString() ?? '';
  final notifier = ref.read(chatProvider(userId).notifier);
  final confirmed = await showDialog<bool>(
   context: context,
   builder: (context) => AlertDialog(
    title: const Text(ChatConstants.deleteMessageTitle),
    content: const Text(ChatConstants.deleteMessageConfirm),
    actions: [
     TextButton(onPressed: () => Navigator.pop(context, false), child: const Text(ChatConstants.cancelButton)),
     ElevatedButton(
      onPressed: () => Navigator.pop(context, true),
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
      child: const Text(ChatConstants.deleteButton),
     ),
    ],
   ),
  );
  if (confirmed == true) {
   await notifier.deleteMessage(message.id);
   if (mounted) {
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(ChatConstants.messageDeleted)));
   }
  }
 }
 Widget _buildMessage(Message message, bool isMe) {
  return GestureDetector(
   onLongPress: isMe ? () => _showDeleteDialog(message) : null,
   child: Align(
    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
     margin: const EdgeInsets.only(bottom: 12),
     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
     constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
     decoration: BoxDecoration(color: isMe ? AppColors.primary : Colors.grey.shade200, borderRadius: BorderRadius.circular(16)),
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Text(message.content, style: TextStyle(color: isMe ? Colors.white : Colors.black)),
       const SizedBox(height: 4),
       Text(_formatTime(message.createdAt), style: TextStyle(fontSize: 10, color: isMe ? Colors.white70 : Colors.grey.shade600)),
      ],
     ),
    ),
   ),
  );
 }
}
class _ChatAppBarTitle extends ConsumerWidget {
 final String otherUserId;
 const _ChatAppBarTitle({required this.otherUserId});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  if (otherUserId.isEmpty) {
   return const Text(ChatConstants.defaultChatTitle);
  }
  final userAsync = ref.watch(userByIdProvider(otherUserId));
  return userAsync.when(
   data: (user) {
    final name = user?['name'] as String? ?? ChatConstants.defaultChatTitle;
    final avatar = user?['avatar'] as String?;
    final hasAvatar = avatar != null && avatar.isNotEmpty;
    return Row(
     children: [
      Container(
       width: 40,
       height: 40,
       decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        image: hasAvatar ? DecorationImage(image: NetworkImage(avatar), fit: BoxFit.cover) : null,
       ),
       child: !hasAvatar ? const Icon(Icons.person, color: Colors.white, size: 20) : null,
      ),
      const SizedBox(width: 12),
      Expanded(child: Text(name, style: const TextStyle(fontSize: 16))),
     ],
    );
   },
   loading: () => const Text(ChatConstants.loading),
   error: (_, __) => const Text(ChatConstants.defaultChatTitle),
  );
 }
}