import '../../core/database/databaseHelper.dart';
import '../../shared/models/itemModel.dart';
class FoodRepository {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  Future<List<Map<String, dynamic>>> getRestaurants({
    int limit = 20,
    int offset = 0,
  }) async {
    final db = await dbHelper.database;
    return await db.rawQuery(
      '''
      SELECT i.sellerId, u.name as sellerName, u.rating as sellerRating 
      FROM items i
      JOIN users u ON i.sellerId = u.id
      WHERE i.type = "food" 
      GROUP BY i.sellerId
      LIMIT ? OFFSET ?
      ''',
      [limit, offset],
    );
  }
  Future<List<ItemModel>> getMenuByRestaurant(int restaurantId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'items',
      where: 'sellerId = ? AND type = ?',
      whereArgs: [restaurantId, 'food'],
    );
    return List.generate(maps.length, (i) => ItemModel.fromMap(maps[i]));
  }
  Future<ItemModel?> getItemById(int id) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'items',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return ItemModel.fromMap(maps.first);
  }
  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await dbHelper.database;
    return await db.rawQuery(
      'SELECT DISTINCT categoryId FROM items WHERE type = "food"',
    );
  }
  Future<int> addToCart(Map<String, dynamic> cartItem) async {
    final db = await dbHelper.database;
    return await db.insert('cartItems', cartItem);
  }
  Future<List<Map<String, dynamic>>> getCart(int userId) async {
    final db = await dbHelper.database;
    return await db.rawQuery(
      '''SELECT c.*, i.name, i.price, i.images FROM cartItems c JOIN items i ON c.itemId = i.id WHERE c.userId = ?''',
      [userId],
    );
  }
  Future<int> updateCartItem(int id, int quantity) async {
    final db = await dbHelper.database;
    return await db.update(
      'cartItems',
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<int> removeFromCart(int id) async {
    final db = await dbHelper.database;
    return await db.delete('cartItems', where: 'id = ?', whereArgs: [id]);
  }
  Future<int> clearCart(int userId) async {
    final db = await dbHelper.database;
    return await db.delete(
      'cartItems',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }
  Future<int> placeOrder(Map<String, dynamic> order) async {
    final db = await dbHelper.database;
    return await db.insert('orders', order);
  }
  Future<List<Map<String, dynamic>>> getOrders(int userId) async {
    final db = await dbHelper.database;
    return await db.query(
      'orders',
      where: 'userId = ? AND orderType = ?',
      whereArgs: [userId, 'food'],
      orderBy: 'createdAt DESC',
    );
  }
  Future<Map<String, dynamic>?> getOrderById(int id) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return maps.first;
  }
  Future<int> updateOrderStatus(int id, String status) async {
    final db = await dbHelper.database;
    return await db.update(
      'orders',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<int> addToFavorites(int userId, int restaurantId) async {
    final db = await dbHelper.database;
    return await db.insert('favorites', {
      'userId': userId,
      'itemId': restaurantId,
      'type': 'restaurant',
    });
  }
  Future<List<Map<String, dynamic>>> getFavorites(int userId) async {
    final db = await dbHelper.database;
    return await db.query(
      'favorites',
      where: 'userId = ? AND type = ?',
      whereArgs: [userId, 'restaurant'],
    );
  }
  Future<int> removeFromFavorites(int userId, int restaurantId) async {
    final db = await dbHelper.database;
    return await db.delete(
      'favorites',
      where: 'userId = ? AND itemId = ? AND type = ?',
      whereArgs: [userId, restaurantId, 'restaurant'],
    );
  }
}