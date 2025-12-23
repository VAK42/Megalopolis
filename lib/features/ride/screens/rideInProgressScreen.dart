import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../ride/constants/rideConstants.dart';
import '../../../providers/rideProvider.dart';
class RideInProgressScreen extends ConsumerWidget {
 const RideInProgressScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final activeRide = ref.watch(activeRideNotifierProvider);
  final duration = activeRide?['duration'] ?? 15;
  return Scaffold(
   body: Stack(
    children: [
     FlutterMap(
      options: const MapOptions(initialCenter: LatLng(37.7749, -122.4194), initialZoom: 15),
      children: [TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png')],
     ),
     SafeArea(
      child: Column(
       children: [
        Container(
         margin: const EdgeInsets.all(16),
         padding: const EdgeInsets.all(16),
         decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
         child: Row(
          children: [
           const Icon(Icons.directions, color: Colors.white),
           const SizedBox(width: 12),
           Expanded(
            child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
              const Text(
               RideConstants.onTheWayToDestination,
               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text('${RideConstants.arrivalInMins} $duration ${RideConstants.mins}', style: const TextStyle(color: Colors.white70)),
             ],
            ),
           ),
          ],
         ),
        ),
        const Spacer(),
        Container(
         padding: const EdgeInsets.all(24),
         decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
         ),
         child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
           const LinearProgressIndicator(value: 0.6, backgroundColor: Colors.grey, color: AppColors.success),
           const SizedBox(height: 24),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
             _buildAction(context, Icons.share, RideConstants.shareTripButton),
             _buildAction(context, Icons.security, RideConstants.sosButton, isEmergency: true, onTap: () => context.go(Routes.rideEmergency)),
            ],
           ),
           const SizedBox(height: 24),
           SizedBox(
            width: double.infinity,
            child: ElevatedButton(
             onPressed: () {
              ref.read(activeRideNotifierProvider.notifier).updateStatus('completed');
              context.go(Routes.rideCompleted);
             },
             style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.all(16)),
             child: const Text(RideConstants.completeRideDemo, style: TextStyle(color: Colors.white)),
            ),
           ),
          ],
         ),
        ),
       ],
      ),
     ),
    ],
   ),
  );
 }
 Widget _buildAction(BuildContext context, IconData icon, String label, {bool isEmergency = false, VoidCallback? onTap}) {
  return GestureDetector(
   onTap: onTap,
   child: Column(
    children: [
     Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: isEmergency ? AppColors.error.withValues(alpha: 0.1) : Colors.grey[100], shape: BoxShape.circle),
      child: Icon(icon, color: isEmergency ? AppColors.error : AppColors.primary, size: 28),
     ),
     const SizedBox(height: 8),
     Text(
      label,
      style: TextStyle(color: isEmergency ? AppColors.error : Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
     ),
    ],
   ),
  );
 }
}