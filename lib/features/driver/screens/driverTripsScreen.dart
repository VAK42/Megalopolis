import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/driverProvider.dart';
import '../constants/driverConstants.dart';
class DriverTripsScreen extends ConsumerWidget {
 const DriverTripsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? '';
  final tripsAsync = ref.watch(driverTripsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(DriverConstants.tripsTitle),
   ),
   body: tripsAsync.when(
    data: (trips) => trips.isEmpty
      ? const Center(
        child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
          Icon(Icons.directions_car_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(DriverConstants.noTripsYet, style: TextStyle(color: Colors.grey, fontSize: 16)),
         ],
        ),
       )
      : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: trips.length,
        itemBuilder: (context, index) {
         final trip = trips[index];
         return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
           leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(24)),
            child: const Icon(Icons.directions_car, color: AppColors.primary),
           ),
           title: Text('${DriverConstants.tripPrefix}${trip['id'].toString().substring(0, 8)}'),
           subtitle: Text(DateTime.fromMillisecondsSinceEpoch(trip['createdAt'] as int).toString().substring(0, 16)),
           trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
             Text(
              '\$${(trip['total'] as num).toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success),
             ),
             const SizedBox(height: 4),
             Text(trip['status'] as String, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ],
           ),
          ),
         );
        },
       ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(child: Text('${DriverConstants.errorPrefix}$e')),
   ),
  );
 }
}