import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/profileProvider.dart';
import '../constants/profileConstants.dart';
class ThemeScreen extends ConsumerStatefulWidget {
 const ThemeScreen({super.key});
 @override
 ConsumerState<ThemeScreen> createState() => _ThemeScreenState();
}
class _ThemeScreenState extends ConsumerState<ThemeScreen> {
 String selectedTheme = ProfileConstants.systemDefault;
 bool _loaded = false;
 @override
 void didChangeDependencies() {
  super.didChangeDependencies();
  if (!_loaded) {
   _loadSettings();
   _loaded = true;
  }
 }
 void _loadSettings() async {
  final userId = ref.read(currentUserIdProvider) ?? 'user1';
  final settings = await ref.read(profileRepositoryProvider).getUserSettings(userId);
  if (settings != null && mounted) {
   final theme = settings['theme']?.toString() ?? ProfileConstants.systemDefault;
   setState(() => selectedTheme = theme);
  }
 }
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ProfileConstants.theme),
   ),
   body: RadioGroup<String>(
    groupValue: selectedTheme,
    onChanged: (value) {
     if (value != null) {
      setState(() => selectedTheme = value);
      final userId = ref.read(currentUserIdProvider) ?? 'user1';
      ref.read(profileRepositoryProvider).updateUserSettings(userId, {'theme': value});
     }
    },
    child: ListView(
     padding: const EdgeInsets.all(16),
     children: [
      _buildThemeOption(ProfileConstants.light, Icons.light_mode, ProfileConstants.alwaysUseLightTheme),
      _buildThemeOption(ProfileConstants.dark, Icons.dark_mode, ProfileConstants.alwaysUseDarkTheme),
      _buildThemeOption(ProfileConstants.systemDefault, Icons.settings_suggest, ProfileConstants.followSystemSettings),
     ],
    ),
   ),
  );
 }
 Widget _buildThemeOption(String title, IconData icon, String subtitle) {
  final isSelected = selectedTheme == title;
  return Card(
   margin: const EdgeInsets.only(bottom: 12),
   child: RadioListTile<String>(
    title: Row(
     children: [
      Icon(icon, color: isSelected ? AppColors.primary : Colors.grey),
      const SizedBox(width: 12),
      Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
     ],
    ),
    subtitle: Padding(
     padding: const EdgeInsets.only(left: 36),
     child: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
    ),
    value: title,
    activeColor: AppColors.primary,
   ),
  );
 }
}