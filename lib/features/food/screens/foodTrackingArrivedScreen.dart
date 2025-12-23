import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../constants/foodConstants.dart';
class FoodTrackingArrivedScreen extends ConsumerWidget {
 final String orderId;
 const FoodTrackingArrivedScreen({super.key, required this.orderId});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(FoodConstants.orderArrivedTitle),
   ),
   body: SafeArea(
    child: Padding(
     padding: const EdgeInsets.all(24),
     child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), shape: BoxShape.circle),
        child: const Icon(Icons.check_circle, size: 80, color: AppColors.success),
       ),
       const SizedBox(height: 32),
       const Text(FoodConstants.orderArrivedMessage, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
       const SizedBox(height: 16),
       const Text(FoodConstants.driverAtLocation, style: TextStyle(color: Colors.grey)),
       const Spacer(),
       SizedBox(
        width: double.infinity,
        child: ElevatedButton(
         onPressed: () => context.go('${Routes.foodRateDriver}/$orderId'),
         style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
         child: const Text(FoodConstants.rateYourExperience),
        ),
       ),
      ],
     ),
    ),
   ),
  );
 }
}