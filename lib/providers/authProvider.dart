import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/userRepository.dart';
import '../shared/models/userModel.dart';
final userRepositoryProvider = Provider<UserRepository>((ref) => UserRepository());
final currentUserIdProvider = StateProvider<String?>((ref) => null);
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
 final userId = ref.watch(currentUserIdProvider);
 if (userId == null) return null;
 final repository = ref.watch(userRepositoryProvider);
 return await repository.getUserById(userId);
});
final userAddressesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
 final userId = ref.watch(currentUserIdProvider);
 if (userId == null) return [];
 final repository = ref.watch(userRepositoryProvider);
 return await repository.getUserAddresses(userId);
});
final userByIdProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, userId) async {
 final repository = ref.watch(userRepositoryProvider);
 final db = await repository.dbHelper.database;
 final results = await db.query('users', where: 'id = ?', whereArgs: [userId], limit: 1);
 if (results.isEmpty) return null;
 return results.first;
});
class AuthNotifier extends AsyncNotifier<UserModel?> {
 late final UserRepository _repository;
 @override
 Future<UserModel?> build() async {
  _repository = ref.watch(userRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return null;
  return await _repository.getUserById(userId);
 }
 Future<void> login(String email, String password) async {
  state = const AsyncValue.loading();
  try {
   final user = await _repository.getUserByEmail(email);
   if (user != null && user.password == password) {
    ref.read(currentUserIdProvider.notifier).state = user.id;
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
   final existingUser = await _repository.getUserByEmail(user.email ?? '');
   if (existingUser != null) {
    state = AsyncValue.error('Email Already Registered!', StackTrace.current);
    return;
   }
   await _repository.createUser(user);
   final createdUser = await _repository.getUserById(user.id);
   ref.read(currentUserIdProvider.notifier).state = user.id;
   state = AsyncValue.data(createdUser);
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
 void logout() {
  ref.read(currentUserIdProvider.notifier).state = null;
  state = const AsyncValue.data(null);
 }
 Future<void> refreshUser() async {
  final currentUser = state.valueOrNull;
  if (currentUser == null) return;
  state = const AsyncValue.loading();
  try {
   final user = await _repository.getUserById(currentUser.id);
   state = AsyncValue.data(user);
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
}
final authProvider = AsyncNotifierProvider<AuthNotifier, UserModel?>(() {
 return AuthNotifier();
});