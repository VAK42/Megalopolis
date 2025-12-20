import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/adminRepository.dart';
final adminRepositoryProvider = Provider((ref) => AdminRepository());
final adminUsersProvider = FutureProvider((ref) async {
  return await ref.watch(adminRepositoryProvider).getAllUsers();
});
final adminTicketsProvider = FutureProvider((ref) async {
  return await ref.watch(adminRepositoryProvider).getTickets();
});
final adminReportsProvider = FutureProvider((ref) async {
  return await ref.watch(adminRepositoryProvider).getReports();
});
final adminStatsProvider = FutureProvider((ref) async {
  return await ref.watch(adminRepositoryProvider).getDashboardStats();
});