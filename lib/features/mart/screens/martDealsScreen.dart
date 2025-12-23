import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../constants/martConstants.dart';
class MartDealsScreen extends ConsumerWidget {
 const MartDealsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(MartConstants.dailyDealsTitle),
   ),
   body: DefaultTabController(
    length: 3,
    child: Column(
     children: [
      TabBar(
       tabs: [
        Tab(text: MartConstants.limitedTime),
        Tab(text: MartConstants.bestDeals),
        Tab(text: MartConstants.off),
       ],
      ),
      Expanded(child: TabBarView(children: [_buildDealsList('limited'), _buildDealsList('bestsellers'), _buildDealsList('clearance')])),
     ],
    ),
   ),
  );
 }
 Widget _buildDealsList(String type) {
  return ListView.builder(
   padding: const EdgeInsets.all(16),
   itemCount: 10,
   itemBuilder: (context, index) {
    return Card(
     margin: const EdgeInsets.only(bottom: 12),
     child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
       children: [
        Container(
         width: 80,
         height: 80,
         decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
         child: Icon(Icons.shopping_bag, size: 40, color: Colors.grey[400]),
        ),
        const SizedBox(width: 12),
        Expanded(
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Text('${MartConstants.productsTitle} ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
           const SizedBox(height: 4),
           Row(
            children: [
             Text(
              '\$${99 + index}',
              style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey),
             ),
             const SizedBox(width: 8),
             Text(
              '\$${79 + index}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
             ),
            ],
           ),
           const SizedBox(height: 4),
           Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(4)),
            child: Text('20% ${MartConstants.off}', style: const TextStyle(color: Colors.white, fontSize: 10)),
           ),
          ],
         ),
        ),
        ElevatedButton(
         onPressed: () {},
         child: Text(MartConstants.buyNow, style: const TextStyle(fontSize: 12)),
        ),
       ],
      ),
     ),
    );
   },
  );
 }
}