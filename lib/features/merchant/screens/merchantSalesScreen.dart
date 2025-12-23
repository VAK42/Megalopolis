import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/merchantProvider.dart';
import '../../../providers/authProvider.dart';
import '../../merchant/constants/merchantConstants.dart';
class MerchantSalesScreen extends ConsumerWidget {
 const MerchantSalesScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final merchantId = ref.watch(currentUserIdProvider) ?? 'user1';
  final statsAsync = ref.watch(merchantStatsProvider(merchantId));
  final ordersAsync = ref.watch(merchantOrdersProvider(merchantId));
  return Scaffold(
   appBar: AppBar(title: const Text(MerchantConstants.salesTitle)),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
     children: [
      Container(
       padding: const EdgeInsets.all(20),
       decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
       child: statsAsync.when(
        data: (stats) => Column(
         children: [
          const Text(MerchantConstants.totalRevenueLabel, style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Text(
           '\$${(stats['totalRevenue'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
           style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
          ),
         ],
        ),
        loading: () => const CircularProgressIndicator(color: Colors.white),
        error: (e, s) => const Text(MerchantConstants.errorGeneric, style: TextStyle(color: Colors.white)),
       ),
      ),
      const SizedBox(height: 24),
      ordersAsync.when(
       data: (orders) {
        if (orders.isEmpty) return const SizedBox.shrink();
        return ListView.builder(
         shrinkWrap: true,
         physics: const NeverScrollableScrollPhysics(),
         itemCount: orders.length,
         itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
           margin: const EdgeInsets.only(bottom: 12),
           child: ListTile(
            title: Text('${MerchantConstants.orderPrefix}${order['id']}'),
            trailing: Text('\$${(order['total'] as num).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
           ),
          );
         },
        );
       },
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (e, s) => const SizedBox.shrink(),
      ),
     ],
    ),
   ),
  );
 }
}