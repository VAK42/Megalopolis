import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/driverRepository.dart';
final driverRepositoryProvider = Provider<DriverRepository>((ref) => DriverRepository());
final driverStatsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, driverId) async {
 final repository = ref.watch(driverRepositoryProvider);
 return await repository.getDriverStats(driverId);
});
final driverTripsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, driverId) async {
 final repository = ref.watch(driverRepositoryProvider);
 return await repository.getDriverTrips(driverId);
});
final driverEarningsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, driverId) async {
 final repository = ref.watch(driverRepositoryProvider);
 return await repository.getDriverEarnings(driverId);
});
final driverPerformanceProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, driverId) async {
 final repository = ref.watch(driverRepositoryProvider);
 return await repository.getDriverPerformance(driverId);
});
final driverIncentivesProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, driverId) async {
 final repository = ref.watch(driverRepositoryProvider);
 return await repository.getDriverIncentives(driverId);
});
final driverDocumentsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, driverId) async {
 final repository = ref.watch(driverRepositoryProvider);
 return await repository.getDriverDocuments(driverId);
});
final driverTrainingModulesProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, driverId) async {
 final repository = ref.watch(driverRepositoryProvider);
 return await repository.getDriverTrainingModules(driverId);
});
final driverStatusProvider = StateProvider<String>((ref) => 'offline');