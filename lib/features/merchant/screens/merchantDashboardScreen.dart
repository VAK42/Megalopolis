import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/merchantProvider.dart';
import '../../../providers/authProvider.dart';
import '../../merchant/constants/merchantConstants.dart';
class MerchantDashboardScreen extends ConsumerWidget {
 const MerchantDashboardScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final merchantId = ref.watch(currentUserIdProvider) ?? 'user1';
  final statsAsync = ref.watch(merchantStatsProvider(merchantId));
  return Scaffold(
   appBar: AppBar(title: const Text(MerchantConstants.dashboardTitle)),
   body: statsAsync.when(
    data: (stats) {
     return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
       children: [
        GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, children: [_buildStat(MerchantConstants.salesTitle, '\$${(stats['totalRevenue'] as num?)?.toStringAsFixed(2) ?? '0.00'}', Icons.attach_money, Colors.green), _buildStat(MerchantConstants.ordersTitle, '${stats['totalOrders'] ?? 0}', Icons.shopping_bag, Colors.orange), _buildStat(MerchantConstants.productsTitle, '${stats['totalProducts'] ?? 0}', Icons.inventory, Colors.blue), _buildStat(MerchantConstants.reviewsTitle, '${stats['averageRating'] ?? 0.0}', Icons.star, Colors.amber)]),
       ],
      ),
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, s) => Center(child: Text('${MerchantConstants.errorGeneric}: $e')),
   ),
  );
 }
 Widget _buildStat(String title, String value, IconData icon, Color color) => Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
  child: Column(
   mainAxisAlignment: MainAxisAlignment.center,
   children: [
    Icon(icon, size: 32, color: color),
    const SizedBox(height: 8),
    Text(
     value,
     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
    ),
    Text(title),
   ],
  ),
 );
}