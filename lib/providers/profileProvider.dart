import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/profileRepository.dart';
final profileRepositoryProvider = Provider((ref) => ProfileRepository());
final userSettingsProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, userId) async {
 return await ref.watch(profileRepositoryProvider).getUserSettings(userId);
});
final userAddressesProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 return await ref.watch(profileRepositoryProvider).getUserAddresses(userId);
});
final paymentMethodsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 return await ref.watch(profileRepositoryProvider).getPaymentMethods(userId);
});
final supportTicketsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 return await ref.watch(profileRepositoryProvider).getSupportTickets(userId);
});
final referralInfoProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, userId) async {
 return await ref.watch(profileRepositoryProvider).getReferralInfo(userId);
});
final userStatsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
 return await ref.watch(profileRepositoryProvider).getUserStats(userId);
});
class AddressesNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
 String _userId = '';
 void setUserId(String id) => _userId = id;
 @override
 Future<List<Map<String, dynamic>>> build() async {
  if (_userId.isEmpty) return [];
  return await ref.watch(profileRepositoryProvider).getUserAddresses(_userId);
 }
 Future<void> addAddress(Map<String, dynamic> address) async {
  address['userId'] = _userId;
  await ref.read(profileRepositoryProvider).addAddress(address);
  ref.invalidateSelf();
 }
 Future<void> updateAddress(String addressId, Map<String, dynamic> data) async {
  await ref.read(profileRepositoryProvider).updateAddress(addressId, data);
  ref.invalidateSelf();
 }
 Future<void> deleteAddress(String addressId) async {
  await ref.read(profileRepositoryProvider).deleteAddress(addressId);
  ref.invalidateSelf();
 }
 Future<void> setDefault(String addressId) async {
  await ref.read(profileRepositoryProvider).setDefaultAddress(_userId, addressId);
  ref.invalidateSelf();
 }
}
final addressesNotifierProvider = AsyncNotifierProvider<AddressesNotifier, List<Map<String, dynamic>>>(() => AddressesNotifier());
class PaymentMethodsNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
 String _userId = '';
 void setUserId(String id) => _userId = id;
 @override
 Future<List<Map<String, dynamic>>> build() async {
  if (_userId.isEmpty) return [];
  return await ref.watch(profileRepositoryProvider).getPaymentMethods(_userId);
 }
 Future<void> addMethod(Map<String, dynamic> method) async {
  method['userId'] = _userId;
  await ref.read(profileRepositoryProvider).addPaymentMethod(method);
  ref.invalidateSelf();
 }
 Future<void> deleteMethod(String methodId) async {
  await ref.read(profileRepositoryProvider).deletePaymentMethod(methodId);
  ref.invalidateSelf();
 }
 Future<void> setDefault(String methodId) async {
  await ref.read(profileRepositoryProvider).setDefaultPaymentMethod(_userId, methodId);
  ref.invalidateSelf();
 }
}
final paymentMethodsNotifierProvider = AsyncNotifierProvider<PaymentMethodsNotifier, List<Map<String, dynamic>>>(() => PaymentMethodsNotifier());
class SupportTicketsNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
 String _userId = '';
 void setUserId(String id) => _userId = id;
 @override
 Future<List<Map<String, dynamic>>> build() async {
  if (_userId.isEmpty) return [];
  return await ref.watch(profileRepositoryProvider).getSupportTickets(_userId);
 }
 Future<void> createTicket(Map<String, dynamic> ticket) async {
  ticket['userId'] = _userId;
  await ref.read(profileRepositoryProvider).createSupportTicket(ticket);
  ref.invalidateSelf();
 }
}
final supportTicketsNotifierProvider = AsyncNotifierProvider<SupportTicketsNotifier, List<Map<String, dynamic>>>(() => SupportTicketsNotifier());
class SettingsNotifier extends AsyncNotifier<Map<String, dynamic>?> {
 String _userId = '';
 void setUserId(String id) => _userId = id;
 @override
 Future<Map<String, dynamic>?> build() async {
  if (_userId.isEmpty) return null;
  return await ref.watch(profileRepositoryProvider).getUserSettings(_userId);
 }
 Future<void> updateSettings(Map<String, dynamic> settings) async {
  await ref.read(profileRepositoryProvider).updateUserSettings(_userId, settings);
  ref.invalidateSelf();
 }
 Future<void> updateNotifications(Map<String, dynamic> settings) async {
  await ref.read(profileRepositoryProvider).updateNotificationSettings(_userId, settings);
  ref.invalidateSelf();
 }
 Future<void> updatePrivacy(Map<String, dynamic> settings) async {
  await ref.read(profileRepositoryProvider).updatePrivacySettings(_userId, settings);
  ref.invalidateSelf();
 }
 Future<void> updateSecurity(Map<String, dynamic> settings) async {
  await ref.read(profileRepositoryProvider).updateSecuritySettings(_userId, settings);
  ref.invalidateSelf();
 }
 Future<void> changePassword(String newPassword) async {
  await ref.read(profileRepositoryProvider).changePassword(_userId, newPassword);
 }
}
final settingsNotifierProvider = AsyncNotifierProvider<SettingsNotifier, Map<String, dynamic>?>(() => SettingsNotifier());
class FeedbackNotifier extends Notifier<bool> {
 @override
 bool build() => false;
 Future<void> submitFeedback(String userId, String message, int rating) async {
  state = true;
  await ref.read(profileRepositoryProvider).submitFeedback({'userId': userId, 'message': message, 'rating': rating});
  state = false;
 }
}
final feedbackNotifierProvider = NotifierProvider<FeedbackNotifier, bool>(() => FeedbackNotifier());
class ChatNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
 String _chatId = '';
 void setChatId(String id) => _chatId = id;
 @override
 Future<List<Map<String, dynamic>>> build() async {
  if (_chatId.isEmpty) return [];
  return await ref.watch(profileRepositoryProvider).getChatMessages(_chatId);
 }
 Future<void> sendMessage(String userId, String text) async {
  await ref.read(profileRepositoryProvider).sendChatMessage({'chatId': _chatId, 'senderId': userId, 'content': text, 'isRead': 0});
  ref.invalidateSelf();
 }
}
final chatNotifierProvider = AsyncNotifierProvider<ChatNotifier, List<Map<String, dynamic>>>(() => ChatNotifier());