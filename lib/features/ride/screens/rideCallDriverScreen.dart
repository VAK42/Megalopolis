import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/rideProvider.dart';
import '../../ride/constants/rideConstants.dart';
class RideCallDriverScreen extends ConsumerWidget {
 const RideCallDriverScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final activeRide = ref.watch(activeRideNotifierProvider);
  final driverName = activeRide?['driverName'] ?? RideConstants.driverName;
  return Scaffold(
   backgroundColor: AppColors.primary,
   body: SafeArea(
    child: Column(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
      const Spacer(),
      const CircleAvatar(
       radius: 60,
       backgroundColor: Colors.white24,
       child: Icon(Icons.person, size: 60, color: Colors.white),
      ),
      const SizedBox(height: 24),
      Text(
       driverName,
       style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(RideConstants.callingLabel, style: TextStyle(color: Colors.white70, fontSize: 16)),
      const Spacer(),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildCallAction(Icons.volume_up, 'Speaker', Colors.white24, () {}), _buildCallAction(Icons.call_end, 'End', AppColors.error, () => context.pop()), _buildCallAction(Icons.mic_off, 'Mute', Colors.white24, () {})]),
      const SizedBox(height: 48),
     ],
    ),
   ),
  );
 }
 Widget _buildCallAction(IconData icon, String label, Color color, VoidCallback onTap) {
  return GestureDetector(
   onTap: onTap,
   child: Column(
    children: [
     Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 28),
     ),
     const SizedBox(height: 8),
     Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
    ],
   ),
  );
 }
}