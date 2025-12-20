import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/rideRepository.dart';
final rideRepositoryProvider = Provider<RideRepository>(
  (ref) => RideRepository(),
);
final ridesProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((
  ref,
  userId,
) async {
  final repository = ref.watch(rideRepositoryProvider);
  return await repository.getRides(userId);
});
final activeRideProvider = FutureProvider.family<Map<String, dynamic>?, int>((
  ref,
  userId,
) async {
  final repository = ref.watch(rideRepositoryProvider);
  return await repository.getActiveRide(userId);
});
final savedPlacesProvider =
  FutureProvider.family<List<Map<String, dynamic>>, int>((ref, userId) async {
    final repository = ref.watch(rideRepositoryProvider);
    return await repository.getSavedPlaces(userId);
  });
final scheduledRidesProvider =
  FutureProvider.family<List<Map<String, dynamic>>, int>((ref, userId) async {
    final repository = ref.watch(rideRepositoryProvider);
    return await repository.getScheduledRides(userId);
  });
class RideBookingNotifier extends Notifier<Map<String, dynamic>> {
  late final RideRepository _repository;
  @override
  Map<String, dynamic> build() {
    _repository = ref.watch(rideRepositoryProvider);
    return {};
  }
  void setPickup(String location, double lat, double lng) {
    state = {
      ...state,
      'pickupLocation': location,
      'pickupLat': lat,
      'pickupLng': lng,
    };
  }
  void setDropoff(String location, double lat, double lng) {
    state = {
      ...state,
      'dropoffLocation': location,
      'dropoffLat': lat,
      'dropoffLng': lng,
    };
  }
  void setRideType(String type) {
    state = {...state, 'rideType': type};
  }
  Future<int?> bookRide(int userId) async {
    try {
      final ride = {
        ...state,
        'userId': userId,
        'type': 'ride',
        'status': 'pending',
        'createdAt': DateTime.now().toIso8601String(),
      };
      final id = await _repository.bookRide(ride);
      state = {};
      return id;
    } catch (e) {
      return null;
    }
  }
  void reset() {
    state = {};
  }
}
final rideBookingProvider =
  NotifierProvider<RideBookingNotifier, Map<String, dynamic>>(() {
    return RideBookingNotifier();
  });