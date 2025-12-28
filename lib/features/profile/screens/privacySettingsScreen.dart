import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/profileProvider.dart';
import '../constants/profileConstants.dart';
class PrivacySettingsScreen extends ConsumerStatefulWidget {
 const PrivacySettingsScreen({super.key});
 @override
 ConsumerState<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}
class _PrivacySettingsScreenState extends ConsumerState<PrivacySettingsScreen> {
 bool shareLocation = true;
 bool shareActivity = false;
 bool showOnlineStatus = true;
 bool allowMessages = true;
 bool allowCalls = true;
 bool dataCollection = false;
 bool personalizedAds = false;
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
    shareLocation = settings['shareLocation'] == 1;
    shareActivity = settings['shareActivity'] == 1;
    showOnlineStatus = settings['showOnlineStatus'] == 1;
    allowMessages = settings['allowMessages'] == 1;
    allowCalls = settings['allowCalls'] == 1;
    dataCollection = settings['dataCollection'] == 1;
    personalizedAds = settings['personalizedAds'] == 1;
   });
  }
 }
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ProfileConstants.privacySettings),
   ),
   body: ListView(
    padding: const EdgeInsets.all(16),
    children: [
     const Text(ProfileConstants.sharingVisibility, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     _buildSwitchTile(ProfileConstants.shareLocation, ProfileConstants.allowLocationAccess, shareLocation, (v) {
      setState(() => shareLocation = v);
      _saveSettings();
     }),
     _buildSwitchTile(ProfileConstants.shareActivity, ProfileConstants.shareActivityStatus, shareActivity, (v) {
      setState(() => shareActivity = v);
      _saveSettings();
     }),
     _buildSwitchTile(ProfileConstants.showOnlineStatus, ProfileConstants.letOthersSeeOnline, showOnlineStatus, (v) {
      setState(() => showOnlineStatus = v);
      _saveSettings();
     }),
     const SizedBox(height: 24),
     const Text(ProfileConstants.communication, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     _buildSwitchTile(ProfileConstants.allowMessages, ProfileConstants.receiveMessagesFromOthers, allowMessages, (v) {
      setState(() => allowMessages = v);
      _saveSettings();
     }),
     _buildSwitchTile(ProfileConstants.allowCalls, ProfileConstants.receiveVoiceVideoCalls, allowCalls, (v) {
      setState(() => allowCalls = v);
      _saveSettings();
     }),
     const SizedBox(height: 24),
     const Text(ProfileConstants.dataPersonalization, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     _buildSwitchTile(ProfileConstants.dataCollection, ProfileConstants.collectUsageData, dataCollection, (v) {
      setState(() => dataCollection = v);
      _saveSettings();
     }),
     _buildSwitchTile(ProfileConstants.personalizedAds, ProfileConstants.showAdsBasedOnInterests, personalizedAds, (v) {
      setState(() => personalizedAds = v);
      _saveSettings();
     }),
     const SizedBox(height: 24),
     Card(
      child: ListTile(
       leading: const Icon(Icons.delete_forever, color: AppColors.error),
       title: const Text(ProfileConstants.deleteAccount, style: TextStyle(color: AppColors.error)),
       subtitle: const Text(ProfileConstants.permanentlyDeleteAccount),
       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
       onTap: () {},
      ),
     ),
    ],
   ),
  );
 }
 void _saveSettings() {
  final userId = ref.read(currentUserIdProvider) ?? 'user1';
  ref.read(profileRepositoryProvider).updatePrivacySettings(userId, {'shareLocation': shareLocation ? 1 : 0, 'shareActivity': shareActivity ? 1 : 0, 'showOnlineStatus': showOnlineStatus ? 1 : 0, 'allowMessages': allowMessages ? 1 : 0, 'allowCalls': allowCalls ? 1 : 0, 'dataCollection': dataCollection ? 1 : 0, 'personalizedAds': personalizedAds ? 1 : 0});
 }
 Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
  return Card(
   margin: const EdgeInsets.only(bottom: 8),
   child: SwitchListTile(
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
    value: value,
    onChanged: onChanged,
    activeThumbColor: AppColors.primary,
   ),
  );
 }
}