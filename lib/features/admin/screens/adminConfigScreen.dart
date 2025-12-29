import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../data/repositories/adminRepository.dart';
import '../widgets/adminScaffold.dart';
import '../constants/adminConstants.dart';
class AdminConfigScreen extends ConsumerStatefulWidget {
 const AdminConfigScreen({super.key});
 @override
 ConsumerState<AdminConfigScreen> createState() => _AdminConfigScreenState();
}
class _AdminConfigScreenState extends ConsumerState<AdminConfigScreen> {
 final AdminRepository repository = AdminRepository();
 bool maintenanceMode = false;
 bool newUserRegistration = true;
 bool emailNotifications = true;
 bool pushNotifications = true;
 double commissionRate = 15.0;
 String minimumVersion = '1.0.0';
 String latestVersion = '1.0.0';
 String maintenanceMessage = AdminConstants.underMaintenanceDefault;
 bool isLoading = false;
 bool hasChanges = false;
 @override
 void initState() {
  super.initState();
  _loadSettings();
 }
 Future<void> _loadSettings() async {
  final db = await repository.dbHelper.database;
  final settings = await db.query('systemSettings');
  for (var setting in settings) {
   final key = setting['key']?.toString();
   final value = setting['value']?.toString();
   if (key == null || value == null) continue;
   setState(() {
    switch (key) {
     case 'maintenanceMode': maintenanceMode = value == 'true'; break;
     case 'newUserRegistration': newUserRegistration = value == 'true'; break;
     case 'emailNotifications': emailNotifications = value == 'true'; break;
     case 'pushNotifications': pushNotifications = value == 'true'; break;
     case 'commissionRate': commissionRate = double.tryParse(value) ?? 15.0; break;
     case 'minimumVersion': minimumVersion = value; break;
     case 'latestVersion': latestVersion = value; break;
     case 'maintenanceMessage': maintenanceMessage = value; break;
    }
   });
  }
 }
 Future<void> _saveSettings() async {
  setState(() => isLoading = true);
  try {
   await _saveSetting('maintenanceMode', maintenanceMode.toString(), 'bool');
   await _saveSetting('newUserRegistration', newUserRegistration.toString(), 'bool');
   await _saveSetting('emailNotifications', emailNotifications.toString(), 'bool');
   await _saveSetting('pushNotifications', pushNotifications.toString(), 'bool');
   await _saveSetting('commissionRate', commissionRate.toString(), 'number');
   await _saveSetting('minimumVersion', minimumVersion, 'string');
   await _saveSetting('latestVersion', latestVersion, 'string');
   await _saveSetting('maintenanceMessage', maintenanceMessage, 'string');
   if (mounted) {
    setState(() => hasChanges = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.settingsSavedMessage), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
   }
  } catch (e) {
   if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AdminConstants.errorSavingSettings}: $e'), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
  } finally {
   if (mounted) setState(() => isLoading = false);
  }
 }
 Future<void> _saveSetting(String key, String value, String type) async {
  final db = await repository.dbHelper.database;
  final existing = await db.query('systemSettings', where: 'key = ?', whereArgs: [key]);
  if (existing.isEmpty) {
   await repository.createSystemSetting(key, value, type);
  } else {
   await repository.updateSystemSetting(key, value, type);
  }
 }
 void _showEditDialog(String title, String currentValue, Function(String) onSave) {
  final controller = TextEditingController(text: currentValue);
  showDialog(
   context: context,
   builder: (context) => AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    title: Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.edit_rounded, color: AppColors.primary)), const SizedBox(width: 12), Text('${AdminConstants.editPrefix}$title')]),
    content: TextField(controller: controller, decoration: InputDecoration(labelText: title, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50])),
    actions: [
     TextButton(onPressed: () => Navigator.pop(context), child: Text(AdminConstants.cancelButton, style: TextStyle(color: Colors.grey[600]))),
     ElevatedButton(onPressed: () { if (controller.text.trim().isEmpty) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.fillAllFieldsError), backgroundColor: AppColors.error)); return; } Navigator.pop(context); onSave(controller.text.trim()); setState(() => hasChanges = true); }, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: Text(AdminConstants.saveButton)),
    ],
   ),
  );
 }
 @override
 Widget build(BuildContext context) {
  return AdminScaffold(
   title: AdminConstants.settingsTitle,
   actions: [if (hasChanges) TextButton.icon(onPressed: _saveSettings, icon: const Icon(Icons.save_rounded, color: Colors.white), label: Text(AdminConstants.saveButton, style: const TextStyle(color: Colors.white)))],
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Text(AdminConstants.appConfigurationTitle, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[800])),
      const SizedBox(height: 8),
      Text(AdminConstants.appConfigurationSubtitle, style: TextStyle(color: Colors.grey[600])),
      const SizedBox(height: 24),
      _buildSection(AdminConstants.generalSettingsSectionTitle, [
       _buildSwitchTile(AdminConstants.maintenanceModeSetting, AdminConstants.maintenanceModeDescription, Icons.build_rounded, maintenanceMode, (v) { setState(() { maintenanceMode = v; hasChanges = true; }); }, isWarning: true),
       _buildSwitchTile(AdminConstants.newUserRegistrationSetting, AdminConstants.newUserRegistrationDescription, Icons.person_add_rounded, newUserRegistration, (v) { setState(() { newUserRegistration = v; hasChanges = true; }); }),
      ]),
      const SizedBox(height: 20),
      _buildSection(AdminConstants.notificationsSectionTitle, [
       _buildSwitchTile(AdminConstants.emailNotificationsSetting, AdminConstants.emailNotificationsDescription, Icons.email_rounded, emailNotifications, (v) { setState(() { emailNotifications = v; hasChanges = true; }); }),
       _buildSwitchTile(AdminConstants.pushNotificationsSetting, AdminConstants.pushNotificationsDescription, Icons.notifications_rounded, pushNotifications, (v) { setState(() { pushNotifications = v; hasChanges = true; }); }),
      ]),
      const SizedBox(height: 20),
      _buildSection(AdminConstants.businessSettingsSectionTitle, [
       Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
          Row(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.percent_rounded, color: AppColors.primary)), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(AdminConstants.commissionRateSetting, style: const TextStyle(fontWeight: FontWeight.w600)), Text(AdminConstants.commissionRateDescription, style: const TextStyle(color: Colors.grey, fontSize: 13))]))]),
          const SizedBox(height: 16),
          Row(children: [Expanded(child: Slider(value: commissionRate, min: 5, max: 30, divisions: 25, label: '${commissionRate.toInt()}%', onChanged: (v) { setState(() { commissionRate = v; hasChanges = true; }); }, activeColor: AppColors.primary)), Text('${commissionRate.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.primary))]),
         ],
        ),
       ),
      ]),
      const SizedBox(height: 20),
      _buildSection(AdminConstants.appVersionSettings, [
       _buildTextTile(AdminConstants.minimumVersionLabel, minimumVersion, Icons.system_update_rounded, () => _showEditDialog(AdminConstants.minimumVersionLabel, minimumVersion, (v) => setState(() => minimumVersion = v))),
       _buildTextTile(AdminConstants.latestVersionLabel, latestVersion, Icons.update_rounded, () => _showEditDialog(AdminConstants.latestVersionLabel, latestVersion, (v) => setState(() => latestVersion = v))),
       if (maintenanceMode) _buildTextTile(AdminConstants.maintenanceMessageLabel, maintenanceMessage, Icons.message_rounded, () => _showEditDialog(AdminConstants.maintenanceMessageLabel, maintenanceMessage, (v) => setState(() => maintenanceMessage = v))),
      ]),
      const SizedBox(height: 24),
      SizedBox(
       width: double.infinity,
       child: ElevatedButton.icon(
        onPressed: isLoading ? null : _saveSettings,
        icon: isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.save_rounded),
        label: Text(isLoading ? AdminConstants.sendingButton : AdminConstants.saveChangesButton),
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6), padding: const EdgeInsets.all(16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
       ),
      ),
     ],
    ),
   ),
  );
 }
 Widget _buildSection(String title, List<Widget> children) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[700])), if (hasChanges) const Padding(padding: EdgeInsets.only(left: 8), child: Icon(Icons.edit_rounded, size: 16, color: AppColors.warning))]), const SizedBox(height: 12), Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100)), child: Column(children: children))]);
 }
 Widget _buildSwitchTile(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged, {bool isWarning = false}) {
  return ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: (isWarning && value ? AppColors.warning : AppColors.primary).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: isWarning && value ? AppColors.warning : AppColors.primary)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)), subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 13)), trailing: Switch(value: value, onChanged: onChanged, activeTrackColor: isWarning ? AppColors.warning : AppColors.primary));
 }
 Widget _buildTextTile(String title, String value, IconData icon, VoidCallback onTap) {
  return ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: AppColors.info)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)), subtitle: Text(value, style: TextStyle(color: Colors.grey[600], fontSize: 13)), trailing: IconButton(icon: const Icon(Icons.edit_rounded), onPressed: onTap, color: AppColors.info), onTap: onTap);
 }
}