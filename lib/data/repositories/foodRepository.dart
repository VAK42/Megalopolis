import '../../core/database/databaseHelper.dart';
import '../../shared/models/itemModel.dart';
class FoodRepository {
 final DatabaseHelper dbHelper = DatabaseHelper.instance;
 Future<List<Map<String, dynamic>>> getRestaurants({int limit = 20, int offset = 0}) async {
  final db = await dbHelper.database;
  return await db.rawQuery(
  '''
  SELECT i.sellerId, u.name as sellerName, u.rating as sellerRating 
  FROM items i
  JOIN users u ON i.sellerId = u.id
  WHERE i.type = 'food' 
  GROUP BY i.sellerId
  LIMIT ? OFFSET ?
  ''',
  [limit, offset],
  );
 }
 Future<Map<String, dynamic>?> getRestaurantById(String id) async {
  final db = await dbHelper.database;
  final results = await db.rawQuery(
  '''
  SELECT u.id, u.name as sellerName, u.rating as sellerRating, s.deliveryFee, s.estimatedTime, s.minOrder
  FROM users u
  LEFT JOIN sellers s ON u.id = s.userId
  WHERE u.id = ?
  ''',
  [id],
  );
  if (results.isNotEmpty) return results.first;
  return null;
 }
 Future<List<ItemModel>> getMenuByRestaurant(String restaurantId) async {
  final db = await dbHelper.database;
  final List<Map<String, dynamic>> maps = await db.query('items', where: 'sellerId = ? AND type = ?', whereArgs: [restaurantId, 'food']);
  return List.generate(maps.length, (i) => ItemModel.fromMap(maps[i]));
 }
 Future<ItemModel?> getItemById(String id) async {
  final db = await dbHelper.database;
  final List<Map<String, dynamic>> maps = await db.query('items', where: 'id = ?', whereArgs: [id], limit: 1);
  if (maps.isEmpty) return null;
  return ItemModel.fromMap(maps.first);
 }
 Future<List<Map<String, dynamic>>> getCategories() async {
  final db = await dbHelper.database;
  return await db.rawQuery("SELECT DISTINCT categoryId as category FROM items WHERE type = 'food'");
 }
 Future<List<ItemModel>> getAllFoodItems() async {
  final db = await dbHelper.database;
  final List<Map<String, dynamic>> maps = await db.query('items', where: 'type = ?', whereArgs: ['food']);
  return List.generate(maps.length, (i) => ItemModel.fromMap(maps[i]));
 }
 Future<int> addToCart(Map<String, dynamic> cartItem) async {
  final db = await dbHelper.database;
  final existing = await db.query('cartItems', where: 'userId = ? AND itemId = ?', whereArgs: [cartItem['userId'], cartItem['itemId']], limit: 1);
  if (existing.isNotEmpty) {
   final existingId = existing.first['id'];
   final existingQty = (existing.first['quantity'] as int?) ?? 0;
   final newQty = (cartItem['quantity'] as int?) ?? 1;
   return await db.update('cartItems', {'quantity': existingQty + newQty}, where: 'id = ?', whereArgs: [existingId]);
  }
  return await db.insert('cartItems', cartItem);
 }
 Future<List<Map<String, dynamic>>> getCart(String userId) async {
  final db = await dbHelper.database;
  return await db.rawQuery('''SELECT c.*, i.name, i.price, i.images FROM cartItems c JOIN items i ON c.itemId = i.id WHERE c.userId = ?''', [userId]);
 }
 Future<int> updateCartItem(String id, int quantity) async {
  final db = await dbHelper.database;
  return await db.update('cartItems', {'quantity': quantity}, where: 'id = ?', whereArgs: [id]);
 }
 Future<int> removeFromCart(String id) async {
  final db = await dbHelper.database;
  return await db.delete('cartItems', where: 'id = ?', whereArgs: [id]);
 }
 Future<int> clearCart(String userId) async {
  final db = await dbHelper.database;
  return await db.delete('cartItems', where: 'userId = ?', whereArgs: [userId]);
 }
 Future<int> placeOrder(Map<String, dynamic> order) async {
  final db = await dbHelper.database;
  return await db.insert('orders', order);
 }
 Future<List<Map<String, dynamic>>> getOrders(String userId) async {
  final db = await dbHelper.database;
  return await db.query('orders', where: 'userId = ? AND orderType = ?', whereArgs: [userId, 'food'], orderBy: 'createdAt DESC');
 }
 Future<Map<String, dynamic>?> getOrderById(String id) async {
  final db = await dbHelper.database;
  final List<Map<String, dynamic>> maps = await db.query('orders', where: 'id = ?', whereArgs: [id], limit: 1);
  if (maps.isEmpty) return null;
  return maps.first;
 }
 Future<int> updateOrderStatus(String id, String status) async {
  final db = await dbHelper.database;
  return await db.update('orders', {'status': status}, where: 'id = ?', whereArgs: [id]);
 }
 Future<int> addToFavorites(String userId, String restaurantId) async {
  final db = await dbHelper.database;
  final existing = await db.query('favorites', where: 'userId = ? AND itemId = ? AND type = ?', whereArgs: [userId, restaurantId, 'restaurant'], limit: 1);
  if (existing.isNotEmpty) return 0;
  return await db.insert('favorites', {'userId': userId, 'itemId': restaurantId, 'type': 'restaurant', 'createdAt': DateTime.now().millisecondsSinceEpoch});
 }
 Future<List<Map<String, dynamic>>> getFavorites(String userId) async {
  final db = await dbHelper.database;
  return await db.query('favorites', where: 'userId = ? AND type = ?', whereArgs: [userId, 'restaurant']);
 }
 Future<int> removeFromFavorites(String userId, String restaurantId) async {
  final db = await dbHelper.database;
  return await db.delete('favorites', where: 'userId = ? AND itemId = ? AND type = ?', whereArgs: [userId, restaurantId, 'restaurant']);
 }
 Future<List<Map<String, dynamic>>> getPromotions() async {
  final db = await dbHelper.database;
  final results = await db.query('promotions', orderBy: 'startDate DESC', limit: 5);
  return results.map((p) {
   String gradient = 'primary';
   final type = p['type']?.toString() ?? '';
   if (type.contains('food')) gradient = 'accent';
   if (type.contains('electronics')) gradient = 'success';
   if (type.contains('delivery')) gradient = 'error';
   return {...p, 'gradient': gradient};
  }).toList();
 }
 Future<List<Map<String, dynamic>>> getLoyaltyRewards() async {
  final db = await dbHelper.database;
  return await db.query('promotions', where: 'type = ?', whereArgs: ['loyalty']);
 }
 Future<Map<String, dynamic>?> getLatestOrder(String userId) async {
  final db = await dbHelper.database;
  final results = await db.query('orders', where: 'userId = ? AND orderType = ?', whereArgs: [userId, 'food'], orderBy: 'createdAt DESC', limit: 1);
  if (results.isNotEmpty) return results.first;
  return null;
 }
 Future<int> cancelOrder(String orderId) async {
  final db = await dbHelper.database;
  return await db.update('orders', {'status': 'cancelled'}, where: 'id = ?', whereArgs: [orderId]);
 }
 Future<int> deleteOrder(String orderId) async {
  final db = await dbHelper.database;
  return await db.delete('orders', where: 'id = ?', whereArgs: [orderId]);
 }
 Future<int> createReservation(Map<String, dynamic> reservation) async {
  final db = await dbHelper.database;
  return await db.insert('reservations', reservation);
 }
 Future<List<Map<String, dynamic>>> getReservations(String userId) async {
  final db = await dbHelper.database;
  return await db.query('reservations', where: 'userId = ?', whereArgs: [userId], orderBy: 'reservationDate DESC');
 }
 Future<int> updateReservation(String id, Map<String, dynamic> data) async {
  final db = await dbHelper.database;
  return await db.update('reservations', data, where: 'id = ?', whereArgs: [id]);
 }
 Future<int> cancelReservation(String id) async {
  final db = await dbHelper.database;
  return await db.update('reservations', {'status': 'cancelled'}, where: 'id = ?', whereArgs: [id]);
 }
 Future<int> deleteReservation(String id) async {
  final db = await dbHelper.database;
  return await db.delete('reservations', where: 'id = ?', whereArgs: [id]);
 }
 Future<int> addReview(Map<String, dynamic> review) async {
  final db = await dbHelper.database;
  return await db.insert('reviews', review);
 }
 Future<List<Map<String, dynamic>>> getReviews(String restaurantId) async {
  final db = await dbHelper.database;
  return await db.query('reviews', where: 'targetId = ? AND targetType = ?', whereArgs: [restaurantId, 'restaurant'], orderBy: 'createdAt DESC');
 }
 Future<int> updateReview(String id, Map<String, dynamic> data) async {
  final db = await dbHelper.database;
  return await db.update('reviews', data, where: 'id = ?', whereArgs: [id]);
 }
 Future<int> deleteReview(String id) async {
  final db = await dbHelper.database;
  return await db.delete('reviews', where: 'id = ?', whereArgs: [id]);
 }
 Future<int> createPromotion(Map<String, dynamic> promo) async {
  final db = await dbHelper.database;
  return await db.insert('promotions', promo);
 }
 Future<int> updatePromotion(String id, Map<String, dynamic> data) async {
  final db = await dbHelper.database;
  return await db.update('promotions', data, where: 'id = ?', whereArgs: [id]);
 }
 Future<int> deletePromotion(String id) async {
  final db = await dbHelper.database;
  return await db.delete('promotions', where: 'id = ?', whereArgs: [id]);
 }
}