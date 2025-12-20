import '../../core/database/databaseHelper.dart';
class RideRepository {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  Future<int> bookRide(Map<String, dynamic> ride) async {
    final db = await dbHelper.database;
    return await db.insert('orders', ride);
  }
  Future<List<Map<String, dynamic>>> getRides(int userId) async {
    final db = await dbHelper.database;
    return await db.query(
      'orders',
      where: 'userId = ? AND type = ?',
      whereArgs: [userId, 'ride'],
      orderBy: 'createdAt DESC',
    );
  }
  Future<Map<String, dynamic>?> getActiveRide(int userId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'orders',
      where: 'userId = ? AND type = ? AND status IN (?, ?)',
      whereArgs: [userId, 'ride', 'pending', 'active'],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return maps.first;
  }
  Future<Map<String, dynamic>?> getRideById(int id) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return maps.first;
  }
  Future<int> updateRideStatus(int id, String status) async {
    final db = await dbHelper.database;
    return await db.update(
      'orders',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<int> cancelRide(int id) async {
    final db = await dbHelper.database;
    return await db.update(
      'orders',
      {'status': 'cancelled'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<int> savePlaceAsync(int userId, Map<String, dynamic> place) async {
    final db = await dbHelper.database;
    place['userId'] = userId;
    return await db.insert('addresses', place);
  }
  Future<List<Map<String, dynamic>>> getSavedPlaces(int userId) async {
    final db = await dbHelper.database;
    return await db.query(
      'addresses',
      where: 'userId = ? AND isSavedPlace = ?',
      whereArgs: [userId, 1],
    );
  }
  Future<int> scheduleRide(Map<String, dynamic> ride) async {
    final db = await dbHelper.database;
    return await db.insert('orders', ride);
  }
  Future<List<Map<String, dynamic>>> getScheduledRides(int userId) async {
    final db = await dbHelper.database;
    return await db.query(
      'orders',
      where: 'userId = ? AND type = ? AND status = ?',
      whereArgs: [userId, 'ride', 'scheduled'],
    );
  }
}