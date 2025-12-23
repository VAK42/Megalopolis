import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/authConstants.dart';
class WelcomeScreen extends StatelessWidget {
 const WelcomeScreen({super.key});
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   body: Container(
    decoration: const BoxDecoration(color: AppColors.primary),
    child: SafeArea(
     child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
       children: [
        const Spacer(),
        Container(
         width: 120,
         height: 120,
         decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, spreadRadius: 5)],
         ),
         child: const Icon(Icons.location_city, size: 60, color: AppColors.primary),
        ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
        const SizedBox(height: 32),
        const Text(
         AuthConstants.welcomeToTitle,
         textAlign: TextAlign.center,
         style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2),
        ).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: 16),
        const Text(
         AuthConstants.welcomeSubtitle,
         textAlign: TextAlign.center,
         style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
        ).animate().fadeIn(delay: 600.ms),
        const Spacer(),
        AppButton(text: AuthConstants.createAccountButton, onPressed: () => context.go(Routes.register), backgroundColor: Colors.white, textColor: AppColors.primary).animate().fadeIn(delay: 900.ms).slideY(begin: 0.3, end: 0),
        const SizedBox(height: 16),
        AppButton(text: AuthConstants.signInButton, onPressed: () => context.go(Routes.login), isOutline: true, backgroundColor: Colors.white).animate().fadeIn(delay: 1100.ms).slideY(begin: 0.3, end: 0),
        const SizedBox(height: 24),
       ],
      ),
     ),
    ),
   ),
  );
 }
}