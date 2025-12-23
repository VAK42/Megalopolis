import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/widgets/appTextField.dart';
import '../constants/servicesConstants.dart';
class ServicesChatScreen extends ConsumerStatefulWidget {
 const ServicesChatScreen({super.key});
 @override
 ConsumerState<ServicesChatScreen> createState() => _ServicesChatScreenState();
}
class _ServicesChatScreenState extends ConsumerState<ServicesChatScreen> {
 final messageController = TextEditingController();
 final List<Map<String, dynamic>> messages = [];
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Text(ServicesConstants.serviceProvider, style: TextStyle(fontSize: 16)),
      Text(ServicesConstants.onlineNow, style: TextStyle(fontSize: 12, color: Colors.green)),
     ],
    ),
   ),
   body: Column(
    children: [
     Expanded(
      child: messages.isEmpty
        ? const Center(child: Text(ServicesConstants.typeMessage))
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
           final message = messages[index];
           final isProvider = message['isProvider'] as bool;
           return Align(
            alignment: isProvider ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
             margin: const EdgeInsets.only(bottom: 12),
             padding: const EdgeInsets.all(12),
             constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
             decoration: BoxDecoration(color: isProvider ? Colors.grey[200] : AppColors.primary, borderRadius: BorderRadius.circular(16)),
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Text(message['text'], style: TextStyle(color: isProvider ? Colors.black : Colors.white)),
               const SizedBox(height: 4),
               Text(message['time'], style: TextStyle(fontSize: 10, color: isProvider ? Colors.grey[600] : Colors.white70)),
              ],
             ),
            ),
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
        Expanded(
         child: AppTextField(controller: messageController, hint: ServicesConstants.typeMessage),
        ),
        const SizedBox(width: 12),
        IconButton(
         icon: const Icon(Icons.send, color: AppColors.primary),
         onPressed: () {
          if (messageController.text.isNotEmpty) {
           setState(() => messages.add({'text': messageController.text, 'isProvider': false, 'time': TimeOfDay.now().format(context)}));
           messageController.clear();
          }
         },
        ),
       ],
      ),
     ),
    ],
   ),
  );
 }
}