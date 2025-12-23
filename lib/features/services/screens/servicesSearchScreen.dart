import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/serviceProvider.dart';
import '../constants/servicesConstants.dart';
class ServicesSearchScreen extends ConsumerStatefulWidget {
 const ServicesSearchScreen({super.key});
 @override
 ConsumerState<ServicesSearchScreen> createState() => _ServicesSearchScreenState();
}
class _ServicesSearchScreenState extends ConsumerState<ServicesSearchScreen> {
 final searchController = TextEditingController();
 String searchQuery = '';
 @override
 Widget build(BuildContext context) {
  final servicesAsync = ref.watch(servicesProvider(null));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: TextField(
     controller: searchController,
     decoration: const InputDecoration(hintText: ServicesConstants.searchHint, border: InputBorder.none),
     onChanged: (value) => setState(() => searchQuery = value.toLowerCase()),
    ),
    actions: [IconButton(icon: const Icon(Icons.filter_list), onPressed: () {})],
   ),
   body: servicesAsync.when(
    data: (services) {
     final filtered = searchQuery.isEmpty ? services : services.where((s) => s.name.toLowerCase().contains(searchQuery)).toList();
     if (filtered.isEmpty) return const Center(child: Text(ServicesConstants.noServicesFound));
     return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
       final service = filtered[index];
       return Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
         leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: service.images.isNotEmpty
            ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(service.images.first, fit: BoxFit.cover),
             )
            : const Icon(Icons.cleaning_services, color: AppColors.primary),
         ),
         title: Text(service.name, style: const TextStyle(fontWeight: FontWeight.bold)),
         subtitle: Text('\$${service.price}', style: const TextStyle(color: AppColors.primary)),
         trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
           const Icon(Icons.star, size: 16, color: Colors.amber),
           Text('${service.rating}'),
          ],
         ),
         onTap: () => context.push('${Routes.servicesHome}/item/${service.id}'),
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