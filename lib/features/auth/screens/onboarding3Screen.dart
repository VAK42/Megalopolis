import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../../auth/constants/authConstants.dart';
import 'package:flutter_animate/flutter_animate.dart';
class Onboarding3Screen extends StatelessWidget {
 const Onboarding3Screen({super.key});
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   body: SafeArea(
    child: Padding(
     padding: const EdgeInsets.all(24.0),
     child: Column(
      children: [
       Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
          child: Text(
           AuthConstants.onboardingSteps[2]['step'],
           style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
          ),
         ),
         TextButton(
          onPressed: () => context.go(Routes.welcome),
          child: const Text(AuthConstants.skipButton, style: TextStyle(fontSize: 16)),
         ),
        ],
       ),
       const Spacer(),
       Container(
        width: 280,
        height: 280,
        decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(140)),
        child: Icon(AuthConstants.onboardingSteps[2]['icon'], size: 120, color: Colors.white),
       ).animate().scale(duration: 600.ms, curve: Curves.easeOut),
       const SizedBox(height: 48),
       Text(
        AuthConstants.onboardingSteps[2]['title'],
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
       ).animate().fadeIn(delay: 300.ms),
       const SizedBox(height: 16),
       Text(
        AuthConstants.onboardingSteps[2]['description'],
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
       ).animate().fadeIn(delay: 600.ms),
       const Spacer(),
       Row(mainAxisAlignment: MainAxisAlignment.center, children: [_buildDot(false), const SizedBox(width: 8), _buildDot(false), const SizedBox(width: 8), _buildDot(true)]),
       const SizedBox(height: 24),
       AppButton(text: AuthConstants.getStartedButton, onPressed: () => context.go(Routes.welcome), icon: Icons.check_circle_outline),
       const SizedBox(height: 16),
      ],
     ),
    ),
   ),
  );
 }
 Widget _buildDot(bool isActive) {
  return Container(
   width: isActive ? 32 : 8,
   height: 8,
   decoration: BoxDecoration(color: isActive ? AppColors.primary : Colors.grey[300], borderRadius: BorderRadius.circular(4)),
  );
 }
}