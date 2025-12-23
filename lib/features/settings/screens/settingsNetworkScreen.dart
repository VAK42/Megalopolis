import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/settingsProvider.dart';
import '../constants/settingsConstants.dart';
class SettingsNetworkScreen extends ConsumerStatefulWidget {
 const SettingsNetworkScreen({super.key});
 @override
 ConsumerState<SettingsNetworkScreen> createState() => _SettingsNetworkScreenState();
}
class _SettingsNetworkScreenState extends ConsumerState<SettingsNetworkScreen> {
 bool wifiOnly = false;
 bool dataCompression = true;
 bool _initialized = false;
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final settingsAsync = ref.watch(networkSettingsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(SettingsConstants.networkPreferences),
   ),
   body: settingsAsync.when(
    data: (settings) {
     if (!_initialized) {
      wifiOnly = settings['wifiOnly'] == 1 || settings['wifiOnly'] == true;
      dataCompression = settings['dataCompression'] == 1 || settings['dataCompression'] == true;
      _initialized = true;
     }
     final dataUsed = settings['dataUsed'] ?? 0;
     return ListView(
      padding: const EdgeInsets.all(16),
      children: [
       SwitchListTile(
        title: const Text(SettingsConstants.wifiOnly),
        subtitle: const Text(SettingsConstants.useAppOnWifi),
        value: wifiOnly,
        onChanged: (v) {
         setState(() => wifiOnly = v);
         _saveSettings(userId);
        },
       ),
       SwitchListTile(
        title: const Text(SettingsConstants.dataCompression),
        subtitle: const Text(SettingsConstants.reduceDataUsage),
        value: dataCompression,
        onChanged: (v) {
         setState(() => dataCompression = v);
         _saveSettings(userId);
        },
       ),
       const SizedBox(height: 24),
       Card(
        child: Padding(
         padding: const EdgeInsets.all(16),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           const Text(SettingsConstants.dataUsageThisMonth, style: TextStyle(fontWeight: FontWeight.bold)),
           const SizedBox(height: 12),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             const Text(SettingsConstants.used),
             Text(
              '$dataUsed ${SettingsConstants.mb}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
             ),
            ],
           ),
           const SizedBox(height: 8),
           LinearProgressIndicator(value: dataUsed / 1000, backgroundColor: Colors.grey, valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary), minHeight: 8),
          ],
         ),
        ),
       ),
      ],
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(SettingsConstants.errorLoadingSettings)),
   ),
  );
 }
 void _saveSettings(String userId) {
  ref.read(settingsRepositoryProvider).updateNetworkSettings(userId, {'wifiOnly': wifiOnly, 'dataCompression': dataCompression});
 }
}