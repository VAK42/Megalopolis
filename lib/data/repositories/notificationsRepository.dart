import '../../core/database/databaseHelper.dart';
class NotificationsRepository {
 final DatabaseHelper dbHelper = DatabaseHelper.instance;
 Future<List<Map<String, dynamic>>> getNotifications(String userId) async {
  final db = await dbHelper.database;
  return await db.query('notifications', where: 'userId = ?', whereArgs: [userId], orderBy: 'createdAt DESC');
 }
 Future<int> getUnreadCount(String userId) async {
  final db = await dbHelper.database;
  final result = await db.rawQuery('SELECT COUNT(*) as count FROM notifications WHERE userId = ? AND isRead = 0', [userId]);
  return (result.first['count'] as int?) ?? 0;
 }
 Future<int> markAsRead(String notificationId) async {
  final db = await dbHelper.database;
  return await db.update('notifications', {'isRead': 1}, where: 'id = ?', whereArgs: [notificationId]);
 }
 Future<int> markAllAsRead(String userId) async {
  final db = await dbHelper.database;
  return await db.update('notifications', {'isRead': 1}, where: 'userId = ?', whereArgs: [userId]);
 }
 Future<int> deleteNotification(String notificationId) async {
  final db = await dbHelper.database;
  return await db.delete('notifications', where: 'id = ?', whereArgs: [notificationId]);
 }
}