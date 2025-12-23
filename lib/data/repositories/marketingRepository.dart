import '../../core/database/databaseHelper.dart';
class MarketingRepository {
 final DatabaseHelper dbHelper = DatabaseHelper.instance;
 Future<List<Map<String, dynamic>>> getPromotions() async {
  final db = await dbHelper.database;
  return await db.query('promotions', orderBy: 'endDate ASC');
 }
 Future<List<Map<String, dynamic>>> getBadges(String userId) async {
  final db = await dbHelper.database;
  return await db.query('badges', where: 'userId = ?', whereArgs: [userId]);
 }
 Future<List<Map<String, dynamic>>> getChallenges(String userId) async {
  final db = await dbHelper.database;
  return await db.rawQuery(
   '''
  SELECT c.*, uc.currentProgress, uc.isCompleted 
  FROM challenges c
  LEFT JOIN userChallenges uc ON c.id = uc.challengeId AND uc.userId = ?
  ''',
   [userId],
  );
 }
 Future<Map<String, dynamic>> getCheckInStatus(String userId) async {
  final db = await dbHelper.database;
  final result = await db.query('checkIns', where: 'userId = ?', whereArgs: [userId], orderBy: 'checkInDate DESC', limit: 7);
  if (result.isEmpty) {
   return {'streak': 0, 'lastCheckIn': null, 'history': <Map<String, dynamic>>[]};
  }
  int streak = 0;
  final now = DateTime.now();
  for (var checkIn in result) {
   final date = DateTime.fromMillisecondsSinceEpoch(checkIn['checkInDate'] as int);
   if (now.difference(date).inDays <= streak + 1) {
    streak++;
   } else {
    break;
   }
  }
  return {'streak': streak, 'lastCheckIn': result.first['checkInDate'], 'history': result};
 }
 Future<int> performCheckIn(String userId) async {
  final db = await dbHelper.database;
  final now = DateTime.now().millisecondsSinceEpoch;
  return await db.insert('checkIns', {'userId': userId, 'checkInDate': now, 'reward': 10});
 }
 Future<List<Map<String, dynamic>>> getLeaderboard() async {
  final db = await dbHelper.database;
  return await db.rawQuery('''
  SELECT u.id, u.name, u.rating, 
   (SELECT COUNT(*) FROM orders WHERE userId = u.id AND status = 'completed') as points
  FROM users u
  WHERE u.role = 'user'
  ORDER BY points DESC
  LIMIT 50
  ''');
 }
 Future<int> getUserRank(String userId) async {
  final leaderboard = await getLeaderboard();
  for (int i = 0; i < leaderboard.length; i++) {
   if (leaderboard[i]['id'].toString() == userId) {
    return i + 1;
   }
  }
  return leaderboard.length + 1;
 }
 Future<Map<String, dynamic>> getScratchCard(String userId) async {
  final db = await dbHelper.database;
  final result = await db.query('scratchCards', where: 'userId = ? AND isScratched = 0', whereArgs: [userId], limit: 1);
  if (result.isEmpty) {
   final now = DateTime.now().millisecondsSinceEpoch;
   final rewards = [5, 10, 15, 20, 25, 50];
   final reward = rewards[now % rewards.length];
   final id = await db.insert('scratchCards', {'userId': userId, 'reward': reward, 'isScratched': 0, 'createdAt': now});
   return {'id': id, 'reward': reward, 'isScratched': false};
  }
  return {'id': result.first['id'], 'reward': result.first['reward'], 'isScratched': result.first['isScratched'] == 1};
 }
 Future<int> scratchCard(int cardId) async {
  final db = await dbHelper.database;
  return await db.update('scratchCards', {'isScratched': 1, 'scratchedAt': DateTime.now().millisecondsSinceEpoch}, where: 'id = ?', whereArgs: [cardId]);
 }
 Future<int> claimReward(int cardId, String userId) async {
  final db = await dbHelper.database;
  final card = await db.query('scratchCards', where: 'id = ?', whereArgs: [cardId]);
  if (card.isEmpty) return 0;
  final reward = card.first['reward'] as int;
  await db.rawUpdate('UPDATE users SET balance = balance + ? WHERE id = ?', [reward, userId]);
  return await db.update('scratchCards', {'isClaimed': 1}, where: 'id = ?', whereArgs: [cardId]);
 }
 Future<List<int>> getSpinWheelOptions() async {
  final db = await dbHelper.database;
  final result = await db.query('spinWheelOptions', columns: ['value'], where: 'isActive = ?', whereArgs: [1], orderBy: 'sortOrder ASC');
  return result.map((e) => e['value'] as int).toList();
 }
 Future<int> processSpinWin(String userId, int amount) async {
  final db = await dbHelper.database;
  if (amount > 0) {
   await db.rawUpdate('UPDATE users SET balance = balance + ? WHERE id = ?', [amount, userId]);
  }
  return amount;
 }
 Future<int> deleteCheckIn(int checkInId) async {
  final db = await dbHelper.database;
  return await db.delete('checkIns', where: 'id = ?', whereArgs: [checkInId]);
 }
 Future<int> deleteScratchCard(int cardId) async {
  final db = await dbHelper.database;
  return await db.delete('scratchCards', where: 'id = ?', whereArgs: [cardId]);
 }
 Future<int> deleteBadge(int badgeId) async {
  final db = await dbHelper.database;
  return await db.delete('badges', where: 'id = ?', whereArgs: [badgeId]);
 }
 Future<int> clearCheckInHistory(String userId) async {
  final db = await dbHelper.database;
  return await db.delete('checkIns', where: 'userId = ?', whereArgs: [userId]);
 }
 Future<int> createBadge(Map<String, dynamic> badge) async {
  final db = await dbHelper.database;
  return await db.insert('badges', badge);
 }
 Future<int> updateBadge(int badgeId, Map<String, dynamic> data) async {
  final db = await dbHelper.database;
  return await db.update('badges', data, where: 'id = ?', whereArgs: [badgeId]);
 }
 Future<int> awardBadge(String userId, String badgeName) async {
  final db = await dbHelper.database;
  return await db.insert('badges', {'userId': userId, 'name': badgeName, 'achieved': 1, 'awardedAt': DateTime.now().millisecondsSinceEpoch});
 }
 Future<int> createPromotion(Map<String, dynamic> promo) async {
  final db = await dbHelper.database;
  return await db.insert('promotions', promo);
 }
 Future<int> updatePromotion(int promoId, Map<String, dynamic> data) async {
  final db = await dbHelper.database;
  return await db.update('promotions', data, where: 'id = ?', whereArgs: [promoId]);
 }
 Future<int> deletePromotion(int promoId) async {
  final db = await dbHelper.database;
  return await db.delete('promotions', where: 'id = ?', whereArgs: [promoId]);
 }
 Future<int> createChallenge(Map<String, dynamic> challenge) async {
  final db = await dbHelper.database;
  return await db.insert('challenges', challenge);
 }
 Future<int> updateChallenge(int challengeId, Map<String, dynamic> data) async {
  final db = await dbHelper.database;
  return await db.update('challenges', data, where: 'id = ?', whereArgs: [challengeId]);
 }
 Future<int> deleteChallenge(int challengeId) async {
  final db = await dbHelper.database;
  return await db.delete('challenges', where: 'id = ?', whereArgs: [challengeId]);
 }
 Future<int> joinChallenge(String userId, int challengeId) async {
  final db = await dbHelper.database;
  return await db.insert('userChallenges', {'userId': userId, 'challengeId': challengeId, 'currentProgress': 0, 'isCompleted': 0, 'joinedAt': DateTime.now().millisecondsSinceEpoch});
 }
 Future<int> updateChallengeProgress(String oderId, int challengeId, int progress) async {
  final db = await dbHelper.database;
  return await db.update('userChallenges', {'currentProgress': progress}, where: 'userId = ? AND challengeId = ?', whereArgs: [oderId, challengeId]);
 }
 Future<int> completeChallenge(String userId, int challengeId) async {
  final db = await dbHelper.database;
  return await db.update('userChallenges', {'isCompleted': 1, 'completedAt': DateTime.now().millisecondsSinceEpoch}, where: 'userId = ? AND challengeId = ?', whereArgs: [userId, challengeId]);
 }
 Future<int> leaveChallenge(String userId, int challengeId) async {
  final db = await dbHelper.database;
  return await db.delete('userChallenges', where: 'userId = ? AND challengeId = ?', whereArgs: [userId, challengeId]);
 }
}