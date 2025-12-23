import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../constants/martConstants.dart';
import 'dart:async';
class MartFlashSaleScreen extends ConsumerStatefulWidget {
 const MartFlashSaleScreen({super.key});
 @override
 ConsumerState<MartFlashSaleScreen> createState() => _MartFlashSaleScreenState();
}
class _MartFlashSaleScreenState extends ConsumerState<MartFlashSaleScreen> {
 int remainingSeconds = 7230;
 late Timer timer;
 @override
 void initState() {
  super.initState();
  timer = Timer.periodic(const Duration(seconds: 1), (timer) {
   if (remainingSeconds > 0) {
    setState(() => remainingSeconds--);
   }
  });
 }
 @override
 Widget build(BuildContext context) {
  final hours = remainingSeconds ~/ 3600;
  final minutes = (remainingSeconds % 3600) ~/ 60;
  final seconds = remainingSeconds % 60;
  return Scaffold(
   body: SafeArea(
    child: CustomScrollView(
     slivers: [
      SliverAppBar(
       leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.martHome)),
       title: const Text(MartConstants.flashSaleTitle),
       floating: true,
      ),
      SliverToBoxAdapter(
       child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(gradient: AppColors.errorGradient, borderRadius: BorderRadius.circular(16)),
        child: Column(
         children: [
          Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
            const Icon(Icons.flash_on, color: Colors.white, size: 28),
            const SizedBox(width: 8),
            const Text(
             MartConstants.flashSaleEndsIn,
             style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
           ],
          ),
          const SizedBox(height: 16),
          Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
            _buildTimeBox(hours.toString().padLeft(2, '0')),
            const Padding(
             padding: EdgeInsets.symmetric(horizontal: 8),
             child: Text(
              ':',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
             ),
            ),
            _buildTimeBox(minutes.toString().padLeft(2, '0')),
            const Padding(
             padding: EdgeInsets.symmetric(horizontal: 8),
             child: Text(
              ':',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
             ),
            ),
            _buildTimeBox(seconds.toString().padLeft(2, '0')),
           ],
          ),
         ],
        ),
       ),
      ),
      SliverPadding(
       padding: const EdgeInsets.all(16),
       sliver: SliverGrid(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.65), delegate: SliverChildBuilderDelegate((context, index) => _buildFlashSaleProduct(context, index), childCount: 12)),
      ),
     ],
    ),
   ),
  );
 }
 Widget _buildTimeBox(String value) {
  return Container(
   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
   decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
   child: Text(
    value,
    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
   ),
  );
 }
 Widget _buildFlashSaleProduct(BuildContext context, int index) {
  final sold = 45 + index * 8;
  final total = 100;
  final progress = sold / total;
  return GestureDetector(
   onTap: () => context.go(Routes.martProductDetail),
   child: Card(
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Stack(
       children: [
        Container(
         height: 120,
         decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
         ),
         child: Center(child: Icon(Icons.image, size: 40, color: Colors.grey[400])),
        ),
        Positioned(
         top: 8,
         right: 8,
         child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(12)),
          child: Text(
           '-${50 + index * 5}%',
           style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
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
          '${MartConstants.productsTitle} ${index + 1}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
         ),
         const SizedBox(height: 4),
         Row(
          children: [
           Text(
            '\$${10 + index * 3}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.error),
           ),
           const SizedBox(width: 6),
           Text(
            '\$${30 + index * 8}',
            style: TextStyle(fontSize: 11, color: Colors.grey[600], decoration: TextDecoration.lineThrough),
           ),
          ],
         ),
         const SizedBox(height: 8),
         Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[200], valueColor: const AlwaysStoppedAnimation<Color>(AppColors.error)),
           const SizedBox(height: 4),
           Text('$sold/$total Sold', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
          ],
         ),
        ],
       ),
      ),
     ],
    ),
   ),
  );
 }
 @override
 void dispose() {
  timer.cancel();
  super.dispose();
 }
}