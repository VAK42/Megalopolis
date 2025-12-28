import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../constants/profileConstants.dart';
class SupportChatScreen extends ConsumerStatefulWidget {
 const SupportChatScreen({super.key});
 @override
 ConsumerState<SupportChatScreen> createState() => _SupportChatScreenState();
}
class _SupportChatScreenState extends ConsumerState<SupportChatScreen> {
 final TextEditingController messageController = TextEditingController();
 final ScrollController scrollController = ScrollController();
 final List<Map<String, dynamic>> messages = [
  {'content': ProfileConstants.hiHowCanIHelp, 'isMe': false, 'createdAt': DateTime.now().millisecondsSinceEpoch - 60000},
 ];
 @override
 void dispose() {
  messageController.dispose();
  scrollController.dispose();
  super.dispose();
 }
 void sendMessage() {
  if (messageController.text.trim().isEmpty) return;
  final text = messageController.text.trim();
  messageController.clear();
  setState(() {
   messages.add({'content': text, 'isMe': true, 'createdAt': DateTime.now().millisecondsSinceEpoch});
  });
  scrollToBottom();
  Future.delayed(const Duration(seconds: 1), () {
   if (mounted) {
    setState(() {
     messages.add({'content': ProfileConstants.happyToHelp, 'isMe': false, 'createdAt': DateTime.now().millisecondsSinceEpoch});
    });
    scrollToBottom();
   }
  });
 }
 void scrollToBottom() {
  Future.delayed(const Duration(milliseconds: 100), () {
   if (scrollController.hasClients) {
    scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
   }
  });
 }
 String formatTime(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
  final period = date.hour >= 12 ? 'PM' : 'AM';
  return '${hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $period';
 }
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: Row(
     children: [
      Container(
       padding: const EdgeInsets.all(8),
       decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
       child: const Icon(Icons.support_agent, color: AppColors.primary),
      ),
      const SizedBox(width: 12),
      Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Text(ProfileConstants.supportTeam, style: const TextStyle(fontSize: 16)),
        Text(ProfileConstants.typicallyReplies, style: const TextStyle(fontSize: 12, color: Colors.green)),
       ],
      ),
     ],
    ),
   ),
   body: Column(
    children: [
     Expanded(
      child: ListView.builder(controller: scrollController, padding: const EdgeInsets.all(16), itemCount: messages.length, itemBuilder: (context, index) => buildMessageBubble(messages[index])),
     ),
     Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)]),
      child: Row(
       children: [
        IconButton(icon: const Icon(Icons.attach_file), onPressed: () {}),
        Expanded(
         child: TextField(
          controller: messageController,
          decoration: InputDecoration(hintText: ProfileConstants.typeQuestion, border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
          onSubmitted: (_) => sendMessage(),
         ),
        ),
        const SizedBox(width: 8),
        Container(
         decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
         child: IconButton(icon: const Icon(Icons.send, color: Colors.white), onPressed: sendMessage),
        ),
       ],
      ),
     ),
    ],
   ),
  );
 }
 Widget buildMessageBubble(Map<String, dynamic> message) {
  final isMe = message['isMe'] as bool;
  final timestamp = message['createdAt'] as int;
  return Align(
   alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
   child: Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
    decoration: BoxDecoration(gradient: isMe ? AppColors.primaryGradient : null, color: isMe ? null : Colors.grey[200], borderRadius: BorderRadius.circular(16)),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Text(message['content'] as String, style: TextStyle(color: isMe ? Colors.white : Colors.black)),
      const SizedBox(height: 4),
      Text(formatTime(timestamp), style: TextStyle(fontSize: 10, color: isMe ? Colors.white70 : Colors.grey[600])),
     ],
    ),
   ),
  );
 }
}