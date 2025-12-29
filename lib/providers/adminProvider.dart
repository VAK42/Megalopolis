import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/adminRepository.dart';
final adminRepositoryProvider = Provider((ref) => AdminRepository());
final adminUsersProvider = FutureProvider((ref) async {
 return await ref.watch(adminRepositoryProvider).getAllUsers();
});
final adminTicketsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
 final repository = AdminRepository();
 return await repository.getSupportTickets();
});
final adminRevenueStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
 final repository = AdminRepository();
 return await repository.getRevenueStats();
});
final adminModuleRevenueProvider = FutureProvider<Map<String, double>>((ref) async {
 final repository = AdminRepository();
 return await repository.getModuleRevenue();
});
final adminDashboardStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
 final repository = AdminRepository();
 return await repository.getDashboardStats();
});
final adminReportsProvider = FutureProvider((ref) async {
 return await ref.watch(adminRepositoryProvider).getContentReports();
});
final reportTypesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
 return await ref.watch(adminRepositoryProvider).getReportTypes();
});
final adminStatsProvider = FutureProvider((ref) async {
 return await ref.watch(adminRepositoryProvider).getDashboardStats();
});
final adminOrdersProvider = FutureProvider((ref) async {
 return await ref.watch(adminRepositoryProvider).getAllOrders();
});