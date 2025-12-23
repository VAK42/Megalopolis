import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../../ride/constants/rideConstants.dart';
import '../../../providers/rideProvider.dart';
class RideCompletedScreen extends ConsumerWidget {
 const RideCompletedScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final bookingState = ref.watch(rideBookingProvider);
  final distance = bookingState['distance'] ?? 5.2;
  final duration = bookingState['duration'] ?? 18;
  final fare = bookingState['estimatedPrice'] ?? 12.50;
  return Scaffold(
   body: SafeArea(
    child: Padding(
     padding: const EdgeInsets.all(24),
     child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.2), shape: BoxShape.circle),
        child: const Icon(Icons.check_circle, size: 60, color: AppColors.success),
       ),
       const SizedBox(height: 32),
       const Text(RideConstants.tripCompletedTitle, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
       const SizedBox(height: 12),
       Text(RideConstants.tripCompletedMessage, style: TextStyle(color: Colors.grey[600])),
       const SizedBox(height: 48),
       Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
        child: Column(
         children: [
          Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
            const Text(RideConstants.distanceLabel),
            Text('$distance Km', style: const TextStyle(fontWeight: FontWeight.bold)),
           ],
          ),
          const SizedBox(height: 8),
          Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
            const Text(RideConstants.timeLabel),
            Text('$duration Min', style: const TextStyle(fontWeight: FontWeight.bold)),
           ],
          ),
          const SizedBox(height: 8),
          Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
            const Text(RideConstants.totalFareLabel),
            Text(
             '\$${fare.toStringAsFixed(2)}',
             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary),
            ),
           ],
          ),
         ],
        ),
       ),
       const Spacer(),
       AppButton(text: RideConstants.rateDriverButton, onPressed: () => context.go(Routes.rideRateDriver), icon: Icons.star),
       const SizedBox(height: 12),
       AppButton(text: RideConstants.viewReceiptButton, onPressed: () => context.go(Routes.rideReceipt), isOutline: true, icon: Icons.receipt),
       const SizedBox(height: 12),
       TextButton(onPressed: () => context.go(Routes.rideHome), child: const Text(RideConstants.backToHomeButton)),
      ],
     ),
    ),
   ),
  );
 }
}