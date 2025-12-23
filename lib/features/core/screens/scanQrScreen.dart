import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../core/constants/coreConstants.dart';
class ScanQrScreen extends ConsumerWidget {
 const ScanQrScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   body: Stack(
    children: [
     Container(
      decoration: BoxDecoration(
       gradient: LinearGradient(colors: [Colors.black, Colors.grey[900]!], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
     ),
     SafeArea(
      child: Column(
       children: [
        Padding(
         padding: const EdgeInsets.all(16),
         child: Row(
          children: [
           IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => context.go(Routes.superDashboard),
           ),
           const Spacer(),
           const Text(
            CoreConstants.scanQrTitle,
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
           ),
           const Spacer(),
           IconButton(
            icon: const Icon(Icons.flash_off, color: Colors.white),
            onPressed: () {},
           ),
          ],
         ),
        ),
        const Spacer(),
        Center(
         child: Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
           border: Border.all(color: AppColors.primary, width: 3),
           borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
           children: [
            Positioned(
             top: -3,
             left: -3,
             child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
               color: AppColors.primary,
               borderRadius: BorderRadius.only(topLeft: Radius.circular(18)),
              ),
             ),
            ),
            Positioned(
             top: -3,
             right: -3,
             child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
               color: AppColors.primary,
               borderRadius: BorderRadius.only(topRight: Radius.circular(18)),
              ),
             ),
            ),
            Positioned(
             bottom: -3,
             left: -3,
             child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
               color: AppColors.primary,
               borderRadius: BorderRadius.only(bottomLeft: Radius.circular(18)),
              ),
             ),
            ),
            Positioned(
             bottom: -3,
             right: -3,
             child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
               color: AppColors.primary,
               borderRadius: BorderRadius.only(bottomRight: Radius.circular(18)),
              ),
             ),
            ),
           ],
          ),
         ),
        ),
        const SizedBox(height: 32),
        const Text(CoreConstants.positionQrFrame, style: TextStyle(color: Colors.white70, fontSize: 16)),
        const Spacer(),
        Padding(
         padding: const EdgeInsets.all(24),
         child: Column(
          children: [
           OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.photo_library, color: Colors.white),
            label: const Text(CoreConstants.uploadFromGallery, style: TextStyle(color: Colors.white)),
            style: OutlinedButton.styleFrom(
             side: const BorderSide(color: Colors.white),
             minimumSize: const Size(double.infinity, 48),
            ),
           ),
           const SizedBox(height: 12),
           TextButton(
            onPressed: () => context.go(Routes.qrError),
            child: const Text(CoreConstants.troubleScanning, style: TextStyle(color: Colors.white70)),
           ),
          ],
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