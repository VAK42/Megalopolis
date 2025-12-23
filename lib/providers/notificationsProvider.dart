import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/notificationsRepository.dart';
final notificationsRepositoryProvider = Provider((ref) => NotificationsRepository());
final notificationsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 return await ref.watch(notificationsRepositoryProvider).getNotifications(userId);
});
final unreadCountProvider = FutureProvider.family<int, String>((ref, userId) async {
 return await ref.watch(notificationsRepositoryProvider).getUnreadCount(userId);
});