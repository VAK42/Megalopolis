import '../../core/database/databaseHelper.dart';
class SettingsRepository {
 final DatabaseHelper dbHelper = DatabaseHelper.instance;
 Future<Map<String, dynamic>> getAccessibilitySettings(String userId) async {
  final db = await dbHelper.database;
  final maps = await db.query('appSettings', where: 'userId = ? AND category = ?', whereArgs: [userId, 'accessibility'], limit: 1);
  if (maps.isEmpty) return {'screenReader': false, 'highContrast': false, 'reducedMotion': false};
  return maps.first;
 }
 Future<int> updateAccessibilitySettings(String userId, Map<String, dynamic> settings) async {
  final db = await dbHelper.database;
  await db.delete('appSettings', where: 'userId = ? AND category = ?', whereArgs: [userId, 'accessibility']);
  return await db.insert('appSettings', {...settings, 'userId': userId, 'category': 'accessibility'});
 }
 Future<Map<String, dynamic>> getNetworkSettings(String userId) async {
  final db = await dbHelper.database;
  final maps = await db.query('appSettings', where: 'userId = ? AND category = ?', whereArgs: [userId, 'network'], limit: 1);
  if (maps.isEmpty) return {'wifiOnly': false, 'dataCompression': true, 'dataUsed': 0};
  return maps.first;
 }
 Future<int> updateNetworkSettings(String userId, Map<String, dynamic> settings) async {
  final db = await dbHelper.database;
  await db.delete('appSettings', where: 'userId = ? AND category = ?', whereArgs: [userId, 'network']);
  return await db.insert('appSettings', {...settings, 'userId': userId, 'category': 'network'});
 }
 Future<Map<String, dynamic>> getStorageInfo(String userId) async {
  final db = await dbHelper.database;
  final maps = await db.query('appSettings', where: 'userId = ? AND category = ?', whereArgs: [userId, 'storage'], limit: 1);
  if (maps.isEmpty) return {'totalUsed': 0, 'available': 2048, 'images': 0, 'videos': 0, 'documents': 0, 'other': 0};
  return maps.first;
 }
 Future<int> clearCache(String userId) async {
  final db = await dbHelper.database;
  return await db.update('appSettings', {'totalUsed': 0, 'images': 0, 'videos': 0, 'documents': 0, 'other': 0}, where: 'userId = ? AND category = ?', whereArgs: [userId, 'storage']);
 }
 Future<Map<String, dynamic>> getOfflineSettings(String userId) async {
  final db = await dbHelper.database;
  final maps = await db.query('appSettings', where: 'userId = ? AND category = ?', whereArgs: [userId, 'offline'], limit: 1);
  if (maps.isEmpty) return {'enabled': false, 'downloadedMaps': 0, 'downloadedData': 0, 'lastSynced': null};
  return maps.first;
 }
 Future<int> updateOfflineSettings(String userId, Map<String, dynamic> settings) async {
  final db = await dbHelper.database;
  await db.delete('appSettings', where: 'userId = ? AND category = ?', whereArgs: [userId, 'offline']);
  return await db.insert('appSettings', {...settings, 'userId': userId, 'category': 'offline'});
 }
 Future<int> syncOfflineData(String userId) async {
  final db = await dbHelper.database;
  return await db.update('appSettings', {'lastSynced': DateTime.now().toIso8601String()}, where: 'userId = ? AND category = ?', whereArgs: [userId, 'offline']);
 }
 Future<Map<String, dynamic>> getVoiceSettings(String userId) async {
  final db = await dbHelper.database;
  final maps = await db.query('appSettings', where: 'userId = ? AND category = ?', whereArgs: [userId, 'voice'], limit: 1);
  if (maps.isEmpty) return {'enabled': false, 'language': 'English'};
  return maps.first;
 }
 Future<int> updateVoiceSettings(String userId, Map<String, dynamic> settings) async {
  final db = await dbHelper.database;
  await db.delete('appSettings', where: 'userId = ? AND category = ?', whereArgs: [userId, 'voice']);
  return await db.insert('appSettings', {...settings, 'userId': userId, 'category': 'voice'});
 }
 Future<Map<String, dynamic>> getFontSettings(String userId) async {
  final db = await dbHelper.database;
  final maps = await db.query('appSettings', where: 'userId = ? AND category = ?', whereArgs: [userId, 'font'], limit: 1);
  if (maps.isEmpty) return {'fontSize': 'Medium'};
  return maps.first;
 }
 Future<int> updateFontSettings(String userId, String fontSize) async {
  final db = await dbHelper.database;
  await db.delete('appSettings', where: 'userId = ? AND category = ?', whereArgs: [userId, 'font']);
  return await db.insert('appSettings', {'userId': userId, 'category': 'font', 'fontSize': fontSize});
 }
 Future<Map<String, dynamic>> getColorBlindSettings(String userId) async {
  final db = await dbHelper.database;
  final maps = await db.query('appSettings', where: 'userId = ? AND category = ?', whereArgs: [userId, 'colorBlind'], limit: 1);
  if (maps.isEmpty) return {'mode': 'none'};
  return maps.first;
 }
 Future<int> updateColorBlindSettings(String userId, String mode) async {
  final db = await dbHelper.database;
  await db.delete('appSettings', where: 'userId = ? AND category = ?', whereArgs: [userId, 'colorBlind']);
  return await db.insert('appSettings', {'userId': userId, 'category': 'colorBlind', 'mode': mode});
 }
}