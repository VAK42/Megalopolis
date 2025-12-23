import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../shared/widgets/appTextField.dart';
import '../../../providers/rideProvider.dart';
import '../../ride/constants/rideConstants.dart';
class RideRateDriverScreen extends ConsumerStatefulWidget {
 const RideRateDriverScreen({super.key});
 @override
 ConsumerState<RideRateDriverScreen> createState() => _RideRateDriverScreenState();
}
class _RideRateDriverScreenState extends ConsumerState<RideRateDriverScreen> {
 final commentController = TextEditingController();
 double _rating = 5.0;
 @override
 void dispose() {
  commentController.dispose();
  super.dispose();
 }
 @override
 Widget build(BuildContext context) {
  final activeRide = ref.watch(activeRideNotifierProvider);
  final driverName = activeRide?['driverName'] ?? RideConstants.driverName;
  final vehicleInfo = activeRide?['vehicleInfo'] ?? '${RideConstants.carModel} • ${RideConstants.plateNumber}';
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.go(Routes.rideHome)),
    title: const Text(RideConstants.rateDriverTitle),
   ),
   body: SafeArea(
    child: SingleChildScrollView(
     padding: const EdgeInsets.all(24),
     child: Column(
      children: [
       const CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey,
        child: Icon(Icons.person, size: 50, color: Colors.white),
       ),
       const SizedBox(height: 16),
       Text(driverName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
       Text(vehicleInfo, style: const TextStyle(color: Colors.grey)),
       const SizedBox(height: 32),
       const Text(RideConstants.rateDriverMessage, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
       const SizedBox(height: 24),
       Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
         return IconButton(
          onPressed: () => setState(() => _rating = index + 1.0),
          icon: Icon(index < _rating ? Icons.star : Icons.star_border, size: 40, color: Colors.amber),
         );
        }),
       ),
       const SizedBox(height: 32),
       AppTextField(controller: commentController, hint: RideConstants.addCommentHint, maxLines: 4),
       const SizedBox(height: 32),
       AppButton(
        text: RideConstants.submitRatingButton,
        onPressed: () {
         ref.read(activeRideNotifierProvider.notifier).clear();
         context.go(Routes.rideHome);
        },
       ),
      ],
     ),
    ),
   ),
  );
 }
}