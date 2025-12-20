import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/userRepository.dart';
import '../shared/models/userModel.dart';
final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(),
);
final currentUserIdProvider = StateProvider<int?>((ref) => null);
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return null;
  final repository = ref.watch(userRepositoryProvider);
  return await repository.getUserById(userId);
});
final userAddressesProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return [];
  final repository = ref.watch(userRepositoryProvider);
  return await repository.getUserAddresses(userId);
});
class AuthNotifier extends AsyncNotifier<UserModel?> {
  late final UserRepository _repository;
  @override
  Future<UserModel?> build() async {
    _repository = ref.watch(userRepositoryProvider);
    return null;
  }
  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.getUserByEmail(email);
      if (user != null && user.password == password) {
        state = AsyncValue.data(user);
      } else {
        state = AsyncValue.error('Invalid Credentials!', StackTrace.current);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  Future<void> register(UserModel user) async {
    state = const AsyncValue.loading();
    try {
      final id = await _repository.createUser(user);
      final createdUser = await _repository.getUserById(id);
      state = AsyncValue.data(createdUser);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  void logout() {
    state = const AsyncValue.data(null);
  }
}
final authProvider = AsyncNotifierProvider<AuthNotifier, UserModel?>(() {
  return AuthNotifier();
});