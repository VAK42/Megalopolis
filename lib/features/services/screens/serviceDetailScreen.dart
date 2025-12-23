import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/serviceProvider.dart';
import '../constants/servicesConstants.dart';
class ServiceDetailScreen extends ConsumerWidget {
 final String? serviceId;
 const ServiceDetailScreen({super.key, this.serviceId});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final serviceAsync = ref.watch(serviceItemProvider(serviceId ?? ''));
  return Scaffold(
   body: serviceAsync.when(
    data: (service) {
     if (service == null) return const Center(child: Text(ServicesConstants.noServicesFound));
     return CustomScrollView(
      slivers: [
       SliverAppBar(
        expandedHeight: 200,
        pinned: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        flexibleSpace: FlexibleSpaceBar(
         background: service.images.isNotEmpty
           ? Image.network(service.images.first, fit: BoxFit.cover)
           : Container(
             color: AppColors.primary.withValues(alpha: 0.3),
             child: const Icon(Icons.cleaning_services, size: 80, color: Colors.white),
            ),
        ),
       ),
       SliverToBoxAdapter(
        child: Padding(
         padding: const EdgeInsets.all(16),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Expanded(
              child: Text(service.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
             ),
             Text(
              '\$${service.price}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
             ),
            ],
           ),
           const SizedBox(height: 8),
           Row(
            children: [
             const Icon(Icons.star, size: 18, color: Colors.amber),
             const SizedBox(width: 4),
             Text('${service.rating}', style: const TextStyle(fontSize: 14)),
             const SizedBox(width: 8),
             Text('(${service.stock} ${ServicesConstants.reviews.toLowerCase()})', style: const TextStyle(color: Colors.grey)),
            ],
           ),
           const SizedBox(height: 16),
           Text(service.description ?? '', style: const TextStyle(color: Colors.grey, height: 1.5)),
           const SizedBox(height: 24),
           const Text(ServicesConstants.servicesOffered, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
           const SizedBox(height: 12),
           Wrap(spacing: 8, runSpacing: 8, children: [ServicesConstants.houseCleaning, ServicesConstants.deepCleaning].map((s) => Chip(label: Text(s))).toList()),
           const SizedBox(height: 24),
           AppButton(
            text: ServicesConstants.bookNow,
            onPressed: () {
             ref.read(serviceBookingProvider.notifier).setService(service.id, service.name, service.price);
             context.go(Routes.servicesBooking);
            },
            icon: Icons.calendar_today,
           ),
          ],
         ),
        ),
       ),
      ],
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(ServicesConstants.errorLoadingServices)),
   ),
  );
 }
}