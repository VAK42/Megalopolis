import '../../core/database/databaseHelper.dart';
class AdminRepository {
 final DatabaseHelper dbHelper = DatabaseHelper.instance;
 Future<List<Map<String, dynamic>>> getAllUsers({int limit = 50}) async {
  final db = await dbHelper.database;
  return await db.query('users', limit: limit);
 }
 Future<List<Map<String, dynamic>>> getAllOrders() async {
  final db = await dbHelper.database;
  return await db.query('orders', orderBy: 'createdAt DESC');
 }
 Future<List<Map<String, dynamic>>> getSupportTickets() async {
  final db = await dbHelper.database;
  return await db.query('supportTickets', orderBy: 'createdAt DESC');
 }
 Future<List<Map<String, dynamic>>> getContentReports() async {
  final db = await dbHelper.database;
  return await db.query('contentReports', orderBy: 'createdAt DESC');
 }
 Future<List<Map<String, dynamic>>> getReportTypes() async {
  final db = await dbHelper.database;
  return await db.query('reportTypes', where: 'isActive = ?', whereArgs: [1], orderBy: 'sortOrder ASC');
 }
 Future<Map<String, dynamic>> getSystemStats() async {
  final db = await dbHelper.database;
  final users = await db.query('users');
  final orders = await db.query('orders');
  double revenue = 0;
  for (var order in orders) {
   revenue += (order['total'] as num).toDouble();
  }
  return {'totalUsers': users.length, 'totalOrders': orders.length, 'totalRevenue': revenue};
 }
 Future<Map<String, dynamic>> getRevenueStats() async {
  final db = await dbHelper.database;
  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
  final weekStart = now.subtract(Duration(days: 7)).millisecondsSinceEpoch;
  final monthStart = DateTime(now.year, now.month, 1).millisecondsSinceEpoch;
  final allOrders = await db.query('orders', where: 'status = ?', whereArgs: ['completed']);
  double totalRevenue = 0;
  double todayRevenue = 0;
  double weekRevenue = 0;
  double monthRevenue = 0;
  for (var order in allOrders) {
   final amount = (order['total'] as num).toDouble();
   final createdAt = order['createdAt'] as int;
   totalRevenue += amount;
   if (createdAt >= todayStart) todayRevenue += amount;
   if (createdAt >= weekStart) weekRevenue += amount;
   if (createdAt >= monthStart) monthRevenue += amount;
  }
  return {'total': totalRevenue, 'today': todayRevenue, 'week': weekRevenue, 'month': monthRevenue};
 }
 Future<Map<String, double>> getModuleRevenue() async {
  final db = await dbHelper.database;
  final orders = await db.query('orders', where: 'status = ?', whereArgs: ['completed']);
  Map<String, double> moduleRevenue = {'food': 0.0, 'ride': 0.0, 'mart': 0.0, 'service': 0.0, 'wallet': 0.0};
  for (var order in orders) {
   final type = order['orderType'] as String;
   final amount = (order['total'] as num).toDouble();
   if (moduleRevenue.containsKey(type)) {
    moduleRevenue[type] = moduleRevenue[type]! + amount;
   }
  }
  return moduleRevenue;
 }
 Future<int> getUserCount() async {
  final db = await dbHelper.database;
  final users = await db.query('users');
  return users.length;
 }
 Future<int> getActiveOrderCount() async {
  final db = await dbHelper.database;
  final orders = await db.query('orders', where: 'status IN (?, ?)', whereArgs: ['pending', 'active']);
  return orders.length;
 }
 Future<int> getSupportTicketCount() async {
  final db = await dbHelper.database;
  final tickets = await db.query('supportTickets', where: 'status = ?', whereArgs: ['open']);
  return tickets.length;
 }
 Future<Map<String, dynamic>> getDashboardStats() async {
  final userCount = await getUserCount();
  final activeOrders = await getActiveOrderCount();
  final ticketCount = await getSupportTicketCount();
  final revenueStats = await getRevenueStats();
  return {'totalUsers': userCount, 'activeOrders': activeOrders, 'revenue': revenueStats['today'], 'supportTickets': ticketCount};
 }
 Future<int> createUser(Map<String, dynamic> user) async {
  final db = await dbHelper.database;
  final now = DateTime.now().millisecondsSinceEpoch;
  user['id'] = 'user_$now';
  user['createdAt'] = now;
  user['updatedAt'] = now;
  return await db.insert('users', user);
 }
 Future<int> updateUser(String userId, Map<String, dynamic> updates) async {
  final db = await dbHelper.database;
  updates['updatedAt'] = DateTime.now().millisecondsSinceEpoch;
  return await db.update('users', updates, where: 'id = ?', whereArgs: [userId]);
 }
 Future<int> deleteUser(String userId) async {
  final db = await dbHelper.database;
  return await db.delete('users', where: 'id = ?', whereArgs: [userId]);
 }
 Future<int> blockUser(String userId) async {
  return await updateUser(userId, {'status': 'blocked'});
 }
 Future<int> updateOrderStatus(String orderId, String status) async {
  final db = await dbHelper.database;
  final updates = {'status': status};
  if (status == 'completed') {
   updates['completedAt'] = DateTime.now().millisecondsSinceEpoch.toString();
  }
  return await db.update('orders', updates, where: 'id = ?', whereArgs: [orderId]);
 }
 Future<int> cancelOrder(String orderId) async {
  return await updateOrderStatus(orderId, 'cancelled');
 }
 Future<int> createPromotion(Map<String, dynamic> promo) async {
  final db = await dbHelper.database;
  final now = DateTime.now().millisecondsSinceEpoch;
  promo['id'] = 'promo_$now';
  return await db.insert('promotions', promo);
 }
 Future<int> updatePromotion(String promoId, Map<String, dynamic> updates) async {
  final db = await dbHelper.database;
  return await db.update('promotions', updates, where: 'id = ?', whereArgs: [promoId]);
 }
 Future<int> deletePromotion(String promoId) async {
  final db = await dbHelper.database;
  return await db.delete('promotions', where: 'id = ?', whereArgs: [promoId]);
 }
 Future<int> sendNotification({required String title, required String body, required String audience}) async {
  final db = await dbHelper.database;
  final now = DateTime.now().millisecondsSinceEpoch;
  final users = await db.query('users');
  int count = 0;
  for (var user in users) {
   await db.insert('notifications', {'id': 'notif${now}${user['id']}', 'userId': user['id'], 'title': title, 'body': body, 'type': 'admin', 'isRead': 0, 'createdAt': now});
   count++;
  }
  return count;
 }
 Future<int> updateSupportTicketStatus(String ticketId, String status) async {
  final db = await dbHelper.database;
  return await db.update('supportTickets', {'status': status}, where: 'id = ?', whereArgs: [ticketId]);
 }
 Future<int> updateContentReportStatus(String reportId, String status) async {
  final db = await dbHelper.database;
  return await db.update('contentReports', {'status': status}, where: 'id = ?', whereArgs: [reportId]);
 }
 Future<int> updateSystemSetting(String key, String value, String type) async {
  final db = await dbHelper.database;
  final now = DateTime.now().millisecondsSinceEpoch;
  return await db.update('systemSettings', {'value': value, 'updatedAt': now}, where: 'key = ?', whereArgs: [key]);
 }
 Future<int> createSystemSetting(String key, String value, String type) async {
  final db = await dbHelper.database;
  final now = DateTime.now().millisecondsSinceEpoch;
  return await db.insert('systemSettings', {'key': key, 'value': value, 'type': type, 'updatedAt': now});
 }
}