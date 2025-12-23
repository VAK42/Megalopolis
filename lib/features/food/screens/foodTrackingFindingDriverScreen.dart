import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../constants/foodConstants.dart';
class FoodTrackingFindingDriverScreen extends ConsumerWidget {
 final String orderId;
 const FoodTrackingFindingDriverScreen({super.key, required this.orderId});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(FoodConstants.findingDriverTitle),
   ),
   body: Center(
    child: Padding(
     padding: const EdgeInsets.all(32),
     child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       Stack(
        alignment: Alignment.center,
        children: [
         Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
         ),
         Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.2), shape: BoxShape.circle),
         ),
         const CircularProgressIndicator(strokeWidth: 3),
        ],
       ),
       const SizedBox(height: 32),
       const Text(FoodConstants.findingDriverMessage, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
       const SizedBox(height: 8),
       Text(FoodConstants.usuallyTakesMinute, style: const TextStyle(color: Colors.grey)),
       const SizedBox(height: 48),
       Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
        child: Row(
         children: [
          const Icon(Icons.access_time, color: AppColors.primary),
          const SizedBox(width: 12),
          Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Text(FoodConstants.estimatedArrivalDefault),
            Text(FoodConstants.calculateArrival, style: const TextStyle(color: Colors.grey, fontSize: 12)),
           ],
          ),
         ],
        ),
       ),
      ],
     ),
    ),
   ),
  );
 }
}