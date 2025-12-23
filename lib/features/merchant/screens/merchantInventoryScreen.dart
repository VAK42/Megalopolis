import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/merchantProvider.dart';
import '../../../providers/authProvider.dart';
import '../../merchant/constants/merchantConstants.dart';
class MerchantInventoryScreen extends ConsumerWidget {
 const MerchantInventoryScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final merchantId = ref.watch(currentUserIdProvider) ?? 'user1';
  final productsAsync = ref.watch(merchantProductsProvider(merchantId));
  return Scaffold(
   appBar: AppBar(title: const Text(MerchantConstants.inventoryTitle)),
   body: productsAsync.when(
    data: (products) {
     if (products.isEmpty) {
      return const Center(child: Text(MerchantConstants.noProductsFound));
     }
     return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (c, i) {
       final product = products[i];
       final stock = product['stock'] as int? ?? 0;
       final int maxStock = 100;
       return Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
         title: Text(product['name'] as String),
         subtitle: LinearProgressIndicator(value: (stock / maxStock).clamp(0.0, 1.0), backgroundColor: Colors.grey[300], valueColor: AlwaysStoppedAnimation<Color>(stock < 10 ? AppColors.error : AppColors.primary)),
         trailing: Text('$stock', style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
       );
      },
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, s) => Center(child: Text('${MerchantConstants.errorGeneric}: $e')),
   ),
  );
 }
}