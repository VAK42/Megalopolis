import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/walletRepository.dart';
final walletRepositoryProvider = Provider<WalletRepository>((ref) => WalletRepository());
final walletBalanceProvider = FutureProvider.family<double, String>((ref, userId) async {
 final repository = ref.watch(walletRepositoryProvider);
 return await repository.getBalance(userId);
});
final transactionsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 final repository = ref.watch(walletRepositoryProvider);
 return await repository.getTransactions(userId);
});
final walletCardsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 final repository = ref.watch(walletRepositoryProvider);
 return await repository.getCards(userId);
});
final walletAnalyticsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
 final repository = ref.watch(walletRepositoryProvider);
 return await repository.getAnalytics(userId);
});
final walletTrendProvider = FutureProvider.family<double, String>((ref, userId) async {
 final repository = WalletRepository();
 return await repository.getBalanceTrend(userId, days: 30);
});
final billsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 final repository = WalletRepository();
 return await repository.getBills(userId);
});
final pendingBillsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 final repository = WalletRepository();
 return await repository.getBills(userId, status: 'pending');
});
final billSummaryProvider = FutureProvider.family<Map<String, int>, String>((ref, userId) async {
 final repository = WalletRepository();
 return await repository.getBillSummary(userId);
});
final giftCardsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 final repository = WalletRepository();
 return await repository.getGiftCards(userId);
});
final giftCardTotalBalanceProvider = FutureProvider.family<double, String>((ref, userId) async {
 final repository = WalletRepository();
 return await repository.getGiftCardTotalBalance(userId);
});
class WalletNotifier extends FamilyAsyncNotifier<double, String> {
 late final WalletRepository _repository;
 late final String _argUserId;
 @override
 Future<double> build(String arg) async {
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
 Future<bool> transfer(String toUserId, double amount) async {
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
final walletNotifierProvider = AsyncNotifierProvider.family<WalletNotifier, double, String>(() {
 return WalletNotifier();
});
final recurringPaymentsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 final repository = ref.watch(walletRepositoryProvider);
 return await repository.getRecurringPayments(userId);
});
final budgetProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
 final repository = ref.watch(walletRepositoryProvider);
 return await repository.getBudget(userId);
});
final budgetCategoriesProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 final repository = ref.watch(walletRepositoryProvider);
 return await repository.getBudgetCategories(userId);
});
final investmentsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
 final repository = ref.watch(walletRepositoryProvider);
 return await repository.getInvestments(userId);
});
final loanOffersProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
 final repository = ref.watch(walletRepositoryProvider);
 return await repository.getLoanOffers(userId);
});
final cashbackOffersProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 final repository = ref.watch(walletRepositoryProvider);
 return await repository.getCashbackOffers(userId);
});
final cashbackTotalProvider = FutureProvider.family<double, String>((ref, userId) async {
 final repository = ref.watch(walletRepositoryProvider);
 return await repository.getCashbackTotal(userId);
});
final bankAccountsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 final repository = ref.watch(walletRepositoryProvider);
 return await repository.getBankAccounts(userId);
});