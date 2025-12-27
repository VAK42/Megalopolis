import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/rideProvider.dart';
import '../../ride/constants/rideConstants.dart';
class RidePriceEstimateScreen extends ConsumerWidget {
 const RidePriceEstimateScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final bookingState = ref.watch(rideBookingProvider);
  final double distance = (bookingState['distance'] as num?)?.toDouble() ?? 0.0;
  final double duration = (bookingState['duration'] as num?)?.toDouble() ?? 0.0;
  final rideType = bookingState['rideType'] ?? 'RideEco';
  double multiplier = 1.0;
  if (rideType == 'RidePremium') multiplier = 1.5;
  if (rideType == 'RideXL') multiplier = 1.3;
  final double baseFare = ((bookingState['baseFare'] as num?)?.toDouble() ?? 3.50) * multiplier;
  final double distanceFare = (distance * 1.5) * multiplier;
  final double timeFare = (duration * 0.2) * multiplier;
  final double totalFare = baseFare + distanceFare + timeFare;
  return Scaffold(
   body: Stack(
    children: [
     FlutterMap(
      options: const MapOptions(initialCenter: LatLng(37.7749, -122.4194), initialZoom: 13),
      children: [TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png')],
     ),
     SafeArea(
      child: Column(
       children: [
        Container(
         padding: const EdgeInsets.all(16),
         color: Colors.white,
         child: Row(
          children: [
           IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.rideSelectVehicle)),
           const Text(RideConstants.tripDetails, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(
            children: [
             Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.directions_car, size: 32, color: AppColors.success),
             ),
             const SizedBox(width: 16),
             Expanded(
              child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                Text(rideType, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const Text(RideConstants.comfortableAffordable),
               ],
              ),
             ),
            ],
           ),
           const SizedBox(height: 24),
           _buildDetailRow(Icons.trip_origin, RideConstants.pickupLocationLabel, bookingState['pickupLocation'] as String? ?? RideConstants.currentLocation),
           const SizedBox(height: 12),
           _buildDetailRow(Icons.location_on, RideConstants.dropoffLocationLabel, bookingState['dropoffLocation'] as String? ?? RideConstants.selectDestination),
           const Divider(height: 32),
           _buildPriceRow(RideConstants.baseFare, '\$${baseFare.toStringAsFixed(2)}'),
           _buildPriceRow('${RideConstants.distanceLabel} ($distance Km)', '\$${distanceFare.toStringAsFixed(2)}'),
           _buildPriceRow('${RideConstants.durationLabel} ($duration Min)', '\$${timeFare.toStringAsFixed(2)}'),
           const Divider(height: 24),
           _buildPriceRow(RideConstants.totalFareLabel, '\$${totalFare.toStringAsFixed(2)}', isTotal: true),
           const SizedBox(height: 24),
           AppButton(
            text: '${RideConstants.bookNowButton} $rideType',
            onPressed: () {
             final userId = RideConstants.defaultUserId;
             ref.read(rideBookingProvider.notifier).bookRide(userId).then((_) {
              context.go(Routes.rideFindingDriver);
             });
            },
            icon: Icons.check_circle,
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
 Widget _buildDetailRow(IconData icon, String label, String value) {
  return Row(
   children: [
    Icon(icon, size: 20),
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
 Widget _buildPriceRow(String label, String amount, {bool isTotal = false}) {
  return Padding(
   padding: const EdgeInsets.symmetric(vertical: 4),
   child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
     Text(
      label,
      style: TextStyle(fontSize: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
     ),
     Text(
      amount,
      style: TextStyle(fontSize: isTotal ? 16 : 14, fontWeight: FontWeight.bold, color: isTotal ? AppColors.primary : null),
     ),
    ],
   ),
  );
 }
}