import '../../core/database/databaseHelper.dart';
class AddressRepository {
 final DatabaseHelper _dbHelper = DatabaseHelper.instance;
 Future<List<Map<String, dynamic>>> getAddresses(String userId) async {
  final db = await _dbHelper.database;
  return await db.query('addresses', where: 'userId = ?', whereArgs: [userId], orderBy: 'isDefault DESC, id DESC');
 }
 Future<Map<String, dynamic>?> getDefaultAddress(String userId) async {
  final db = await _dbHelper.database;
  final addresses = await db.query('addresses', where: 'userId = ? AND isDefault = 1', whereArgs: [userId], limit: 1);
  return addresses.isEmpty ? null : addresses.first;
 }
 Future<String> addAddress({required String userId, String? label, required String fullAddress, double? lat, double? lng, bool isDefault = false}) async {
  final db = await _dbHelper.database;
  final now = DateTime.now().millisecondsSinceEpoch;
  final addressId = 'addr${now}${userId}';
  if (isDefault) {
   await db.update('addresses', {'isDefault': 0}, where: 'userId = ?', whereArgs: [userId]);
  }
  await db.insert('addresses', {'id': addressId, 'userId': userId, 'label': label, 'fullAddress': fullAddress, 'lat': lat, 'lng': lng, 'isDefault': isDefault ? 1 : 0});
  return addressId;
 }
 Future<void> updateAddress(String addressId, Map<String, dynamic> updates) async {
  final db = await _dbHelper.database;
  await db.update('addresses', updates, where: 'id = ?', whereArgs: [addressId]);
 }
 Future<void> deleteAddress(String addressId) async {
  final db = await _dbHelper.database;
  await db.delete('addresses', where: 'id = ?', whereArgs: [addressId]);
 }
 Future<void> setDefaultAddress(String userId, String addressId) async {
  final db = await _dbHelper.database;
  await db.update('addresses', {'isDefault': 0}, where: 'userId = ?', whereArgs: [userId]);
  await db.update('addresses', {'isDefault': 1}, where: 'id = ?', whereArgs: [addressId]);
 }
 Future<Map<String, dynamic>?> getAddressById(String addressId) async {
  final db = await _dbHelper.database;
  final addresses = await db.query('addresses', where: 'id = ?', whereArgs: [addressId], limit: 1);
  return addresses.isEmpty ? null : addresses.first;
 }
}