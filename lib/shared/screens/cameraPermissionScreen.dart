import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/appButton.dart';
class CameraPermissionScreen extends ConsumerWidget {
  const CameraPermissionScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 120,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 32),
              const Text(
                'Camera Permission Required!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'We Need Access To Your Camera To Scan QR Codes And Take Photos!',
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              AppButton(
                text: 'Enable Camera',
                onPressed: () {},
                icon: Icons.camera,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Skip For Now!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}