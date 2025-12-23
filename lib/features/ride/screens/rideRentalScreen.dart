import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/rideProvider.dart';
import '../../ride/constants/rideConstants.dart';
class RideRentalScreen extends ConsumerWidget {
 const RideRentalScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(RideConstants.rentalTitle),
   ),
   body: ListView(
    padding: const EdgeInsets.all(16),
    children: [
     const Text(RideConstants.rentalVehicles, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
     const SizedBox(height: 16),
     _buildRentalCard(context, ref, userId, 'Sedan', Icons.directions_car, 25.0, 150.0, AppColors.primary),
     _buildRentalCard(context, ref, userId, 'SUV', Icons.airport_shuttle, 35.0, 200.0, AppColors.accent),
     _buildRentalCard(context, ref, userId, 'Luxury', Icons.directions_car, 60.0, 350.0, Colors.amber),
     _buildRentalCard(context, ref, userId, 'Motorcycle', Icons.two_wheeler, 15.0, 80.0, AppColors.success),
    ],
   ),
  );
 }
 Widget _buildRentalCard(BuildContext context, WidgetRef ref, String userId, String name, IconData icon, double hourly, double daily, Color color) {
  return Card(
   margin: const EdgeInsets.only(bottom: 16),
   child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
     children: [
      Row(
       children: [
        Container(
         width: 60,
         height: 60,
         decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
         child: Icon(icon, size: 32, color: color),
        ),
        const SizedBox(width: 16),
        Expanded(
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
           const SizedBox(height: 4),
           Row(
            children: [
             Text('${RideConstants.hourlyRate}: \$${hourly.toStringAsFixed(0)}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
             const SizedBox(width: 16),
             Text('${RideConstants.dailyRate}: \$${daily.toStringAsFixed(0)}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
           ),
          ],
         ),
        ),
       ],
      ),
      const SizedBox(height: 12),
      SizedBox(
       width: double.infinity,
       child: AppButton(
        text: RideConstants.bookRental,
        onPressed: () async {
         await ref.read(rideRepositoryProvider).bookRental({'userId': userId, 'vehicleType': name, 'hourlyRate': hourly, 'dailyRate': daily});
         if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$name booked!')));
         }
        },
        isOutline: true,
       ),
      ),
     ],
    ),
   ),
  );
 }
}