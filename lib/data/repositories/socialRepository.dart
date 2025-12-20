import '../../core/database/databaseHelper.dart';
class SocialRepository {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  Future<List<Map<String, dynamic>>> getFriends(String userId) async {
    final db = await dbHelper.database;
    return await db.rawQuery(
      '''
      SELECT u.* FROM users u
      JOIN friends f ON (f.friendId = u.id OR f.userId = u.id)
      WHERE (f.userId = ? OR f.friendId = ?) AND u.id != ?
    ''',
      [userId, userId, userId],
    );
  }
  Future<List<Map<String, dynamic>>> getActivityFeed(String userId) async {
    final db = await dbHelper.database;
    return await db.query('reviews', orderBy: 'createdAt DESC', limit: 20);
  }
  Future<void> addFriend(String userId, String friendId) async {
    final db = await dbHelper.database;
    await db.insert('friends', {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'userId': userId,
      'friendId': friendId,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
  }
}