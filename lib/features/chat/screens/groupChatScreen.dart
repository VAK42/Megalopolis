import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/chatProvider.dart';
import '../../chat/constants/chatConstants.dart';
class GroupChatScreen extends ConsumerStatefulWidget {
 final String chatId;
 const GroupChatScreen({super.key, required this.chatId});
 @override
 ConsumerState<GroupChatScreen> createState() => _GroupChatScreenState();
}
class _GroupChatScreenState extends ConsumerState<GroupChatScreen> {
 final TextEditingController messageController = TextEditingController();
 @override
 void dispose() {
  messageController.dispose();
  super.dispose();
 }
 @override
 Widget build(BuildContext context) {
  final userAsync = ref.watch(authProvider);
  final userId = userAsync.value?.id.toString() ?? '';
  final notifier = ref.read(chatProvider(userId).notifier);
  final chatDetailsAsync = ref.watch(chatDetailsProvider(widget.chatId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: chatDetailsAsync.when(
     data: (chat) {
      final title = chat?['title'] ?? ChatConstants.groupChatDefaultTitle;
      final participants = (chat?['participants'] as String?)?.split(',') ?? [];
      return Row(
       children: [
        Container(
         width: 40,
         height: 40,
         decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
         child: const Icon(Icons.group, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Text(title, style: const TextStyle(fontSize: 16)),
           Text('${participants.length}${ChatConstants.textMembers}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
         ),
        ),
       ],
      );
     },
     loading: () => const Text(ChatConstants.loading),
     error: (_, __) => const Text(ChatConstants.groupChatDefaultTitle),
    ),
    actions: [
     IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
     IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
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
         return Center(child: Text('${ChatConstants.errorPrefix}${snapshot.error}'));
        }
        final messages = snapshot.data ?? [];
        if (messages.isEmpty) {
         return const Center(child: Text(ChatConstants.noGroupMessages));
        }
        return ListView.builder(
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
   child: Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
     crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
     children: [
      if (!isMe)
       Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
         message.senderId,
         style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
       ),
      Container(
       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
       constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
       decoration: BoxDecoration(color: isMe ? AppColors.primary : Colors.grey.shade200, borderRadius: BorderRadius.circular(16)),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(message.content, style: TextStyle(color: isMe ? Colors.white : Colors.black)),
         const SizedBox(height: 4),
         Text(DateTime.fromMillisecondsSinceEpoch(message.createdAt).toString(), style: TextStyle(fontSize: 10, color: isMe ? Colors.white70 : Colors.grey.shade600)),
        ],
       ),
      ),
     ],
    ),
   ),
  );
 }
}