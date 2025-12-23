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
 final List<Map<String, dynamic>> messages = [
  {'text': ProfileConstants.hiHowCanIHelp, 'isMe': false, 'time': '10:00 AM'},
  {'text': ProfileConstants.iHaveQuestion, 'isMe': true, 'time': '10:01 AM'},
  {'text': ProfileConstants.happyToHelp, 'isMe': false, 'time': '10:02 AM'},
 ];
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: Row(
     children: [
      const Icon(Icons.support_agent),
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
      child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: messages.length, itemBuilder: (context, index) => _buildMessage(messages[index])),
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
           hintText: ProfileConstants.typeQuestion,
           border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
         ),
        ),
        const SizedBox(width: 8),
        Container(
         decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
         child: IconButton(
          icon: const Icon(Icons.send, color: Colors.white),
          onPressed: () {
           if (messageController.text.isNotEmpty) {
            setState(() {
             messages.add({'text': messageController.text, 'isMe': true, 'time': ProfileConstants.now});
             messageController.clear();
            });
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
 Widget _buildMessage(Map<String, dynamic> message) {
  final isMe = message['isMe'] as bool;
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
      Text(message['text'] as String, style: TextStyle(color: isMe ? Colors.white : Colors.black)),
      const SizedBox(height: 4),
      Text(message['time'] as String, style: TextStyle(fontSize: 10, color: isMe ? Colors.white70 : Colors.grey[600])),
     ],
    ),
   ),
  );
 }
}