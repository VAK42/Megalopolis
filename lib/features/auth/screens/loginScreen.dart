import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../shared/widgets/appTextField.dart';
import '../../../providers/authProvider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/authConstants.dart';
class LoginScreen extends ConsumerStatefulWidget {
 const LoginScreen({super.key});
 @override
 ConsumerState<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends ConsumerState<LoginScreen> {
 final emailController = TextEditingController();
 final passwordController = TextEditingController();
 final formKey = GlobalKey<FormState>();
 @override
 void dispose() {
  emailController.dispose();
  passwordController.dispose();
  super.dispose();
 }
 Future<void> handleLogin() async {
  if (formKey.currentState!.validate()) {
   await ref.read(authProvider.notifier).login(emailController.text, passwordController.text);
   final authState = ref.read(authProvider);
   authState.when(
    data: (user) {
     if (user != null) {
      ref.read(currentUserIdProvider.notifier).state = user.id;
      if (user.role == 'admin') {
       context.go(Routes.adminDashboard);
      } else {
       context.go(Routes.dashboard);
      }
     }
    },
    loading: () {},
    error: (error, stack) {
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AuthConstants.loginFailedPrefix}$error'), backgroundColor: AppColors.error));
    },
   );
  }
 }
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.welcome)),
   ),
   body: SafeArea(
    child: SingleChildScrollView(
     padding: const EdgeInsets.all(24.0),
     child: Form(
      key: formKey,
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Text(AuthConstants.welcomeBackTitle, style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)).animate().fadeIn().slideX(begin: -0.2, end: 0),
        const SizedBox(height: 12),
        Text(AuthConstants.loginSubtitle, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600])).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 48),
        AppTextField(
         label: AuthConstants.emailLabel,
         hint: AuthConstants.emailHint,
         controller: emailController,
         keyboardType: TextInputType.emailAddress,
         prefixIcon: const Icon(Icons.email_outlined),
         validator: (value) {
          if (value == null || value.isEmpty) {
           return AuthConstants.enterEmailError;
          }
          return null;
         },
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
        const SizedBox(height: 16),
        AppTextField(
         label: AuthConstants.passwordLabel,
         hint: AuthConstants.passwordHint,
         controller: passwordController,
         obscureText: true,
         prefixIcon: const Icon(Icons.lock_outlined),
         validator: (value) {
          if (value == null || value.isEmpty) {
           return AuthConstants.enterPasswordError;
          }
          return null;
         },
        ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
        const SizedBox(height: 24),
        Row(
         mainAxisAlignment: MainAxisAlignment.end,
         children: [TextButton(onPressed: () => context.go(Routes.forgotPassword), child: const Text(AuthConstants.forgotPasswordLink))],
        ),
        const SizedBox(height: 32),
        AppButton(text: AuthConstants.loginButton, onPressed: handleLogin, isLoading: ref.watch(authProvider).isLoading, icon: Icons.arrow_forward).animate().fadeIn(delay: 600.ms),
        const SizedBox(height: 24),
        Row(
         children: [
          const Expanded(child: Divider()),
          Padding(
           padding: const EdgeInsets.symmetric(horizontal: 16),
           child: Text(AuthConstants.orDivider, style: TextStyle(color: Colors.grey[600])),
          ),
          const Expanded(child: Divider()),
         ],
        ),
        const SizedBox(height: 24),
        OutlinedButton(
         onPressed: () {},
         style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          side: BorderSide(color: Colors.grey[300]!),
         ),
         child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Icon(Icons.g_mobiledata, size: 28, color: Colors.grey[700]),
           const SizedBox(width: 12),
           const Text(AuthConstants.continueWithGoogle),
          ],
         ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
         onPressed: () {},
         style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          side: BorderSide(color: Colors.grey[300]!),
         ),
         child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Icon(Icons.apple, size: 24, color: Colors.grey[700]),
           const SizedBox(width: 12),
           const Text(AuthConstants.continueWithApple),
          ],
         ),
        ),
        const SizedBox(height: 32),
        Center(
         child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Text(AuthConstants.noAccountText, style: TextStyle(color: Colors.grey[600])),
           TextButton(onPressed: () => context.go(Routes.register), child: const Text(AuthConstants.signUpButton)),
          ],
         ),
        ),
       ],
      ),
     ),
    ),
   ),
  );
 }
}