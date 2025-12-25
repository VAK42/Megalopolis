import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/chatRepository.dart';
class Chat {
 final String id;
 final List<String> participants;
 final String? lastMessage;
 final int? lastMessageAt;
 final String type;
 Chat({required this.id, required this.participants, this.lastMessage, this.lastMessageAt, this.type = 'direct'});
 factory Chat.fromMap(Map<String, dynamic> map) {
  return Chat(id: map['id'] as String, participants: (map['participants'] as String).split(','), lastMessage: map['lastMessage'] as String?, lastMessageAt: map['lastMessageAt'] as int?, type: map['type'] as String? ?? 'direct');
 }
}
class Message {
 final String id;
 final String chatId;
 final String senderId;
 final String content;
 final String type;
 final int createdAt;
 Message({required this.id, required this.chatId, required this.senderId, required this.content, this.type = 'text', required this.createdAt});
 factory Message.fromMap(Map<String, dynamic> map) {
  return Message(id: map['id'] as String, chatId: map['chatId'] as String, senderId: map['senderId'] as String, content: map['content'] as String, type: map['type'] as String? ?? 'text', createdAt: map['createdAt'] as int);
 }
}
class ChatNotifier extends FamilyAsyncNotifier<List<Chat>, String> {
 late final ChatRepository _repository;
 late final String _argUserId;
 Future<List<Chat>> build(String arg) async {
  _repository = ChatRepository();
  _argUserId = arg;
  return _loadChats();
 }
 Future<List<Chat>> _loadChats() async {
  final chatsData = await _repository.getChats(_argUserId);
  return chatsData.map((data) => Chat.fromMap(data)).toList();
 }
 Future<List<Message>> getMessages(String chatId) async {
  try {
   final messagesData = await _repository.getMessages(chatId);
   return messagesData.map((data) => Message.fromMap(data)).toList();
  } catch (e) {
   rethrow;
  }
 }
 Future<void> sendMessage(String chatId, String content, {String type = 'text'}) async {
  try {
   await _repository.sendMessage(chatId: chatId, senderId: _argUserId, content: content, type: type);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _loadChats());
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
 Future<String> createChat(List<String> participants, {String type = 'direct'}) async {
  try {
   final chatId = await _repository.createChat(participants: participants, type: type);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _loadChats());
   return chatId;
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
   rethrow;
  }
 }
 Future<String> getChatWithUser(String otherUserId) async {
  try {
   final existingChat = await _repository.getChatBetweenUsers(_argUserId, otherUserId);
   if (existingChat != null) {
    return existingChat['id'] as String;
   }
   return await createChat([_argUserId, otherUserId]);
  } catch (e) {
   rethrow;
  }
 }
 Future<List<Map<String, dynamic>>> getContacts() async {
  try {
   return await _repository.getContacts(_argUserId);
  } catch (e) {
   rethrow;
  }
 }
 Future<void> deleteMessage(String messageId) async {
  try {
   await _repository.deleteMessage(messageId);
  } catch (e) {
   rethrow;
  }
 }
 Future<void> deleteChat(String chatId) async {
  try {
   await _repository.deleteChat(chatId);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _loadChats());
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
}
final chatProvider = AsyncNotifierProvider.family<ChatNotifier, List<Chat>, String>(() {
 return ChatNotifier();
});
final contactsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 final repository = ChatRepository();
 return await repository.getContacts(userId);
});
final chatDetailsProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, chatId) async {
 final repository = ChatRepository();
 return await repository.getChatById(chatId);
});
final chatMessagesProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, chatId) async {
 final repository = ChatRepository();
 return await repository.getMessages(chatId);
});