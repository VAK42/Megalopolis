import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/serviceProvider.dart';
import '../../../shared/models/itemModel.dart';
import '../constants/servicesConstants.dart';
class ServicesHomeScreen extends ConsumerWidget {
 const ServicesHomeScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   body: SafeArea(
    child: CustomScrollView(
     slivers: [
      SliverAppBar(
       floating: true,
       title: const Text(ServicesConstants.servicesTitle),
       actions: [
        IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () => context.go(Routes.notifications)),
        IconButton(icon: const Icon(Icons.search), onPressed: () => context.go(Routes.servicesSearch)),
       ],
      ),
      SliverToBoxAdapter(
       child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
          const Text(ServicesConstants.categories, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ref
            .watch(serviceCategoriesProvider)
            .when(
             data: (categories) => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
               final cat = categories[index];
               return _buildCategory(context, Icons.work, cat['category'] as String, '${Routes.servicesProviders}?category=${cat['category']}');
              },
             ),
             loading: () => const Center(child: CircularProgressIndicator()),
             error: (_, __) => const Text(ServicesConstants.errorLoadingCategories),
            ),
          const SizedBox(height: 24),
          Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
            const Text(ServicesConstants.popularServices, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () => context.go(Routes.servicesProviders), child: const Text(ServicesConstants.viewAll)),
           ],
          ),
          const SizedBox(height: 12),
         ],
        ),
       ),
      ),
      ref
        .watch(servicesProvider(null))
        .when(
         data: (services) => SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(delegate: SliverChildBuilderDelegate((context, index) => _buildServiceCard(context, services[index]), childCount: services.length)),
         ),
         loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
         error: (_, __) => const SliverToBoxAdapter(child: Center(child: Text(ServicesConstants.errorLoadingServices))),
        ),
     ],
    ),
   ),
  );
 }
 Widget _buildCategory(BuildContext context, IconData icon, String label, String route) {
  return GestureDetector(
   onTap: () => context.push(route),
   child: Container(
    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
    child: Column(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
      Icon(icon, size: 32, color: AppColors.primary),
      const SizedBox(height: 8),
      Text(
       label,
       style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
       textAlign: TextAlign.center,
      ),
     ],
    ),
   ),
  );
 }
 Widget _buildServiceCard(BuildContext context, ItemModel service) {
  return GestureDetector(
   onTap: () => context.push('${Routes.servicesHome}/item/${service.id}'),
   child: Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: Padding(
     padding: const EdgeInsets.all(12),
     child: Row(
      children: [
       Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
         color: Colors.grey[200],
         borderRadius: BorderRadius.circular(12),
         image: service.images.isNotEmpty ? DecorationImage(image: NetworkImage(service.images.first), fit: BoxFit.cover) : null,
        ),
        child: service.images.isEmpty ? Icon(Icons.cleaning_services, size: 40, color: Colors.grey[400]) : null,
       ),
       const SizedBox(width: 12),
       Expanded(
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
          Text(service.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
           children: [
            const Icon(Icons.star, size: 14, color: Colors.amber),
            const SizedBox(width: 4),
            Text('${service.rating}', style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            Text('(${service.stock})', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
           ],
          ),
          const SizedBox(height: 4),
          Text(ServicesConstants.startingFrom, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
         ],
        ),
       ),
       Column(
        children: [
         Text(
          '\$${service.price}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
         ),
         const SizedBox(height: 8),
         ElevatedButton(
          onPressed: () => context.push('${Routes.servicesHome}/item/${service.id}'),
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
          child: const Text(ServicesConstants.book, style: TextStyle(fontSize: 12)),
         ),
        ],
       ),
      ],
     ),
    ),
   ),
  );
 }
}