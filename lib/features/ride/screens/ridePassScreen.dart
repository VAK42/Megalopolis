import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/rideProvider.dart';
import '../../ride/constants/rideConstants.dart';
class RidePassScreen extends ConsumerWidget {
 const RidePassScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(RideConstants.ridePassTitle),
   ),
   body: ListView(
    padding: const EdgeInsets.all(16),
    children: [
     Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
      child: const Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Icon(Icons.star, color: Colors.amber, size: 40),
        SizedBox(height: 16),
        Text(
         RideConstants.ridePassTitle,
         style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(RideConstants.unlimitedRides, style: TextStyle(color: Colors.white70)),
       ],
      ),
     ),
     const SizedBox(height: 24),
     _buildPassCard(context, ref, userId, RideConstants.weeklyPass, 29.99, '7 Days', AppColors.success),
     _buildPassCard(context, ref, userId, RideConstants.monthlyPass, 99.99, '30 Days', AppColors.primary),
    ],
   ),
  );
 }
 Widget _buildPassCard(BuildContext context, WidgetRef ref, String userId, String title, double price, String duration, Color color) {
  return Card(
   margin: const EdgeInsets.only(bottom: 16),
   child: Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
     children: [
      Container(
       width: 60,
       height: 60,
       decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
       child: Icon(Icons.card_membership, size: 32, color: color),
      ),
      const SizedBox(width: 16),
      Expanded(
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
         Text('${RideConstants.validUntil} $duration', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
       ),
      ),
      Column(
       crossAxisAlignment: CrossAxisAlignment.end,
       children: [
        Text('\$${price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        TextButton(
         onPressed: () async {
          await ref.read(rideRepositoryProvider).purchaseRidePass({'userId': userId, 'passType': title, 'price': price, 'duration': duration});
          if (context.mounted) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title purchased!')));
          }
         },
         child: const Text(RideConstants.buyNow),
        ),
       ],
      ),
     ],
    ),
   ),
  );
 }
}