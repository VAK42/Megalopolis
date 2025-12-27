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
  ''', [userId, userId, userId],
  );
 }
 Future<List<Map<String, dynamic>>> getActivityFeed(String userId) async {
  final db = await dbHelper.database;
  return await db.query('reviews', orderBy: 'createdAt DESC', limit: 20);
 }
 Future<int> addFriend(String userId, String friendId) async {
  final db = await dbHelper.database;
  final existing = await db.query('friends', where: '(userId = ? AND friendId = ?) OR (userId = ? AND friendId = ?)', whereArgs: [userId, friendId, friendId, userId], limit: 1);
  if (existing.isNotEmpty) return -1;
  return await db.insert('friends', {'id': DateTime.now().millisecondsSinceEpoch.toString(), 'userId': userId, 'friendId': friendId, 'createdAt': DateTime.now().millisecondsSinceEpoch});
 }
 Future<int> removeFriend(String userId, String friendId) async {
  final db = await dbHelper.database;
  return await db.delete('friends', where: '(userId = ? AND friendId = ?) OR (userId = ? AND friendId = ?)', whereArgs: [userId, friendId, friendId, userId]);
 }
 Future<List<Map<String, dynamic>>> searchUsers(String query) async {
  final db = await dbHelper.database;
  return await db.query('users', where: 'name LIKE ? OR email LIKE ?', whereArgs: ['%$query%', '%$query%'], limit: 20);
 }
 Future<List<Map<String, dynamic>>> getChallenges(String userId) async {
  final db = await dbHelper.database;
  return await db.query('challenges', where: 'userId = ? OR userId IS NULL', whereArgs: [userId], orderBy: 'createdAt DESC');
 }
 Future<int> joinChallenge(String userId, String challengeId) async {
  final db = await dbHelper.database;
  return await db.insert('userChallenges', {'userId': userId, 'challengeId': challengeId, 'joinedAt': DateTime.now().toIso8601String(), 'currentProgress': 0});
 }
 Future<int> shareLocation(String userId, List<String> friendIds, double lat, double lng) async {
  final db = await dbHelper.database;
  return await db.insert('locationShares', {'userId': userId, 'friendIds': friendIds.join(','), 'lat': lat, 'lng': lng, 'sharedAt': DateTime.now().toIso8601String(), 'isActive': 1});
 }
 Future<int> stopSharingLocation(String shareId) async {
  final db = await dbHelper.database;
  return await db.update('locationShares', {'isActive': 0}, where: 'id = ?', whereArgs: [shareId]);
 }
 Future<int> splitExpense(String userId, List<String> friendIds, double amount, String description) async {
  final db = await dbHelper.database;
  return await db.insert('expenseSplits', {'userId': userId, 'friendIds': friendIds.join(','), 'amount': amount, 'description': description, 'createdAt': DateTime.now().toIso8601String(), 'status': 'pending'});
 }
 Future<List<Map<String, dynamic>>> getExpenseSplits(String userId) async {
  final db = await dbHelper.database;
  return await db.query('expenseSplits', where: 'userId = ? OR friendIds LIKE ?', whereArgs: [userId, '%$userId%'], orderBy: 'createdAt DESC');
 }
 Future<int> sendGift(String fromUserId, String toUserId, String giftType, double amount, String message) async {
  final db = await dbHelper.database;
  return await db.insert('gifts', {'fromUserId': fromUserId, 'toUserId': toUserId, 'giftType': giftType, 'amount': amount, 'message': message, 'sentAt': DateTime.now().toIso8601String()});
 }
 Future<Map<String, dynamic>?> getUserProfile(String userId) async {
  final db = await dbHelper.database;
  final maps = await db.query('users', where: 'id = ?', whereArgs: [userId], limit: 1);
  if (maps.isEmpty) return null;
  return maps.first;
 }
 Future<Map<String, dynamic>> getUserStats(String userId) async {
  final db = await dbHelper.database;
  final rides = await db.query('orders', where: 'userId = ? AND type = ?', whereArgs: [userId, 'ride']);
  final orders = await db.query('orders', where: 'userId = ? AND type != ?', whereArgs: [userId, 'ride']);
  double totalSpent = 0;
  for (var order in [...rides, ...orders]) {
   totalSpent += (order['totalAmount'] as num?)?.toDouble() ?? 0;
  }
  return {'ridesCompleted': rides.length, 'ordersPlaced': orders.length, 'totalSpent': totalSpent};
 }
}