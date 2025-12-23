import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/analyticsRepository.dart';
final analyticsRepositoryProvider = Provider((ref) => AnalyticsRepository());
final totalSpendingProvider = FutureProvider.family<double, String>((ref, userId) async {
 return await ref.watch(analyticsRepositoryProvider).getTotalSpending(userId);
});
final spendingByCategoryProvider = FutureProvider.family<Map<String, double>, String>((ref, userId) async {
 return await ref.watch(analyticsRepositoryProvider).getSpendingByCategory(userId);
});
final recentTransactionsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 return await ref.watch(analyticsRepositoryProvider).getRecentTransactions(userId);
});
final budgetsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 return await ref.watch(analyticsRepositoryProvider).getBudgets(userId);
});
final goalsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 return await ref.watch(analyticsRepositoryProvider).getGoals(userId);
});
final incomeProvider = FutureProvider.family<double, String>((ref, userId) async {
 return await ref.watch(analyticsRepositoryProvider).getTotalIncome(userId);
});
final incomeSourcesProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 return await ref.watch(analyticsRepositoryProvider).getIncomeSources(userId);
});
final investmentsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
 return await ref.watch(analyticsRepositoryProvider).getInvestments(userId);
});
final savingsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
 return await ref.watch(analyticsRepositoryProvider).getSavings(userId);
});
final taxProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
 return await ref.watch(analyticsRepositoryProvider).getTax(userId);
});
final trendsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 return await ref.watch(analyticsRepositoryProvider).getTrends(userId);
});
final comparisonProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 return await ref.watch(analyticsRepositoryProvider).getMonthlyComparison(userId);
});
final reportGeneratorProvider = FutureProvider.family<String, ({String userId, String reportType})>((ref, arg) async {
 return await ref.watch(analyticsRepositoryProvider).generateReport(arg.userId, arg.reportType);
});