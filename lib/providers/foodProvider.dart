import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/foodRepository.dart';
final foodRepositoryProvider = Provider<FoodRepository>((ref) => FoodRepository());
final restaurantsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
 final repository = ref.watch(foodRepositoryProvider);
 return await repository.getRestaurants();
});
final restaurantDetailsProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, id) async {
 final repository = ref.watch(foodRepositoryProvider);
 return await repository.getRestaurantById(id);
});
final restaurantMenuProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, restaurantId) async {
 final repository = ref.watch(foodRepositoryProvider);
 final items = await repository.getMenuByRestaurant(restaurantId);
 return items.map((item) => item.toMap()).toList();
});
final foodItemProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, itemId) async {
 final repository = ref.watch(foodRepositoryProvider);
 final item = await repository.getItemById(itemId);
 return item?.toMap();
});
final foodCategoriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
 final repository = ref.watch(foodRepositoryProvider);
 return await repository.getCategories();
});
final foodItemsListProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
 final repository = ref.watch(foodRepositoryProvider);
 final items = await repository.getAllFoodItems();
 return items.map((item) => item.toMap()).toList();
});
class CartNotifier extends FamilyAsyncNotifier<List<Map<String, dynamic>>, String> {
 late final FoodRepository _repository;
 late final String _argUserId;
 @override
 Future<List<Map<String, dynamic>>> build(String arg) async {
  _repository = ref.watch(foodRepositoryProvider);
  _argUserId = arg;
  return _repository.getCart(_argUserId);
 }
 Future<void> addItem(String itemId, int quantity) async {
  try {
   await _repository.addToCart({'userId': _argUserId, 'itemId': itemId, 'quantity': quantity, 'createdAt': DateTime.now().toIso8601String()});
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getCart(_argUserId));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
 Future<void> updateQuantity(String cartItemId, int quantity) async {
  try {
   await _repository.updateCartItem(cartItemId, quantity);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getCart(_argUserId));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
 Future<void> removeItem(String cartItemId) async {
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
final foodCartProvider = AsyncNotifierProvider.family<CartNotifier, List<Map<String, dynamic>>, String>(() {
 return CartNotifier();
});
class OrdersNotifier extends FamilyAsyncNotifier<List<Map<String, dynamic>>, String> {
 late final FoodRepository _repository;
 late final String _argUserId;
 @override
 Future<List<Map<String, dynamic>>> build(String arg) async {
  _repository = ref.watch(foodRepositoryProvider);
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
final foodOrdersProvider = AsyncNotifierProvider.family<OrdersNotifier, List<Map<String, dynamic>>, String>(() {
 return OrdersNotifier();
});
class FavoritesNotifier extends FamilyAsyncNotifier<List<Map<String, dynamic>>, int> {
 late final FoodRepository _repository;
 late final int _argUserId;
 @override
 Future<List<Map<String, dynamic>>> build(int arg) async {
  _repository = ref.watch(foodRepositoryProvider);
  _argUserId = arg;
  return _repository.getFavorites(_argUserId.toString());
 }
 Future<void> addFavorite(String restaurantId) async {
  try {
   await _repository.addToFavorites(_argUserId.toString(), restaurantId);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getFavorites(_argUserId.toString()));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
 Future<void> removeFavorite(String restaurantId) async {
  try {
   await _repository.removeFromFavorites(_argUserId.toString(), restaurantId);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getFavorites(_argUserId.toString()));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
}
final foodFavoritesProvider = AsyncNotifierProvider.family<FavoritesNotifier, List<Map<String, dynamic>>, int>(() {
 return FavoritesNotifier();
});
class ReservationsNotifier extends FamilyAsyncNotifier<List<Map<String, dynamic>>, String> {
 late final FoodRepository _repository;
 late final String _argUserId;
 @override
 Future<List<Map<String, dynamic>>> build(String arg) async {
  _repository = ref.watch(foodRepositoryProvider);
  _argUserId = arg;
  return _repository.getReservations(_argUserId);
 }
 Future<void> createReservation(Map<String, dynamic> data) async {
  try {
   await _repository.createReservation({...data, 'userId': _argUserId});
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getReservations(_argUserId));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
 Future<void> cancelReservation(String id) async {
  try {
   await _repository.cancelReservation(id);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getReservations(_argUserId));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
 Future<void> deleteReservation(String id) async {
  try {
   await _repository.deleteReservation(id);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getReservations(_argUserId));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
}
final foodReservationsProvider = AsyncNotifierProvider.family<ReservationsNotifier, List<Map<String, dynamic>>, String>(() {
 return ReservationsNotifier();
});
final foodPromotionsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
 final repository = ref.watch(foodRepositoryProvider);
 return await repository.getPromotions();
});
final foodLoyaltyRewardsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
 final repository = ref.watch(foodRepositoryProvider);
 return await repository.getLoyaltyRewards();
});
final foodLatestOrderProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, userId) async {
 final repository = ref.watch(foodRepositoryProvider);
 return await repository.getLatestOrder(userId);
});