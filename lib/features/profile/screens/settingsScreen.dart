import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../constants/profileConstants.dart';
class SettingsScreen extends ConsumerWidget {
 const SettingsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ProfileConstants.settings),
   ),
   body: ListView(
    padding: const EdgeInsets.all(16),
    children: [
     const Text(ProfileConstants.appPreferences, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     _buildSettingItem(context, Icons.language, ProfileConstants.language, ProfileConstants.english, () {}),
     _buildSettingItem(context, Icons.dark_mode, ProfileConstants.theme, ProfileConstants.systemDefault, () {}),
     _buildSettingItem(context, Icons.notifications, ProfileConstants.notifications, '', () {}),
     const SizedBox(height: 24),
     const Text(ProfileConstants.privacySecurity, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     _buildSettingItem(context, Icons.lock, ProfileConstants.changePassword, '', () {}),
     _buildSettingItem(context, Icons.fingerprint, ProfileConstants.biometricLogin, '', () {}),
     _buildSettingItem(context, Icons.privacy_tip, ProfileConstants.privacySettings, '', () {}),
     const SizedBox(height: 24),
     const Text(ProfileConstants.about, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     _buildSettingItem(context, Icons.info, ProfileConstants.appVersion, ProfileConstants.versionNumber, () {}),
     _buildSettingItem(context, Icons.description, ProfileConstants.termsOfService, '', () {}),
     _buildSettingItem(context, Icons.policy, ProfileConstants.privacyPolicy, '', () {}),
    ],
   ),
  );
 }
 Widget _buildSettingItem(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
  return Card(
   margin: const EdgeInsets.only(bottom: 8),
   child: ListTile(
    leading: Icon(icon, color: AppColors.primary),
    title: Text(title),
    subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    onTap: onTap,
   ),
  );
 }
}