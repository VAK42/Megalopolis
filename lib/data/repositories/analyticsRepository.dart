import '../../core/database/databaseHelper.dart';
class AnalyticsRepository {
 final DatabaseHelper dbHelper = DatabaseHelper.instance;
 Future<double> getTotalSpending(String userId) async {
  final db = await dbHelper.database;
  final result = await db.rawQuery('SELECT SUM(total) as total FROM orders WHERE userId = ? AND status = ?', [userId, 'completed']);
  if (result.isNotEmpty && result.first['total'] != null) {
   return (result.first['total'] as num).toDouble();
  }
  return 0.0;
 }
 Future<Map<String, double>> getSpendingByCategory(String userId) async {
  final db = await dbHelper.database;
  final result = await db.rawQuery(
  '''
  SELECT orderType, SUM(total) as total 
  FROM orders 
  WHERE userId = ? AND status = ? 
  GROUP BY orderType
  ''', [userId, 'completed'],
  );
  final Map<String, double> spending = {};
  for (var row in result) {
   spending[row['orderType'] as String] = (row['total'] as num).toDouble();
  }
  return spending;
 }
 Future<List<Map<String, dynamic>>> getRecentTransactions(String userId) async {
  final db = await dbHelper.database;
  return await db.query('orders', where: 'userId = ? AND status = ?', whereArgs: [userId, 'completed'], orderBy: 'completedAt DESC');
 }
 Future<List<Map<String, dynamic>>> getBudgets(String userId) async {
  final db = await dbHelper.database;
  final budgetsResult = await db.query('analyticsBudgets', where: 'userId = ?', whereArgs: [userId]);
  if (budgetsResult.isEmpty) {
   return [];
  }
  final spending = await getSpendingByCategory(userId);
  return budgetsResult.map((b) {
   final cat = b['category'] as String;
   return {'category': cat, 'limit': (b['budgetLimit'] as num).toDouble(), 'spent': spending[cat] ?? 0.0};
  }).toList();
 }
 Future<List<Map<String, dynamic>>> getGoals(String userId) async {
  final db = await dbHelper.database;
  final goalsResult = await db.query('analyticsGoals', where: 'userId = ?', whereArgs: [userId]);
  if (goalsResult.isEmpty) {
   return [];
  }
  return goalsResult.map((g) => {'id': g['id'], 'title': g['title'], 'target': (g['target'] as num).toDouble(), 'current': (g['current'] as num).toDouble()}).toList();
 }
 Future<int> createGoal({required String userId, required String title, required double target, double current = 0}) async {
  final db = await dbHelper.database;
  final now = DateTime.now().millisecondsSinceEpoch;
  return await db.insert('analyticsGoals', {'id': 'goal$now', 'userId': userId, 'title': title, 'target': target, 'current': current, 'createdAt': now});
 }
 Future<int> updateGoal(String goalId, Map<String, dynamic> updates) async {
  final db = await dbHelper.database;
  return await db.update('analyticsGoals', updates, where: 'id = ?', whereArgs: [goalId]);
 }
 Future<int> deleteGoal(String goalId) async {
  final db = await dbHelper.database;
  return await db.delete('analyticsGoals', where: 'id = ?', whereArgs: [goalId]);
 }
 Future<int> updateGoalProgress(String goalId, double amount) async {
  final db = await dbHelper.database;
  return await db.rawUpdate('UPDATE analyticsGoals SET current = current + ? WHERE id = ?', [amount, goalId]);
 }
 Future<double> getTotalIncome(String userId) async {
  final db = await dbHelper.database;
  final result = await db.rawQuery('SELECT SUM(amount) as total FROM transactions WHERE userId = ? AND type = ?', [userId, 'topup']);
  if (result.isNotEmpty && result.first['total'] != null) {
   return (result.first['total'] as num).toDouble();
  }
  return 0.0;
 }
 Future<List<Map<String, dynamic>>> getIncomeSources(String userId) async {
  final db = await dbHelper.database;
  return await db.query('transactions', where: 'userId = ? AND type = ?', whereArgs: [userId, 'topup'], orderBy: 'createdAt DESC', limit: 10);
 }
 Future<Map<String, dynamic>> getInvestments(String userId) async {
  final db = await dbHelper.database;
  final result = await db.query('analyticsInvestments', where: 'userId = ?', whereArgs: [userId]);
  if (result.isEmpty) {
   return {'total': 0.0, 'growth': 0.0, 'growthPercentage': 0.0, 'portfolio': <Map<String, dynamic>>[]};
  }
  double total = 0;
  double growth = 0;
  final portfolio = result.map((i) {
   total += (i['value'] as num).toDouble();
   growth += (i['growth'] as num).toDouble();
   return {'name': i['name'], 'growth': (i['growthPercent'] as num).toDouble()};
  }).toList();
  return {'total': total, 'growth': growth, 'growthPercentage': total > 0 ? (growth / total * 100) : 0.0, 'portfolio': portfolio};
 }
 Future<Map<String, dynamic>> getSavings(String userId) async {
  final db = await dbHelper.database;
  final result = await db.query('analyticsSavingsGoals', where: 'userId = ?', whereArgs: [userId]);
  if (result.isEmpty) {
   return {'total': 0.0, 'month': 0.0, 'goal': 0.0};
  }
  double total = 0;
  double goal = 0;
  for (var s in result) {
   total += (s['current'] as num).toDouble();
   goal += (s['target'] as num).toDouble();
  }
  return {'total': total, 'month': total * 0.1, 'goal': goal};
 }
 Future<Map<String, dynamic>> getTax(String userId) async {
  final income = await getTotalIncome(userId);
  final estimated = income * 0.22;
  return {
   'estimated': estimated,
   'breakdown': [
    {'name': 'Income Tax', 'amount': estimated * 0.72},
    {'name': 'Sales Tax', 'amount': estimated * 0.13},
    {'name': 'Property Tax', 'amount': estimated * 0.15},
   ],
  };
 }
 Future<List<Map<String, dynamic>>> getTrends(String userId) async {
  final db = await dbHelper.database;
  final now = DateTime.now();
  final weekAgo = now.subtract(const Duration(days: 7)).millisecondsSinceEpoch;
  final result = await db.rawQuery(
  '''
  SELECT strftime('%w', createdAt/1000, 'unixepoch') as dayNum, SUM(total) as amount
  FROM orders
  WHERE userId = ? AND status = ? AND createdAt >= ?
  GROUP BY dayNum
  ORDER BY dayNum
  ''', [userId, 'completed', weekAgo],
  );
  final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  if (result.isEmpty) {
   return days.map((d) => {'day': d, 'amount': 0.0}).toList();
  }
  return result.map((r) {
   final dayIndex = int.tryParse(r['dayNum'].toString()) ?? 0;
   return {'day': days[dayIndex], 'amount': (r['amount'] as num).toDouble()};
  }).toList();
 }
 Future<List<Map<String, dynamic>>> getMonthlyComparison(String userId) async {
  final db = await dbHelper.database;
  final now = DateTime.now();
  final months = <Map<String, dynamic>>[];
  for (int i = 0; i < 3; i++) {
   final month = DateTime(now.year, now.month - i, 1);
   final nextMonth = DateTime(now.year, now.month - i + 1, 1);
   final spendingResult = await db.rawQuery('SELECT SUM(total) as total FROM orders WHERE userId = ? AND status = ? AND createdAt >= ? AND createdAt < ?', [userId, 'completed', month.millisecondsSinceEpoch, nextMonth.millisecondsSinceEpoch]);
   final incomeResult = await db.rawQuery('SELECT SUM(amount) as total FROM transactions WHERE userId = ? AND type = ? AND createdAt >= ? AND createdAt < ?', [userId, 'topup', month.millisecondsSinceEpoch, nextMonth.millisecondsSinceEpoch]);
   final monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
   double spending = (spendingResult.first['total'] as num?)?.toDouble() ?? 0.0;
   double income = (incomeResult.first['total'] as num?)?.toDouble() ?? 0.0;
   months.add({'month': monthNames[month.month - 1], 'spending': spending, 'income': income});
  }
  return months;
 }
 Future<String> generateReport(String userId, String reportType) async {
  final StringBuffer buffer = StringBuffer();
  if (reportType == 'Transaction Log') {
   final transactions = await getRecentTransactions(userId);
   buffer.writeln('Date,Order ID,Amount,Status');
   for (var t in transactions) {
    buffer.writeln('${t['completedAt']},${t['id']},${t['total']},${t['status']}');
   }
  } else if (reportType == 'Monthly Statement') {
   final comparison = await getMonthlyComparison(userId);
   buffer.writeln('Month,Spending,Income,Net');
   for (var c in comparison) {
    buffer.writeln('${c['month']},${c['spending']},${c['income']},${(c['income'] as num) - (c['spending'] as num)}');
   }
  } else {
   buffer.writeln('Report: $reportType');
   buffer.writeln('Generated On: ${DateTime.now()}');
   buffer.writeln('User ID: $userId');
  }
  return buffer.toString();
 }
}