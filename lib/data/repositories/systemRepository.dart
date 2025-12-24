import 'dart:convert';
import '../../core/database/databaseHelper.dart';
import '../../shared/models/itemModel.dart';
class SystemRepository {
 final DatabaseHelper dbHelper = DatabaseHelper.instance;
 Future<Map<String, dynamic>> getSettings() async {
  final db = await dbHelper.database;
  final List<Map<String, dynamic>> results = await db.query('appSettings');
  final Map<String, dynamic> settings = {};
  for (var row in results) {
   final key = row['key'] as String;
   final value = row['value'];
   final type = row['type'] as String;
   if (type == 'boolean') {
    settings[key] = value.toString().toLowerCase() == 'true';
   } else if (type == 'integer') {
    settings[key] = int.tryParse(value.toString()) ?? 0;
   } else if (type == 'double') {
    settings[key] = double.tryParse(value.toString()) ?? 0.0;
   } else {
    settings[key] = value.toString();
   }
  }
  return settings;
 }
 Future<String> getSearchHint() async {
  final db = await dbHelper.database;
  final result = await db.query('appSettings', where: 'key = ?', whereArgs: ['searchHint']);
  if (result.isNotEmpty) return result.first['value'] as String;
  return 'Search...';
 }
 Future<List<Map<String, dynamic>>> getGlobalCategories() async {
  final db = await dbHelper.database;
  final result = await db.query('appSettings', where: 'key = ?', whereArgs: ['globalCategories']);
  if (result.isNotEmpty) {
   final jsonStr = result.first['value'] as String;
   final List<dynamic> list = jsonDecode(jsonStr);
   return list.cast<Map<String, dynamic>>();
  }
  return [];
 }
 Future<List<ItemModel>> globalSearch(String query) async {
  final db = await dbHelper.database;
  final List<Map<String, dynamic>> maps = await db.query('items', where: 'name LIKE ? OR description LIKE ?', whereArgs: ['%$query%', '%$query%'], limit: 50);
  return List.generate(maps.length, (i) => ItemModel.fromMap(maps[i]));
 }
 Future<List<String>> getSearchHistory(String userId) async {
  final db = await dbHelper.database;
  final results = await db.query('searchHistory', where: 'userId = ?', whereArgs: [userId], orderBy: 'createdAt DESC', limit: 10);
  return results.map((e) => e['query'] as String).toList();
 }
 Future<void> addSearchHistory(String userId, String query) async {
  final db = await dbHelper.database;
  await db.delete('searchHistory', where: 'userId = ? AND query = ?', whereArgs: [userId, query]);
  await db.insert('searchHistory', {'userId': userId, 'query': query, 'createdAt': DateTime.now().millisecondsSinceEpoch});
 }
 Future<void> clearSearchHistory(String userId) async {
  final db = await dbHelper.database;
  await db.delete('searchHistory', where: 'userId = ?', whereArgs: [userId]);
 }
 Future<List<String>> getPopularSearches() async {
  final db = await dbHelper.database;
  final results = await db.rawQuery('SELECT query, COUNT(*) as count FROM searchHistory GROUP BY query ORDER BY count DESC LIMIT 5');
  if (results.isEmpty) {
   return ['Headphones', 'Pizza', 'Cleaning', 'Shoes', 'Burger'];
  }
  return results.map((e) => e['query'] as String).toList();
 }
}