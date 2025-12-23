import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../constants/profileConstants.dart';
class DataUsageScreen extends ConsumerWidget {
 const DataUsageScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ProfileConstants.dataUsageTitle),
   ),
   body: ListView(
    padding: const EdgeInsets.all(16),
    children: [
     Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
      child: const Column(
       children: [
        Text('This Month', style: TextStyle(color: Colors.white70)),
        SizedBox(height: 8),
        Text(
         '2.4 GB',
         style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
        ),
       ],
      ),
     ),
     const SizedBox(height: 24),
     const Text('Usage By Feature', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     _buildUsageItem('Food Delivery', 850, 2400),
     _buildUsageItem('Ride Hailing', 320, 2400),
     _buildUsageItem('Shopping', 680, 2400),
     _buildUsageItem('Wallet', 120, 2400),
     _buildUsageItem('Services', 430, 2400),
    ],
   ),
  );
 }
 Widget _buildUsageItem(String feature, int mb, int total) {
  return Card(
   margin: const EdgeInsets.only(bottom: 12),
   child: Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
     children: [
      Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
        Text(feature, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text('$mb MB'),
       ],
      ),
      const SizedBox(height: 8),
      LinearProgressIndicator(value: mb / total, backgroundColor: Colors.grey[300], valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary), minHeight: 6, borderRadius: BorderRadius.circular(3)),
     ],
    ),
   ),
  );
 }
}