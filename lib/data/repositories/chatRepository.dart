import '../../core/database/databaseHelper.dart';
class ChatRepository {
 final DatabaseHelper _dbHelper = DatabaseHelper.instance;
 Future<List<Map<String, dynamic>>> getChats(String userId) async {
  final db = await _dbHelper.database;
  return await db.query('chats', where: 'participants LIKE ?', whereArgs: ['%$userId%'], orderBy: 'lastMessageAt DESC');
 }
 Future<List<Map<String, dynamic>>> getMessages(String chatId) async {
  final db = await _dbHelper.database;
  return await db.query('messages', where: 'chatId = ?', whereArgs: [chatId], orderBy: 'createdAt ASC');
 }
 Future<void> sendMessage({required String chatId, required String senderId, required String content, String type = 'text'}) async {
  final db = await _dbHelper.database;
  final now = DateTime.now().millisecondsSinceEpoch;
  await db.insert('messages', {'id': 'msg_${now}_$senderId', 'chatId': chatId, 'senderId': senderId, 'content': content, 'type': type, 'createdAt': now});
  await db.update('chats', {'lastMessage': content, 'lastMessageAt': now}, where: 'id = ?', whereArgs: [chatId]);
 }
 Future<String> createChat({required List<String> participants, String type = 'direct'}) async {
  final db = await _dbHelper.database;
  final now = DateTime.now().millisecondsSinceEpoch;
  final chatId = 'chat_${now}_${participants.join('_')}';
  await db.insert('chats', {'id': chatId, 'participants': participants.join(','), 'type': type, 'lastMessageAt': now});
  return chatId;
 }
 Future<Map<String, dynamic>?> getChatBetweenUsers(String userId1, String userId2) async {
  final db = await _dbHelper.database;
  final chats = await db.query('chats', where: 'participants LIKE ? AND participants LIKE ?', whereArgs: ['%$userId1%', '%$userId2%'], limit: 1);
  return chats.isEmpty ? null : chats.first;
 }
 Future<List<Map<String, dynamic>>> getContacts(String userId) async {
  final db = await _dbHelper.database;
  return await db.query('users', where: 'id != ?', whereArgs: [userId], orderBy: 'name ASC');
 }
 Future<Map<String, dynamic>?> getChatById(String chatId) async {
  final db = await _dbHelper.database;
  final results = await db.query('chats', where: 'id = ?', whereArgs: [chatId], limit: 1);
  if (results.isNotEmpty) return results.first;
  return null;
 }
 Future<void> deleteMessage(String messageId) async {
  final db = await _dbHelper.database;
  await db.delete('messages', where: 'id = ?', whereArgs: [messageId]);
 }
}