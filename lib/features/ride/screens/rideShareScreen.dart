import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/rideProvider.dart';
import '../../ride/constants/rideConstants.dart';
class RideShareScreen extends ConsumerWidget {
 const RideShareScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final activeRide = ref.watch(activeRideNotifierProvider);
  final pickup = activeRide?['pickupLocation'] ?? RideConstants.currentLocation;
  final dropoff = activeRide?['dropoffLocation'] ?? RideConstants.selectedDestination;
  final driverName = activeRide?['driverName'] ?? RideConstants.driverName;
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(RideConstants.shareRideTitle),
   ),
   body: Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
     children: [
      Container(
       padding: const EdgeInsets.all(24),
       decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(16)),
       child: Column(
        children: [
         const Icon(Icons.share_location, size: 60, color: AppColors.primary),
         const SizedBox(height: 16),
         const Text(RideConstants.tripDetails, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
         const SizedBox(height: 16),
         _buildDetailRow(Icons.trip_origin, RideConstants.pickupTitle, pickup),
         const SizedBox(height: 8),
         _buildDetailRow(Icons.location_on, RideConstants.destinationTitle, dropoff),
         const SizedBox(height: 8),
         _buildDetailRow(Icons.person, RideConstants.driverTitle, driverName),
        ],
       ),
      ),
      const SizedBox(height: 32),
      const Text(RideConstants.shareWithContacts, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 16),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildShareOption(Icons.message, 'SMS', Colors.green), _buildShareOption(Icons.email, 'Email', AppColors.primary), _buildShareOption(Icons.share, 'Share', AppColors.accent)]),
     ],
    ),
   ),
  );
 }
 Widget _buildDetailRow(IconData icon, String label, String value) {
  return Row(
   children: [
    Icon(icon, size: 20, color: AppColors.primary),
    const SizedBox(width: 12),
    Expanded(
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
       Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
     ),
    ),
   ],
  );
 }
 Widget _buildShareOption(IconData icon, String label, Color color) {
  return Column(
   children: [
    Container(
     padding: const EdgeInsets.all(16),
     decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
     child: Icon(icon, color: color, size: 28),
    ),
    const SizedBox(height: 8),
    Text(label, style: const TextStyle(fontSize: 12)),
   ],
  );
 }
}