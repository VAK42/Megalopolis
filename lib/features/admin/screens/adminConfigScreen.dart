import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/systemProvider.dart';
import '../../../data/repositories/adminRepository.dart';
import '../constants/adminConstants.dart';
class AdminConfigScreen extends ConsumerStatefulWidget {
 const AdminConfigScreen({super.key});
 @override
 ConsumerState<AdminConfigScreen> createState() => _AdminConfigScreenState();
}
class _AdminConfigScreenState extends ConsumerState<AdminConfigScreen> {
 final AdminRepository repository = AdminRepository();
 bool isSaving = false;
 Future<void> _updateSetting(String key, String value, String type) async {
  setState(() => isSaving = true);
  try {
   await repository.updateSystemSetting(key, value, type);
   ref.invalidate(systemSettingsProvider);
   if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$key${AdminConstants.updatedSuccessSuffix}')));
   }
  } catch (e) {
   if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AdminConstants.failedToUpdatePrefix}$e')));
   }
  } finally {
   if (mounted) setState(() => isSaving = false);
  }
 }
 Future<void> _showEditDialog(String key, String currentValue, String type) async {
  final controller = TextEditingController(text: currentValue);
  await showDialog(
   context: context,
   builder: (context) => AlertDialog(
    title: Text('${AdminConstants.editPrefix}$key'),
    content: TextField(
     controller: controller,
     decoration: InputDecoration(
      labelText: key,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
     ),
    ),
    actions: [
     TextButton(onPressed: () => Navigator.pop(context), child: const Text(AdminConstants.cancelButton)),
     ElevatedButton(
      onPressed: () {
       Navigator.pop(context);
       _updateSetting(key, controller.text, type);
      },
      child: const Text(AdminConstants.saveButton),
     ),
    ],
   ),
  );
 }
 @override
 Widget build(BuildContext context) {
  final settingsAsync = ref.watch(systemSettingsProvider);
  return Scaffold(
   appBar: AppBar(
    title: const Text(AdminConstants.configurationTitle),
    actions: [
     if (isSaving)
      const Padding(
       padding: EdgeInsets.all(16),
       child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
      ),
    ],
   ),
   body: settingsAsync.when(
    data: (settings) {
     final maintenanceMode = settings['maintenanceMode'] ?? false;
     return ListView(
      padding: const EdgeInsets.all(16),
      children: [
       Card(
        child: SwitchListTile(title: const Text(AdminConstants.maintenanceModeLabel), subtitle: const Text(AdminConstants.maintenanceModeSubtitle), value: maintenanceMode is bool ? maintenanceMode : maintenanceMode.toString().toLowerCase() == 'true', onChanged: (v) => _updateSetting('maintenanceMode', v.toString(), 'boolean')),
       ),
       const SizedBox(height: 8),
       Card(
        child: ListTile(
         title: const Text(AdminConstants.minimumVersionLabel),
         subtitle: Text(settings['minVersion']?.toString() ?? '1.0.0'),
         trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () => _showEditDialog('minVersion', settings['minVersion']?.toString() ?? '1.0.0', 'string')),
        ),
       ),
       const SizedBox(height: 8),
       Card(
        child: ListTile(
         title: const Text(AdminConstants.latestVersionLabel),
         subtitle: Text(settings['latestVersion']?.toString() ?? '2.0.0'),
         trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () => _showEditDialog('latestVersion', settings['latestVersion']?.toString() ?? '2.0.0', 'string')),
        ),
       ),
       const SizedBox(height: 8),
       Card(
        child: ListTile(
         title: const Text(AdminConstants.maintenanceMessageLabel),
         subtitle: Text(settings['maintenanceMessage']?.toString() ?? AdminConstants.underMaintenanceDefault, maxLines: 2, overflow: TextOverflow.ellipsis),
         trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () => _showEditDialog('maintenanceMessage', settings['maintenanceMessage']?.toString() ?? AdminConstants.underMaintenanceDefault, 'string')),
        ),
       ),
       const SizedBox(height: 8),
       Card(
        child: ListTile(
         title: const Text(AdminConstants.maintenanceEtaLabel),
         subtitle: Text(settings['maintenanceEta']?.toString() ?? AdminConstants.twoHoursDefault),
         trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () => _showEditDialog('maintenanceEta', settings['maintenanceEta']?.toString() ?? AdminConstants.twoHoursDefault, 'string')),
        ),
       ),
      ],
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (err, stack) => const Center(child: Text(AdminConstants.errorLoadingSettings)),
   ),
  );
 }
}