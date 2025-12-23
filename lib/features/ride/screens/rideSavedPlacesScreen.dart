import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/rideProvider.dart';
import '../../../providers/authProvider.dart';
import '../../ride/constants/rideConstants.dart';
class RideSavedPlacesScreen extends ConsumerWidget {
 const RideSavedPlacesScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final placesAsync = ref.watch(savedPlacesProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(RideConstants.savedPlacesTitle),
    actions: [IconButton(icon: const Icon(Icons.add), onPressed: () {})],
   ),
   body: placesAsync.when(
    data: (places) => places.isEmpty
      ? const Center(child: Text(RideConstants.noRidesFound))
      : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: places.length,
        itemBuilder: (context, index) {
         final place = places[index];
         return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
           leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(_getPlaceIcon(place['label'] ?? ''), color: AppColors.primary),
           ),
           title: Text(place['label'] ?? RideConstants.savedPlacesTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
           subtitle: Text(place['fullAddress'] ?? '', maxLines: 2),
           trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () {}),
           onTap: () {
            ref.read(rideBookingProvider.notifier).setDropoff(place['fullAddress'] ?? '', place['lat'] ?? 0.0, place['lng'] ?? 0.0);
            context.go(Routes.rideSelectVehicle);
           },
          ),
         );
        },
       ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(RideConstants.errorGeneric)),
   ),
  );
 }
 IconData _getPlaceIcon(String label) {
  switch (label.toLowerCase()) {
   case 'home':
    return Icons.home;
   case 'work':
    return Icons.work;
   default:
    return Icons.location_on;
  }
 }
}