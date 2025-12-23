import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/foodProvider.dart';
import '../../core/constants/coreConstants.dart';
class GlobalSearchResultsScreen extends ConsumerWidget {
 const GlobalSearchResultsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final restaurantsAsync = ref.watch(restaurantsProvider);
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.globalSearch)),
    title: const Text(CoreConstants.searchResultsTitle),
   ),
   body: restaurantsAsync.when(
    data: (results) => results.isEmpty
      ? const Center(
        child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(CoreConstants.noResultsFound, style: TextStyle(color: Colors.grey)),
         ],
        ),
       )
      : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: results.length,
        itemBuilder: (context, index) {
         final result = results[index];
         return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
           leading: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.restaurant, color: Colors.white),
           ),
           title: Text(result['sellerName']?.toString() ?? '${CoreConstants.resultPrefix}${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
           subtitle: Row(
            children: [
             Icon(Icons.star, size: 14, color: Colors.amber[700]),
             const SizedBox(width: 4),
             Text('${result['sellerRating'] ?? 4.5}'),
            ],
           ),
           trailing: const Icon(Icons.chevron_right),
           onTap: () => context.go('${Routes.foodRestaurantDetail}/${result['sellerId']}'),
          ),
         );
        },
       ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(child: Text('${CoreConstants.errorPrefix}$e')),
   ),
  );
 }
}