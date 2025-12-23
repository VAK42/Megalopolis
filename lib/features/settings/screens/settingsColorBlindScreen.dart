import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/settingsProvider.dart';
import '../constants/settingsConstants.dart';
class SettingsColorBlindScreen extends ConsumerStatefulWidget {
 const SettingsColorBlindScreen({super.key});
 @override
 ConsumerState<SettingsColorBlindScreen> createState() => _SettingsColorBlindScreenState();
}
class _SettingsColorBlindScreenState extends ConsumerState<SettingsColorBlindScreen> {
 String selectedMode = 'none';
 bool _initialized = false;
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final settingsAsync = ref.watch(colorBlindSettingsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(SettingsConstants.colorBlindMode),
   ),
   body: settingsAsync.when(
    data: (settings) {
     if (!_initialized) {
      selectedMode = settings['mode'] ?? 'none';
      _initialized = true;
     }
     return ListView(
      padding: const EdgeInsets.all(16),
      children: [
       const Text(SettingsConstants.colorBlindOptions, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
       const SizedBox(height: 16),
       _buildModeOption('none', SettingsConstants.none, SettingsConstants.defaultColorScheme),
       _buildModeOption('protanopia', SettingsConstants.protanopia, SettingsConstants.redGreenBlindness),
       _buildModeOption('deuteranopia', SettingsConstants.deuteranopia, SettingsConstants.greenBlindness),
       _buildModeOption('tritanopia', SettingsConstants.tritanopia, SettingsConstants.blueYellowBlindness),
      ],
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(SettingsConstants.errorLoadingSettings)),
   ),
  );
 }
 Widget _buildModeOption(String mode, String title, String subtitle) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final isSelected = selectedMode == mode;
  return Card(
   margin: const EdgeInsets.only(bottom: 12),
   child: ListTile(
    leading: Icon(isSelected ? Icons.check_circle : Icons.circle_outlined, color: isSelected ? AppColors.primary : Colors.grey),
    title: Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
    subtitle: Text(subtitle),
    onTap: () {
     setState(() => selectedMode = mode);
     ref.read(settingsRepositoryProvider).updateColorBlindSettings(userId, mode);
    },
   ),
  );
 }
}