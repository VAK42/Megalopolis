import '../../core/database/databaseHelper.dart';
class MerchantRepository {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  Future<List<Map<String, dynamic>>> getMerchantOrders(
    String merchantId,
  ) async {
    final db = await dbHelper.database;
    return await db.query(
      'orders',
      where: 'providerId = ?',
      whereArgs: [merchantId],
      orderBy: 'createdAt DESC',
    );
  }
  Future<List<Map<String, dynamic>>> getMerchantProducts(
    String merchantId,
  ) async {
    final db = await dbHelper.database;
    return await db.query(
      'items',
      where: 'sellerId = ?',
      whereArgs: [merchantId],
    );
  }
  Future<Map<String, dynamic>> getMerchantStats(String merchantId) async {
    final db = await dbHelper.database;
    final orders = await db.query(
      'orders',
      where: 'providerId = ?',
      whereArgs: [merchantId],
    );
    double revenue = 0;
    for (var o in orders) {
      revenue += (o['total'] as num).toDouble();
    }
    return {'totalOrders': orders.length, 'totalRevenue': revenue};
  }
}