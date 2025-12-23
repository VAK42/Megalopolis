import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/rideProvider.dart';
import '../../../providers/authProvider.dart';
import '../../ride/constants/rideConstants.dart';
class RideHistoryScreen extends ConsumerWidget {
 const RideHistoryScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final ridesAsync = ref.watch(ridesProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.rideHome)),
    title: const Text(RideConstants.historyTitle),
   ),
   body: ridesAsync.when(
    data: (rides) => rides.isEmpty
      ? const Center(
        child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
          Icon(Icons.local_taxi, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(RideConstants.noRidesFound, style: TextStyle(fontSize: 16, color: Colors.grey)),
         ],
        ),
       )
      : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: rides.length,
        itemBuilder: (context, index) {
         final ride = rides[index];
         return GestureDetector(
          onTap: () => context.go(Routes.rideReceipt),
          child: Card(
           margin: const EdgeInsets.only(bottom: 12),
           child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
              Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                Text(ride['orderType']?.toString() ?? 'RideEco', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('\$${(ride['total'] ?? 0).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
               ],
              ),
              const SizedBox(height: 8),
              Row(
               children: [
                const Icon(Icons.circle, size: 8, color: AppColors.success),
                const SizedBox(width: 8),
                Expanded(child: Text(ride['pickupLocation']?.toString() ?? RideConstants.pickupLocationLabel, style: const TextStyle(fontSize: 12))),
               ],
              ),
              const SizedBox(height: 4),
              Row(
               children: [
                const Icon(Icons.location_on, size: 12, color: AppColors.error),
                const SizedBox(width: 8),
                Expanded(child: Text(ride['dropoffLocation']?.toString() ?? RideConstants.dropoffLocationLabel, style: const TextStyle(fontSize: 12))),
               ],
              ),
              const SizedBox(height: 8),
              Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                Text(ride['createdAt'] != null ? DateFormat('MMM dd, yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(ride['createdAt'] as int)) : 'Recent', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                Container(
                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                 decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                 child: Text(
                  ride['status']?.toString().toUpperCase() ?? 'COMPLETED',
                  style: const TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.bold),
                 ),
                ),
               ],
              ),
             ],
            ),
           ),
          ),
         );
        },
       ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, _) => const Center(
     child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       Icon(Icons.error_outline, size: 64, color: Colors.grey),
       SizedBox(height: 16),
       Text(RideConstants.errorGeneric, style: TextStyle(fontSize: 16, color: Colors.grey)),
      ],
     ),
    ),
   ),
  );
 }
}