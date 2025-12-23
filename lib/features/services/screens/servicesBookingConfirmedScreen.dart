import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../constants/servicesConstants.dart';
class ServicesBookingConfirmedScreen extends ConsumerWidget {
 const ServicesBookingConfirmedScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   body: SafeArea(
    child: Padding(
     padding: const EdgeInsets.all(24),
     child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       const Spacer(),
       Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.2), shape: BoxShape.circle),
        child: const Icon(Icons.check_circle, size: 60, color: AppColors.success),
       ),
       const SizedBox(height: 32),
       const Text(ServicesConstants.bookingConfirmed, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
       const SizedBox(height: 12),
       const Text(
        ServicesConstants.thankYou,
        style: TextStyle(color: Colors.grey),
        textAlign: TextAlign.center,
       ),
       const Spacer(),
       AppButton(text: ServicesConstants.viewBooking, onPressed: () => context.go(Routes.servicesHistory), icon: Icons.visibility),
       const SizedBox(height: 12),
       TextButton(onPressed: () => context.go(Routes.servicesHome), child: const Text(ServicesConstants.backToHome)),
      ],
     ),
    ),
   ),
  );
 }
}