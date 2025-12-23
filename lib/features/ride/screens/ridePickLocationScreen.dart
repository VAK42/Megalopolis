import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/rideProvider.dart';
import '../../ride/constants/rideConstants.dart';
class RidePickLocationScreen extends ConsumerStatefulWidget {
 const RidePickLocationScreen({super.key});
 @override
 ConsumerState<RidePickLocationScreen> createState() => _RidePickLocationScreenState();
}
class _RidePickLocationScreenState extends ConsumerState<RidePickLocationScreen> {
 final pickupController = TextEditingController();
 final dropoffController = TextEditingController();
 bool isSelectingPickup = true;
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   body: Stack(
    children: [
     FlutterMap(
      options: const MapOptions(initialCenter: LatLng(37.7749, -122.4194), initialZoom: 14),
      children: [TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png')],
     ),
     SafeArea(
      child: Column(
       children: [
        Container(
         margin: const EdgeInsets.all(16),
         padding: const EdgeInsets.all(16),
         decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)],
         ),
         child: Column(
          children: [
           Row(
            children: [
             IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.rideHome)),
             const Expanded(
              child: Text(RideConstants.searchLocation, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
             ),
            ],
           ),
           const SizedBox(height: 16),
           _buildLocationField(Icons.trip_origin, RideConstants.pickupTitle, pickupController, AppColors.success, true),
           const SizedBox(height: 12),
           _buildLocationField(Icons.location_on, RideConstants.destinationTitle, dropoffController, AppColors.error, false),
          ],
         ),
        ),
        const Spacer(),
        Container(
         padding: const EdgeInsets.all(16),
         color: Colors.white,
         child: AppButton(
          text: isSelectingPickup ? RideConstants.confirmPickup : RideConstants.confirmDropoff,
          onPressed: () {
           if (isSelectingPickup && pickupController.text.isNotEmpty) {
            ref.read(rideBookingProvider.notifier).setPickup(pickupController.text, 37.7749, -122.4194);
            setState(() => isSelectingPickup = false);
           } else if (!isSelectingPickup && dropoffController.text.isNotEmpty) {
            ref.read(rideBookingProvider.notifier).setDropoff(dropoffController.text, 37.7849, -122.4094);
            context.go(Routes.rideSelectVehicle);
           }
          },
          icon: Icons.check,
         ),
        ),
       ],
      ),
     ),
    ],
   ),
  );
 }
 Widget _buildLocationField(IconData icon, String label, TextEditingController controller, Color color, bool isPickup) {
  return GestureDetector(
   onTap: () => setState(() => isSelectingPickup = isPickup),
   child: Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
     color: (isSelectingPickup == isPickup) ? color.withValues(alpha: 0.1) : Colors.grey[100],
     borderRadius: BorderRadius.circular(12),
     border: Border.all(color: (isSelectingPickup == isPickup) ? color : Colors.transparent),
    ),
    child: Row(
     children: [
      Icon(icon, color: color, size: 20),
      const SizedBox(width: 12),
      Expanded(
       child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: label, border: InputBorder.none, isDense: true),
       ),
      ),
     ],
    ),
   ),
  );
 }
}