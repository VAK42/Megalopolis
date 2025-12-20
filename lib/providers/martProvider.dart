import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/martRepository.dart';
import '../shared/models/itemModel.dart';
final martRepositoryProvider = Provider<MartRepository>(
  (ref) => MartRepository(),
);
final martProductsProvider = FutureProvider.family<List<ItemModel>, String?>((
  ref,
  category,
) async {
  final repository = ref.watch(martRepositoryProvider);
  return await repository.getProducts(category: category);
});
final martProductProvider = FutureProvider.family<ItemModel?, int>((
  ref,
  productId,
) async {
  final repository = ref.watch(martRepositoryProvider);
  return await repository.getProductById(productId);
});
final martCategoriesProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final repository = ref.watch(martRepositoryProvider);
  return await repository.getCategories();
});
class MartCartNotifier extends FamilyAsyncNotifier<List<Map<String, dynamic>>, int> {
  late final MartRepository _repository;
  late final int _argUserId;
  @override
  Future<List<Map<String, dynamic>>> build(int arg) async {
    _repository = ref.watch(martRepositoryProvider);
    _argUserId = arg;
    return _repository.getCart(_argUserId);
  }
  Future<void> addItem(int productId, int quantity) async {
    try {
      await _repository.addToCart({
        'userId': _argUserId,
        'itemId': productId,
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
}
final martCartProvider =
  AsyncNotifierProvider.family<
    MartCartNotifier,
    List<Map<String, dynamic>>,
    int
  >(() {
    return MartCartNotifier();
  });
final wishlistProvider = FutureProvider.family<List<Map<String, dynamic>>, int>(
  (ref, userId) async {
    final repository = ref.watch(martRepositoryProvider);
    return await repository.getWishlist(userId);
  },
);
final martOrdersProvider =
  FutureProvider.family<List<Map<String, dynamic>>, int>((ref, userId) async {
    final repository = ref.watch(martRepositoryProvider);
    return await repository.getOrders(userId);
  });
final productReviewsProvider =
  FutureProvider.family<List<Map<String, dynamic>>, int>((
    ref,
    productId,
  ) async {
    final repository = ref.watch(martRepositoryProvider);
    return await repository.getReviews(productId);
  });