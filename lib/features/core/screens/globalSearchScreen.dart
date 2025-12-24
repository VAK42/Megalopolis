import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/systemProvider.dart';
import '../../../providers/authProvider.dart';
import '../../core/constants/coreConstants.dart';
class GlobalSearchScreen extends ConsumerStatefulWidget {
 const GlobalSearchScreen({super.key});
 @override
 ConsumerState<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}
class _GlobalSearchScreenState extends ConsumerState<GlobalSearchScreen> {
 final searchController = TextEditingController();
 @override
 void dispose() {
  searchController.dispose();
  super.dispose();
 }
 void _performSearch(String query) {
  if (query.length > 1) {
   final userId = ref.read(currentUserIdProvider) ?? '1';
   ref.read(searchHistoryNotifierProvider(userId).notifier).addSearch(query);
   ref.read(searchQueryProvider.notifier).state = query;
   context.go(Routes.globalSearchResults);
  }
 }
 @override
 Widget build(BuildContext context) {
  final categoriesAsync = ref.watch(globalCategoriesProvider);
  final userId = ref.watch(currentUserIdProvider) ?? '1';
  final historyAsync = ref.watch(searchHistoryNotifierProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.superDashboard)),
    title: TextField(
     controller: searchController,
     autofocus: true,
     decoration: const InputDecoration(hintText: CoreConstants.searchForAnything, border: InputBorder.none),
     onSubmitted: _performSearch,
    ),
   ),
   body: SafeArea(
    child: SingleChildScrollView(
     padding: const EdgeInsets.all(24),
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         Text(CoreConstants.recentSearches, style: Theme.of(context).textTheme.titleMedium),
         historyAsync.when(
          data: (searches) => searches.isNotEmpty ? TextButton(onPressed: () => ref.read(searchHistoryNotifierProvider(userId).notifier).clearHistory(), child: const Text(CoreConstants.clear)) : const SizedBox(),
          loading: () => const SizedBox(),
          error: (_, __) => const SizedBox(),
         ),
        ],
       ),
       const SizedBox(height: 16),
       historyAsync.when(
        data: (searches) => searches.isEmpty
          ? const Text(CoreConstants.noRecentSearches, style: TextStyle(color: Colors.grey))
          : Column(
            children: searches.map((search) => ListTile(
             leading: const Icon(Icons.history),
             title: Text(search),
             trailing: const Icon(Icons.north_west),
             onTap: () {
              searchController.text = search;
              _performSearch(search);
             },
            )).toList(),
           ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const SizedBox(),
       ),
       const SizedBox(height: 32),
       Text(CoreConstants.popularCategories, style: Theme.of(context).textTheme.titleMedium),
       const SizedBox(height: 16),
       categoriesAsync.when(
        data: (categories) => Wrap(
         spacing: 12,
         runSpacing: 12,
         children: categories.map((cat) {
          final icon = _getIcon(cat['icon'] as String);
          return _buildCategoryChip(cat['label'] as String, icon, cat['route'] as String);
         }).toList(),
        ),
        loading: () => const CircularProgressIndicator(),
        error: (e, s) => Text('${CoreConstants.errorPrefix}$e'),
       ),
      ],
     ),
    ),
   ),
  );
 }
 Widget _buildCategoryChip(String label, IconData icon, String route) {
  return ActionChip(avatar: Icon(icon, size: 18), label: Text(label), onPressed: () => context.go(route));
 }
 IconData _getIcon(String name) {
  switch (name) {
   case 'restaurant':
    return Icons.restaurant;
   case 'directions_car':
    return Icons.directions_car;
   case 'shopping_bag':
    return Icons.shopping_bag;
   case 'handyman':
    return Icons.handyman;
   case 'receipt':
    return Icons.receipt;
   default:
    return Icons.category;
  }
 }
}