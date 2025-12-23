import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/authProvider.dart';
import '../constants/walletConstants.dart';
class WalletMyQrScreen extends ConsumerWidget {
 const WalletMyQrScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? WalletConstants.defaultUserId;
  final userAsync = ref.watch(authProvider);
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(WalletConstants.myQrCode),
   ),
   body: Center(
    child: Padding(
     padding: const EdgeInsets.all(24),
     child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(16),
         boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), blurRadius: 10)],
        ),
        child: Column(
         children: [
          Container(
           width: 200,
           height: 200,
           decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!)),
           child: const Icon(Icons.qr_code_2, size: 180),
          ),
          const SizedBox(height: 16),
          userAsync.when(
           data: (user) => Text(user?.name ?? WalletConstants.unknown, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
           loading: () => const Text(WalletConstants.loading),
           error: (_, __) => const Text(WalletConstants.errorText),
          ),
          const SizedBox(height: 8),
          Text('${WalletConstants.idPrefix} $userId', style: TextStyle(color: Colors.grey[600])),
         ],
        ),
       ),
       const SizedBox(height: 24),
       const Text(WalletConstants.scanToPay, style: TextStyle(fontSize: 16, color: Colors.grey)),
      ],
     ),
    ),
   ),
  );
 }
}