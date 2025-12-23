import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../constants/martConstants.dart';
class MartReturnSubmittedScreen extends ConsumerWidget {
 const MartReturnSubmittedScreen({super.key});
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
        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.2), shape: BoxShape.circle),
        child: const Icon(Icons.assignment_return, size: 60, color: AppColors.primary),
       ),
       const SizedBox(height: 32),
       const Text(
        MartConstants.returnRequestSubmitted,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
       ),
       const SizedBox(height: 12),
       Text(
        MartConstants.reviewRequestMessage,
        style: TextStyle(color: Colors.grey[600]),
        textAlign: TextAlign.center,
       ),
       const SizedBox(height: 32),
       Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
        child: Column(
         children: [
          Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
            const Text(MartConstants.requestId),
            const Text('#RR2024456', style: TextStyle(fontWeight: FontWeight.bold)),
           ],
          ),
          const SizedBox(height: 8),
          Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
            const Text(MartConstants.status),
            Text(
             MartConstants.underReview,
             style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
            ),
           ],
          ),
         ],
        ),
       ),
       const Spacer(),
       AppButton(text: MartConstants.backToOrders, onPressed: () => context.go(Routes.martOrders), icon: Icons.list),
       const SizedBox(height: 12),
       AppButton(text: MartConstants.backToHome, onPressed: () => context.go(Routes.martHome), isOutline: true, icon: Icons.home),
      ],
     ),
    ),
   ),
  );
 }
}