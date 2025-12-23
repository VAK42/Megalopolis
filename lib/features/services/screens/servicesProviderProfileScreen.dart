import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/serviceProvider.dart';
import '../constants/servicesConstants.dart';
class ServicesProviderProfileScreen extends ConsumerWidget {
 final String? providerId;
 const ServicesProviderProfileScreen({super.key, this.providerId});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final bookingState = ref.watch(serviceBookingProvider);
  final providerName = bookingState['providerName'] ?? ServicesConstants.serviceProvider;
  final providerRating = bookingState['providerRating'] ?? 4.9;
  final reviewCount = bookingState['reviewCount'] ?? 0;
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ServicesConstants.providerProfile),
   ),
   body: SingleChildScrollView(
    child: Column(
     children: [
      Container(
       padding: const EdgeInsets.all(24),
       decoration: BoxDecoration(gradient: AppColors.primaryGradient),
       child: Column(
        children: [
         const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white24,
          child: Icon(Icons.person, size: 50, color: Colors.white),
         ),
         const SizedBox(height: 16),
         Text(
          providerName,
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
         ),
         const SizedBox(height: 8),
         Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           const Icon(Icons.star, size: 20, color: Colors.amber),
           const SizedBox(width: 4),
           Text('$providerRating', style: const TextStyle(color: Colors.white, fontSize: 16)),
           const SizedBox(width: 8),
           Text('($reviewCount ${ServicesConstants.reviews.toLowerCase()})', style: const TextStyle(color: Colors.white70)),
          ],
         ),
        ],
       ),
      ),
      Padding(
       padding: const EdgeInsets.all(16),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         const Text(ServicesConstants.aboutProvider, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
         const SizedBox(height: 8),
         Text(bookingState['providerBio'] ?? '', style: const TextStyle(color: Colors.grey)),
         const SizedBox(height: 24),
         const Text(ServicesConstants.servicesOffered, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
         const SizedBox(height: 12),
         Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [ServicesConstants.houseCleaning, ServicesConstants.deepCleaning, ServicesConstants.officeCleaning].map((s) => Chip(label: Text(s), backgroundColor: AppColors.primary.withValues(alpha: 0.1))).toList(),
         ),
         const SizedBox(height: 24),
         const Text(ServicesConstants.reviews, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
         const SizedBox(height: 12),
         if (reviewCount == 0) const Text(ServicesConstants.noBookings, style: TextStyle(color: Colors.grey)) else const SizedBox.shrink(),
         const SizedBox(height: 24),
         Row(
          children: [
           Expanded(
            child: OutlinedButton.icon(onPressed: () => context.go(Routes.servicesChat), icon: const Icon(Icons.chat), label: const Text(ServicesConstants.contactProvider)),
           ),
           const SizedBox(width: 12),
           Expanded(
            child: AppButton(
             text: ServicesConstants.bookNow,
             onPressed: () {
              ref.read(serviceBookingProvider.notifier).setProvider(providerId ?? '', providerName);
              context.go(Routes.servicesBooking);
             },
            ),
           ),
          ],
         ),
        ],
       ),
      ),
     ],
    ),
   ),
  );
 }
}