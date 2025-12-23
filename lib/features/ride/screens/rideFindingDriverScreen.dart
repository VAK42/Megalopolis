import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/rideProvider.dart';
import '../../ride/constants/rideConstants.dart';
class RideFindingDriverScreen extends ConsumerStatefulWidget {
 const RideFindingDriverScreen({super.key});
 @override
 ConsumerState<RideFindingDriverScreen> createState() => _RideFindingDriverScreenState();
}
class _RideFindingDriverScreenState extends ConsumerState<RideFindingDriverScreen> {
 @override
 void initState() {
  super.initState();
  Future.delayed(const Duration(seconds: 3), () {
   if (mounted) context.go(Routes.rideDriverFound);
  });
 }
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   body: SafeArea(
    child: Padding(
     padding: const EdgeInsets.all(24),
     child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       const Spacer(),
       Stack(
        alignment: Alignment.center,
        children: [
         Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withValues(alpha: 0.1)),
         ),
         Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withValues(alpha: 0.2)),
         ),
         Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
          child: const Icon(Icons.local_taxi, color: Colors.white, size: 50),
         ),
        ],
       ),
       const SizedBox(height: 48),
       const Text(RideConstants.findingDriverTitle, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
       const SizedBox(height: 12),
       const Text(RideConstants.searchingForDriver, style: TextStyle(color: Colors.grey)),
       const SizedBox(height: 24),
       const CircularProgressIndicator(color: AppColors.primary),
       const Spacer(),
       SizedBox(
        width: double.infinity,
        child: OutlinedButton(
         onPressed: () {
          ref.read(rideBookingProvider.notifier).reset();
          context.go(Routes.rideHome);
         },
         style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.error),
         ),
         child: const Text(RideConstants.cancelRideButton),
        ),
       ),
      ],
     ),
    ),
   ),
  );
 }
}