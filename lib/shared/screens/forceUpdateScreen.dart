import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/systemProvider.dart';
class ForceUpdateScreen extends ConsumerWidget {
 const ForceUpdateScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final settingsAsync = ref.watch(systemSettingsProvider);
  return Scaffold(
   body: SafeArea(
    child: settingsAsync.when(
     data: (settings) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
        Container(
         padding: const EdgeInsets.all(24),
         decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
         child: const Icon(Icons.system_update, size: 80, color: Colors.white),
        ),
        const SizedBox(height: 32),
        const Text(
         'Update Required',
         textAlign: TextAlign.center,
         style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
         'A New Version Of The App Is Available! Please Update To Continue Using The App!',
         style: TextStyle(color: Colors.grey.shade600),
         textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Container(
         padding: const EdgeInsets.all(16),
         decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
         child: Column(
          children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             const Text('Current Version'),
             Text('v${settings['minVersion'] ?? '1.0.0'}', style: TextStyle(color: Colors.grey[600])),
            ],
           ),
           const Divider(height: 24),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             const Text('Latest Version'),
             Text(
              'v${settings['latestVersion'] ?? '2.0.0'}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
             ),
            ],
           ),
          ],
         ),
        ),
        const SizedBox(height: 48),
        AppButton(text: 'Update Now', onPressed: () {}, icon: Icons.download),
       ],
      ),
     ),
     loading: () => const Center(child: CircularProgressIndicator()),
     error: (err, stack) => const Center(child: Text('Failed To Load Update Info')),
    ),
   ),
  );
 }
}