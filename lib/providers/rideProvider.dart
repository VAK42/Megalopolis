import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/rideRepository.dart';
final rideRepositoryProvider = Provider<RideRepository>((ref) => RideRepository());
final ridesProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 final repository = ref.watch(rideRepositoryProvider);
 return await repository.getRides(userId);
});
final activeRideProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, userId) async {
 final repository = ref.watch(rideRepositoryProvider);
 return await repository.getActiveRide(userId);
});
final savedPlacesProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 final repository = ref.watch(rideRepositoryProvider);
 return await repository.getSavedPlaces(userId);
});
final scheduledRidesProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
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
  state = {...state, 'pickupLocation': location, 'pickupLat': lat, 'pickupLng': lng};
 }
 void setDropoff(String location, double lat, double lng) {
  state = {...state, 'dropoffLocation': location, 'dropoffLat': lat, 'dropoffLng': lng};
  _calculateEstimates();
 }
 void _calculateEstimates() {
  final double pickupLat = state['pickupLat'] as double? ?? 0.0;
  final double pickupLng = state['pickupLng'] as double? ?? 0.0;
  final double dropoffLat = state['dropoffLat'] as double? ?? 0.0;
  final double dropoffLng = state['dropoffLng'] as double? ?? 0.0;
  double dist = 0.0;
  if (pickupLat != 0 && pickupLng != 0 && dropoffLat != 0 && dropoffLng != 0) {
   dist = ((pickupLat - dropoffLat).abs() + (pickupLng - dropoffLng).abs()) * 111.0;
  }
  final double dur = dist * 3.0;
  final double base = 3.50;
  final double price = base + (dist * 1.5) + (dur * 0.2);
  state = {...state, 'distance': double.parse(dist.toStringAsFixed(1)), 'duration': dur.ceil(), 'baseFare': base, 'estimatedPrice': double.parse(price.toStringAsFixed(2))};
 }
 void setRideType(String type) {
  state = {...state, 'rideType': type};
 }
 Future<int?> bookRide(String userId) async {
  try {
   final ride = {...state, 'userId': userId, 'type': 'ride', 'status': 'pending', 'createdAt': DateTime.now().toIso8601String()};
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
final rideBookingProvider = NotifierProvider<RideBookingNotifier, Map<String, dynamic>>(() {
 return RideBookingNotifier();
});
class SavedPlacesNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
 String _userId = '';
 void setUserId(String id) => _userId = id;
 @override
 Future<List<Map<String, dynamic>>> build() async {
  if (_userId.isEmpty) return [];
  return await ref.watch(rideRepositoryProvider).getSavedPlaces(_userId);
 }
 Future<void> addPlace(Map<String, dynamic> place) async {
  place['isSavedPlace'] = 1;
  await ref.read(rideRepositoryProvider).savePlaceAsync(_userId, place);
  ref.invalidateSelf();
 }
}
final savedPlacesNotifierProvider = AsyncNotifierProvider<SavedPlacesNotifier, List<Map<String, dynamic>>>(() => SavedPlacesNotifier());
class ScheduledRidesNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
 String _userId = '';
 void setUserId(String id) => _userId = id;
 @override
 Future<List<Map<String, dynamic>>> build() async {
  if (_userId.isEmpty) return [];
  return await ref.watch(rideRepositoryProvider).getScheduledRides(_userId);
 }
 Future<void> scheduleRide(Map<String, dynamic> ride) async {
  ride['userId'] = _userId;
  ride['type'] = 'ride';
  ride['status'] = 'scheduled';
  await ref.read(rideRepositoryProvider).scheduleRide(ride);
  ref.invalidateSelf();
 }
 Future<void> cancelScheduled(String rideId) async {
  await ref.read(rideRepositoryProvider).cancelRide(rideId);
  ref.invalidateSelf();
 }
}
final scheduledRidesNotifierProvider = AsyncNotifierProvider<ScheduledRidesNotifier, List<Map<String, dynamic>>>(() => ScheduledRidesNotifier());
class ActiveRideNotifier extends Notifier<Map<String, dynamic>?> {
 @override
 Map<String, dynamic>? build() => null;
 void setActiveRide(Map<String, dynamic> ride) => state = ride;
 Future<void> updateStatus(String status) async {
  if (state != null) {
   await ref.read(rideRepositoryProvider).updateRideStatus(state!['id'].toString(), status);
   state = {...state!, 'status': status};
  }
 }
 Future<void> cancelRide() async {
  if (state != null) {
   await ref.read(rideRepositoryProvider).cancelRide(state!['id'].toString());
   state = null;
  }
 }
 void clear() => state = null;
}
final activeRideNotifierProvider = NotifierProvider<ActiveRideNotifier, Map<String, dynamic>?>(() => ActiveRideNotifier());