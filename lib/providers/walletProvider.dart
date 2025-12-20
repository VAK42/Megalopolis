import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/walletRepository.dart';
final walletRepositoryProvider = Provider<WalletRepository>(
  (ref) => WalletRepository(),
);
final walletBalanceProvider = FutureProvider.family<double, int>((
  ref,
  userId,
) async {
  final repository = ref.watch(walletRepositoryProvider);
  return await repository.getBalance(userId);
});
final transactionsProvider =
  FutureProvider.family<List<Map<String, dynamic>>, int>((ref, userId) async {
    final repository = ref.watch(walletRepositoryProvider);
    return await repository.getTransactions(userId);
  });
final walletCardsProvider =
  FutureProvider.family<List<Map<String, dynamic>>, int>((ref, userId) async {
    final repository = ref.watch(walletRepositoryProvider);
    return await repository.getCards(userId);
  });
final walletAnalyticsProvider =
  FutureProvider.family<Map<String, dynamic>, int>((ref, userId) async {
    final repository = ref.watch(walletRepositoryProvider);
    return await repository.getAnalytics(userId);
  });
class WalletNotifier extends FamilyAsyncNotifier<double, int> {
  late final WalletRepository _repository;
  late final int _argUserId;
  @override
  Future<double> build(int arg) async {
    _repository = ref.watch(walletRepositoryProvider);
    _argUserId = arg;
    return _repository.getBalance(_argUserId);
  }
  Future<bool> topUp(double amount, String method) async {
    try {
      await _repository.topUp(_argUserId, amount, method);
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() => _repository.getBalance(_argUserId));
      return true;
    } catch (e) {
      return false;
    }
  }
  Future<bool> transfer(int toUserId, double amount) async {
    try {
      await _repository.transfer(_argUserId, toUserId, amount);
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() => _repository.getBalance(_argUserId));
      return true;
    } catch (e) {
      return false;
    }
  }
  Future<bool> payBill(double amount, String billType) async {
    try {
      await _repository.payBill(_argUserId, amount, billType);
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() => _repository.getBalance(_argUserId));
      return true;
    } catch (e) {
      return false;
    }
  }
  Future<bool> withdraw(double amount, String bankAccount) async {
    try {
      await _repository.withdraw(_argUserId, amount, bankAccount);
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() => _repository.getBalance(_argUserId));
      return true;
    } catch (e) {
      return false;
    }
  }
}
final walletNotifierProvider =
  AsyncNotifierProvider.family<WalletNotifier, double, int>(() {
    return WalletNotifier();
  });