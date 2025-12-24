import '../../core/database/databaseHelper.dart';
class WalletRepository {
 final DatabaseHelper dbHelper = DatabaseHelper.instance;
 Future<double> getBalance(String userId) async {
  final db = await dbHelper.database;
  final result = await db.rawQuery("SELECT SUM(CASE WHEN type IN ('credit', 'topup', 'refund') THEN amount WHEN type IN ('debit', 'transfer', 'payment') THEN -amount ELSE 0 END) as balance FROM transactions WHERE userId = ?", [userId]);
  return (result.first['balance'] as num?)?.toDouble() ?? 0.0;
 }
 Future<int> addTransaction(Map<String, dynamic> transaction) async {
  final db = await dbHelper.database;
  return await db.insert('transactions', transaction);
 }
 Future<List<Map<String, dynamic>>> getTransactions(String userId, {int limit = 50}) async {
  final db = await dbHelper.database;
  return await db.query('transactions', where: 'userId = ?', whereArgs: [userId], orderBy: 'createdAt DESC', limit: limit);
 }
 Future<int> topUp(String userId, double amount, String method) async {
  final db = await dbHelper.database;
  return await db.insert('transactions', {'userId': userId, 'type': 'topup', 'amount': amount, 'paymentMethod': method, 'status': 'completed', 'createdAt': DateTime.now().toIso8601String()});
 }
 Future<int> transfer(String fromUserId, String toUserId, double amount) async {
  final db = await dbHelper.database;
  await db.insert('transactions', {'userId': fromUserId, 'type': 'transfer', 'amount': amount, 'toUserId': toUserId, 'status': 'completed', 'createdAt': DateTime.now().toIso8601String()});
  return await db.insert('transactions', {'userId': toUserId, 'type': 'credit', 'amount': amount, 'fromUserId': fromUserId, 'status': 'completed', 'createdAt': DateTime.now().toIso8601String()});
 }
 Future<int> payBill(String userId, double amount, String billType) async {
  final db = await dbHelper.database;
  return await db.insert('transactions', {'userId': userId, 'type': 'payment', 'amount': amount, 'description': billType, 'status': 'completed', 'createdAt': DateTime.now().toIso8601String()});
 }
 Future<int> withdraw(String userId, double amount, String bankAccount) async {
  final db = await dbHelper.database;
  return await db.insert('transactions', {'userId': userId, 'type': 'debit', 'amount': amount, 'description': 'Withdrawal to $bankAccount', 'status': 'pending', 'createdAt': DateTime.now().toIso8601String()});
 }
 Future<List<Map<String, dynamic>>> getCards(String userId) async {
  final db = await dbHelper.database;
  return await db.query('walletCards', where: 'userId = ?', whereArgs: [userId]);
 }
 Future<int> addCard(Map<String, dynamic> card) async {
  final db = await dbHelper.database;
  return await db.insert('walletCards', card);
 }
 Future<int> removeCard(int id) async {
  final db = await dbHelper.database;
  return await db.delete('walletCards', where: 'id = ?', whereArgs: [id]);
 }
 Future<Map<String, dynamic>> getAnalytics(String userId, {int days = 30}) async {
  final db = await dbHelper.database;
  final DateTime startDate = DateTime.now().subtract(Duration(days: days));
  final result = await db.rawQuery("SELECT SUM(CASE WHEN type IN ('debit', 'payment', 'transfer') THEN amount ELSE 0 END) as totalSpent, SUM(CASE WHEN type IN ('credit', 'topup', 'refund') THEN amount ELSE 0 END) as totalIncome FROM transactions WHERE userId = ? AND createdAt >= ?", [userId, startDate.toIso8601String()]);
  return result.first;
 }
 Future<List<Map<String, dynamic>>> getBills(String userId, {String status = 'all'}) async {
  final db = await dbHelper.database;
  if (status == 'all') {
   return await db.query('bills', where: 'userId = ?', whereArgs: [userId], orderBy: 'dueDate ASC');
  }
  return await db.query('bills', where: 'userId = ? AND status = ?', whereArgs: [userId, status], orderBy: 'dueDate ASC');
 }
 Future<Map<String, dynamic>?> getBillById(String billId) async {
  final db = await dbHelper.database;
  final results = await db.query('bills', where: 'id = ?', whereArgs: [billId]);
  return results.isEmpty ? null : results.first;
 }
 Future<int> payExistingBill(String billId, String userId, double amount) async {
  final db = await dbHelper.database;
  await db.update('bills', {'status': 'paid', 'lastPaymentDate': DateTime.now().millisecondsSinceEpoch}, where: 'id = ?', whereArgs: [billId]);
  return await db.insert('transactions', {'id': 'txn_${DateTime.now().millisecondsSinceEpoch}', 'userId': userId, 'type': 'payment', 'amount': amount, 'status': 'completed', 'reference': 'Bill Payment - $billId', 'createdAt': DateTime.now().millisecondsSinceEpoch});
 }
 Future<Map<String, int>> getBillSummary(String userId) async {
  final bills = await getBills(userId);
  int pending = 0;
  int paid = 0;
  for (var bill in bills) {
   if (bill['status'] == 'pending') pending++;
   if (bill['status'] == 'paid') paid++;
  }
  return {'pending': pending, 'paid': paid, 'total': bills.length};
 }
 Future<List<Map<String, dynamic>>> getGiftCards(String userId) async {
  final db = await dbHelper.database;
  return await db.query('giftCards', where: 'userId = ? AND status = ?', whereArgs: [userId, 'active'], orderBy: 'createdAt DESC');
 }
 Future<double> getGiftCardTotalBalance(String userId) async {
  final cards = await getGiftCards(userId);
  double total = 0;
  for (var card in cards) {
   total += (card['balance'] as num).toDouble();
  }
  return total;
 }
 Future<double> getBalanceTrend(String userId, {int days = 30}) async {
  final db = await dbHelper.database;
  final periodStart = DateTime.now().subtract(Duration(days: days)).millisecondsSinceEpoch;
  final recentTransactions = await db.query('transactions', where: 'userId = ? AND createdAt >= ?', whereArgs: [userId, periodStart]);
  final olderTransactions = await db.query('transactions', where: 'userId = ? AND createdAt < ?', whereArgs: [userId, periodStart]);
  double recentBalance = 0;
  for (var tx in recentTransactions) {
   final amount = (tx['amount'] as num).toDouble();
   final type = tx['type'] as String;
   if (type == 'credit' || type == 'topup' || type == 'refund') {
    recentBalance += amount;
   } else if (type == 'debit' || type == 'transfer' || type == 'payment') {
    recentBalance -= amount;
   }
  }
  double olderBalance = 0;
  for (var tx in olderTransactions) {
   final amount = (tx['amount'] as num).toDouble();
   final type = tx['type'] as String;
   if (type == 'credit' || type == 'topup' || type == 'refund') {
    olderBalance += amount;
   } else if (type == 'debit' || type == 'transfer' || type == 'payment') {
    olderBalance -= amount;
   }
  }
  if (olderBalance == 0) return 0.0;
  final currentTotal = olderBalance + recentBalance;
  return ((currentTotal - olderBalance) / olderBalance) * 100;
 }
 Future<int> createMoneyRequest(Map<String, dynamic> request) async {
  final db = await dbHelper.database;
  return await db.insert('transactions', {'userId': request['userId'], 'type': 'request', 'amount': request['amount'], 'description': request['reason'], 'status': 'pending', 'createdAt': DateTime.now().millisecondsSinceEpoch});
 }
 Future<Map<String, dynamic>?> getMoneyRequest(int id) async {
  final db = await dbHelper.database;
  final results = await db.query('transactions', where: 'id = ?', whereArgs: [id]);
  return results.isEmpty ? null : results.first;
 }
 Future<List<Map<String, dynamic>>> getRecurringPayments(String userId) async {
  final db = await dbHelper.database;
  return await db.query('recurringPayments', where: 'userId = ?', whereArgs: [userId], orderBy: 'nextPayDate ASC');
 }
 Future<Map<String, dynamic>> getBudget(String userId) async {
  final db = await dbHelper.database;
  final results = await db.query('budgets', where: 'userId = ?', whereArgs: [userId], limit: 1);
  if (results.isEmpty) return {'monthlyBudget': 0.0, 'spent': 0.0, 'remaining': 0.0, 'categories': []};
  return results.first;
 }
 Future<List<Map<String, dynamic>>> getBudgetCategories(String userId) async {
  final db = await dbHelper.database;
  return await db.query('budgetCategories', where: 'userId = ?', whereArgs: [userId]);
 }
 Future<Map<String, dynamic>> getInvestments(String userId) async {
  final db = await dbHelper.database;
  final results = await db.query('investments', where: 'userId = ?', whereArgs: [userId]);
  double totalValue = 0;
  double totalReturns = 0;
  for (var inv in results) {
   totalValue += (inv['currentValue'] as num?)?.toDouble() ?? 0;
   totalReturns += (inv['returns'] as num?)?.toDouble() ?? 0;
  }
  return {'totalValue': totalValue, 'totalReturns': totalReturns, 'investments': results};
 }
 Future<Map<String, dynamic>> getLoanOffers(String userId) async {
  final db = await dbHelper.database;
  final results = await db.query('loanOffers', where: 'userId = ?', whereArgs: [userId], limit: 1);
  if (results.isEmpty) return {'amount': 0.0, 'interestRate': 0.0, 'tenure': 0, 'emi': 0.0, 'totalRepayment': 0.0};
  return results.first;
 }
 Future<List<Map<String, dynamic>>> getCashbackOffers(String userId) async {
  final db = await dbHelper.database;
  return await db.query('cashbackOffers', where: 'userId = ? OR userId IS NULL', whereArgs: [userId]);
 }
 Future<double> getCashbackTotal(String userId) async {
  final db = await dbHelper.database;
  final result = await db.rawQuery('SELECT SUM(amount) as total FROM cashbackHistory WHERE userId = ?', [userId]);
  return (result.first['total'] as num?)?.toDouble() ?? 0.0;
 }
 Future<List<Map<String, dynamic>>> getBankAccounts(String userId) async {
  final db = await dbHelper.database;
  return await db.query('bankAccounts', where: 'userId = ?', whereArgs: [userId]);
 }
}