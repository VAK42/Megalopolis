import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/appButton.dart';
class NoInternetScreen extends ConsumerWidget {
  const NoInternetScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 120, color: Colors.grey[400]),
              const SizedBox(height: 32),
              const Text(
                'No Internet Connection!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Please Check Your Internet Connection And Try Again!',
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              AppButton(text: 'Retry', onPressed: () {}, icon: Icons.refresh),
            ],
          ),
        ),
      ),
    );
  }
}