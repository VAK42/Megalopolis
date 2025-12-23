import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/authConstants.dart';
class CheckInboxScreen extends ConsumerWidget {
 const CheckInboxScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.login)),
   ),
   body: SafeArea(
    child: Padding(
     padding: const EdgeInsets.all(24.0),
     child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(60)),
        child: const Icon(Icons.email, size: 60, color: Colors.white),
       ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
       const SizedBox(height: 32),
       Text(AuthConstants.checkEmailTitle, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)).animate().fadeIn(delay: 300.ms),
       const SizedBox(height: 16),
       Text(
        AuthConstants.checkEmailSubtitle,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
       ).animate().fadeIn(delay: 600.ms),
       const SizedBox(height: 48),
       AppButton(text: AuthConstants.openEmailAppButton, onPressed: () {}, icon: Icons.open_in_new).animate().fadeIn(delay: 900.ms),
       const SizedBox(height: 16),
       TextButton(onPressed: () {}, child: const Text(AuthConstants.resendEmailButton)),
       const SizedBox(height: 24),
       TextButton(onPressed: () => context.go(Routes.login), child: const Text(AuthConstants.backToLoginButton)),
      ],
     ),
    ),
   ),
  );
 }
}