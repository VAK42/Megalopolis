import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/chatProvider.dart';
import '../../../providers/authProvider.dart';
import '../../chat/constants/chatConstants.dart';
class VideoCallScreen extends ConsumerStatefulWidget {
 final String recipientId;
 const VideoCallScreen({super.key, required this.recipientId});
 @override
 ConsumerState<VideoCallScreen> createState() => _VideoCallScreenState();
}
class _VideoCallScreenState extends ConsumerState<VideoCallScreen> {
 bool isMuted = false;
 bool isCameraOff = false;
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider) ?? '1';
  final contactsAsync = ref.watch(contactsProvider(userId));
  return Scaffold(
   body: contactsAsync.when(
    data: (contacts) {
     final recipient = contacts.firstWhere((c) => c['id'].toString() == widget.recipientId, orElse: () => {'name': ChatConstants.unknownUser});
     return Stack(
      children: [
       Container(color: Colors.grey[900]),
       Positioned(
        right: 16,
        top: 48,
        child: Container(
         width: 120,
         height: 180,
         decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
         child: const Center(child: Icon(Icons.person, size: 48, color: Colors.white)),
        ),
       ),
       Positioned(
        top: 100,
        left: 0,
        right: 0,
        child: Column(
         children: [
          Container(
           width: 80,
           height: 80,
           decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
           child: const Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
           recipient['name']?.toString() ?? ChatConstants.unknownUser,
           style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(ChatConstants.videoCallTitle, style: TextStyle(color: Colors.white70)),
         ],
        ),
       ),
       Positioned(
        bottom: 48,
        left: 0,
        right: 0,
        child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         children: [
          _buildActionButton(Icons.mic, Icons.mic_off, isMuted, () => setState(() => isMuted = !isMuted)),
          GestureDetector(
           onTap: () => context.pop(),
           child: Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            child: const Icon(Icons.call_end, color: Colors.white),
           ),
          ),
          _buildActionButton(Icons.videocam, Icons.videocam_off, isCameraOff, () => setState(() => isCameraOff = !isCameraOff)),
         ],
        ),
       ),
      ],
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(ChatConstants.errorGeneric)),
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