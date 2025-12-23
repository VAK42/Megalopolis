import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/foodProvider.dart';
import '../../../providers/authProvider.dart';
import '../../../core/routes/routeNames.dart';
import '../constants/foodConstants.dart';
class FoodTrackingPickedUpScreen extends ConsumerWidget {
 final String orderId;
 const FoodTrackingPickedUpScreen({super.key, required this.orderId});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? '1';
  final orderAsync = ref.watch(foodLatestOrderProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(FoodConstants.pickedUpTitle),
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
        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
        child: const Icon(Icons.delivery_dining, size: 60, color: Colors.white),
       ),
       const SizedBox(height: 32),
       const Text(FoodConstants.pickedUpMessage, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
       const SizedBox(height: 16),
       const Text(FoodConstants.onTheWay, style: TextStyle(color: Colors.grey)),
       const SizedBox(height: 32),
       Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
        child: Row(
         children: [
          const Icon(Icons.access_time, color: AppColors.primary),
          const SizedBox(width: 12),
          orderAsync.when(
           data: (order) => Text('${FoodConstants.estimatedTimePrefix}${order?['estimatedTime'] ?? FoodConstants.defaultEstimatedTime}', style: const TextStyle(fontWeight: FontWeight.bold)),
           loading: () => const Text(FoodConstants.calculateArrival),
           error: (_, __) => const Text(FoodConstants.estimatedArrivalDefault),
          ),
         ],
        ),
       ),
       const Spacer(),
       SizedBox(
        width: double.infinity,
        child: ElevatedButton(
         onPressed: () => context.go('${Routes.foodTrackingArrived}/$orderId'),
         style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
         child: const Text(FoodConstants.trackOrder),
        ),
       ),
      ],
     ),
    ),
   ),
  );
 }
}