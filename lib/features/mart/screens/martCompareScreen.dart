import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../constants/martConstants.dart';
class MartCompareScreen extends ConsumerWidget {
 const MartCompareScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(MartConstants.compareProductsTitle),
   ),
   body: SingleChildScrollView(
    child: Column(
     children: [
      Padding(
       padding: const EdgeInsets.all(16),
       child: Row(
        children: [
         Expanded(child: _buildProductHeader(MartConstants.productA, '\$299')),
         const SizedBox(width: 16),
         Expanded(child: _buildProductHeader(MartConstants.productB, '\$349')),
        ],
       ),
      ),
      _buildCompareRow(MartConstants.brand, 'Brand X', 'Brand Y'),
      _buildCompareRow(MartConstants.display, '6.5"', '6.7"'),
      _buildCompareRow(MartConstants.storage, '128GB', '256GB'),
      _buildCompareRow(MartConstants.battery, '4000mAh', '4500mAh'),
      _buildCompareRow(MartConstants.camera, '48MP', '64MP'),
      _buildCompareRow(MartConstants.rating, '4.5', '4.7'),
      _buildCompareRow(MartConstants.warranty, '1 Year', '2 Years'),
      Padding(
       padding: const EdgeInsets.all(16),
       child: Row(
        children: [
         Expanded(
          child: ElevatedButton(onPressed: () {}, child: const Text(MartConstants.buyNow)),
         ),
         const SizedBox(width: 16),
         Expanded(
          child: ElevatedButton(onPressed: () {}, child: const Text(MartConstants.buyNow)),
         ),
        ],
       ),
      ),
     ],
    ),
   ),
  );
 }
 Widget _buildProductHeader(String name, String price) {
  return Container(
   padding: const EdgeInsets.all(16),
   decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(12)),
   child: Column(
    children: [
     Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Icon(Icons.phone_android, size: 40, color: Colors.grey[400]),
     ),
     const SizedBox(height: 12),
     Text(
      name,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
     ),
     Text(price, style: const TextStyle(color: Colors.white, fontSize: 20)),
    ],
   ),
  );
 }
 Widget _buildCompareRow(String feature, String value1, String value2) {
  return Container(
   decoration: BoxDecoration(
    border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
   ),
   child: Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
     children: [
      Expanded(
       child: Text(feature, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      Expanded(child: Text(value1, textAlign: TextAlign.center)),
      Expanded(child: Text(value2, textAlign: TextAlign.center)),
     ],
    ),
   ),
  );
 }
}