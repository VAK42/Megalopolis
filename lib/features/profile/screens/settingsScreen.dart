import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../core/database/databaseHelper.dart';
import '../../../core/database/databaseSeeder.dart';
import '../../../providers/authProvider.dart';
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
     _buildSettingItem(context, Icons.language, ProfileConstants.language, ProfileConstants.english, () => context.go(Routes.profileLanguage)),
     _buildSettingItem(context, Icons.dark_mode, ProfileConstants.theme, ProfileConstants.systemDefault, () => context.go(Routes.profileTheme)),
     _buildSettingItem(context, Icons.notifications, ProfileConstants.notifications, '', () => context.go(Routes.notificationSettings)),
     const SizedBox(height: 24),
     const Text(ProfileConstants.privacySecurity, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     _buildSettingItem(context, Icons.lock, ProfileConstants.changePassword, '', () => context.go(Routes.profileSecurity)),
     _buildSettingItem(context, Icons.fingerprint, ProfileConstants.biometricLogin, '', () => context.go(Routes.profileSecurity)),
     _buildSettingItem(context, Icons.privacy_tip, ProfileConstants.privacySettings, '', () => context.go(Routes.privacySettings)),
     const SizedBox(height: 24),
     const Text(ProfileConstants.about, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     _buildSettingItem(context, Icons.info, ProfileConstants.appVersion, ProfileConstants.versionNumber, () => context.go(Routes.about)),
     _buildSettingItem(context, Icons.description, ProfileConstants.termsOfService, '', () => context.go(Routes.about)),
     _buildSettingItem(context, Icons.policy, ProfileConstants.privacyPolicy, '', () => context.go(Routes.about)),
     const SizedBox(height: 24),
     const Text(ProfileConstants.developerOptions, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     _buildDangerSettingItem(context, Icons.restart_alt, ProfileConstants.resetDatabase, ProfileConstants.clearAllDataAndReseed, () => _showResetDialog(context, ref)),
    ],
   ),
  );
 }
 void _showResetDialog(BuildContext context, WidgetRef ref) {
  showDialog(
   context: context,
   builder: (ctx) => AlertDialog(
    title: const Text(ProfileConstants.resetDatabaseQuestion),
    content: const Text(ProfileConstants.resetDatabaseWarning),
    actions: [
     TextButton(onPressed: () => Navigator.pop(ctx), child: const Text(ProfileConstants.cancel)),
     TextButton(
      onPressed: () async {
       Navigator.pop(ctx);
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(ProfileConstants.resettingDatabase)));
       await DatabaseHelper.instance.resetDatabase();
       await DatabaseSeeder().seed();
       ref.read(currentUserIdProvider.notifier).state = null;
       ref.invalidate(authProvider);
       if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(ProfileConstants.databaseResetComplete), backgroundColor: AppColors.success));
        context.go(Routes.welcome);
       }
      },
      child: const Text(ProfileConstants.reset, style: TextStyle(color: AppColors.error)),
     ),
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
 Widget _buildDangerSettingItem(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
  return Card(
   margin: const EdgeInsets.only(bottom: 8),
   color: AppColors.error.withValues(alpha: 0.1),
   child: ListTile(
    leading: Icon(icon, color: AppColors.error),
    title: Text(title, style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
    subtitle: Text(subtitle, style: TextStyle(color: AppColors.error.withValues(alpha: 0.7))),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.error),
    onTap: onTap,
   ),
  );
 }
}