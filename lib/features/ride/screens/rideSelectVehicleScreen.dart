import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../ride/constants/rideConstants.dart';
import '../../../providers/rideProvider.dart';
class RideSelectVehicleScreen extends ConsumerWidget {
 const RideSelectVehicleScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final bookingState = ref.watch(rideBookingProvider);
  final pickup = bookingState['pickupLocation'] ?? RideConstants.currentLocation;
  final dropoff = bookingState['dropoffLocation'] ?? RideConstants.selectedDestination;
  final double distance = (bookingState['distance'] as num?)?.toDouble() ?? 0.0;
  final double duration = (bookingState['duration'] as num?)?.toDouble() ?? 0.0;
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.ridePickLocation)),
    title: const Text(RideConstants.selectVehicleTitle),
   ),
   body: Column(
    children: [
     Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.primary.withValues(alpha: 0.1),
      child: Row(
       children: [
        const Icon(Icons.trip_origin, color: AppColors.success, size: 16),
        const SizedBox(width: 8),
        Expanded(child: Text(pickup, style: const TextStyle(fontSize: 12))),
       ],
      ),
     ),
     Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.error.withValues(alpha: 0.1),
      child: Row(
       children: [
        const Icon(Icons.location_on, color: AppColors.error, size: 16),
        const SizedBox(width: 8),
        Expanded(child: Text(dropoff, style: const TextStyle(fontSize: 12))),
       ],
      ),
     ),
     const SizedBox(height: 16),
     Expanded(
      child: ListView(padding: const EdgeInsets.all(16), children: [_buildVehicleCard(context, ref, RideConstants.rideEco, RideConstants.affordableRides, Icons.directions_car, (12.50 + (distance * 1.5)).toStringAsFixed(2), '${(5 + duration).ceil()} ${RideConstants.mins}', AppColors.success), _buildVehicleCard(context, ref, RideConstants.ridePremium, RideConstants.luxuryCars, Icons.directions_car, (24.00 + (distance * 2.5)).toStringAsFixed(2), '${(8 + duration).ceil()} ${RideConstants.mins}', AppColors.primary), _buildVehicleCard(context, ref, RideConstants.rideXl, RideConstants.sixSeats, Icons.airport_shuttle, (18.50 + (distance * 2.0)).toStringAsFixed(2), '${(10 + duration).ceil()} ${RideConstants.mins}', AppColors.accent), _buildVehicleCard(context, ref, RideConstants.rideShare, RideConstants.sharedRides, Icons.people, (8.00 + (distance * 1.0)).toStringAsFixed(2), '${(15 + duration).ceil()} ${RideConstants.mins}', Colors.green)]),
     ),
    ],
   ),
  );
 }
 Widget _buildVehicleCard(BuildContext context, WidgetRef ref, String name, String description, IconData icon, String price, String eta, Color color) {
  return GestureDetector(
   onTap: () {
    ref.read(rideBookingProvider.notifier).setRideType(name);
    context.go(Routes.ridePriceEstimate);
   },
   child: Card(
    margin: const EdgeInsets.only(bottom: 16),
    child: Padding(
     padding: const EdgeInsets.all(16),
     child: Row(
      children: [
       Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, size: 32, color: color),
       ),
       const SizedBox(width: 16),
       Expanded(
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(description, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 4),
          Row(
           children: [
            const Icon(Icons.access_time, size: 14),
            const SizedBox(width: 4),
            Text(eta, style: const TextStyle(fontSize: 12)),
           ],
          ),
         ],
        ),
       ),
       Text('\$$price', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
     ),
    ),
   ),
  );
 }
}