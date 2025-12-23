import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../constants/walletConstants.dart';
class WalletScanScreen extends ConsumerWidget {
 const WalletScanScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   backgroundColor: Colors.black,
   appBar: AppBar(
    backgroundColor: Colors.transparent,
    leading: IconButton(
     icon: const Icon(Icons.close, color: Colors.white),
     onPressed: () => context.pop(),
    ),
    title: const Text(WalletConstants.scanQr, style: TextStyle(color: Colors.white)),
    actions: [
     IconButton(
      icon: const Icon(Icons.flash_off, color: Colors.white),
      onPressed: () {},
     ),
    ],
   ),
   body: Stack(
    children: [
     Center(
      child: Container(
       width: 300,
       height: 300,
       decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(16),
       ),
       child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
         color: Colors.grey[900],
         child: const Center(child: Icon(Icons.qr_code_scanner, size: 100, color: Colors.white54)),
        ),
       ),
      ),
     ),
     Positioned(
      top: 50,
      left: 0,
      right: 0,
      child: Container(
       margin: const EdgeInsets.symmetric(horizontal: 32),
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(12)),
       child: const Text(
        WalletConstants.scanQr,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
       ),
      ),
     ),
     Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: Column(
       children: [
        Container(
         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
         decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(25)),
         child: GestureDetector(
          onTap: () => context.go(Routes.walletMyQr),
          child: const Text(
           WalletConstants.myQrCode,
           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
         ),
        ),
       ],
      ),
     ),
    ],
   ),
  );
 }
}