import '../../core/database/databaseHelper.dart';
class ProfileRepository {
 final DatabaseHelper dbHelper = DatabaseHelper.instance;
 Future<Map<String, dynamic>?> getUserSettings(String userId) async {
  final db = await dbHelper.database;
  final results = await db.query('appSettings', where: 'userId = ?', whereArgs: [userId]);
  return results.isNotEmpty ? results.first : null;
 }
 Future<int> updateUserSettings(String userId, Map<String, dynamic> settings) async {
  final db = await dbHelper.database;
  final existing = await getUserSettings(userId);
  if (existing != null) {
   return await db.update('appSettings', settings, where: 'userId = ?', whereArgs: [userId]);
  } else {
   settings['userId'] = userId;
   return await db.insert('appSettings', settings);
  }
 }
 Future<List<Map<String, dynamic>>> getUserAddresses(String userId) async {
  final db = await dbHelper.database;
  return await db.query('addresses', where: 'userId = ?', whereArgs: [userId], orderBy: 'isDefault DESC');
 }
 Future<int> addAddress(Map<String, dynamic> address) async {
  final db = await dbHelper.database;
  return await db.insert('addresses', address);
 }
 Future<int> updateAddress(String addressId, Map<String, dynamic> data) async {
  final db = await dbHelper.database;
  return await db.update('addresses', data, where: 'id = ?', whereArgs: [addressId]);
 }
 Future<int> deleteAddress(String addressId) async {
  final db = await dbHelper.database;
  return await db.delete('addresses', where: 'id = ?', whereArgs: [addressId]);
 }
 Future<int> setDefaultAddress(String userId, String addressId) async {
  final db = await dbHelper.database;
  await db.update('addresses', {'isDefault': 0}, where: 'userId = ?', whereArgs: [userId]);
  return await db.update('addresses', {'isDefault': 1}, where: 'id = ?', whereArgs: [addressId]);
 }
 Future<List<Map<String, dynamic>>> getPaymentMethods(String userId) async {
  final db = await dbHelper.database;
  return await db.query('walletCards', where: 'userId = ?', whereArgs: [userId], orderBy: 'isDefault DESC');
 }
 Future<int> addPaymentMethod(Map<String, dynamic> method) async {
  final db = await dbHelper.database;
  return await db.insert('walletCards', method);
 }
 Future<int> deletePaymentMethod(String methodId) async {
  final db = await dbHelper.database;
  return await db.delete('walletCards', where: 'id = ?', whereArgs: [methodId]);
 }
 Future<int> setDefaultPaymentMethod(String userId, String methodId) async {
  final db = await dbHelper.database;
  await db.update('walletCards', {'isDefault': 0}, where: 'userId = ?', whereArgs: [userId]);
  return await db.update('walletCards', {'isDefault': 1}, where: 'id = ?', whereArgs: [methodId]);
 }
 Future<List<Map<String, dynamic>>> getSupportTickets(String userId) async {
  final db = await dbHelper.database;
  return await db.query('tickets', where: 'userId = ?', whereArgs: [userId], orderBy: 'createdAt DESC');
 }
 Future<int> createSupportTicket(Map<String, dynamic> ticket) async {
  final db = await dbHelper.database;
  ticket['createdAt'] = DateTime.now().millisecondsSinceEpoch;
  ticket['status'] = 'Open';
  return await db.insert('tickets', ticket);
 }
 Future<Map<String, dynamic>?> getReferralInfo(String userId) async {
  final db = await dbHelper.database;
  final results = await db.query('users', columns: ['referralCode', 'referralCount', 'referralEarnings'], where: 'id = ?', whereArgs: [userId]);
  return results.isNotEmpty ? results.first : null;
 }
 Future<int> updateNotificationSettings(String userId, Map<String, dynamic> settings) async {
  final db = await dbHelper.database;
  return await db.update('appSettings', settings, where: 'userId = ?', whereArgs: [userId]);
 }
 Future<int> updatePrivacySettings(String userId, Map<String, dynamic> settings) async {
  final db = await dbHelper.database;
  return await db.update('appSettings', settings, where: 'userId = ?', whereArgs: [userId]);
 }
 Future<int> updateSecuritySettings(String userId, Map<String, dynamic> settings) async {
  final db = await dbHelper.database;
  return await db.update('appSettings', settings, where: 'userId = ?', whereArgs: [userId]);
 }
 Future<int> changePassword(String userId, String newPassword) async {
  final db = await dbHelper.database;
  return await db.update('users', {'password': newPassword, 'updatedAt': DateTime.now().millisecondsSinceEpoch}, where: 'id = ?', whereArgs: [userId]);
 }
 Future<Map<String, dynamic>> getUserStats(String userId) async {
  final db = await dbHelper.database;
  final orders = await db.query('orders', where: 'userId = ?', whereArgs: [userId]);
  final transactions = await db.query('transactions', where: 'userId = ?', whereArgs: [userId]);
  int totalPoints = 0;
  for (var t in transactions) {
   if (t['type'] == 'points') {
    totalPoints += (t['amount'] as int? ?? 0);
   }
  }
  return {'ordersCount': orders.length, 'points': totalPoints, 'rewards': (totalPoints / 100).floor()};
 }
 Future<int> submitFeedback(Map<String, dynamic> feedback) async {
  final db = await dbHelper.database;
  feedback['createdAt'] = DateTime.now().millisecondsSinceEpoch;
  feedback['type'] = 'feedback';
  return await db.insert('reports', feedback);
 }
 Future<List<Map<String, dynamic>>> getChatMessages(String chatId) async {
  final db = await dbHelper.database;
  return await db.query('messages', where: 'chatId = ?', whereArgs: [chatId], orderBy: 'createdAt ASC');
 }
 Future<int> sendChatMessage(Map<String, dynamic> message) async {
  final db = await dbHelper.database;
  message['createdAt'] = DateTime.now().millisecondsSinceEpoch;
  return await db.insert('messages', message);
 }
}