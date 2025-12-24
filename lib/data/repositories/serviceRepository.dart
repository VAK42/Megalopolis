import '../../core/database/databaseHelper.dart';
import '../../shared/models/itemModel.dart';
class ServiceRepository {
 final DatabaseHelper dbHelper = DatabaseHelper.instance;
 Future<List<ItemModel>> getServices({int limit = 20, int offset = 0, String? category}) async {
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
 Future<ItemModel?> getServiceById(String id) async {
  final db = await dbHelper.database;
  final List<Map<String, dynamic>> maps = await db.query('items', where: 'id = ? AND type = ?', whereArgs: [id, 'service'], limit: 1);
  if (maps.isEmpty) return null;
  return ItemModel.fromMap(maps.first);
 }
 Future<List<Map<String, dynamic>>> getCategories() async {
  final db = await dbHelper.database;
  return await db.rawQuery("SELECT DISTINCT categoryId as category FROM items WHERE type = 'service'");
 }
 Future<List<Map<String, dynamic>>> getProviders(String category) async {
  final db = await dbHelper.database;
  return await db.rawQuery(
  '''
  SELECT i.sellerId, u.name as sellerName, u.rating as sellerRating 
  FROM items i
  JOIN users u ON i.sellerId = u.id
  WHERE i.type = 'service' AND i.categoryId = ?
  GROUP BY i.sellerId
  ''',
  [category],
  );
 }
 Future<int> bookService(Map<String, dynamic> booking) async {
  final db = await dbHelper.database;
  return await db.insert('orders', booking);
 }
 Future<List<Map<String, dynamic>>> getBookings(String userId) async {
  final db = await dbHelper.database;
  return await db.query('orders', where: 'userId = ? AND orderType = ?', whereArgs: [userId, 'service'], orderBy: 'createdAt DESC');
 }
 Future<Map<String, dynamic>?> getBookingById(String id) async {
  final db = await dbHelper.database;
  final List<Map<String, dynamic>> maps = await db.query('orders', where: 'id = ?', whereArgs: [id], limit: 1);
  if (maps.isEmpty) return null;
  return maps.first;
 }
 Future<int> cancelBooking(String id) async {
  final db = await dbHelper.database;
  return await db.update('orders', {'status': 'cancelled'}, where: 'id = ?', whereArgs: [id]);
 }
 Future<int> rateService(String bookingId, int rating, String review) async {
  final db = await dbHelper.database;
  return await db.insert('reviews', {'itemId': bookingId, 'rating': rating, 'comment': review, 'createdAt': DateTime.now().toIso8601String()});
 }
 Future<List<Map<String, dynamic>>> getPromos() async {
  final db = await dbHelper.database;
  return await db.query('promotions', where: 'type = ?', whereArgs: ['service'], orderBy: 'createdAt DESC');
 }
 Future<int> applyPromo(String userId, String promoCode) async {
  final db = await dbHelper.database;
  return await db.insert('userPromos', {'userId': userId, 'promoCode': promoCode, 'appliedAt': DateTime.now().toIso8601String()});
 }
 Future<List<Map<String, dynamic>>> getSubscriptionPlans() async {
  final db = await dbHelper.database;
  return await db.query('subscriptionPlans', where: 'type = ?', whereArgs: ['service']);
 }
 Future<int> purchaseSubscription(String userId, String planId) async {
  final db = await dbHelper.database;
  return await db.insert('userSubscriptions', {'userId': userId, 'planId': planId, 'purchasedAt': DateTime.now().toIso8601String(), 'status': 'active'});
 }
 Future<List<Map<String, dynamic>>> getInsurancePlans() async {
  final db = await dbHelper.database;
  return await db.query('insurancePlans', where: 'type = ?', whereArgs: ['service']);
 }
 Future<int> purchaseInsurance(String userId, String planId) async {
  final db = await dbHelper.database;
  return await db.insert('userInsurance', {'userId': userId, 'planId': planId, 'purchasedAt': DateTime.now().toIso8601String(), 'status': 'active'});
 }
 Future<Map<String, dynamic>?> getWarrantyInfo(String bookingId) async {
  final db = await dbHelper.database;
  final maps = await db.query('warranties', where: 'bookingId = ?', whereArgs: [bookingId], limit: 1);
  if (maps.isEmpty) return null;
  return maps.first;
 }
 Future<int> claimWarranty(String bookingId, String reason) async {
  final db = await dbHelper.database;
  return await db.insert('warrantyClaims', {'bookingId': bookingId, 'reason': reason, 'createdAt': DateTime.now().toIso8601String(), 'status': 'pending'});
 }
}