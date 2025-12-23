import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/settingsProvider.dart';
import '../constants/settingsConstants.dart';
class SettingsOfflineModeScreen extends ConsumerStatefulWidget {
 const SettingsOfflineModeScreen({super.key});
 @override
 ConsumerState<SettingsOfflineModeScreen> createState() => _SettingsOfflineModeScreenState();
}
class _SettingsOfflineModeScreenState extends ConsumerState<SettingsOfflineModeScreen> {
 bool offlineEnabled = false;
 bool _initialized = false;
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final settingsAsync = ref.watch(offlineSettingsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(SettingsConstants.offlineMode),
   ),
   body: settingsAsync.when(
    data: (settings) {
     if (!_initialized) {
      offlineEnabled = settings['enabled'] == 1 || settings['enabled'] == true;
      _initialized = true;
     }
     final downloadedMaps = settings['downloadedMaps'] ?? 0;
     final downloadedData = settings['downloadedData'] ?? 0;
     final lastSynced = settings['lastSynced'] ?? '';
     return ListView(
      padding: const EdgeInsets.all(16),
      children: [
       SwitchListTile(
        title: const Text(SettingsConstants.enableOffline),
        subtitle: const Text(SettingsConstants.downloadForOffline),
        value: offlineEnabled,
        onChanged: (v) {
         setState(() => offlineEnabled = v);
         ref.read(settingsRepositoryProvider).updateOfflineSettings(userId, {'enabled': v});
        },
       ),
       const SizedBox(height: 24),
       const Text(SettingsConstants.offlineContent, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
       const SizedBox(height: 12),
       Card(
        child: ListTile(
         title: const Text(SettingsConstants.downloadedMaps),
         trailing: Text('$downloadedMaps ${SettingsConstants.mb}', style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
       ),
       Card(
        child: ListTile(
         title: const Text(SettingsConstants.downloadedData),
         trailing: Text('$downloadedData ${SettingsConstants.mb}', style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
       ),
       const SizedBox(height: 24),
       Card(
        child: ListTile(
         title: const Text(SettingsConstants.lastSynced),
         subtitle: Text(lastSynced.isNotEmpty ? lastSynced : SettingsConstants.never),
         trailing: TextButton(
          onPressed: () async {
           await ref.read(settingsRepositoryProvider).syncOfflineData(userId);
           ref.invalidate(offlineSettingsProvider);
           if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(SettingsConstants.settingsSaved)));
          },
          child: const Text(SettingsConstants.syncNow),
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
}