import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/rideProvider.dart';
import '../../ride/constants/rideConstants.dart';
class RideReceiptScreen extends ConsumerWidget {
 const RideReceiptScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final activeRide = ref.watch(activeRideNotifierProvider);
  final distance = activeRide?['distance'] ?? 5.2;
  final duration = activeRide?['duration'] ?? 18;
  final fare = activeRide?['estimatedPrice'] ?? 12.50;
  final baseFare = activeRide?['baseFare'] ?? 3.50;
  final pickup = activeRide?['pickupLocation'] ?? RideConstants.currentLocation;
  final dropoff = activeRide?['dropoffLocation'] ?? RideConstants.selectedDestination;
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.rideHome)),
    title: const Text(RideConstants.receiptTitle),
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Column(
     children: [
      Container(
       width: 80,
       height: 80,
       decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.2), shape: BoxShape.circle),
       child: const Icon(Icons.check_circle, size: 40, color: AppColors.success),
      ),
      const SizedBox(height: 16),
      const Text(RideConstants.paymentSuccessful, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 32),
      Container(
       padding: const EdgeInsets.all(20),
       decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(16)),
       child: Column(children: [_buildReceiptRow(RideConstants.pickupLocationLabel, pickup.toString()), const Divider(height: 24), _buildReceiptRow(RideConstants.dropoffLocationLabel, dropoff.toString()), const Divider(height: 24), _buildReceiptRow(RideConstants.distanceLabel, '$distance ${RideConstants.km}'), _buildReceiptRow(RideConstants.durationLabel, '$duration ${RideConstants.mins}'), const Divider(height: 24), _buildReceiptRow(RideConstants.baseFare, '\$${baseFare.toStringAsFixed(2)}'), _buildReceiptRow(RideConstants.distanceFare, '\$${(distance * 1.5).toStringAsFixed(2)}'), _buildReceiptRow(RideConstants.timeFare, '\$${(duration * 0.2).toStringAsFixed(2)}'), const Divider(height: 24), _buildReceiptRow(RideConstants.totalFareLabel, '\$${fare.toStringAsFixed(2)}', isTotal: true)]),
      ),
      const SizedBox(height: 32),
      Row(
       children: [
        Expanded(
         child: AppButton(text: RideConstants.downloadReceipt, onPressed: () {}, isOutline: true, icon: Icons.download),
        ),
        const SizedBox(width: 12),
        Expanded(
         child: AppButton(text: RideConstants.emailReceipt, onPressed: () {}, icon: Icons.email),
        ),
       ],
      ),
      const SizedBox(height: 16),
      TextButton(onPressed: () => context.go(Routes.rideHome), child: const Text(RideConstants.backToHomeButton)),
     ],
    ),
   ),
  );
 }
 Widget _buildReceiptRow(String label, String value, {bool isTotal = false}) {
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
      value,
      style: TextStyle(fontSize: isTotal ? 18 : 14, fontWeight: FontWeight.bold, color: isTotal ? AppColors.primary : null),
     ),
    ],
   ),
  );
 }
}