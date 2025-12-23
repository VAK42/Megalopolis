import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/widgets/appTextField.dart';
import '../../../providers/rideProvider.dart';
import '../../ride/constants/rideConstants.dart';
class RideMessageDriverScreen extends ConsumerStatefulWidget {
 const RideMessageDriverScreen({super.key});
 @override
 ConsumerState<RideMessageDriverScreen> createState() => _RideMessageDriverScreenState();
}
class _RideMessageDriverScreenState extends ConsumerState<RideMessageDriverScreen> {
 final TextEditingController messageController = TextEditingController();
 final List<Map<String, dynamic>> messages = [
  {'text': 'Hi, I am on my way!', 'isDriver': true, 'time': '10:30 AM'},
  {'text': 'Great, I am waiting outside.', 'isDriver': false, 'time': '10:31 AM'},
 ];
 @override
 Widget build(BuildContext context) {
  final activeRide = ref.watch(activeRideNotifierProvider);
  final driverName = activeRide?['driverName'] ?? RideConstants.driverName;
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Text(driverName, style: const TextStyle(fontSize: 16)),
      Text(RideConstants.onlineStatus, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
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
        final message = messages[index];
        final isDriver = message['isDriver'] as bool;
        return Align(
         alignment: isDriver ? Alignment.centerLeft : Alignment.centerRight,
         child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          decoration: BoxDecoration(color: isDriver ? Colors.grey[200] : AppColors.primary, borderRadius: BorderRadius.circular(16)),
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Text(message['text'], style: TextStyle(color: isDriver ? Colors.black : Colors.white)),
            const SizedBox(height: 4),
            Text(message['time'], style: TextStyle(fontSize: 10, color: isDriver ? Colors.grey[600] : Colors.white70)),
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
         child: AppTextField(controller: messageController, hint: RideConstants.chatHint),
        ),
        const SizedBox(width: 12),
        IconButton(
         icon: const Icon(Icons.send, color: AppColors.primary),
         onPressed: () {
          if (messageController.text.isNotEmpty) {
           setState(() => messages.add({'text': messageController.text, 'isDriver': false, 'time': 'Now'}));
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