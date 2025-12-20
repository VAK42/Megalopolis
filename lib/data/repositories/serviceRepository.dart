import '../../core/database/databaseHelper.dart';
import '../../shared/models/itemModel.dart';
class ServiceRepository {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  Future<List<ItemModel>> getServices({
    int limit = 20,
    int offset = 0,
    String? category,
  }) async {
    final db = await dbHelper.database;
    String sql = 'SELECT * FROM items WHERE type = ?';
    List<dynamic> args = ['service'];
    if (category != null) {
      sql += ' AND categoryId = ?';
      args.add(category);
    }
    sql += ' LIMIT ? OFFSET ?';
    args.addAll([limit, offset]);
    final List<Map<String, dynamic>> maps = await db.rawQuery(sql, args);
    return List.generate(maps.length, (i) => ItemModel.fromMap(maps[i]));
  }
  Future<ItemModel?> getServiceById(int id) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'items',
      where: 'id = ? AND type = ?',
      whereArgs: [id, 'service'],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return ItemModel.fromMap(maps.first);
  }
  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await dbHelper.database;
    return await db.rawQuery(
      'SELECT DISTINCT categoryId FROM items WHERE type = "service"',
    );
  }
  Future<List<Map<String, dynamic>>> getProviders(String category) async {
    final db = await dbHelper.database;
    return await db.rawQuery(
      '''
      SELECT i.sellerId, u.name as sellerName, u.rating as sellerRating 
      FROM items i
      JOIN users u ON i.sellerId = u.id
      WHERE i.type = "service" AND i.categoryId = ?
      GROUP BY i.sellerId
      ''',
      [category],
    );
  }
  Future<int> bookService(Map<String, dynamic> booking) async {
    final db = await dbHelper.database;
    return await db.insert('orders', booking);
  }
  Future<List<Map<String, dynamic>>> getBookings(int userId) async {
    final db = await dbHelper.database;
    return await db.query(
      'orders',
      where: 'userId = ? AND type = ?',
      whereArgs: [userId, 'service'],
      orderBy: 'createdAt DESC',
    );
  }
  Future<Map<String, dynamic>?> getBookingById(int id) async {
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
  Future<int> cancelBooking(int id) async {
    final db = await dbHelper.database;
    return await db.update(
      'orders',
      {'status': 'cancelled'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<int> rateService(int bookingId, int rating, String review) async {
    final db = await dbHelper.database;
    return await db.insert('reviews', {
      'itemId': bookingId,
      'rating': rating,
      'comment': review,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }
}