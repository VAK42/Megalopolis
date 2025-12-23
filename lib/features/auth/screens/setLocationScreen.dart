import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/authConstants.dart';
class SetLocationScreen extends ConsumerWidget {
 const SetLocationScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   body: Container(
    decoration: BoxDecoration(gradient: AppColors.primaryGradient),
    child: SafeArea(
     child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
        const Spacer(),
        Container(
         width: 160,
         height: 160,
         decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(80)),
         child: const Icon(Icons.location_on_rounded, size: 80, color: Colors.white),
        ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
        const SizedBox(height: 48),
        const Text(
         AuthConstants.enableLocationTitle,
         textAlign: TextAlign.center,
         style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        ).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: 16),
        const Text(
         AuthConstants.locationSubtitle,
         textAlign: TextAlign.center,
         style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
        ).animate().fadeIn(delay: 600.ms),
        const Spacer(),
        AppButton(text: AuthConstants.allowLocationButton, onPressed: () => context.go(Routes.enableBiometrics), backgroundColor: Colors.white, textColor: AppColors.primary, icon: Icons.my_location).animate().fadeIn(delay: 900.ms).slideY(begin: 0.3, end: 0),
        const SizedBox(height: 16),
        TextButton(
         onPressed: () => context.go(Routes.enableBiometrics),
         child: const Text(AuthConstants.skipForNowButton, style: TextStyle(color: Colors.white70, fontSize: 16)),
        ),
        const SizedBox(height: 24),
       ],
      ),
     ),
    ),
   ),
  );
 }
}