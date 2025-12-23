import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/rideProvider.dart';
import '../../ride/constants/rideConstants.dart';
class RideDriverFoundScreen extends ConsumerWidget {
 const RideDriverFoundScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final bookingState = ref.watch(rideBookingProvider);
  final driverName = bookingState['driverName'] ?? RideConstants.driverName;
  final vehicleInfo = bookingState['vehicleInfo'] ?? '${RideConstants.carModel} - ${RideConstants.plateNumber}';
  final driverRating = bookingState['driverRating'] ?? '4.9';
  final eta = bookingState['eta'] ?? 5;
  return Scaffold(
   body: SafeArea(
    child: Padding(
     padding: const EdgeInsets.all(24),
     child: Column(
      children: [
       const Spacer(),
       Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.2), shape: BoxShape.circle),
        child: const Icon(Icons.check_circle, size: 60, color: AppColors.success),
       ),
       const SizedBox(height: 24),
       const Text(RideConstants.driverFoundTitle, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
       const SizedBox(height: 8),
       Text('${RideConstants.driverArrivingMessage} $eta ${RideConstants.mins}', style: const TextStyle(color: Colors.grey)),
       const SizedBox(height: 32),
       Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(16)),
        child: Row(
         children: [
          const CircleAvatar(
           radius: 30,
           backgroundColor: Colors.grey,
           child: Icon(Icons.person, size: 30, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
           child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Text(driverName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
             Text(vehicleInfo, style: const TextStyle(color: Colors.grey, fontSize: 12)),
             Row(
              children: [
               const Icon(Icons.star, size: 16, color: Colors.amber),
               const SizedBox(width: 4),
               Text(driverRating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
             ),
            ],
           ),
          ),
          Column(
           children: [
            IconButton(
             icon: const Icon(Icons.call, color: AppColors.primary),
             onPressed: () => context.go(Routes.rideCallDriver),
            ),
            IconButton(
             icon: const Icon(Icons.message, color: AppColors.primary),
             onPressed: () => context.go(Routes.rideMessageDriver),
            ),
           ],
          ),
         ],
        ),
       ),
       const Spacer(),
       AppButton(
        text: RideConstants.confirmRideButton,
        onPressed: () {
         ref.read(activeRideNotifierProvider.notifier).setActiveRide({...bookingState, 'driverName': driverName, 'vehicleInfo': vehicleInfo, 'driverRating': driverRating});
         context.go(Routes.rideInProgress);
        },
        icon: Icons.check,
       ),
       const SizedBox(height: 12),
       OutlinedButton(
        onPressed: () {
         ref.read(rideBookingProvider.notifier).reset();
         context.go(Routes.rideHome);
        },
        style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16), foregroundColor: AppColors.error),
        child: const Text(RideConstants.cancelRideButton),
       ),
      ],
     ),
    ),
   ),
  );
 }
}