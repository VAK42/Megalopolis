import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/serviceRepository.dart';
import '../shared/models/itemModel.dart';
final serviceRepositoryProvider = Provider<ServiceRepository>((ref) => ServiceRepository());
final servicesProvider = FutureProvider.family<List<ItemModel>, String?>((ref, category) async {
 final repository = ref.watch(serviceRepositoryProvider);
 return await repository.getServices(category: category);
});
final serviceItemProvider = FutureProvider.family<ItemModel?, String>((ref, serviceId) async {
 final repository = ref.watch(serviceRepositoryProvider);
 return await repository.getServiceById(serviceId);
});
final serviceCategoriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
 final repository = ref.watch(serviceRepositoryProvider);
 return await repository.getCategories();
});
final serviceProvidersProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, category) async {
 final repository = ref.watch(serviceRepositoryProvider);
 return await repository.getProviders(category);
});
final serviceBookingsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 final repository = ref.watch(serviceRepositoryProvider);
 return await repository.getBookings(userId);
});
class ServiceBookingNotifier extends Notifier<Map<String, dynamic>> {
 late final ServiceRepository _repository;
 @override
 Map<String, dynamic> build() {
  _repository = ref.watch(serviceRepositoryProvider);
  return {};
 }
 void setService(String serviceId, String serviceName, double price) {
  state = {...state, 'serviceId': serviceId, 'serviceName': serviceName, 'price': price};
 }
 void setProvider(String providerId, String providerName) {
  state = {...state, 'providerId': providerId, 'providerName': providerName};
 }
 void setDateTime(DateTime dateTime) {
  state = {...state, 'scheduledAt': dateTime.toIso8601String()};
 }
 void setAddress(String address) {
  state = {...state, 'address': address};
 }
 Future<int?> bookService(String userId) async {
  try {
   final booking = {...state, 'userId': userId, 'orderType': 'service', 'status': 'pending', 'createdAt': DateTime.now().millisecondsSinceEpoch};
   final id = await _repository.bookService(booking);
   state = {};
   return id;
  } catch (e) {
   return null;
  }
 }
 void reset() {
  state = {};
 }
}
final serviceBookingProvider = NotifierProvider<ServiceBookingNotifier, Map<String, dynamic>>(() {
 return ServiceBookingNotifier();
});
final servicePromosProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
 return await ref.watch(serviceRepositoryProvider).getPromos();
});
final serviceSubscriptionPlansProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
 return await ref.watch(serviceRepositoryProvider).getSubscriptionPlans();
});
final serviceInsurancePlansProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
 return await ref.watch(serviceRepositoryProvider).getInsurancePlans();
});
final serviceWarrantyProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, bookingId) async {
 return await ref.watch(serviceRepositoryProvider).getWarrantyInfo(bookingId);
});