import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../data/repositories/adminRepository.dart';
import '../widgets/adminScaffold.dart';
import '../constants/adminConstants.dart';
final adminNotificationsHistoryProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
 final repository = AdminRepository();
 final db = await repository.dbHelper.database;
 return await db.query('notifications', where: 'type = ?', whereArgs: ['admin'], orderBy: 'createdAt DESC', limit: 50);
});
class AdminNotificationScreen extends ConsumerStatefulWidget {
 const AdminNotificationScreen({super.key});
 @override
 ConsumerState<AdminNotificationScreen> createState() => _AdminNotificationScreenState();
}
class _AdminNotificationScreenState extends ConsumerState<AdminNotificationScreen> {
 final titleController = TextEditingController();
 final messageController = TextEditingController();
 String selectedAudience = AdminConstants.notificationAudiences.first;
 bool isSending = false;
 final AdminRepository repository = AdminRepository();
 Future<void> _sendNotification() async {
  if (titleController.text.isEmpty || messageController.text.isEmpty) {
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.fillAllFieldsError), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
   return;
  }
  setState(() => isSending = true);
  try {
   final count = await repository.sendNotification(title: titleController.text, body: messageController.text, audience: selectedAudience);
   if (mounted) {
    titleController.clear();
    messageController.clear();
    ref.invalidate(adminNotificationsHistoryProvider);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AdminConstants.notificationSentPrefix}$count${AdminConstants.usersSuffix}'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
   }
  } catch (e) {
   if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AdminConstants.failedToSendPrefix}$e'), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
  } finally {
   if (mounted) setState(() => isSending = false);
  }
 }
 @override
 void dispose() {
  titleController.dispose();
  messageController.dispose();
  super.dispose();
 }
 @override
 Widget build(BuildContext context) {
  return AdminScaffold(
   title: AdminConstants.sendNotificationsTitle,
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Text(AdminConstants.pushNotificationsTitle, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[800])),
      const SizedBox(height: 8),
      Text(AdminConstants.pushNotificationsSubtitle, style: TextStyle(color: Colors.grey[600])),
      const SizedBox(height: 24),
      Container(
       padding: const EdgeInsets.all(24),
       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade100), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2))]),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Row(
          children: [
           Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.edit_notifications_rounded, color: AppColors.primary)),
           const SizedBox(width: 12),
           Text(AdminConstants.composeNotificationTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[800])),
          ],
         ),
         const SizedBox(height: 24),
         TextField(controller: titleController, decoration: InputDecoration(labelText: AdminConstants.notificationTitleLabel, prefixIcon: const Icon(Icons.title_rounded), filled: true, fillColor: Colors.grey[50], border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primary, width: 2)))),
         const SizedBox(height: 16),
         TextField(controller: messageController, maxLines: 4, decoration: InputDecoration(labelText: AdminConstants.notificationMessageLabel, alignLabelWithHint: true, prefixIcon: const Padding(padding: EdgeInsets.only(bottom: 60), child: Icon(Icons.message_rounded)), filled: true, fillColor: Colors.grey[50], border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primary, width: 2)))),
         const SizedBox(height: 16),
         DropdownButtonFormField<String>(
          initialValue: selectedAudience,
          decoration: InputDecoration(labelText: AdminConstants.targetAudienceLabel, prefixIcon: const Icon(Icons.people_rounded), filled: true, fillColor: Colors.grey[50], border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
          items: AdminConstants.notificationAudiences.map((audience) => DropdownMenuItem(value: audience, child: Text(audience))).toList(),
          onChanged: (v) => setState(() => selectedAudience = v!),
         ),
         const SizedBox(height: 24),
         SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
           onPressed: isSending ? null : _sendNotification,
           icon: isSending ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.send_rounded),
           label: Text(isSending ? AdminConstants.sendingButton : AdminConstants.sendNotificationButtonLabel),
           style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6), padding: const EdgeInsets.all(16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          ),
         ),
        ],
       ),
      ),
      const SizedBox(height: 32),
      Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
        Text(AdminConstants.recentNotificationsTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[800])),
        TextButton.icon(onPressed: () => ref.invalidate(adminNotificationsHistoryProvider), icon: const Icon(Icons.refresh_rounded, size: 18), label: Text(AdminConstants.refreshButton), style: TextButton.styleFrom(foregroundColor: AppColors.primary)),
       ],
      ),
      const SizedBox(height: 16),
      ref.watch(adminNotificationsHistoryProvider).when(
       data: (notifications) {
        if (notifications.isEmpty) return Center(child: Padding(padding: const EdgeInsets.all(40), child: Column(children: [Icon(Icons.notifications_off_rounded, size: 64, color: Colors.grey[300]), const SizedBox(height: 16), Text(AdminConstants.noNotificationsSent, style: TextStyle(color: Colors.grey[600]))])));
        return ListView.builder(
         shrinkWrap: true,
         physics: const NeverScrollableScrollPhysics(),
         itemCount: notifications.length,
         itemBuilder: (context, index) {
          final notif = notifications[index];
          return Container(
           margin: const EdgeInsets.only(bottom: 12),
           padding: const EdgeInsets.all(16),
           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100)),
           child: Row(
            children: [
             Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.notifications_rounded, color: AppColors.primary)),
             const SizedBox(width: 16),
             Expanded(
              child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                Text(notif['title']?.toString() ?? AdminConstants.notificationTitleLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(notif['body']?.toString() ?? '', style: TextStyle(color: Colors.grey[600], fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
               ],
              ),
             ),
             Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
               Text(_formatDate(notif['createdAt']), style: TextStyle(color: Colors.grey[500], fontSize: 11)),
               const SizedBox(height: 4),
               Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: notif['isRead'] == 1 ? AppColors.success.withValues(alpha: 0.1) : AppColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Text(notif['isRead'] == 1 ? AdminConstants.readStatus : AdminConstants.sentStatus, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: notif['isRead'] == 1 ? AppColors.success : AppColors.warning))),
              ],
             ),
            ],
           ),
          );
         },
        );
       },
       loading: () => const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator())),
       error: (_, __) => Center(child: Padding(padding: const EdgeInsets.all(40), child: Column(children: [Icon(Icons.error_outline_rounded, size: 48, color: Colors.grey[400]), const SizedBox(height: 16), Text(AdminConstants.errorLoadingHistory, style: TextStyle(color: Colors.grey[600]))]))),
      ),
     ],
    ),
   ),
  );
 }
 String _formatDate(dynamic timestamp) {
  if (timestamp == null) return '';
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp is int ? timestamp : int.tryParse(timestamp.toString()) ?? 0);
  final now = DateTime.now();
  final diff = now.difference(date);
  if (diff.inMinutes < 60) return '${diff.inMinutes}m Ago';
  if (diff.inHours < 24) return '${diff.inHours}h Ago';
  if (diff.inDays < 7) return '${diff.inDays}d Ago';
  return '${date.day}/${date.month}/${date.year}';
 }
}