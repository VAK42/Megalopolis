import '../../core/database/databaseHelper.dart';
import '../../shared/models/itemModel.dart';
class MartRepository {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  Future<List<ItemModel>> getProducts({
    int limit = 20,
    int offset = 0,
    String? category,
  }) async {
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
  Future<ItemModel?> getProductById(int id) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'items',
      where: 'id = ? AND type = ?',
      whereArgs: [id, 'product'],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return ItemModel.fromMap(maps.first);
  }
  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await dbHelper.database;
    return await db.rawQuery(
      'SELECT DISTINCT categoryId FROM items WHERE type = "product"',
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
      whereArgs: [userId, 'mart'],
      orderBy: 'createdAt DESC',
    );
  }
  Future<int> addToWishlist(int userId, int productId) async {
    final db = await dbHelper.database;
    return await db.insert('favorites', {
      'userId': userId,
      'itemId': productId,
      'type': 'product',
    });
  }
  Future<List<Map<String, dynamic>>> getWishlist(int userId) async {
    final db = await dbHelper.database;
    return await db.rawQuery(
      '''SELECT f.*, i.name, i.price, i.images FROM favorites f JOIN items i ON f.itemId = i.id WHERE f.userId = ? AND f.type = ?''',
      [userId, 'product'],
    );
  }
  Future<int> removeFromWishlist(int userId, int productId) async {
    final db = await dbHelper.database;
    return await db.delete(
      'favorites',
      where: 'userId = ? AND itemId = ? AND type = ?',
      whereArgs: [userId, productId, 'product'],
    );
  }
  Future<List<Map<String, dynamic>>> getReviews(int productId) async {
    final db = await dbHelper.database;
    return await db.query(
      'reviews',
      where: 'itemId = ?',
      whereArgs: [productId],
      orderBy: 'createdAt DESC',
    );
  }
  Future<int> addReview(Map<String, dynamic> review) async {
    final db = await dbHelper.database;
    return await db.insert('reviews', review);
  }
}