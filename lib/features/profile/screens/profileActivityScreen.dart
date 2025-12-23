import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../constants/profileConstants.dart';
class ProfileActivityScreen extends ConsumerWidget {
 const ProfileActivityScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ProfileConstants.activityTitle),
   ),
   body: ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: 30,
    itemBuilder: (context, index) {
     final activities = ['Order Placed', 'Ride Completed', 'Payment Made', 'Service Booked', 'Address Added'];
     final icons = [Icons.shopping_bag, Icons.local_taxi, Icons.payment, Icons.cleaning_services, Icons.location_on];
     final times = ['2 Min Ago', '1 Hour Ago', '3 Hours Ago', '1 Day Ago', '2 Days Ago'];
     return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
       leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icons[index % icons.length], color: AppColors.primary, size: 20),
       ),
       title: Text(activities[index % activities.length]),
       subtitle: Text(times[index % times.length]),
       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
     );
    },
   ),
  );
 }
}