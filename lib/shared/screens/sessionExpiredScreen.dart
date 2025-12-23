import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
class SessionExpiredScreen extends ConsumerWidget {
 const SessionExpiredScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   body: SafeArea(
    child: Padding(
     padding: const EdgeInsets.all(24),
     child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       Icon(Icons.lock_clock, size: 120, color: Colors.grey[400]),
       const SizedBox(height: 32),
       const Text(
        'Session Expired',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
       ),
       const SizedBox(height: 12),
       Text(
        'Your Session Has Expired For Security Reasons! Please Log In Again To Continue!',
        style: TextStyle(color: Colors.grey.shade600),
        textAlign: TextAlign.center,
       ),
       const SizedBox(height: 48),
       AppButton(text: 'Log In Again', onPressed: () => context.go(Routes.login), icon: Icons.login),
      ],
     ),
    ),
   ),
  );
 }
}