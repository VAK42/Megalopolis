import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/serviceProvider.dart';
import '../constants/servicesConstants.dart';
class ServicesTrackingScreen extends ConsumerWidget {
 const ServicesTrackingScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final bookingState = ref.watch(serviceBookingProvider);
  final providerName = bookingState['providerName'] ?? ServicesConstants.serviceProvider;
  final providerRating = bookingState['providerRating'] ?? 4.9;
  final eta = bookingState['eta'] ?? 15;
  final status = bookingState['status'] ?? 'confirmed';
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ServicesConstants.trackProvider),
   ),
   body: Column(
    children: [
     Expanded(
      flex: 2,
      child: Container(
       color: Colors.grey[200],
       child: const Center(child: Icon(Icons.map, size: 100, color: Colors.grey)),
      ),
     ),
     Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
       color: Colors.white,
       borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
       mainAxisSize: MainAxisSize.min,
       children: [
        Container(
         padding: const EdgeInsets.all(16),
         decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
         child: Row(
          children: [
           const Icon(Icons.local_shipping, color: AppColors.primary, size: 32),
           const SizedBox(width: 16),
           Expanded(
            child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
              const Text(ServicesConstants.providerOnTheWay, style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('$eta ${ServicesConstants.mins}', style: const TextStyle(color: Colors.grey)),
             ],
            ),
           ),
          ],
         ),
        ),
        const SizedBox(height: 16),
        Row(
         children: [
          const CircleAvatar(
           radius: 25,
           backgroundColor: Colors.grey,
           child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
           child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Text(providerName, style: const TextStyle(fontWeight: FontWeight.bold)),
             Row(
              children: [
               const Icon(Icons.star, size: 14, color: Colors.amber),
               const SizedBox(width: 4),
               Text('$providerRating'),
              ],
             ),
            ],
           ),
          ),
          IconButton(
           icon: const Icon(Icons.call, color: AppColors.primary),
           onPressed: () {},
          ),
          IconButton(
           icon: const Icon(Icons.message, color: AppColors.primary),
           onPressed: () => context.go(Routes.servicesChat),
          ),
         ],
        ),
        const SizedBox(height: 16),
        _buildTrackingStep(ServicesConstants.bookingConfirmed, _isStepComplete(status, 'confirmed')),
        _buildTrackingStep(ServicesConstants.providerOnTheWay, _isStepComplete(status, 'onTheWay')),
        _buildTrackingStep(ServicesConstants.providerArrived, _isStepComplete(status, 'arrived')),
        _buildTrackingStep(ServicesConstants.serviceInProgress, _isStepComplete(status, 'inProgress')),
        _buildTrackingStep(ServicesConstants.serviceCompleted, _isStepComplete(status, 'completed')),
       ],
      ),
     ),
    ],
   ),
  );
 }
 bool _isStepComplete(String currentStatus, String step) {
  const steps = ['confirmed', 'onTheWay', 'arrived', 'inProgress', 'completed'];
  final currentIndex = steps.indexOf(currentStatus);
  final stepIndex = steps.indexOf(step);
  return stepIndex <= currentIndex;
 }
 Widget _buildTrackingStep(String label, bool isCompleted) {
  return Padding(
   padding: const EdgeInsets.symmetric(vertical: 4),
   child: Row(
    children: [
     Icon(isCompleted ? Icons.check_circle : Icons.circle_outlined, color: isCompleted ? AppColors.success : Colors.grey, size: 20),
     const SizedBox(width: 12),
     Text(label, style: TextStyle(color: isCompleted ? Colors.black : Colors.grey)),
    ],
   ),
  );
 }
}