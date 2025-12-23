import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../constants/foodConstants.dart';
class FoodCallDriverScreen extends ConsumerWidget {
 final String orderId;
 const FoodCallDriverScreen({super.key, required this.orderId});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   body: Container(
    color: AppColors.primary,
    child: SafeArea(
     child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       const Spacer(),
       Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
        child: const Icon(Icons.person, size: 50, color: Colors.white),
       ),
       const SizedBox(height: 24),
       const Text(
        FoodConstants.yourDriver,
        style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
       ),
       const SizedBox(height: 8),
       const Text(FoodConstants.calling, style: TextStyle(color: Colors.white70, fontSize: 16)),
       const Spacer(),
       Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildCallButton(Icons.volume_up, FoodConstants.speaker, () {}), _buildCallButton(Icons.mic_off, FoodConstants.mute, () {})]),
       const SizedBox(height: 48),
       FloatingActionButton(onPressed: () => context.pop(), backgroundColor: AppColors.error, child: const Icon(Icons.call_end, size: 32)),
       const SizedBox(height: 48),
      ],
     ),
    ),
   ),
  );
 }
 Widget _buildCallButton(IconData icon, String label, VoidCallback onPressed) {
  return Column(
   children: [
    IconButton(
     onPressed: onPressed,
     icon: Icon(icon, color: Colors.white, size: 32),
     style: IconButton.styleFrom(backgroundColor: Colors.white.withValues(alpha: 0.2), padding: const EdgeInsets.all(16)),
    ),
    const SizedBox(height: 8),
    Text(label, style: const TextStyle(color: Colors.white70)),
   ],
  );
 }
}