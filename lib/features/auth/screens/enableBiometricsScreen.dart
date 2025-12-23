import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/authConstants.dart';
class EnableBiometricsScreen extends ConsumerWidget {
 const EnableBiometricsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   body: Container(
    decoration: BoxDecoration(gradient: AppColors.successGradient),
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
         child: const Icon(Icons.fingerprint, size: 80, color: Colors.white),
        ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
        const SizedBox(height: 48),
        const Text(
         AuthConstants.secureWithBiometricsTitle,
         textAlign: TextAlign.center,
         style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        ).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: 16),
        const Text(
         AuthConstants.biometricsSubtitle,
         textAlign: TextAlign.center,
         style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
        ).animate().fadeIn(delay: 600.ms),
        const Spacer(),
        AppButton(text: AuthConstants.enableBiometricsButton, onPressed: () => context.go(Routes.accountCreated), backgroundColor: Colors.white, textColor: AppColors.success, icon: Icons.verified_user).animate().fadeIn(delay: 900.ms).slideY(begin: 0.3, end: 0),
        const SizedBox(height: 16),
        TextButton(
         onPressed: () => context.go(Routes.accountCreated),
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