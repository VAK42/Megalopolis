import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../shared/widgets/appTextField.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/authConstants.dart';
class CreatePasswordScreen extends ConsumerStatefulWidget {
 const CreatePasswordScreen({super.key});
 @override
 ConsumerState<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}
class _CreatePasswordScreenState extends ConsumerState<CreatePasswordScreen> {
 final passwordController = TextEditingController();
 final confirmPasswordController = TextEditingController();
 final formKey = GlobalKey<FormState>();
 bool isLoading = false;
 bool obscurePassword = true;
 bool obscureConfirmPassword = true;
 @override
 void dispose() {
  passwordController.dispose();
  confirmPasswordController.dispose();
  super.dispose();
 }
 void handleSubmit() {
  if (formKey.currentState!.validate()) {
   setState(() => isLoading = true);
   Future.delayed(const Duration(seconds: 2), () {
    if (mounted) {
     context.go(Routes.login);
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
         decoration: BoxDecoration(gradient: AppColors.successGradient, borderRadius: BorderRadius.circular(40)),
         child: const Icon(Icons.vpn_key, size: 40, color: Colors.white),
        ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
        const SizedBox(height: 24),
        Text(AuthConstants.createNewPasswordTitle, style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)).animate().fadeIn().slideX(begin: -0.2, end: 0),
        const SizedBox(height: 12),
        Text(AuthConstants.createNewPasswordSubtitle, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600])).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 48),
        AppTextField(
         label: AuthConstants.newPasswordLabel,
         hint: '********',
         controller: passwordController,
         obscureText: obscurePassword,
         prefixIcon: const Icon(Icons.lock_outline),
         suffixIcon: IconButton(icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => obscurePassword = !obscurePassword)),
         validator: (value) {
          if (value == null || value.isEmpty) {
           return AuthConstants.enterValidPasswordError;
          }
          if (value.length < 6) {
           return AuthConstants.passwordMinLengthError;
          }
          return null;
         },
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
        const SizedBox(height: 16),
        AppTextField(
         label: AuthConstants.confirmPasswordLabel,
         hint: '********',
         controller: confirmPasswordController,
         obscureText: obscureConfirmPassword,
         prefixIcon: const Icon(Icons.lock_outline),
         suffixIcon: IconButton(icon: Icon(obscureConfirmPassword ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => obscureConfirmPassword = !obscureConfirmPassword)),
         validator: (value) {
          if (value == null || value.isEmpty) {
           return AuthConstants.confirmPasswordError;
          }
          if (value != passwordController.text) {
           return AuthConstants.passwordsNoMatchError;
          }
          return null;
         },
        ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
        const SizedBox(height: 32),
        AppButton(text: AuthConstants.resetPasswordButton, onPressed: handleSubmit, isLoading: isLoading, icon: Icons.check).animate().fadeIn(delay: 600.ms),
       ],
      ),
     ),
    ),
   ),
  );
 }
}