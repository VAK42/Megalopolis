import 'dart:convert';
import '../../core/database/databaseHelper.dart';
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
}