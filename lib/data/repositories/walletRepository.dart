import '../../core/database/databaseHelper.dart';
class WalletRepository {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  Future<double> getBalance(int userId) async {
    final db = await dbHelper.database;
    final result = await db.rawQuery(
      'SELECT SUM(CASE WHEN type IN ("credit", "topup", "refund") THEN amount WHEN type IN ("debit", "transfer", "payment") THEN -amount ELSE 0 END) as balance FROM transactions WHERE userId = ?',
      [userId],
    );
    return (result.first['balance'] as num?)?.toDouble() ?? 0.0;
  }
  Future<int> addTransaction(Map<String, dynamic> transaction) async {
    final db = await dbHelper.database;
    return await db.insert('transactions', transaction);
  }
  Future<List<Map<String, dynamic>>> getTransactions(
    int userId, {
    int limit = 50,
  }) async {
    final db = await dbHelper.database;
    return await db.query(
      'transactions',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
      limit: limit,
    );
  }
  Future<int> topUp(int userId, double amount, String method) async {
    final db = await dbHelper.database;
    return await db.insert('transactions', {
      'userId': userId,
      'type': 'topup',
      'amount': amount,
      'paymentMethod': method,
      'status': 'completed',
      'createdAt': DateTime.now().toIso8601String(),
    });
  }
  Future<int> transfer(int fromUserId, int toUserId, double amount) async {
    final db = await dbHelper.database;
    await db.insert('transactions', {
      'userId': fromUserId,
      'type': 'transfer',
      'amount': amount,
      'toUserId': toUserId,
      'status': 'completed',
      'createdAt': DateTime.now().toIso8601String(),
    });
    return await db.insert('transactions', {
      'userId': toUserId,
      'type': 'credit',
      'amount': amount,
      'fromUserId': fromUserId,
      'status': 'completed',
      'createdAt': DateTime.now().toIso8601String(),
    });
  }
  Future<int> payBill(int userId, double amount, String billType) async {
    final db = await dbHelper.database;
    return await db.insert('transactions', {
      'userId': userId,
      'type': 'payment',
      'amount': amount,
      'description': billType,
      'status': 'completed',
      'createdAt': DateTime.now().toIso8601String(),
    });
  }
  Future<int> withdraw(int userId, double amount, String bankAccount) async {
    final db = await dbHelper.database;
    return await db.insert('transactions', {
      'userId': userId,
      'type': 'debit',
      'amount': amount,
      'description': 'Withdrawal to $bankAccount',
      'status': 'pending',
      'createdAt': DateTime.now().toIso8601String(),
    });
  }
  Future<List<Map<String, dynamic>>> getCards(int userId) async {
    final db = await dbHelper.database;
    return await db.query(
      'walletCards',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }
  Future<int> addCard(Map<String, dynamic> card) async {
    final db = await dbHelper.database;
    return await db.insert('walletCards', card);
  }
  Future<int> removeCard(int id) async {
    final db = await dbHelper.database;
    return await db.delete('walletCards', where: 'id = ?', whereArgs: [id]);
  }
  Future<Map<String, dynamic>> getAnalytics(int userId, {int days = 30}) async {
    final db = await dbHelper.database;
    final DateTime startDate = DateTime.now().subtract(Duration(days: days));
    final result = await db.rawQuery(
      '''SELECT SUM(CASE WHEN type IN ("debit", "payment", "transfer") THEN amount ELSE 0 END) as totalSpent, SUM(CASE WHEN type IN ("credit", "topup", "refund") THEN amount ELSE 0 END) as totalIncome FROM transactions WHERE userId = ? AND createdAt >= ?''',
      [userId, startDate.toIso8601String()],
    );
    return result.first;
  }
}