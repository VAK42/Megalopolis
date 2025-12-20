import 'package:sqflite/sqflite.dart';
import '../../core/database/databaseHelper.dart';
class AdminRepository {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  Future<List<Map<String, dynamic>>> getAllUsers({int limit = 50}) async {
    final db = await dbHelper.database;
    return await db.query('users', limit: limit);
  }
  Future<List<Map<String, dynamic>>> getTickets() async {
    final db = await dbHelper.database;
    return await db.query('tickets', orderBy: 'createdAt DESC');
  }
  Future<List<Map<String, dynamic>>> getReports() async {
    final db = await dbHelper.database;
    return await db.query('reports', orderBy: 'createdAt DESC');
  }
  Future<Map<String, dynamic>> getDashboardStats() async {
    final db = await dbHelper.database;
    final users = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM users'),
    );
    final orders = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM orders'),
    );
    final revenue = (await db.rawQuery(
      'SELECT SUM(total) as total FROM orders',
    )).first['total'];
    return {
      'totalUsers': users ?? 0,
      'totalOrders': orders ?? 0,
      'totalRevenue': revenue ?? 0.0,
    };
  }
}