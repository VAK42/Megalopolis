import '../../core/database/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';
class ReviewRepository {
 final DatabaseHelper _dbHelper = DatabaseHelper.instance;
 Future<List<Map<String, dynamic>>> getReviews(String targetType, String targetId) async {
  final db = await _dbHelper.database;
  final reviews = await db.query('reviews', where: 'targetType = ? AND targetId = ?', whereArgs: [targetType, targetId], orderBy: 'createdAt DESC');
  final List<Map<String, dynamic>> enrichedReviews = [];
  for (var review in reviews) {
   final users = await db.query('users', where: 'id = ?', whereArgs: [review['userId']], limit: 1);
   enrichedReviews.add({...review, 'userName': users.isNotEmpty ? users.first['name'] : 'Unknown User', 'userAvatar': users.isNotEmpty ? users.first['avatar'] : null});
  }
  return enrichedReviews;
 }
 Future<void> addReview({required String targetType, required String targetId, required String userId, required double rating, String? comment, List<String>? images}) async {
  final db = await _dbHelper.database;
  final now = DateTime.now().millisecondsSinceEpoch;
  await db.insert('reviews', {'id': 'review_${now}_$userId', 'targetType': targetType, 'targetId': targetId, 'userId': userId, 'rating': rating, 'comment': comment, 'images': images?.join(','), 'createdAt': now});
  await _updateTargetRating(targetType, targetId);
 }
 Future<List<Map<String, dynamic>>> getUserReviews(String userId) async {
  final db = await _dbHelper.database;
  return await db.query('reviews', where: 'userId = ?', whereArgs: [userId], orderBy: 'createdAt DESC');
 }
 Future<void> _updateTargetRating(String targetType, String targetId) async {
  final db = await _dbHelper.database;
  final result = await db.rawQuery('SELECT AVG(rating) as avgRating FROM reviews WHERE targetType = ? AND targetId = ?', [targetType, targetId]);
  if (result.isNotEmpty && result.first['avgRating'] != null) {
   final avgRating = result.first['avgRating'] as double;
   String table;
   switch (targetType) {
    case 'item':
    case 'service':
     table = 'items';
     break;
    case 'driver':
    case 'provider':
    case 'merchant':
     table = 'users';
     break;
    default:
     return;
   }
   await db.update(table, {'rating': avgRating}, where: 'id = ?', whereArgs: [targetId]);
  }
 }
 Future<double> getAverageRating(String targetType, String targetId) async {
  final db = await _dbHelper.database;
  final result = await db.rawQuery('SELECT AVG(rating) as avgRating FROM reviews WHERE targetType = ? AND targetId = ?', [targetType, targetId]);
  if (result.isNotEmpty && result.first['avgRating'] != null) {
   return result.first['avgRating'] as double;
  }
  return 0.0;
 }
 Future<int> getReviewCount(String targetType, String targetId) async {
  final db = await _dbHelper.database;
  final result = await db.rawQuery('SELECT COUNT(*) as count FROM reviews WHERE targetType = ? AND targetId = ?', [targetType, targetId]);
  return Sqflite.firstIntValue(result) ?? 0;
 }
}