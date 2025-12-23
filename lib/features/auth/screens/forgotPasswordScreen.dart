import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../shared/widgets/appTextField.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/authConstants.dart';
class ForgotPasswordScreen extends ConsumerStatefulWidget {
 const ForgotPasswordScreen({super.key});
 @override
 ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}
class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
 final emailController = TextEditingController();
 final formKey = GlobalKey<FormState>();
 bool isLoading = false;
 @override
 void dispose() {
  emailController.dispose();
  super.dispose();
 }
 void handleSubmit() {
  if (formKey.currentState!.validate()) {
   setState(() => isLoading = true);
   Future.delayed(const Duration(seconds: 2), () {
    if (mounted) {
     context.go(Routes.checkInbox);
    }
   });
  }
 }
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.login)),
   ),
   body: SafeArea(
    child: SingleChildScrollView(
     padding: const EdgeInsets.all(24.0),
     child: Form(
      key: formKey,
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Container(
         width: 80,
         height: 80,
         decoration: BoxDecoration(gradient: AppColors.accentGradient, borderRadius: BorderRadius.circular(40)),
         child: const Icon(Icons.lock_reset, size: 40, color: Colors.white),
        ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
        const SizedBox(height: 24),
        Text(AuthConstants.forgotPasswordTitle, style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)).animate().fadeIn().slideX(begin: -0.2, end: 0),
        const SizedBox(height: 12),
        Text(AuthConstants.forgotPasswordSubtitle, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600])).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 48),
        AppTextField(
         label: AuthConstants.emailAddressLabel,
         hint: AuthConstants.emailHintRegister,
         controller: emailController,
         keyboardType: TextInputType.emailAddress,
         prefixIcon: const Icon(Icons.email_outlined),
         validator: (value) {
          if (value == null || value.isEmpty) {
           return AuthConstants.enterEmailError;
          }
          if (!value.contains('@')) {
           return AuthConstants.enterValidEmailError;
          }
          return null;
         },
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
        const SizedBox(height: 32),
        AppButton(text: AuthConstants.sendResetLinkButton, onPressed: handleSubmit, isLoading: isLoading, icon: Icons.send).animate().fadeIn(delay: 600.ms),
        const SizedBox(height: 24),
        Center(
         child: TextButton(onPressed: () => context.go(Routes.login), child: const Text(AuthConstants.backToLoginButton)),
        ),
       ],
      ),
     ),
    ),
   ),
  );
 }
}