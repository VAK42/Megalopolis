import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/merchantRepository.dart';
import '../shared/models/itemModel.dart';
final merchantRepositoryProvider = Provider((ref) => MerchantRepository());
final merchantOrdersProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, merchantId) async {
 return await ref.watch(merchantRepositoryProvider).getMerchantOrders(merchantId);
});
final merchantProductsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, merchantId) async {
 return await ref.watch(merchantRepositoryProvider).getMerchantProducts(merchantId);
});
final merchantStatsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, merchantId) async {
 return await ref.watch(merchantRepositoryProvider).getMerchantStats(merchantId);
});
final merchantPayoutsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, merchantId) async {
 return await ref.watch(merchantRepositoryProvider).getMerchantPayouts(merchantId);
});
final merchantProfileProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, merchantId) async {
 return await ref.watch(merchantRepositoryProvider).getMerchantProfile(merchantId);
});
final merchantPromotionsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, merchantId) async {
 return await ref.watch(merchantRepositoryProvider).getMerchantPromotions(merchantId);
});
final merchantReviewsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, merchantId) async {
 return await ref.watch(merchantRepositoryProvider).getMerchantReviews(merchantId);
});
class MerchantOrdersNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
 String _merchantId = '';
 void setMerchantId(String id) => _merchantId = id;
 @override
 Future<List<Map<String, dynamic>>> build() async {
  if (_merchantId.isEmpty) return [];
  return await ref.watch(merchantRepositoryProvider).getMerchantOrders(_merchantId);
 }
 Future<void> updateOrderStatus(String orderId, String status) async {
  await ref.read(merchantRepositoryProvider).updateOrderStatus(orderId, status);
  ref.invalidateSelf();
 }
 Future<void> cancelOrder(String orderId) async {
  await ref.read(merchantRepositoryProvider).cancelOrder(orderId);
  ref.invalidateSelf();
 }
}
final merchantOrdersNotifierProvider = AsyncNotifierProvider<MerchantOrdersNotifier, List<Map<String, dynamic>>>(() => MerchantOrdersNotifier());
class MerchantProductsNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
 String _merchantId = '';
 void setMerchantId(String id) => _merchantId = id;
 @override
 Future<List<Map<String, dynamic>>> build() async {
  if (_merchantId.isEmpty) return [];
  return await ref.watch(merchantRepositoryProvider).getMerchantProducts(_merchantId);
 }
 Future<void> addProduct(ItemModel item) async {
  await ref.read(merchantRepositoryProvider).addProduct(item);
  ref.invalidateSelf();
 }
 Future<void> updateProduct(ItemModel item) async {
  await ref.read(merchantRepositoryProvider).updateProduct(item);
  ref.invalidateSelf();
 }
 Future<void> deleteProduct(String id) async {
  await ref.read(merchantRepositoryProvider).deleteProduct(id);
  ref.invalidateSelf();
 }
}
final merchantProductsNotifierProvider = AsyncNotifierProvider<MerchantProductsNotifier, List<Map<String, dynamic>>>(() => MerchantProductsNotifier());
class MerchantPromotionsNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
 String _merchantId = '';
 void setMerchantId(String id) => _merchantId = id;
 @override
 Future<List<Map<String, dynamic>>> build() async {
  if (_merchantId.isEmpty) return [];
  return await ref.watch(merchantRepositoryProvider).getMerchantPromotions(_merchantId);
 }
 Future<void> createPromotion(Map<String, dynamic> promo) async {
  await ref.read(merchantRepositoryProvider).createPromotion(promo);
  ref.invalidateSelf();
 }
 Future<void> updatePromotion(String promoId, Map<String, dynamic> data) async {
  await ref.read(merchantRepositoryProvider).updatePromotion(promoId, data);
  ref.invalidateSelf();
 }
 Future<void> deletePromotion(String promoId) async {
  await ref.read(merchantRepositoryProvider).deletePromotion(promoId);
  ref.invalidateSelf();
 }
 Future<void> toggleStatus(String promoId, bool isActive) async {
  await ref.read(merchantRepositoryProvider).togglePromotionStatus(promoId, isActive);
  ref.invalidateSelf();
 }
}
final merchantPromotionsNotifierProvider = AsyncNotifierProvider<MerchantPromotionsNotifier, List<Map<String, dynamic>>>(() => MerchantPromotionsNotifier());
class MerchantPayoutsNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
 String _merchantId = '';
 void setMerchantId(String id) => _merchantId = id;
 @override
 Future<List<Map<String, dynamic>>> build() async {
  if (_merchantId.isEmpty) return [];
  return await ref.watch(merchantRepositoryProvider).getMerchantPayouts(_merchantId);
 }
 Future<void> requestWithdrawal(double amount) async {
  await ref.read(merchantRepositoryProvider).requestWithdrawal(_merchantId, amount);
  ref.invalidateSelf();
 }
 Future<void> cancelWithdrawal(String payoutId) async {
  await ref.read(merchantRepositoryProvider).cancelWithdrawal(payoutId);
  ref.invalidateSelf();
 }
}
final merchantPayoutsNotifierProvider = AsyncNotifierProvider<MerchantPayoutsNotifier, List<Map<String, dynamic>>>(() => MerchantPayoutsNotifier());
class MerchantProfileNotifier extends AsyncNotifier<Map<String, dynamic>?> {
 String _merchantId = '';
 void setMerchantId(String id) => _merchantId = id;
 @override
 Future<Map<String, dynamic>?> build() async {
  if (_merchantId.isEmpty) return null;
  return await ref.watch(merchantRepositoryProvider).getMerchantProfile(_merchantId);
 }
 Future<void> updateProfile(Map<String, dynamic> data) async {
  await ref.read(merchantRepositoryProvider).updateMerchantProfile(_merchantId, data);
  ref.invalidateSelf();
 }
 Future<void> register(Map<String, dynamic> data) async {
  await ref.read(merchantRepositoryProvider).registerMerchant(data);
  ref.invalidateSelf();
 }
}
final merchantProfileNotifierProvider = AsyncNotifierProvider<MerchantProfileNotifier, Map<String, dynamic>?>(() => MerchantProfileNotifier());