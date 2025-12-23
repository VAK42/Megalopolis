import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../constants/foodConstants.dart';
class FoodMessageDriverScreen extends ConsumerStatefulWidget {
 final String orderId;
 const FoodMessageDriverScreen({super.key, required this.orderId});
 @override
 ConsumerState<FoodMessageDriverScreen> createState() => _FoodMessageDriverScreenState();
}
class _FoodMessageDriverScreenState extends ConsumerState<FoodMessageDriverScreen> {
 final messageController = TextEditingController();
 final List<Map<String, dynamic>> messages = [
  {'text': FoodConstants.onMyWayMessage, 'isDriver': true, 'time': FoodConstants.twoMinAgo},
  {'text': FoodConstants.thankYouMessage, 'isDriver': false, 'time': FoodConstants.oneMinAgo},
 ];
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Text(FoodConstants.yourDriver, style: const TextStyle(fontSize: 16)),
      Text(FoodConstants.online, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
     ],
    ),
   ),
   body: Column(
    children: [
     Expanded(
      child: ListView.builder(
       padding: const EdgeInsets.all(16),
       itemCount: messages.length,
       itemBuilder: (context, index) {
        final msg = messages[index];
        return _buildMessage(msg['text'] as String, msg['isDriver'] as bool, msg['time'] as String);
       },
      ),
     ),
     Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
       color: Colors.white,
       boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Row(
       children: [
        Expanded(
         child: TextField(
          controller: messageController,
          decoration: InputDecoration(
           hintText: FoodConstants.typeMessage,
           border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
         ),
        ),
        const SizedBox(width: 8),
        FloatingActionButton(
         onPressed: () {
          if (messageController.text.isNotEmpty) {
           setState(() {
            messages.add({'text': messageController.text, 'isDriver': false, 'time': FoodConstants.justNow});
            messageController.clear();
           });
          }
         },
         mini: true,
         child: const Icon(Icons.send),
        ),
       ],
      ),
     ),
    ],
   ),
  );
 }
 Widget _buildMessage(String text, bool isDriver, String time) {
  return Align(
   alignment: isDriver ? Alignment.centerLeft : Alignment.centerRight,
   child: Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(color: isDriver ? Colors.grey[200] : AppColors.primary, borderRadius: BorderRadius.circular(16)),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Text(text, style: TextStyle(color: isDriver ? Colors.black : Colors.white)),
      const SizedBox(height: 4),
      Text(time, style: TextStyle(fontSize: 10, color: isDriver ? Colors.grey[600] : Colors.white70)),
     ],
    ),
   ),
  );
 }
 @override
 void dispose() {
  messageController.dispose();
  super.dispose();
 }
}