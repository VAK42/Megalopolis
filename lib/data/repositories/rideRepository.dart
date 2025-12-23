import '../../core/database/databaseHelper.dart';
class RideRepository {
 final DatabaseHelper dbHelper = DatabaseHelper.instance;
 Future<int> bookRide(Map<String, dynamic> ride) async {
  final db = await dbHelper.database;
  return await db.insert('orders', ride);
 }
 Future<List<Map<String, dynamic>>> getRides(String userId) async {
  final db = await dbHelper.database;
  return await db.query('orders', where: 'userId = ? AND type = ?', whereArgs: [userId, 'ride'], orderBy: 'createdAt DESC');
 }
 Future<Map<String, dynamic>?> getActiveRide(String userId) async {
  final db = await dbHelper.database;
  final List<Map<String, dynamic>> maps = await db.query('orders', where: 'userId = ? AND type = ? AND status IN (?, ?)', whereArgs: [userId, 'ride', 'pending', 'active'], limit: 1);
  if (maps.isEmpty) return null;
  return maps.first;
 }
 Future<Map<String, dynamic>?> getRideById(String id) async {
  final db = await dbHelper.database;
  final List<Map<String, dynamic>> maps = await db.query('orders', where: 'id = ?', whereArgs: [id], limit: 1);
  if (maps.isEmpty) return null;
  return maps.first;
 }
 Future<int> updateRideStatus(String id, String status) async {
  final db = await dbHelper.database;
  return await db.update('orders', {'status': status}, where: 'id = ?', whereArgs: [id]);
 }
 Future<int> cancelRide(String id) async {
  final db = await dbHelper.database;
  return await db.update('orders', {'status': 'cancelled'}, where: 'id = ?', whereArgs: [id]);
 }
 Future<int> savePlaceAsync(String userId, Map<String, dynamic> place) async {
  final db = await dbHelper.database;
  place['userId'] = userId;
  return await db.insert('addresses', place);
 }
 Future<List<Map<String, dynamic>>> getSavedPlaces(String userId) async {
  final db = await dbHelper.database;
  return await db.query('addresses', where: 'userId = ? AND isSavedPlace = ?', whereArgs: [userId, 1]);
 }
 Future<int> scheduleRide(Map<String, dynamic> ride) async {
  final db = await dbHelper.database;
  return await db.insert('orders', ride);
 }
 Future<List<Map<String, dynamic>>> getScheduledRides(String userId) async {
  final db = await dbHelper.database;
  return await db.query('orders', where: 'userId = ? AND type = ? AND status = ?', whereArgs: [userId, 'ride', 'scheduled']);
 }
 Future<List<Map<String, dynamic>>> getRidePasses(String userId) async {
  final db = await dbHelper.database;
  return await db.query('orders', where: 'userId = ? AND type = ?', whereArgs: [userId, 'ride_pass'], orderBy: 'createdAt DESC');
 }
 Future<int> purchaseRidePass(Map<String, dynamic> pass) async {
  final db = await dbHelper.database;
  pass['type'] = 'ride_pass';
  pass['createdAt'] = DateTime.now().millisecondsSinceEpoch;
  return await db.insert('orders', pass);
 }
 Future<List<Map<String, dynamic>>> getRentals(String userId) async {
  final db = await dbHelper.database;
  return await db.query('orders', where: 'userId = ? AND type = ?', whereArgs: [userId, 'rental'], orderBy: 'createdAt DESC');
 }
 Future<int> bookRental(Map<String, dynamic> rental) async {
  final db = await dbHelper.database;
  rental['type'] = 'rental';
  rental['createdAt'] = DateTime.now().millisecondsSinceEpoch;
  return await db.insert('orders', rental);
 }
 Future<int> deleteSavedPlace(String placeId) async {
  final db = await dbHelper.database;
  return await db.delete('addresses', where: 'id = ?', whereArgs: [placeId]);
 }
 Future<int> rateDriver(String rideId, double rating, String comment) async {
  final db = await dbHelper.database;
  return await db.update('orders', {'driverRating': rating, 'ratingComment': comment}, where: 'id = ?', whereArgs: [rideId]);
 }
}