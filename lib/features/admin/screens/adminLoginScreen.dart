import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/routeNames.dart';
import '../../../core/theme/colors.dart';
import '../constants/adminConstants.dart';
class AdminLoginScreen extends ConsumerStatefulWidget {
 const AdminLoginScreen({super.key});
 @override
 ConsumerState<AdminLoginScreen> createState() => _AdminLoginScreenState();
}
class _AdminLoginScreenState extends ConsumerState<AdminLoginScreen> {
 final TextEditingController emailController = TextEditingController();
 final TextEditingController passwordController = TextEditingController();
 bool obscurePassword = true;
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   body: SafeArea(
    child: SingleChildScrollView(
     padding: const EdgeInsets.all(24),
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       const SizedBox(height: 60),
       Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.admin_panel_settings, size: 40, color: Colors.white),
       ),
       const SizedBox(height: 24),
       const Text(AdminConstants.loginTitle, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
       const SizedBox(height: 8),
       const Text(AdminConstants.loginSubtitle, style: TextStyle(color: Colors.grey)),
       const SizedBox(height: 48),
       TextField(
        controller: emailController,
        decoration: InputDecoration(
         labelText: AdminConstants.emailLabel,
         prefixIcon: const Icon(Icons.email),
         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        keyboardType: TextInputType.emailAddress,
       ),
       const SizedBox(height: 16),
       TextField(
        controller: passwordController,
        obscureText: obscurePassword,
        decoration: InputDecoration(
         labelText: AdminConstants.passwordLabel,
         prefixIcon: const Icon(Icons.lock),
         suffixIcon: IconButton(icon: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => obscurePassword = !obscurePassword)),
         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
       ),
       const SizedBox(height: 24),
       SizedBox(
        width: double.infinity,
        child: ElevatedButton(
         onPressed: () => context.go(Routes.adminDashboard),
         style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
         child: const Text(AdminConstants.signInButton),
        ),
       ),
      ],
     ),
    ),
   ),
  );
 }
}