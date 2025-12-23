import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/settingsProvider.dart';
import '../constants/settingsConstants.dart';
class SettingsVoiceCommandsScreen extends ConsumerStatefulWidget {
 const SettingsVoiceCommandsScreen({super.key});
 @override
 ConsumerState<SettingsVoiceCommandsScreen> createState() => _SettingsVoiceCommandsScreenState();
}
class _SettingsVoiceCommandsScreenState extends ConsumerState<SettingsVoiceCommandsScreen> {
 bool voiceEnabled = false;
 String selectedLanguage = 'English';
 bool _initialized = false;
 final List<String> languages = [SettingsConstants.english, SettingsConstants.spanish, SettingsConstants.french];
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final settingsAsync = ref.watch(voiceSettingsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(SettingsConstants.voiceCommands),
   ),
   body: settingsAsync.when(
    data: (settings) {
     if (!_initialized) {
      voiceEnabled = settings['enabled'] == 1 || settings['enabled'] == true;
      selectedLanguage = settings['language'] ?? SettingsConstants.english;
      _initialized = true;
     }
     return ListView(
      padding: const EdgeInsets.all(16),
      children: [
       SwitchListTile(
        title: const Text(SettingsConstants.enableVoice),
        value: voiceEnabled,
        onChanged: (v) {
         setState(() => voiceEnabled = v);
         _saveSettings(userId);
        },
       ),
       const SizedBox(height: 24),
       const Text(SettingsConstants.voiceLanguage, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
       const SizedBox(height: 12),
       ...languages.map(
        (lang) => Card(
         margin: const EdgeInsets.only(bottom: 8),
         child: ListTile(
          leading: Icon(selectedLanguage == lang ? Icons.check_circle : Icons.circle_outlined, color: selectedLanguage == lang ? AppColors.primary : Colors.grey),
          title: Text(lang),
          onTap: () {
           setState(() => selectedLanguage = lang);
           _saveSettings(userId);
          },
         ),
        ),
       ),
       const SizedBox(height: 24),
       ElevatedButton.icon(
        onPressed: voiceEnabled
          ? () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(SettingsConstants.listeningForCommand)));
           }
          : null,
        icon: const Icon(Icons.mic),
        label: const Text(SettingsConstants.testVoice),
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.all(16)),
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
  ref.read(settingsRepositoryProvider).updateVoiceSettings(userId, {'enabled': voiceEnabled, 'language': selectedLanguage});
 }
}