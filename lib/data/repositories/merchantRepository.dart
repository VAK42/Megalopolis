import '../../core/database/databaseHelper.dart';
import '../../shared/models/itemModel.dart';
class MerchantRepository {
 final DatabaseHelper dbHelper = DatabaseHelper.instance;
 Future<List<Map<String, dynamic>>> getMerchantOrders(String merchantId) async {
  final db = await dbHelper.database;
  return await db.query('orders', where: 'providerId = ?', whereArgs: [merchantId], orderBy: 'createdAt DESC');
 }
 Future<int> updateOrderStatus(String orderId, String status) async {
  final db = await dbHelper.database;
  return await db.update('orders', {'status': status}, where: 'id = ?', whereArgs: [orderId]);
 }
 Future<int> cancelOrder(String orderId) async {
  final db = await dbHelper.database;
  return await db.update('orders', {'status': 'Cancelled'}, where: 'id = ?', whereArgs: [orderId]);
 }
 Future<List<Map<String, dynamic>>> getMerchantProducts(String merchantId) async {
  final db = await dbHelper.database;
  return await db.query('items', where: 'sellerId = ?', whereArgs: [merchantId]);
 }
 Future<int> addProduct(ItemModel item) async {
  final db = await dbHelper.database;
  return await db.insert('items', item.toMap());
 }
 Future<int> updateProduct(ItemModel item) async {
  final db = await dbHelper.database;
  return await db.update('items', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
 }
 Future<int> deleteProduct(String id) async {
  final db = await dbHelper.database;
  return await db.delete('items', where: 'id = ?', whereArgs: [id]);
 }
 Future<Map<String, dynamic>> getMerchantStats(String merchantId) async {
  final db = await dbHelper.database;
  final orders = await db.query('orders', where: 'providerId = ?', whereArgs: [merchantId]);
  double revenue = 0;
  for (var o in orders) {
   revenue += (o['total'] as num).toDouble();
  }
  return {'totalOrders': orders.length, 'totalRevenue': revenue};
 }
 Future<List<Map<String, dynamic>>> getMerchantPayouts(String merchantId) async {
  final db = await dbHelper.database;
  return await db.query('payouts', where: 'merchantId = ?', whereArgs: [merchantId], orderBy: 'createdAt DESC');
 }
 Future<int> requestWithdrawal(String merchantId, double amount) async {
  final db = await dbHelper.database;
  return await db.insert('payouts', {'merchantId': merchantId, 'amount': amount, 'status': 'Pending', 'createdAt': DateTime.now().millisecondsSinceEpoch});
 }
 Future<int> cancelWithdrawal(String payoutId) async {
  final db = await dbHelper.database;
  return await db.update('payouts', {'status': 'Cancelled'}, where: 'id = ?', whereArgs: [payoutId]);
 }
 Future<Map<String, dynamic>?> getMerchantProfile(String merchantId) async {
  final db = await dbHelper.database;
  final results = await db.query('sellers', where: 'id = ?', whereArgs: [merchantId]);
  return results.isNotEmpty ? results.first : null;
 }
 Future<int> registerMerchant(Map<String, dynamic> data) async {
  final db = await dbHelper.database;
  return await db.insert('sellers', data);
 }
 Future<int> updateMerchantProfile(String merchantId, Map<String, dynamic> data) async {
  final db = await dbHelper.database;
  return await db.update('sellers', data, where: 'id = ?', whereArgs: [merchantId]);
 }
 Future<List<Map<String, dynamic>>> getMerchantPromotions(String merchantId) async {
  final db = await dbHelper.database;
  return await db.query('promotions', where: 'merchantId = ?', whereArgs: [merchantId], orderBy: 'createdAt DESC');
 }
 Future<int> createPromotion(Map<String, dynamic> promo) async {
  final db = await dbHelper.database;
  return await db.insert('promotions', promo);
 }
 Future<int> updatePromotion(String promoId, Map<String, dynamic> data) async {
  final db = await dbHelper.database;
  return await db.update('promotions', data, where: 'id = ?', whereArgs: [promoId]);
 }
 Future<int> deletePromotion(String promoId) async {
  final db = await dbHelper.database;
  return await db.delete('promotions', where: 'id = ?', whereArgs: [promoId]);
 }
 Future<int> togglePromotionStatus(String promoId, bool isActive) async {
  final db = await dbHelper.database;
  return await db.update('promotions', {'isActive': isActive ? 1 : 0}, where: 'id = ?', whereArgs: [promoId]);
 }
 Future<List<Map<String, dynamic>>> getMerchantReviews(String merchantId) async {
  final db = await dbHelper.database;
  return await db.query('reviews', where: 'targetId = ?', whereArgs: [merchantId], orderBy: 'createdAt DESC');
 }
}