import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/chatProvider.dart';
import '../../../providers/authProvider.dart';
import '../../chat/constants/chatConstants.dart';
class VoiceCallScreen extends ConsumerStatefulWidget {
 final String recipientId;
 const VoiceCallScreen({super.key, required this.recipientId});
 @override
 ConsumerState<VoiceCallScreen> createState() => _VoiceCallScreenState();
}
class _VoiceCallScreenState extends ConsumerState<VoiceCallScreen> {
 bool isMuted = false;
 bool isSpeakerOn = false;
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider) ?? '1';
  final contactsAsync = ref.watch(contactsProvider(userId));
  return Scaffold(
   body: Container(
    decoration: BoxDecoration(gradient: AppColors.primaryGradient),
    child: SafeArea(
     child: contactsAsync.when(
      data: (contacts) {
       final recipient = contacts.firstWhere((c) => c['id'].toString() == widget.recipientId, orElse: () => {'name': ChatConstants.unknownUser});
       return Column(
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
          recipient['name']?.toString() ?? ChatConstants.unknownUser,
          style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
         ),
         const SizedBox(height: 8),
         const Text(ChatConstants.timerDefault, style: TextStyle(color: Colors.white70, fontSize: 18)),
         const Spacer(),
         Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildActionButton(Icons.mic, Icons.mic_off, isMuted, () => setState(() => isMuted = !isMuted)), _buildActionButton(Icons.volume_up, Icons.volume_off, !isSpeakerOn, () => setState(() => isSpeakerOn = !isSpeakerOn))]),
         const SizedBox(height: 32),
         GestureDetector(
          onTap: () => context.pop(),
          child: Container(
           width: 72,
           height: 72,
           decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
           child: const Icon(Icons.call_end, color: Colors.white, size: 32),
          ),
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
 Widget _buildActionButton(IconData onIcon, IconData offIcon, bool isOff, VoidCallback onPressed) {
  return GestureDetector(
   onTap: onPressed,
   child: Container(
    width: 56,
    height: 56,
    decoration: BoxDecoration(color: isOff ? Colors.red : Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
    child: Icon(isOff ? offIcon : onIcon, color: Colors.white),
   ),
  );
 }
}