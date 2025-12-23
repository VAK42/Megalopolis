import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/serviceProvider.dart';
import '../constants/servicesConstants.dart';
class ServicesProvidersScreen extends ConsumerWidget {
 final String? category;
 const ServicesProvidersScreen({super.key, this.category});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final providersAsync = ref.watch(serviceProvidersProvider(category ?? ''));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: Text(category ?? ServicesConstants.servicesTitle),
   ),
   body: providersAsync.when(
    data: (providers) {
     if (providers.isEmpty) return const Center(child: Text(ServicesConstants.noServicesFound));
     return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: providers.length,
      itemBuilder: (context, index) {
       final provider = providers[index];
       return Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
         leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: const Icon(Icons.person, color: AppColors.primary),
         ),
         title: Text(provider['sellerName'] ?? ServicesConstants.serviceProvider, style: const TextStyle(fontWeight: FontWeight.bold)),
         subtitle: Row(
          children: [
           const Icon(Icons.star, size: 14, color: Colors.amber),
           const SizedBox(width: 4),
           Text('${provider['sellerRating'] ?? 4.5}'),
          ],
         ),
         trailing: ElevatedButton(
          onPressed: () {
           ref.read(serviceBookingProvider.notifier).setProvider(provider['sellerId']?.toString() ?? '', provider['sellerName'] ?? '');
           context.go(Routes.servicesBooking);
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