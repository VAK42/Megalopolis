import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/martProvider.dart';
import '../constants/martConstants.dart';
class MartBrandsScreen extends ConsumerWidget {
 const MartBrandsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(MartConstants.shopByBrand),
   ),
   body: ref
     .watch(martCategoriesProvider)
     .when(
      data: (categories) => GridView.builder(
       padding: const EdgeInsets.all(16),
       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 1.2),
       itemCount: categories.length,
       itemBuilder: (context, index) {
        return _buildBrandCard(categories[index]['category']?.toString() ?? MartConstants.brand);
       },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text(MartConstants.errorLoadingBrands)),
     ),
  );
 }
 Widget _buildBrandCard(String brand) {
  return GestureDetector(
   onTap: () {},
   child: Card(
    child: Column(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
      Container(
       width: 80,
       height: 80,
       decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(40)),
       child: Icon(Icons.store, size: 40, color: Colors.grey[400]),
      ),
      const SizedBox(height: 12),
      Text(brand, style: const TextStyle(fontWeight: FontWeight.bold)),
      Text(MartConstants.viewProducts, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
     ],
    ),
   ),
  );
 }
}