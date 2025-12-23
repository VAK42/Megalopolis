import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../constants/martConstants.dart';
class MartOrderPlacedScreen extends ConsumerWidget {
 const MartOrderPlacedScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
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
       const Text(
        MartConstants.orderPlacedMessage,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
       ),
       const SizedBox(height: 12),
       Text(MartConstants.orderConfirmed, style: TextStyle(color: Colors.grey[600])),
       const SizedBox(height: 32),
       Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
        child: Column(
         children: [
          Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
            const Text(MartConstants.orderId),
            const Text('#OR2024123', style: TextStyle(fontWeight: FontWeight.bold)),
           ],
          ),
          const SizedBox(height: 8),
          Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
            const Text(MartConstants.estimatedDelivery),
            const Text('Dec 22-24', style: TextStyle(fontWeight: FontWeight.bold)),
           ],
          ),
         ],
        ),
       ),
       const Spacer(),
       AppButton(text: MartConstants.trackOrderTitle, onPressed: () => context.go(Routes.martOrderTracking), icon: Icons.delivery_dining),
       const SizedBox(height: 12),
       AppButton(text: MartConstants.continueShopping, onPressed: () => context.go(Routes.martHome), isOutline: true, icon: Icons.shopping_bag),
      ],
     ),
    ),
   ),
  );
 }
}