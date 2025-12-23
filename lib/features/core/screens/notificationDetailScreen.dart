import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/notificationsProvider.dart';
import '../../../providers/authProvider.dart';
import '../../core/constants/coreConstants.dart';
class NotificationDetailScreen extends ConsumerWidget {
 final String notificationId;
 const NotificationDetailScreen({super.key, required this.notificationId});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? '';
  final notificationsAsync = ref.watch(notificationsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.notifications)),
    title: const Text(CoreConstants.notificationDefaultTitle),
    actions: [
     IconButton(
      icon: const Icon(Icons.delete_outline),
      onPressed: () async {
       await ref.read(notificationsRepositoryProvider).deleteNotification(notificationId);
       ref.invalidate(notificationsProvider(userId));
       if (context.mounted) context.go(Routes.notifications);
      },
     ),
    ],
   ),
   body: notificationsAsync.when(
    data: (notifications) {
     final notification = notifications.firstWhere((n) => n['id'].toString() == notificationId, orElse: () => <String, dynamic>{});
     if (notification.isEmpty) {
      return const Center(child: Text(CoreConstants.notificationNotFound));
     }
     final createdAt = DateTime.fromMillisecondsSinceEpoch(notification['createdAt'] as int);
     return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Container(
         width: 72,
         height: 72,
         decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(36)),
         child: const Icon(Icons.notifications, size: 36, color: AppColors.primary),
        ),
        const SizedBox(height: 24),
        Text(notification['title']?.toString() ?? CoreConstants.notificationDefaultTitle, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('${createdAt.day}/${createdAt.month}/${createdAt.year} at ${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}', style: TextStyle(color: Colors.grey[600])),
        const SizedBox(height: 24),
        Text(notification['message']?.toString() ?? '', style: const TextStyle(fontSize: 16, height: 1.5)),
       ],
      ),
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(child: Text('${CoreConstants.errorPrefix}$e')),
   ),
  );
 }
}