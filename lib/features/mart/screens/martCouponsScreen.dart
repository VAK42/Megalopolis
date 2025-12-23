import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../constants/martConstants.dart';
class MartCouponsScreen extends ConsumerWidget {
 const MartCouponsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(MartConstants.couponsTitle),
   ),
   body: DefaultTabController(
    length: 2,
    child: Column(
     children: [
      TabBar(
       tabs: [
        Tab(text: MartConstants.available),
        Tab(text: MartConstants.used),
       ],
      ),
      Expanded(child: TabBarView(children: [_buildCouponList(true), _buildCouponList(false)])),
     ],
    ),
   ),
  );
 }
 Widget _buildCouponList(bool available) {
  return ListView.builder(padding: const EdgeInsets.all(16), itemCount: available ? 5 : 8, itemBuilder: (context, index) => _buildCouponCard(index, available));
 }
 Widget _buildCouponCard(int index, bool available) {
  final discounts = ['20% OFF', '15% OFF', '\$10 OFF', 'BUY 1 GET 1'];
  final descriptions = ['${MartConstants.onElectronics} \$50', MartConstants.onElectronics, '${MartConstants.onElectronics} \$100', MartConstants.onSelectedItems];
  final codes = ['SAVE20', 'ELEC15', 'TEN', 'BOGO'];
  return Container(
   margin: const EdgeInsets.only(bottom: 16),
   decoration: BoxDecoration(
    gradient: available ? AppColors.primaryGradient : null,
    color: available ? null : Colors.grey[200],
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: available ? Colors.transparent : Colors.grey[300]!),
   ),
   child: Stack(
    children: [
     Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
       children: [
        Expanded(
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Text(
            discounts[index % discounts.length],
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: available ? Colors.white : Colors.grey),
           ),
           const SizedBox(height: 4),
           Text(descriptions[index % descriptions.length], style: TextStyle(color: available ? Colors.white70 : Colors.grey[600])),
           const SizedBox(height: 8),
           Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: available ? Colors.white.withValues(alpha: 0.2) : Colors.grey[300], borderRadius: BorderRadius.circular(20)),
            child: Text(
             codes[index % codes.length],
             style: TextStyle(fontWeight: FontWeight.bold, color: available ? Colors.white : Colors.grey),
            ),
           ),
          ],
         ),
        ),
        if (available)
         ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary),
          child: const Text(MartConstants.useButton),
         )
        else
         Icon(Icons.check_circle, color: Colors.grey[400], size: 40),
       ],
      ),
     ),
     if (!available)
      Positioned(
       top: 16,
       right: 16,
       child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(12)),
        child: Text(MartConstants.used, style: const TextStyle(color: Colors.white, fontSize: 10)),
       ),
      ),
    ],
   ),
  );
 }
}