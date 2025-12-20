import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/foodRepository.dart';
final foodRepositoryProvider = Provider<FoodRepository>(
  (ref) => FoodRepository(),
);
final restaurantsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final repository = ref.watch(foodRepositoryProvider);
  return await repository.getRestaurants();
});
final restaurantMenuProvider =
  FutureProvider.family<List<Map<String, dynamic>>, int>((
    ref,
    restaurantId,
  ) async {
    final repository = ref.watch(foodRepositoryProvider);
    final items = await repository.getMenuByRestaurant(restaurantId);
    return items.map((item) => item.toMap()).toList();
  });
final foodItemProvider = FutureProvider.family<Map<String, dynamic>?, int>((
  ref,
  itemId,
) async {
  final repository = ref.watch(foodRepositoryProvider);
  final item = await repository.getItemById(itemId);
  return item?.toMap();
});
final foodCategoriesProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final repository = ref.watch(foodRepositoryProvider);
  return await repository.getCategories();
});
class CartNotifier extends FamilyAsyncNotifier<List<Map<String, dynamic>>, int> {
  late final FoodRepository _repository;
  late final int _argUserId;
  @override
  Future<List<Map<String, dynamic>>> build(int arg) async {
    _repository = ref.watch(foodRepositoryProvider);
    _argUserId = arg;
    return _repository.getCart(_argUserId);
  }
  Future<void> addItem(int itemId, int quantity) async {
    try {
      await _repository.addToCart({
        'userId': _argUserId,
        'itemId': itemId,
        'quantity': quantity,
        'createdAt': DateTime.now().toIso8601String(),
      });
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
final foodCartProvider =
  AsyncNotifierProvider.family<CartNotifier, List<Map<String, dynamic>>, int>(
    () {
      return CartNotifier();
    },
  );
final foodOrdersProvider =
  FutureProvider.family<List<Map<String, dynamic>>, int>((ref, userId) async {
    final repository = ref.watch(foodRepositoryProvider);
    return await repository.getOrders(userId);
  });
final foodFavoritesProvider =
  FutureProvider.family<List<Map<String, dynamic>>, int>((ref, userId) async {
    final repository = ref.watch(foodRepositoryProvider);
    return await repository.getFavorites(userId);
  });