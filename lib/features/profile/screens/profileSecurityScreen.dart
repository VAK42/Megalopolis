import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/profileProvider.dart';
import '../constants/profileConstants.dart';
class ProfileSecurityScreen extends ConsumerStatefulWidget {
 const ProfileSecurityScreen({super.key});
 @override
 ConsumerState<ProfileSecurityScreen> createState() => _ProfileSecurityScreenState();
}
class _ProfileSecurityScreenState extends ConsumerState<ProfileSecurityScreen> {
 bool twoFactorAuth = false;
 bool biometricLogin = true;
 bool loginAlerts = true;
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
   setState(() {
    twoFactorAuth = settings['twoFactorAuth'] == 1;
    biometricLogin = settings['biometricLogin'] == 1;
    loginAlerts = settings['loginAlerts'] == 1;
   });
  }
 }
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ProfileConstants.security),
   ),
   body: ListView(
    padding: const EdgeInsets.all(16),
    children: [
     _buildSwitchTile(ProfileConstants.twoFactorAuth, ProfileConstants.extraLayerSecurity, twoFactorAuth, (value) {
      setState(() => twoFactorAuth = value);
      _saveSecuritySettings();
     }),
     _buildSwitchTile(ProfileConstants.biometricLogin, ProfileConstants.useFingerprintFace, biometricLogin, (value) {
      setState(() => biometricLogin = value);
      _saveSecuritySettings();
     }),
     _buildSwitchTile(ProfileConstants.loginAlerts, ProfileConstants.getNotifiedLogins, loginAlerts, (value) {
      setState(() => loginAlerts = value);
      _saveSecuritySettings();
     }),
     const SizedBox(height: 24),
     Card(
      child: ListTile(
       leading: const Icon(Icons.lock_reset, color: AppColors.primary),
       title: const Text(ProfileConstants.changePassword),
       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
       onTap: () {},
      ),
     ),
     const SizedBox(height: 8),
     Card(
      child: ListTile(
       leading: const Icon(Icons.devices, color: AppColors.primary),
       title: const Text(ProfileConstants.activeSessions),
       subtitle: const Text(ProfileConstants.manageDevices),
       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
       onTap: () {},
      ),
     ),
    ],
   ),
  );
 }
 void _saveSecuritySettings() {
  final userId = ref.read(currentUserIdProvider) ?? 'user1';
  ref.read(profileRepositoryProvider).updateSecuritySettings(userId, {'twoFactorAuth': twoFactorAuth ? 1 : 0, 'biometricLogin': biometricLogin ? 1 : 0, 'loginAlerts': loginAlerts ? 1 : 0});
 }
 Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
  return Card(
   margin: const EdgeInsets.only(bottom: 8),
   child: SwitchListTile(
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
    value: value,
    onChanged: onChanged,
    activeTrackColor: AppColors.primary,
   ),
  );
 }
}