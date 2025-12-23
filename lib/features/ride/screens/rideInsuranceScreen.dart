import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../ride/constants/rideConstants.dart';
class RideInsuranceScreen extends ConsumerWidget {
 const RideInsuranceScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(RideConstants.insuranceTitle),
   ),
   body: ListView(
    padding: const EdgeInsets.all(16),
    children: [
     Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
      child: const Column(
       children: [
        Icon(Icons.security, size: 60, color: AppColors.primary),
        SizedBox(height: 16),
        Text(RideConstants.tripInsurance, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text(
         'Protect yourself and your belongings during every ride',
         textAlign: TextAlign.center,
         style: TextStyle(color: Colors.grey),
        ),
       ],
      ),
     ),
     const SizedBox(height: 24),
     const Text(RideConstants.coverageDetails, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     _buildCoverageItem(Icons.medical_services, 'Medical Coverage', 'Up to \$50,000'),
     _buildCoverageItem(Icons.luggage, 'Baggage Protection', 'Up to \$2,000'),
     _buildCoverageItem(Icons.car_crash, 'Accident Coverage', 'Up to \$100,000'),
     _buildCoverageItem(Icons.cancel, 'Trip Cancellation', 'Full Refund'),
     const SizedBox(height: 24),
     ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.all(16)),
      child: const Text(RideConstants.addInsurance, style: TextStyle(color: Colors.white)),
     ),
    ],
   ),
  );
 }
 Widget _buildCoverageItem(IconData icon, String title, String value) {
  return Card(
   margin: const EdgeInsets.only(bottom: 8),
   child: ListTile(
    leading: Icon(icon, color: AppColors.primary),
    title: Text(title),
    trailing: Text(
     value,
     style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success),
    ),
   ),
  );
 }
}