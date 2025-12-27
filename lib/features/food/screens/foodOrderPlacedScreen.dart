import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/foodProvider.dart';
import '../../../shared/widgets/appButton.dart';
import '../constants/foodConstants.dart';
class FoodOrderPlacedScreen extends ConsumerWidget {
 const FoodOrderPlacedScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userIdStr = ref.watch(currentUserIdProvider);
  final userId = userIdStr ?? '1';
  final orderAsync = ref.watch(foodLatestOrderProvider(userId));
  return Scaffold(
   body: SafeArea(
    child: Padding(
     padding: const EdgeInsets.all(24),
     child: orderAsync.when(
      data: (order) {
       final orderId = order?['id']?.toString() ?? '...';
       return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(60)),
          child: const Icon(Icons.check_circle, size: 60, color: AppColors.success),
         ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
         const SizedBox(height: 32),
         const Text(FoodConstants.orderPlacedTitle, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)).animate().fadeIn(delay: 300.ms),
         const SizedBox(height: 12),
         Text(FoodConstants.orderPlacedMessage, style: TextStyle(color: Colors.grey[600], fontSize: 16)).animate().fadeIn(delay: 600.ms),
         const SizedBox(height: 48),
         Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
          child: Column(
           children: [
            Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
              const Text(FoodConstants.orderId),
              Text('#$orderId', style: const TextStyle(fontWeight: FontWeight.bold)),
             ],
            ),
            const SizedBox(height: 8),
            Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
              Text('${FoodConstants.estimatedTimePrefix.split(':')[0]}'),
              const Text(FoodConstants.defaultDeliveryTime, style: TextStyle(fontWeight: FontWeight.bold)),
             ],
            ),
           ],
          ),
         ).animate().fadeIn(delay: 900.ms),
         const Spacer(),
         AppButton(text: FoodConstants.trackOrder, onPressed: () => context.go('/food/tracking/$orderId/findingDriver'), icon: Icons.location_on).animate().fadeIn(delay: 1200.ms),
         const SizedBox(height: 12),
         AppButton(text: FoodConstants.backToHome, onPressed: () => context.go(Routes.foodHome), isOutline: true).animate().fadeIn(delay: 1400.ms),
        ],
       );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text(FoodConstants.errorLoadingOrder)),
     ),
    ),
   ),
  );
 }
}