import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/rideProvider.dart';
import '../../ride/constants/rideConstants.dart';
class RideHomeScreen extends ConsumerWidget {
 const RideHomeScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   body: Stack(
    children: [
     FlutterMap(
      options: const MapOptions(initialCenter: LatLng(37.7749, -122.4194), initialZoom: 13),
      children: [TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png')],
     ),
     SafeArea(
      child: Column(
       children: [
        Padding(
         padding: const EdgeInsets.all(16),
         child: Row(
          children: [
           IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => context.go(Routes.superDashboard),
            style: IconButton.styleFrom(backgroundColor: Colors.white),
           ),
           const Spacer(),
           IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.go(Routes.rideHistory),
            style: IconButton.styleFrom(backgroundColor: Colors.white),
           ),
          ],
         ),
        ),
        const Spacer(),
        Container(
         padding: const EdgeInsets.all(24),
         decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
         ),
         child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Text(RideConstants.whereToHint, style: Theme.of(context).textTheme.headlineSmall),
           const SizedBox(height: 16),
           GestureDetector(
            onTap: () => context.go(Routes.ridePickLocation),
            child: Container(
             padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
             child: const Row(children: [Icon(Icons.search), SizedBox(width: 12), Text(RideConstants.whereToHint)]),
            ),
           ),
           const SizedBox(height: 16),
           const Text(RideConstants.savedPlacesTitle, style: TextStyle(fontWeight: FontWeight.bold)),
           const SizedBox(height: 12),
           if (ref.watch(currentUserIdProvider) != null)
            ...ref
              .watch(savedPlacesProvider(ref.read(currentUserIdProvider)!))
              .when(
               data: (places) => places
                 .take(3)
                 .map(
                  (place) => ListTile(
                   contentPadding: EdgeInsets.zero,
                   leading: const Icon(Icons.location_on, color: AppColors.primary),
                   title: Text(place['label'] ?? 'Unknown'),
                   subtitle: Text(place['fullAddress'] ?? ''),
                   onTap: () => context.go(Routes.rideSelectVehicle),
                  ),
                 )
                 .toList(),
               loading: () => [const Center(child: CircularProgressIndicator())],
               error: (_, __) => [],
              ),
          ],
         ),
        ),
       ],
      ),
     ),
    ],
   ),
  );
 }
}