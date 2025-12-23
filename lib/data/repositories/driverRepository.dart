import '../../core/database/databaseHelper.dart';
class DriverRepository {
 final DatabaseHelper dbHelper = DatabaseHelper.instance;
 Future<Map<String, dynamic>?> getDriverById(String driverId) async {
  final db = await dbHelper.database;
  final results = await db.query('users', where: 'id = ? AND role = ?', whereArgs: [driverId, 'driver']);
  if (results.isNotEmpty) return results.first;
  return null;
 }
 Future<Map<String, dynamic>> getDriverStats(String driverId) async {
  final db = await dbHelper.database;
  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
  final weekStart = now.subtract(Duration(days: now.weekday - 1)).millisecondsSinceEpoch;
  final monthStart = DateTime(now.year, now.month, 1).millisecondsSinceEpoch;
  final todayTrips = await db.rawQuery('SELECT COUNT(*) as count, SUM(total) as earnings FROM orders WHERE driverId = ? AND status = ? AND completedAt >= ?', [driverId, 'completed', todayStart]);
  final weekTrips = await db.rawQuery('SELECT COUNT(*) as count, SUM(total) as earnings FROM orders WHERE driverId = ? AND status = ? AND completedAt >= ?', [driverId, 'completed', weekStart]);
  final monthTrips = await db.rawQuery('SELECT COUNT(*) as count, SUM(total) as earnings FROM orders WHERE driverId = ? AND status = ? AND completedAt >= ?', [driverId, 'completed', monthStart]);
  return {'todayTrips': (todayTrips.first['count'] as int?) ?? 0, 'todayEarnings': (todayTrips.first['earnings'] as num?)?.toDouble() ?? 0.0, 'weekTrips': (weekTrips.first['count'] as int?) ?? 0, 'weekEarnings': (weekTrips.first['earnings'] as num?)?.toDouble() ?? 0.0, 'monthTrips': (monthTrips.first['count'] as int?) ?? 0, 'monthEarnings': (monthTrips.first['earnings'] as num?)?.toDouble() ?? 0.0};
 }
 Future<List<Map<String, dynamic>>> getDriverTrips(String driverId, {int limit = 20}) async {
  final db = await dbHelper.database;
  return await db.query('orders', where: 'driverId = ?', whereArgs: [driverId], orderBy: 'createdAt DESC', limit: limit);
 }
 Future<List<Map<String, dynamic>>> getDriverEarnings(String driverId) async {
  final db = await dbHelper.database;
  final now = DateTime.now();
  final earnings = <Map<String, dynamic>>[];
  for (int i = 0; i < 7; i++) {
   final day = now.subtract(Duration(days: i));
   final dayStart = DateTime(day.year, day.month, day.day).millisecondsSinceEpoch;
   final dayEnd = dayStart + 86400000;
   final result = await db.rawQuery('SELECT SUM(total) as earnings FROM orders WHERE driverId = ? AND status = ? AND completedAt >= ? AND completedAt < ?', [driverId, 'completed', dayStart, dayEnd]);
   final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
   earnings.add({'day': days[day.weekday % 7], 'date': '${day.day}/${day.month}', 'earnings': (result.first['earnings'] as num?)?.toDouble() ?? 0.0});
  }
  return earnings.reversed.toList();
 }
 Future<int> updateDriverStatus(String driverId, String status) async {
  final db = await dbHelper.database;
  return await db.update('users', {'status': status, 'updatedAt': DateTime.now().millisecondsSinceEpoch}, where: 'id = ?', whereArgs: [driverId]);
 }
 Future<int> registerAsDriver(String userId, Map<String, dynamic> driverData) async {
  final db = await dbHelper.database;
  return await db.update('users', {'role': 'driver', 'status': 'pending', 'updatedAt': DateTime.now().millisecondsSinceEpoch, ...driverData}, where: 'id = ?', whereArgs: [userId]);
 }
 Future<Map<String, dynamic>> getDriverPerformance(String driverId) async {
  final db = await dbHelper.database;
  final ratingResult = await db.rawQuery('SELECT AVG(rating) as avgRating, COUNT(*) as totalTrips FROM orders WHERE driverId = ? AND status = ?', [driverId, 'completed']);
  final acceptanceResult = await db.rawQuery('SELECT COUNT(*) as accepted FROM orders WHERE driverId = ? AND status != ?', [driverId, 'cancelled']);
  final totalOffered = await db.rawQuery('SELECT COUNT(*) as total FROM orders WHERE driverId = ?', [driverId]);
  final accepted = (acceptanceResult.first['accepted'] as int?) ?? 0;
  final total = (totalOffered.first['total'] as int?) ?? 1;
  return {'rating': (ratingResult.first['avgRating'] as num?)?.toDouble() ?? 4.5, 'totalTrips': (ratingResult.first['totalTrips'] as int?) ?? 0, 'acceptanceRate': total > 0 ? (accepted / total * 100).toInt() : 100, 'completionRate': 98, 'onTimeRate': 95};
 }
 Future<List<Map<String, dynamic>>> getDriverIncentives(String driverId) async {
  final db = await dbHelper.database;
  return await db.query('driverIncentives', where: 'driverId = ?', whereArgs: [driverId]);
 }
 Future<List<Map<String, dynamic>>> getDriverDocuments(String driverId) async {
  final db = await dbHelper.database;
  return await db.query('driverDocuments', where: 'driverId = ?', whereArgs: [driverId]);
 }
 Future<int> uploadDocument(String driverId, String documentType, String documentPath) async {
  final db = await dbHelper.database;
  final now = DateTime.now().millisecondsSinceEpoch;
  return await db.insert('driverDocuments', {'id': 'doc$now', 'driverId': driverId, 'name': documentType, 'status': 'pending', 'path': documentPath, 'uploadedAt': now});
 }
 Future<int> deleteDocument(String documentId) async {
  final db = await dbHelper.database;
  return await db.delete('driverDocuments', where: 'id = ?', whereArgs: [documentId]);
 }
 Future<List<Map<String, dynamic>>> getDriverTrainingModules(String driverId) async {
  final db = await dbHelper.database;
  return await db.query('driverTraining', where: 'driverId = ?', whereArgs: [driverId]);
 }
}