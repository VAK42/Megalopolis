import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/adminRepository.dart';
import '../../admin/constants/adminConstants.dart';
class AdminNotificationScreen extends ConsumerStatefulWidget {
 const AdminNotificationScreen({super.key});
 @override
 ConsumerState<AdminNotificationScreen> createState() => _AdminNotificationScreenState();
}
class _AdminNotificationScreenState extends ConsumerState<AdminNotificationScreen> {
 final TextEditingController titleController = TextEditingController();
 final TextEditingController messageController = TextEditingController();
 final AdminRepository repository = AdminRepository();
 String selectedAudience = AdminConstants.defaultAudience;
 bool isSending = false;
 Future<void> _sendNotification() async {
  if (titleController.text.isEmpty || messageController.text.isEmpty) {
   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AdminConstants.fillAllFieldsError)));
   return;
  }
  setState(() => isSending = true);
  try {
   final count = await repository.sendNotification(title: titleController.text, body: messageController.text, audience: selectedAudience);
   if (mounted) {
    titleController.clear();
    messageController.clear();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AdminConstants.notificationSentPrefix}$count${AdminConstants.usersSuffix}')));
   }
  } catch (e) {
   if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AdminConstants.failedToSendPrefix}$e')));
   }
  } finally {
   if (mounted) setState(() => isSending = false);
  }
 }
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(title: const Text(AdminConstants.pushNotificationsTitle)),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      const Text(AdminConstants.sendNotificationTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 16),
      TextField(
       controller: titleController,
       decoration: InputDecoration(
        labelText: AdminConstants.titleLabel,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
       ),
      ),
      const SizedBox(height: 16),
      TextField(
       controller: messageController,
       maxLines: 4,
       decoration: InputDecoration(
        labelText: AdminConstants.messageLabel,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
       ),
      ),
      const SizedBox(height: 16),
      DropdownButtonFormField<String>(
       initialValue: selectedAudience,
       decoration: InputDecoration(
        labelText: AdminConstants.audienceLabel,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
       ),
       items: AdminConstants.notificationAudiences.map((audience) => DropdownMenuItem(value: audience, child: Text(audience))).toList(),
       onChanged: (value) => setState(() => selectedAudience = value!),
      ),
      const SizedBox(height: 24),
      SizedBox(
       width: double.infinity,
       child: ElevatedButton.icon(
        onPressed: isSending ? null : _sendNotification,
        icon: isSending ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send),
        label: Text(isSending ? AdminConstants.sendingButton : AdminConstants.sendNotificationButton),
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
       ),
      ),
     ],
    ),
   ),
  );
 }
}