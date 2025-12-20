import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
class NotFoundScreen extends ConsumerWidget {
  const NotFoundScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 120, color: Colors.grey[400]),
              const SizedBox(height: 32),
              const Text(
                '404',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Page Not Found!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'The Page You Are Looking For Does Not Exist Or Has Been Moved!',
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              AppButton(
                text: 'Go Home',
                onPressed: () => context.go(Routes.splash),
                icon: Icons.home,
              ),
            ],
          ),
        ),
      ),
    );
  }
}