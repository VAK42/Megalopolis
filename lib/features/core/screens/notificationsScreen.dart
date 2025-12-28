import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/notificationsProvider.dart';
import '../../core/constants/coreConstants.dart';
class NotificationsScreen extends ConsumerWidget {
 const NotificationsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? '';
  final notificationsAsync = ref.watch(notificationsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.superDashboard)),
    title: const Text(CoreConstants.notificationsTitle),
    actions: [
     PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) async {
       switch (value) {
        case 'markAllRead':
         await ref.read(notificationsRepositoryProvider).markAllAsRead(userId);
         ref.invalidate(notificationsProvider(userId));
         break;
        case 'deleteAll':
         await ref.read(notificationsRepositoryProvider).deleteAllByUser(userId);
         ref.invalidate(notificationsProvider(userId));
         break;
       }
      },
      itemBuilder: (context) => [
       const PopupMenuItem(value: 'markAllRead', child: Text(CoreConstants.markAllAsRead)),
       const PopupMenuItem(value: 'deleteAll', child: Text(CoreConstants.deleteAll)),
      ],
     ),
    ],
   ),
   body: notificationsAsync.when(
    data: (notifications) {
     if (notifications.isEmpty) {
      return const Center(
       child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey),
         SizedBox(height: 16),
         Text(CoreConstants.noNotifications, style: TextStyle(color: Colors.grey)),
        ],
       ),
      );
     }
     final now = DateTime.now();
     final today = notifications.where((n) {
      final date = DateTime.fromMillisecondsSinceEpoch(n['createdAt'] as int);
      return date.day == now.day && date.month == now.month && date.year == now.year;
     }).toList();
     final earlier = notifications.where((n) {
      final date = DateTime.fromMillisecondsSinceEpoch(n['createdAt'] as int);
      return !(date.day == now.day && date.month == now.month && date.year == now.year);
     }).toList();
     return ListView(
      padding: const EdgeInsets.all(16),
      children: [
       if (today.isNotEmpty) ...[Text(CoreConstants.today, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey[600])), const SizedBox(height: 12), ...today.map((n) => _buildNotificationItem(context, ref, n, userId)), const SizedBox(height: 24)],
       if (earlier.isNotEmpty) ...[Text(CoreConstants.earlier, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey[600])), const SizedBox(height: 12), ...earlier.map((n) => _buildNotificationItem(context, ref, n, userId))],
      ],
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(child: Text('${CoreConstants.errorPrefix}$e')),
   ),
  );
 }
 Widget _buildNotificationItem(BuildContext context, WidgetRef ref, Map<String, dynamic> notification, String userId) {
  final isRead = notification['isRead'] == 1;
  final isStarred = notification['isStarred'] == 1;
  final isMuted = notification['isMuted'] == 1;
  final iconData = _getIcon(notification['type']?.toString());
  final color = _getColor(notification['type']?.toString());
  final createdAt = DateTime.fromMillisecondsSinceEpoch(notification['createdAt'] as int);
  final timeAgo = _formatTimeAgo(createdAt);
  return Dismissible(
   key: Key(notification['id'].toString()),
   direction: DismissDirection.endToStart,
   background: Container(
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(right: 20),
    color: AppColors.error,
    child: const Icon(Icons.delete, color: Colors.white),
   ),
   onDismissed: (_) async {
    await ref.read(notificationsRepositoryProvider).deleteNotification(notification['id'].toString());
    ref.invalidate(notificationsProvider(userId));
   },
   child: Card(
    margin: const EdgeInsets.only(bottom: 12),
    color: isRead ? null : AppColors.primary.withValues(alpha: 0.05),
    child: ListTile(
     leading: Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(24)),
      child: Icon(iconData, color: color),
     ),
     title: Row(
      children: [
       Expanded(child: Text(notification['title']?.toString() ?? CoreConstants.notificationDefaultTitle, style: TextStyle(fontWeight: isRead ? FontWeight.normal : FontWeight.bold))),
       if (isStarred) const Icon(Icons.star, color: Colors.amber, size: 18),
       if (isMuted) const Icon(Icons.notifications_off, color: Colors.grey, size: 18),
      ],
     ),
     subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       const SizedBox(height: 4),
       Text(notification['body']?.toString() ?? ''),
       const SizedBox(height: 4),
       Text(timeAgo, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
     ),
     isThreeLine: true,
     trailing: PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 20),
      onSelected: (value) async {
       switch (value) {
        case 'star':
         await ref.read(notificationsRepositoryProvider).toggleStar(notification['id'].toString(), !isStarred);
         ref.invalidate(notificationsProvider(userId));
         break;
        case 'mute':
         await ref.read(notificationsRepositoryProvider).toggleMute(notification['id'].toString(), !isMuted);
         ref.invalidate(notificationsProvider(userId));
         break;
        case 'delete':
         await ref.read(notificationsRepositoryProvider).deleteNotification(notification['id'].toString());
         ref.invalidate(notificationsProvider(userId));
         break;
       }
      },
      itemBuilder: (context) => [
       PopupMenuItem(value: 'star', child: Text(isStarred ? CoreConstants.unstar : CoreConstants.star)),
       PopupMenuItem(value: 'mute', child: Text(isMuted ? CoreConstants.unmute : CoreConstants.mute)),
       const PopupMenuItem(value: 'delete', child: Text(CoreConstants.delete)),
      ],
     ),
     onTap: () async {
      if (!isRead) {
       await ref.read(notificationsRepositoryProvider).markAsRead(notification['id'].toString());
       ref.invalidate(notificationsProvider(userId));
      }
      if (context.mounted) context.go('/notifications/${notification['id']}');
     },
    ),
   ),
  );
 }
 IconData _getIcon(String? type) {
  switch (type) {
   case 'order':
    return Icons.check_circle;
   case 'ride':
    return Icons.directions_car;
   case 'shipping':
    return Icons.local_shipping;
   case 'wallet':
    return Icons.account_balance_wallet;
   case 'service':
    return Icons.home_repair_service;
   default:
    return Icons.notifications;
  }
 }
 Color _getColor(String? type) {
  switch (type) {
   case 'order':
    return AppColors.success;
   case 'ride':
    return AppColors.accent;
   case 'shipping':
    return AppColors.primary;
   case 'wallet':
    return Colors.green;
   case 'service':
    return Colors.purple;
   default:
    return AppColors.primary;
  }
 }
 String _formatTimeAgo(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);
  if (diff.inMinutes < 60) return '${diff.inMinutes}${CoreConstants.minAgo}';
  if (diff.inHours < 24) return '${diff.inHours}${CoreConstants.hoursAgo}';
  if (diff.inDays == 1) return CoreConstants.yesterday;
  return '${diff.inDays}${CoreConstants.daysAgo}';
 }
}