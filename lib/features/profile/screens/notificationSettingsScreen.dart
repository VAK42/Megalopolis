import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/profileProvider.dart';
import '../constants/profileConstants.dart';
class NotificationSettingsScreen extends ConsumerStatefulWidget {
 const NotificationSettingsScreen({super.key});
 @override
 ConsumerState<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}
class _NotificationSettingsScreenState extends ConsumerState<NotificationSettingsScreen> {
 bool pushNotifications = true;
 bool emailNotifications = false;
 bool smsNotifications = false;
 bool orderUpdates = true;
 bool promotions = false;
 bool rideUpdates = true;
 bool chatMessages = true;
 bool sound = true;
 bool vibration = true;
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
    pushNotifications = settings['pushNotifications'] == 1;
    emailNotifications = settings['emailNotifications'] == 1;
    smsNotifications = settings['smsNotifications'] == 1;
    orderUpdates = settings['orderUpdates'] == 1;
    promotions = settings['promotions'] == 1;
    rideUpdates = settings['rideUpdates'] == 1;
    chatMessages = settings['chatMessages'] == 1;
    sound = settings['sound'] == 1;
    vibration = settings['vibration'] == 1;
   });
  }
 }
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ProfileConstants.notificationSettings),
   ),
   body: ListView(
    padding: const EdgeInsets.all(16),
    children: [
     const Text(ProfileConstants.notificationChannels, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     _buildSwitchTile(ProfileConstants.pushNotifications, ProfileConstants.receivePushNotifications, pushNotifications, (v) {
      setState(() => pushNotifications = v);
      _saveSettings();
     }),
     _buildSwitchTile(ProfileConstants.emailNotifications, ProfileConstants.receiveEmailUpdates, emailNotifications, (v) {
      setState(() => emailNotifications = v);
      _saveSettings();
     }),
     _buildSwitchTile(ProfileConstants.smsNotifications, ProfileConstants.receiveSmsAlerts, smsNotifications, (v) {
      setState(() => smsNotifications = v);
      _saveSettings();
     }),
     const SizedBox(height: 24),
     const Text(ProfileConstants.notificationTypes, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     _buildSwitchTile(ProfileConstants.orderUpdates, ProfileConstants.foodShoppingOrderStatus, orderUpdates, (v) {
      setState(() => orderUpdates = v);
      _saveSettings();
     }),
     _buildSwitchTile(ProfileConstants.promotionsOffers, ProfileConstants.dealsSpecialOffers, promotions, (v) {
      setState(() => promotions = v);
      _saveSettings();
     }),
     _buildSwitchTile(ProfileConstants.rideUpdates, ProfileConstants.driverTripNotifications, rideUpdates, (v) {
      setState(() => rideUpdates = v);
      _saveSettings();
     }),
     _buildSwitchTile(ProfileConstants.chatMessages, ProfileConstants.newMessageAlerts, chatMessages, (v) {
      setState(() => chatMessages = v);
      _saveSettings();
     }),
     const SizedBox(height: 24),
     const Text(ProfileConstants.alertPreferences, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     _buildSwitchTile(ProfileConstants.sound, ProfileConstants.playNotificationSound, sound, (v) {
      setState(() => sound = v);
      _saveSettings();
     }),
     _buildSwitchTile(ProfileConstants.vibration, ProfileConstants.vibrateOnNotifications, vibration, (v) {
      setState(() => vibration = v);
      _saveSettings();
     }),
    ],
   ),
  );
 }
 void _saveSettings() {
  final userId = ref.read(currentUserIdProvider) ?? 'user1';
  ref.read(profileRepositoryProvider).updateNotificationSettings(userId, {'pushNotifications': pushNotifications ? 1 : 0, 'emailNotifications': emailNotifications ? 1 : 0, 'smsNotifications': smsNotifications ? 1 : 0, 'orderUpdates': orderUpdates ? 1 : 0, 'promotions': promotions ? 1 : 0, 'rideUpdates': rideUpdates ? 1 : 0, 'chatMessages': chatMessages ? 1 : 0, 'sound': sound ? 1 : 0, 'vibration': vibration ? 1 : 0});
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