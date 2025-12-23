import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../shared/widgets/appTextField.dart';
import '../../../providers/authProvider.dart';
import '../../../shared/models/userModel.dart';
import '../../auth/constants/authConstants.dart';
import 'package:flutter_animate/flutter_animate.dart';
class RegisterScreen extends ConsumerStatefulWidget {
 const RegisterScreen({super.key});
 @override
 ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}
class _RegisterScreenState extends ConsumerState<RegisterScreen> {
 final nameController = TextEditingController();
 final emailController = TextEditingController();
 final phoneController = TextEditingController();
 final passwordController = TextEditingController();
 final formKey = GlobalKey<FormState>();
 bool obscurePassword = true;
 @override
 void dispose() {
  nameController.dispose();
  emailController.dispose();
  phoneController.dispose();
  passwordController.dispose();
  super.dispose();
 }
 Future<void> handleRegister() async {
  if (formKey.currentState!.validate()) {
   final now = DateTime.now();
   final newUser = UserModel(id: 'user_${now.millisecondsSinceEpoch}', role: AuthConstants.defaultUserRole, name: nameController.text, email: emailController.text, phone: phoneController.text, createdAt: now, updatedAt: now);
   await ref.read(authProvider.notifier).register(newUser);
   final authState = ref.read(authProvider);
   authState.when(
    data: (user) {
     if (user != null) {
      ref.read(currentUserIdProvider.notifier).state = user.id;
      context.go(Routes.accountCreated);
     }
    },
    loading: () {},
    error: (error, stack) {
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AuthConstants.registrationFailedPrefix}$error'), backgroundColor: AppColors.error));
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
        Text(AuthConstants.createAccountTitle, style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)).animate().fadeIn().slideX(begin: -0.2, end: 0),
        const SizedBox(height: 12),
        Text(AuthConstants.signUpSubtitle, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600])).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 32),
        AppTextField(
         label: AuthConstants.fullNameLabel,
         hint: AuthConstants.fullNameHint,
         controller: nameController,
         prefixIcon: const Icon(Icons.person_outline),
         validator: (value) {
          if (value == null || value.isEmpty) {
           return AuthConstants.enterNameError;
          }
          return null;
         },
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
        const SizedBox(height: 16),
        AppTextField(
         label: AuthConstants.emailLabel,
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
        const SizedBox(height: 16),
        AppTextField(
         label: AuthConstants.phoneLabel,
         hint: AuthConstants.phoneHint,
         controller: phoneController,
         keyboardType: TextInputType.phone,
         prefixIcon: const Icon(Icons.phone_outlined),
         validator: (value) {
          if (value == null || value.isEmpty) {
           return AuthConstants.enterPhoneError;
          }
          return null;
         },
        ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
        const SizedBox(height: 16),
        AppTextField(
         label: AuthConstants.passwordLabel,
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
        ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
        const SizedBox(height: 32),
        AppButton(text: AuthConstants.createAccountButton, onPressed: handleRegister, isLoading: ref.watch(authProvider).isLoading, icon: Icons.arrow_forward).animate().fadeIn(delay: 700.ms),
        const SizedBox(height: 24),
        Center(
         child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Text(AuthConstants.hasAccountText, style: TextStyle(color: Colors.grey[600])),
           TextButton(onPressed: () => context.go(Routes.login), child: const Text(AuthConstants.signInButton)),
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