import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/martRepository.dart';
import '../shared/models/itemModel.dart';
final martRepositoryProvider = Provider<MartRepository>((ref) => MartRepository());
final martProductsProvider = FutureProvider.family<List<ItemModel>, String?>((ref, category) async {
 final repository = ref.watch(martRepositoryProvider);
 return await repository.getProducts(category: category);
});
final martProductProvider = FutureProvider.family<ItemModel?, String>((ref, productId) async {
 final repository = ref.watch(martRepositoryProvider);
 return await repository.getProductById(productId);
});
final martCategoriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
 final repository = ref.watch(martRepositoryProvider);
 return await repository.getCategories();
});
class MartCartNotifier extends FamilyAsyncNotifier<List<Map<String, dynamic>>, String> {
 late final MartRepository _repository;
 late final String _argUserId;
 @override
 Future<List<Map<String, dynamic>>> build(String arg) async {
  _repository = ref.watch(martRepositoryProvider);
  _argUserId = arg;
  return _repository.getCart(_argUserId);
 }
 Future<void> addItem(String productId, int quantity) async {
  try {
   await _repository.addToCart({'userId': _argUserId, 'itemId': productId, 'quantity': quantity, 'createdAt': DateTime.now().toIso8601String()});
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getCart(_argUserId));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
 Future<void> updateQuantity(int cartItemId, int quantity) async {
  try {
   await _repository.updateCartItem(cartItemId, quantity);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getCart(_argUserId));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
 Future<void> removeItem(int cartItemId) async {
  try {
   await _repository.removeFromCart(cartItemId);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getCart(_argUserId));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
 Future<void> clearCart() async {
  try {
   await _repository.clearCart(_argUserId);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getCart(_argUserId));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
}
final martCartProvider = AsyncNotifierProvider.family<MartCartNotifier, List<Map<String, dynamic>>, String>(() {
 return MartCartNotifier();
});
class MartOrdersNotifier extends FamilyAsyncNotifier<List<Map<String, dynamic>>, String> {
 late MartRepository _repository;
 late String _argUserId;
 @override
 Future<List<Map<String, dynamic>>> build(String arg) async {
  _repository = ref.watch(martRepositoryProvider);
  _argUserId = arg;
  return _repository.getOrders(_argUserId);
 }
 Future<void> cancelOrder(String orderId) async {
  try {
   await _repository.cancelOrder(orderId);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getOrders(_argUserId));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
 Future<void> deleteOrder(String orderId) async {
  try {
   await _repository.deleteOrder(orderId);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getOrders(_argUserId));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
}
final martOrdersProvider = AsyncNotifierProvider.family<MartOrdersNotifier, List<Map<String, dynamic>>, String>(() => MartOrdersNotifier());
class MartWishlistNotifier extends FamilyAsyncNotifier<List<Map<String, dynamic>>, String> {
 late final MartRepository _repository;
 late final String _argUserId;
 @override
 Future<List<Map<String, dynamic>>> build(String arg) async {
  _repository = ref.watch(martRepositoryProvider);
  _argUserId = arg;
  return _repository.getWishlist(_argUserId);
 }
 Future<void> addToWishlist(String productId) async {
  try {
   await _repository.addToWishlist(_argUserId, productId);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getWishlist(_argUserId));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
 Future<void> removeFromWishlist(String productId) async {
  try {
   await _repository.removeFromWishlist(_argUserId, productId);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getWishlist(_argUserId));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
}
final wishlistProvider = AsyncNotifierProvider.family<MartWishlistNotifier, List<Map<String, dynamic>>, String>(() => MartWishlistNotifier());
class ReviewsNotifier extends FamilyAsyncNotifier<List<Map<String, dynamic>>, String> {
 late final MartRepository _repository;
 late final String _productId;
 @override
 Future<List<Map<String, dynamic>>> build(String arg) async {
  _repository = ref.watch(martRepositoryProvider);
  _productId = arg;
  return _repository.getReviews(_productId);
 }
 Future<void> addReview(String userId, int rating, String comment) async {
  try {
   await _repository.addReview({'itemId': _productId, 'userId': userId, 'rating': rating, 'comment': comment, 'createdAt': DateTime.now().millisecondsSinceEpoch});
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getReviews(_productId));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
 Future<void> deleteReview(String reviewId) async {
  try {
   await _repository.deleteReview(reviewId);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getReviews(_productId));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
}
final productReviewsProvider = AsyncNotifierProvider.family<ReviewsNotifier, List<Map<String, dynamic>>, String>(() => ReviewsNotifier());
final martSearchProvider = FutureProvider.family<List<ItemModel>, String>((ref, query) async {
 final repository = ref.watch(martRepositoryProvider);
 return await repository.searchProducts(query);
});
final martBrandsProvider = FutureProvider((ref) async {
 final repository = ref.watch(martRepositoryProvider);
 return await repository.getBrands();
});
final martPromotionsProvider = FutureProvider((ref) async {
 final repository = ref.watch(martRepositoryProvider);
 return await repository.getPromotions();
});
final martSellerProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, sellerId) async {
 final repository = ref.watch(martRepositoryProvider);
 return await repository.getSeller(sellerId);
});
final sellerProductsProvider = FutureProvider.family<List<ItemModel>, String>((ref, sellerId) async {
 final repository = ref.watch(martRepositoryProvider);
 return await repository.getSellerProducts(sellerId);
});
final martSearchHistoryProvider = FutureProvider.family<List<String>, String>((ref, userId) async {
 final repository = ref.watch(martRepositoryProvider);
 return await repository.getSearchHistory(userId);
});
final popularSearchesProvider = FutureProvider((ref) async {
 final repository = ref.watch(martRepositoryProvider);
 final searches = await repository.getPopularSearches();
 if (searches.isEmpty) return ['Headphones', 'Pizza', 'Cleaning', 'Shoes', 'Burger'];
 return searches;
});