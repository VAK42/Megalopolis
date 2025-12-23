import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/settingsProvider.dart';
import '../constants/settingsConstants.dart';
class SettingsAccessibilityScreen extends ConsumerStatefulWidget {
 const SettingsAccessibilityScreen({super.key});
 @override
 ConsumerState<SettingsAccessibilityScreen> createState() => _SettingsAccessibilityScreenState();
}
class _SettingsAccessibilityScreenState extends ConsumerState<SettingsAccessibilityScreen> {
 bool screenReader = false;
 bool highContrast = false;
 bool reducedMotion = false;
 bool _initialized = false;
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final settingsAsync = ref.watch(accessibilitySettingsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(SettingsConstants.accessibility),
   ),
   body: settingsAsync.when(
    data: (settings) {
     if (!_initialized) {
      screenReader = settings['screenReader'] == 1 || settings['screenReader'] == true;
      highContrast = settings['highContrast'] == 1 || settings['highContrast'] == true;
      reducedMotion = settings['reducedMotion'] == 1 || settings['reducedMotion'] == true;
      _initialized = true;
     }
     return ListView(
      padding: const EdgeInsets.all(16),
      children: [
       SwitchListTile(
        title: const Text(SettingsConstants.screenReader),
        subtitle: const Text(SettingsConstants.enableVoiceFeedback),
        value: screenReader,
        onChanged: (v) {
         setState(() => screenReader = v);
         _saveSettings(userId);
        },
       ),
       SwitchListTile(
        title: const Text(SettingsConstants.highContrast),
        subtitle: const Text(SettingsConstants.increaseContrast),
        value: highContrast,
        onChanged: (v) {
         setState(() => highContrast = v);
         _saveSettings(userId);
        },
       ),
       SwitchListTile(
        title: const Text(SettingsConstants.reducedMotion),
        subtitle: const Text(SettingsConstants.minimizeAnimations),
        value: reducedMotion,
        onChanged: (v) {
         setState(() => reducedMotion = v);
         _saveSettings(userId);
        },
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
  ref.read(settingsRepositoryProvider).updateAccessibilitySettings(userId, {'screenReader': screenReader, 'highContrast': highContrast, 'reducedMotion': reducedMotion});
 }
}