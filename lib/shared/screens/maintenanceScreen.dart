import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/systemProvider.dart';
class MaintenanceScreen extends ConsumerWidget {
 const MaintenanceScreen({super.key});
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
        Icon(Icons.construction, size: 120, color: Colors.grey[400]),
        const SizedBox(height: 32),
        const Text(
         'Under Maintenance!',
         textAlign: TextAlign.center,
         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
         settings['maintenanceMessage'] ?? 'We Are Currently Performing Scheduled Maintenance! We Will Be Back Soon!',
         style: TextStyle(color: Colors.grey.shade600),
         textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Container(
         padding: const EdgeInsets.all(16),
         decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
         child: Column(
          children: [
           const Text('Estimated Time:', style: TextStyle(fontWeight: FontWeight.bold)),
           const SizedBox(height: 8),
           Text(
            settings['maintenanceEta'] ?? 'Unknown',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
           ),
          ],
         ),
        ),
        const SizedBox(height: 48),
        AppButton(text: 'Check Again', onPressed: () => ref.refresh(systemSettingsProvider), icon: Icons.refresh),
       ],
      ),
     ),
     loading: () => const Center(child: CircularProgressIndicator()),
     error: (err, stack) => const Center(child: Text('Failed To Load Status')),
    ),
   ),
  );
 }
}