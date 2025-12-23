import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/martProvider.dart';
import '../../../providers/authProvider.dart';
import '../../../shared/models/itemModel.dart';
import '../constants/martConstants.dart';
class MartSearchScreen extends ConsumerStatefulWidget {
 const MartSearchScreen({super.key});
 @override
 ConsumerState<MartSearchScreen> createState() => _MartSearchScreenState();
}
class _MartSearchScreenState extends ConsumerState<MartSearchScreen> {
 final TextEditingController searchController = TextEditingController();
 bool isSearching = false;
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final searchHistoryAsync = ref.watch(martSearchHistoryProvider(userId));
  final popularAsync = ref.watch(popularSearchesProvider);
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: TextField(
     controller: searchController,
     autofocus: true,
     decoration: const InputDecoration(hintText: MartConstants.searchHint, border: InputBorder.none),
     onChanged: (value) => setState(() => isSearching = value.isNotEmpty),
     onSubmitted: (value) async {
      if (value.isNotEmpty) {
       final repo = ref.read(martRepositoryProvider);
       await repo.addSearchHistory(userId, value);
       ref.invalidate(martSearchHistoryProvider(userId));
      }
     },
    ),
    actions: [
     if (searchController.text.isNotEmpty)
      IconButton(
       icon: const Icon(Icons.clear),
       onPressed: () {
        searchController.clear();
        setState(() => isSearching = false);
       },
      ),
    ],
   ),
   body: isSearching
     ? ref
        .watch(martSearchProvider(searchController.text))
        .when(
         data: (products) => products.isEmpty ? const Center(child: Text(MartConstants.noProductsFound)) : GridView.builder(padding: const EdgeInsets.all(16), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.7), itemCount: products.length, itemBuilder: (context, index) => _buildProductCard(context, products[index])),
         loading: () => const Center(child: CircularProgressIndicator()),
         error: (err, stack) => const Center(child: Text(MartConstants.errorSearching)),
        )
     : ListView(
       padding: const EdgeInsets.all(16),
       children: [
        searchHistoryAsync.when(
         data: (recentSearches) {
          if (recentSearches.isEmpty) return const SizedBox.shrink();
          return Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
              const Text(MartConstants.recentSearches, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextButton(
               onPressed: () async {
                final repo = ref.read(martRepositoryProvider);
                await repo.clearSearchHistory(userId);
                ref.invalidate(martSearchHistoryProvider(userId));
               },
               child: const Text(MartConstants.clearAll),
              ),
             ],
            ),
            const SizedBox(height: 8),
            ...recentSearches.map(
             (search) => ListTile(
              leading: const Icon(Icons.history),
              title: Text(search),
              onTap: () {
               searchController.text = search;
               setState(() => isSearching = true);
              },
             ),
            ),
            const SizedBox(height: 16),
           ],
          );
         },
         loading: () => const SizedBox.shrink(),
         error: (err, stack) => const SizedBox.shrink(),
        ),
        const Text(MartConstants.popularSearches, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        popularAsync.when(
         data: (popularSearches) => Wrap(
          spacing: 8,
          runSpacing: 8,
          children: popularSearches.map((search) {
           return GestureDetector(
            onTap: () {
             searchController.text = search;
             setState(() => isSearching = true);
            },
            child: Container(
             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
             decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
             child: Text(search, style: const TextStyle(color: AppColors.primary)),
            ),
           );
          }).toList(),
         ),
         loading: () => const SizedBox.shrink(),
         error: (err, stack) => const SizedBox.shrink(),
        ),
       ],
      ),
  );
 }
 Widget _buildProductCard(BuildContext context, ItemModel product) {
  return GestureDetector(
   onTap: () {
    final route = Routes.martProductDetail.replaceFirst(':id', product.id.toString());
    context.push(route);
   },
   child: Card(
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Container(
       height: 140,
       decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        image: product.images.isNotEmpty ? DecorationImage(image: NetworkImage(product.images.first), fit: BoxFit.cover) : null,
       ),
       child: product.images.isEmpty ? Center(child: Icon(Icons.image, size: 50, color: Colors.grey[400])) : null,
      ),
      Padding(
       padding: const EdgeInsets.all(8),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(
          product.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
         ),
         const SizedBox(height: 4),
         Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
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