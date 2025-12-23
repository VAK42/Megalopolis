import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../constants/martConstants.dart';
class MartProductsScreen extends ConsumerStatefulWidget {
 const MartProductsScreen({super.key});
 @override
 ConsumerState<MartProductsScreen> createState() => _MartProductsScreenState();
}
class _MartProductsScreenState extends ConsumerState<MartProductsScreen> {
 String sortBy = MartConstants.popular;
 bool showFilters = false;
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.martHome)),
    title: const Text(MartConstants.electronics),
    actions: [IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () => context.go(Routes.martCart))],
   ),
   body: Column(
    children: [
     Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[100],
      child: Row(
       children: [
        Expanded(
         child: GestureDetector(
          onTap: () => setState(() => showFilters = !showFilters),
          child: Container(
           padding: const EdgeInsets.symmetric(vertical: 12),
           decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
           ),
           child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.filter_list, size: 20), SizedBox(width: 8), Text(MartConstants.filter)]),
          ),
         ),
        ),
        const SizedBox(width: 12),
        Expanded(
         child: GestureDetector(
          onTap: () => _showSortOptions(context),
          child: Container(
           padding: const EdgeInsets.symmetric(vertical: 12),
           decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
           ),
           child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.sort, size: 20), const SizedBox(width: 8), Text(sortBy)]),
          ),
         ),
        ),
       ],
      ),
     ),
     if (showFilters)
      Container(
       padding: const EdgeInsets.all(16),
       color: Colors.white,
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         const Text(MartConstants.priceRange, style: TextStyle(fontWeight: FontWeight.bold)),
         const SizedBox(height: 8),
         Wrap(
          spacing: 8,
          children: ['\$0-\$50', '\$50-\$100', '\$100-\$200', '\$200+'].map((range) {
           return FilterChip(label: Text(range), selected: false, onSelected: (selected) {});
          }).toList(),
         ),
         const SizedBox(height: 16),
         const Text(MartConstants.brand, style: TextStyle(fontWeight: FontWeight.bold)),
         const SizedBox(height: 8),
         Wrap(
          spacing: 8,
          children: [MartConstants.samsung, MartConstants.apple, MartConstants.sony, MartConstants.lg].map((brand) {
           return FilterChip(label: Text(brand), selected: false, onSelected: (selected) {});
          }).toList(),
         ),
        ],
       ),
      ),
     Expanded(
      child: GridView.builder(padding: const EdgeInsets.all(16), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.7), itemCount: 20, itemBuilder: (context, index) => _buildProductCard(context, index)),
     ),
    ],
   ),
  );
 }
 Widget _buildProductCard(BuildContext context, int index) {
  return GestureDetector(
   onTap: () => context.go(Routes.martProductDetail),
   child: Card(
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Stack(
       children: [
        Container(
         height: 140,
         decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
         ),
         child: Center(child: Icon(Icons.image, size: 50, color: Colors.grey[400])),
        ),
        if (index % 3 == 0)
         Positioned(
          top: 8,
          right: 8,
          child: Container(
           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
           decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(12)),
           child: const Text(
            '-20%',
            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
           ),
          ),
         ),
        Positioned(
         top: 8,
         left: 8,
         child: IconButton(
          icon: const Icon(Icons.favorite_border, color: Colors.white),
          onPressed: () {},
          style: IconButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: 0.3)),
         ),
        ),
       ],
      ),
      Padding(
       padding: const EdgeInsets.all(8),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(
          '${MartConstants.electronics} ${index + 1}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
         ),
         const SizedBox(height: 4),
         Row(
          children: [
           const Icon(Icons.star, size: 14, color: Colors.amber),
           const SizedBox(width: 4),
           Text('${4.0 + (index % 10) / 10}', style: const TextStyle(fontSize: 12)),
          ],
         ),
         const SizedBox(height: 4),
         Text(
          '\$${50 + index * 10}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
         ),
        ],
       ),
      ),
     ],
    ),
   ),
  );
 }
 void _showSortOptions(BuildContext context) {
  showModalBottomSheet(
   context: context,
   builder: (context) => Container(
    padding: const EdgeInsets.all(16),
    child: Column(
     mainAxisSize: MainAxisSize.min,
     children: [MartConstants.popular, MartConstants.priceLowHigh, MartConstants.priceHighLow, MartConstants.newest, MartConstants.rating].map((option) {
      return ListTile(
       title: Text(option),
       trailing: sortBy == option ? const Icon(Icons.check, color: AppColors.primary) : null,
       onTap: () {
        setState(() => sortBy = option);
        Navigator.pop(context);
       },
      );
     }).toList(),
    ),
   ),
  );
 }
}