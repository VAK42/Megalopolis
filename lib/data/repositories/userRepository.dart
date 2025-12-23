import 'package:sqflite/sqflite.dart';
import '../../core/database/databaseHelper.dart';
import '../../shared/models/userModel.dart';
class UserRepository {
 final DatabaseHelper dbHelper = DatabaseHelper.instance;
 Future<UserModel?> getUserById(String id) async {
  final db = await dbHelper.database;
  final List<Map<String, dynamic>> maps = await db.query('users', where: 'id = ?', whereArgs: [id], limit: 1);
  if (maps.isEmpty) return null;
  return UserModel.fromMap(maps.first);
 }
 Future<UserModel?> getUserByEmail(String email) async {
  final db = await dbHelper.database;
  final List<Map<String, dynamic>> maps = await db.query('users', where: 'email = ?', whereArgs: [email], limit: 1);
  if (maps.isEmpty) return null;
  return UserModel.fromMap(maps.first);
 }
 Future<int> createUser(UserModel user) async {
  final db = await dbHelper.database;
  return await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
 }
 Future<int> updateUser(UserModel user) async {
  final db = await dbHelper.database;
  return await db.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
 }
 Future<int> deleteUser(String id) async {
  final db = await dbHelper.database;
  return await db.delete('users', where: 'id = ?', whereArgs: [id]);
 }
 Future<List<Map<String, dynamic>>> getUserAddresses(String userId) async {
  final db = await dbHelper.database;
  return await db.query('addresses', where: 'userId = ?', whereArgs: [userId]);
 }
 Future<int> addAddress(Map<String, dynamic> address) async {
  final db = await dbHelper.database;
  return await db.insert('addresses', address);
 }
 Future<int> updateAddress(int id, Map<String, dynamic> address) async {
  final db = await dbHelper.database;
  return await db.update('addresses', address, where: 'id = ?', whereArgs: [id]);
 }
 Future<int> deleteAddress(int id) async {
  final db = await dbHelper.database;
  return await db.delete('addresses', where: 'id = ?', whereArgs: [id]);
 }
}