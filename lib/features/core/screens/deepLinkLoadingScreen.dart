import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../core/constants/coreConstants.dart';
class DeepLinkLoadingScreen extends ConsumerStatefulWidget {
 const DeepLinkLoadingScreen({super.key});
 @override
 ConsumerState<DeepLinkLoadingScreen> createState() => _DeepLinkLoadingScreenState();
}
class _DeepLinkLoadingScreenState extends ConsumerState<DeepLinkLoadingScreen> {
 @override
 void initState() {
  super.initState();
  Future.delayed(const Duration(seconds: 2), () {
   if (mounted) {
    context.go(Routes.superDashboard);
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
       const CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
       const SizedBox(height: 32),
       const Text(
        CoreConstants.loading,
        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
       ),
       const SizedBox(height: 12),
       Text(CoreConstants.deepLinkLoadingMessage, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
      ],
     ),
    ),
   ),
  );
 }
}