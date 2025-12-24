import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/systemProvider.dart';
import '../../core/constants/coreConstants.dart';
class GlobalSearchResultsScreen extends ConsumerWidget {
 const GlobalSearchResultsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final query = ref.watch(searchQueryProvider);
  final searchAsync = ref.watch(globalSearchProvider);
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.globalSearch)),
    title: Text('${CoreConstants.resultsFor}"$query"'),
   ),
   body: searchAsync.when(
    data: (results) => results.isEmpty
      ? Center(
        child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
          const Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text('${CoreConstants.noResultsFound} "$query"', style: const TextStyle(color: Colors.grey)),
         ],
        ),
       )
      : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: results.length,
        itemBuilder: (context, index) {
         final item = results[index];
         final icon = _getIconForType(item.type);
         final route = _getRouteForItem(item.type, item.id);
         return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
           leading: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: Colors.white),
           ),
           title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
           subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Text(_capitalizeType(item.type), style: TextStyle(color: AppColors.primary, fontSize: 12)),
             Row(
              children: [
               Icon(Icons.star, size: 14, color: Colors.amber[700]),
               const SizedBox(width: 4),
               Text('${item.rating}'),
               const SizedBox(width: 8),
               Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
             ),
            ],
           ),
           trailing: const Icon(Icons.chevron_right),
           onTap: () => context.go(route),
          ),
         );
        },
       ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(child: Text('${CoreConstants.errorPrefix}$e')),
   ),
  );
 }
 IconData _getIconForType(String type) {
  switch (type) {
   case 'product':
    return Icons.shopping_bag;
   case 'food':
    return Icons.restaurant;
   case 'service':
    return Icons.handyman;
   default:
    return Icons.category;
  }
 }
 String _getRouteForItem(String type, String id) {
  switch (type) {
   case 'product':
    return '/mart/product/$id';
   case 'food':
    return '/food/item/$id';
   case 'service':
    return '/services/item/$id';
   default:
    return Routes.globalSearch;
  }
 }
 String _capitalizeType(String type) {
  if (type.isEmpty) return type;
  return type[0].toUpperCase() + type.substring(1);
 }
}