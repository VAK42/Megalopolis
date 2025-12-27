import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/serviceProvider.dart';
import '../../../shared/models/itemModel.dart';
import '../constants/servicesConstants.dart';
class ServicesProvidersScreen extends ConsumerWidget {
 final String? category;
 const ServicesProvidersScreen({super.key, this.category});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final servicesAsync = ref.watch(servicesProvider(category));
  final displayCategory = category != null && category!.isNotEmpty 
    ? category![0].toUpperCase() + category!.substring(1) 
    : ServicesConstants.servicesTitle;
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: Text(displayCategory),
   ),
   body: servicesAsync.when(
    data: (services) {
     if (services.isEmpty) return const Center(child: Text(ServicesConstants.noServicesFound));
     return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: services.length,
      itemBuilder: (context, index) {
       final service = services[index];
       return Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
         leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
           color: AppColors.primary.withValues(alpha: 0.1),
           borderRadius: BorderRadius.circular(8),
           image: service.images.isNotEmpty ? DecorationImage(image: NetworkImage(service.images.first), fit: BoxFit.cover) : null,
          ),
          child: service.images.isEmpty ? const Icon(Icons.cleaning_services, color: AppColors.primary) : null,
         ),
         title: Text(service.name, style: const TextStyle(fontWeight: FontWeight.bold)),
         subtitle: Row(
          children: [
           const Icon(Icons.star, size: 14, color: Colors.amber),
           const SizedBox(width: 4),
           Text('${service.rating}'),
           const SizedBox(width: 8),
           Text('\$${service.price.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ],
         ),
         trailing: ElevatedButton(
          onPressed: () {
           ref.read(serviceBookingProvider.notifier).setService(service.id, service.name, service.price);
           context.push('${Routes.servicesHome}/item/${service.id}');
          },
          child: const Text(ServicesConstants.bookNow),
         ),
        ),
       );
      },
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(ServicesConstants.errorLoadingServices)),
   ),
  );
 }
}