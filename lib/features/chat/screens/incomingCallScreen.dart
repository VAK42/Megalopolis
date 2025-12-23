import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/chatProvider.dart';
import '../../../providers/authProvider.dart';
import '../../chat/constants/chatConstants.dart';
class IncomingCallScreen extends ConsumerWidget {
 final String callerId;
 const IncomingCallScreen({super.key, required this.callerId});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? '1';
  final contactsAsync = ref.watch(contactsProvider(userId));
  return Scaffold(
   body: Container(
    decoration: BoxDecoration(gradient: AppColors.primaryGradient),
    child: SafeArea(
     child: contactsAsync.when(
      data: (contacts) {
       final caller = contacts.firstWhere((c) => c['id'].toString() == callerId, orElse: () => {'name': ChatConstants.unknownCaller});
       return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         const Spacer(),
         Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
          child: const Icon(Icons.person, size: 60, color: Colors.white),
         ),
         const SizedBox(height: 24),
         Text(
          caller['name']?.toString() ?? ChatConstants.unknownUser,
          style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
         ),
         const SizedBox(height: 8),
         const Text(ChatConstants.incomingCallTitle, style: TextStyle(color: Colors.white70, fontSize: 16)),
         const Spacer(),
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
           GestureDetector(
            onTap: () => context.pop(),
            child: Container(
             width: 72,
             height: 72,
             decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
             child: const Icon(Icons.call_end, color: Colors.white, size: 32),
            ),
           ),
           GestureDetector(
            onTap: () => context.pop(),
            child: Container(
             width: 72,
             height: 72,
             decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
             child: const Icon(Icons.call, color: Colors.white, size: 32),
            ),
           ),
          ],
         ),
         const SizedBox(height: 48),
        ],
       );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
      error: (_, __) => const Center(
       child: Text(ChatConstants.errorGeneric, style: TextStyle(color: Colors.white)),
      ),
     ),
    ),
   ),
  );
 }
}