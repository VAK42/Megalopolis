import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../auth/constants/authConstants.dart';
import 'package:flutter_animate/flutter_animate.dart';
class SplashScreen extends ConsumerStatefulWidget {
 const SplashScreen({super.key});
 @override
 ConsumerState<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends ConsumerState<SplashScreen> {
 @override
 void initState() {
  super.initState();
  Future.delayed(const Duration(seconds: 3), () {
   if (mounted) {
    context.go(Routes.onboarding1);
   }
  });
 }
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   body: Container(
    decoration: BoxDecoration(gradient: AppColors.primaryGradient),
    child: Center(
     child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
       const SizedBox(height: 24),
       const Text(
        AuthConstants.appName,
        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2),
       ).animate().fadeIn(delay: 300.ms, duration: 600.ms),
       const SizedBox(height: 8),
       const Text(AuthConstants.appSlogan, style: TextStyle(fontSize: 16, color: Colors.white70, letterSpacing: 0.5)).animate().fadeIn(delay: 600.ms, duration: 600.ms),
      ],
     ),
    ),
   ),
  );
 }
}