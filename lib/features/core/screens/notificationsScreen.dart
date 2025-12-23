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
     IconButton(
      icon: const Icon(Icons.done_all),
      onPressed: () async {
       await ref.read(notificationsRepositoryProvider).markAllAsRead(userId);
       ref.invalidate(notificationsProvider(userId));
      },
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
  final iconData = _getIcon(notification['type']?.toString());
  final color = _getColor(notification['type']?.toString());
  final createdAt = DateTime.fromMillisecondsSinceEpoch(notification['createdAt'] as int);
  final timeAgo = _formatTimeAgo(createdAt);
  return Card(
   margin: const EdgeInsets.only(bottom: 12),
   color: isRead ? null : AppColors.primary.withValues(alpha: 0.05),
   child: ListTile(
    leading: Container(
     width: 48,
     height: 48,
     decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(24)),
     child: Icon(iconData, color: color),
    ),
    title: Text(notification['title']?.toString() ?? CoreConstants.notificationDefaultTitle, style: TextStyle(fontWeight: isRead ? FontWeight.normal : FontWeight.bold)),
    subtitle: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      const SizedBox(height: 4),
      Text(notification['message']?.toString() ?? ''),
      const SizedBox(height: 4),
      Text(timeAgo, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
     ],
    ),
    isThreeLine: true,
    onTap: () async {
     if (!isRead) {
      await ref.read(notificationsRepositoryProvider).markAsRead(notification['id'].toString());
      ref.invalidate(notificationsProvider(userId));
     }
     if (context.mounted) context.go('${Routes.notificationDetail}/${notification['id']}');
    },
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