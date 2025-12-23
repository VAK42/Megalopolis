import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../../core/constants/coreConstants.dart';
class QrErrorScreen extends ConsumerWidget {
 const QrErrorScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.scanQr)),
    title: const Text(CoreConstants.qrErrorTitle),
   ),
   body: SafeArea(
    child: Padding(
     padding: const EdgeInsets.all(24),
     child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(60)),
        child: const Icon(Icons.qr_code_scanner, size: 60, color: AppColors.error),
       ),
       const SizedBox(height: 32),
       Text(CoreConstants.invalidQrCode, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
       const SizedBox(height: 16),
       Text(
        CoreConstants.qrErrorMessage,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey[600]),
       ),
       const SizedBox(height: 48),
       AppButton(text: CoreConstants.tryAgain, onPressed: () => context.go(Routes.scanQr), icon: Icons.refresh),
       const SizedBox(height: 16),
       TextButton(onPressed: () => context.go(Routes.superDashboard), child: const Text(CoreConstants.backToHome)),
      ],
     ),
    ),
   ),
  );
 }
}