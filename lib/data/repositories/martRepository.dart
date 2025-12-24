import '../../core/database/databaseHelper.dart';
import '../../shared/models/itemModel.dart';
class MartRepository {
 final DatabaseHelper dbHelper = DatabaseHelper.instance;
 Future<List<ItemModel>> getProducts({int limit = 20, int offset = 0, String? category}) async {
  final db = await dbHelper.database;
  String sql = 'SELECT * FROM items WHERE type = ?';
  List<dynamic> args = ['product'];
  if (category != null) {
   sql += ' AND categoryId = ?';
   args.add(category);
  }
  sql += ' LIMIT ? OFFSET ?';
  args.addAll([limit, offset]);
  final List<Map<String, dynamic>> maps = await db.rawQuery(sql, args);
  return List.generate(maps.length, (i) => ItemModel.fromMap(maps[i]));
 }
 Future<ItemModel?> getProductById(String id) async {
  final db = await dbHelper.database;
  final List<Map<String, dynamic>> maps = await db.query('items', where: 'id = ? AND type = ?', whereArgs: [id, 'product'], limit: 1);
  if (maps.isEmpty) return null;
  return ItemModel.fromMap(maps.first);
 }
 Future<List<Map<String, dynamic>>> getCategories() async {
  final db = await dbHelper.database;
  return await db.rawQuery("SELECT DISTINCT categoryId as category FROM items WHERE type = 'product'");
 }
 Future<int> addToCart(Map<String, dynamic> cartItem) async {
  final db = await dbHelper.database;
  return await db.insert('cartItems', cartItem);
 }
 Future<List<Map<String, dynamic>>> getCart(String userId) async {
  final db = await dbHelper.database;
  return await db.rawQuery('''SELECT c.*, i.name, i.price, i.images FROM cartItems c JOIN items i ON c.itemId = i.id WHERE c.userId = ?''', [userId]);
 }
 Future<int> updateCartItem(int id, int quantity) async {
  final db = await dbHelper.database;
  return await db.update('cartItems', {'quantity': quantity}, where: 'id = ?', whereArgs: [id]);
 }
 Future<int> removeFromCart(int id) async {
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
  return await db.query('orders', where: 'userId = ? AND orderType = ?', whereArgs: [userId, 'mart'], orderBy: 'createdAt DESC');
 }
 Future<int> addToWishlist(String userId, String productId) async {
  final db = await dbHelper.database;
  return await db.insert('favorites', {'userId': userId, 'itemId': productId, 'type': 'product'});
 }
 Future<List<Map<String, dynamic>>> getWishlist(String userId) async {
  final db = await dbHelper.database;
  return await db.rawQuery('''SELECT f.*, i.name, i.price, i.images FROM favorites f JOIN items i ON f.itemId = i.id WHERE f.userId = ? AND f.type = ?''', [userId, 'product']);
 }
 Future<int> removeFromWishlist(String userId, String productId) async {
  final db = await dbHelper.database;
  return await db.delete('favorites', where: 'userId = ? AND itemId = ? AND type = ?', whereArgs: [userId, productId, 'product']);
 }
 Future<List<Map<String, dynamic>>> getReviews(String productId) async {
  final db = await dbHelper.database;
  return await db.query('reviews', where: 'itemId = ?', whereArgs: [productId], orderBy: 'createdAt DESC');
 }
 Future<List<ItemModel>> searchProducts(String query) async {
  final db = await dbHelper.database;
  final List<Map<String, dynamic>> maps = await db.query('items', where: 'type = ? AND name LIKE ?', whereArgs: ['product', '%$query%']);
  return List.generate(maps.length, (i) => ItemModel.fromMap(maps[i]));
 }
 Future<List<String>> getBrands() async {
  final db = await dbHelper.database;
  final result = await db.rawQuery("SELECT DISTINCT metadata FROM items WHERE type = 'product' AND metadata IS NOT NULL");
  return result.map((e) => e['metadata'] as String).toList();
 }
 Future<List<ItemModel>> getProductsByBrand(String brand) async {
  final db = await dbHelper.database;
  final List<Map<String, dynamic>> maps = await db.query('items', where: 'type = ? AND metadata LIKE ?', whereArgs: ['product', '%$brand%']);
  return List.generate(maps.length, (i) => ItemModel.fromMap(maps[i]));
 }
 Future<Map<String, dynamic>?> getSeller(String sellerId) async {
  final db = await dbHelper.database;
  final results = await db.query('sellers', where: 'id = ?', whereArgs: [sellerId]);
  return results.isEmpty ? null : results.first;
 }
 Future<List<ItemModel>> getSellerProducts(String sellerId, {int limit = 20}) async {
  final db = await dbHelper.database;
  final List<Map<String, dynamic>> maps = await db.query('items', where: 'type = ? AND sellerId = ?', whereArgs: ['product', sellerId], limit: limit);
  return List.generate(maps.length, (i) => ItemModel.fromMap(maps[i]));
 }
 Future<List<Map<String, dynamic>>> getPromotions() async {
  final db = await dbHelper.database;
  final results = await db.query('promotions', orderBy: 'startDate DESC', limit: 5);
  return results.map((p) => {...p, 'subtitle': p['description'] ?? '${p['discount']}% Off'}).toList();
 }
 Future<List<String>> getSearchHistory(String userId) async {
  final db = await dbHelper.database;
  final results = await db.query('searchHistory', where: 'userId = ?', whereArgs: [userId.toString()], orderBy: 'createdAt DESC', limit: 10);
  return results.map((e) => e['query'] as String).toList();
 }
 Future<void> addSearchHistory(String userId, String query) async {
  final db = await dbHelper.database;
  await db.insert('searchHistory', {'userId': userId.toString(), 'query': query, 'createdAt': DateTime.now().millisecondsSinceEpoch});
 }
 Future<void> clearSearchHistory(String userId) async {
  final db = await dbHelper.database;
  await db.delete('searchHistory', where: 'userId = ?', whereArgs: [userId.toString()]);
 }
 Future<List<String>> getPopularSearches() async {
  final db = await dbHelper.database;
  final results = await db.rawQuery('SELECT query, COUNT(*) as count FROM searchHistory GROUP BY query ORDER BY count DESC LIMIT 5');
  return results.map((e) => e['query'] as String).toList();
 }
 Future<int> cancelOrder(String orderId) async {
  final db = await dbHelper.database;
  return await db.update('orders', {'status': 'cancelled'}, where: 'id = ?', whereArgs: [orderId]);
 }
 Future<int> deleteOrder(String orderId) async {
  final db = await dbHelper.database;
  return await db.delete('orders', where: 'id = ?', whereArgs: [orderId]);
 }
 Future<int> updateOrderStatus(String orderId, String status) async {
  final db = await dbHelper.database;
  return await db.update('orders', {'status': status}, where: 'id = ?', whereArgs: [orderId]);
 }
 Future<int> addReview(Map<String, dynamic> review) async {
  final db = await dbHelper.database;
  return await db.insert('reviews', review);
 }
 Future<int> updateReview(String reviewId, Map<String, dynamic> data) async {
  final db = await dbHelper.database;
  return await db.update('reviews', data, where: 'id = ?', whereArgs: [reviewId]);
 }
 Future<int> deleteReview(String reviewId) async {
  final db = await dbHelper.database;
  return await db.delete('reviews', where: 'id = ?', whereArgs: [reviewId]);
 }
 Future<int> submitReturnRequest(Map<String, dynamic> request) async {
  final db = await dbHelper.database;
  return await db.insert('returnRequests', request);
 }
 Future<List<Map<String, dynamic>>> getReturnRequests(String userId) async {
  final db = await dbHelper.database;
  return await db.query('returnRequests', where: 'userId = ?', whereArgs: [userId], orderBy: 'createdAt DESC');
 }
 Future<int> cancelReturnRequest(String requestId) async {
  final db = await dbHelper.database;
  return await db.update('returnRequests', {'status': 'cancelled'}, where: 'id = ?', whereArgs: [requestId]);
 }
}