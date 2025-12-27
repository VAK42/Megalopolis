import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/merchantProvider.dart';
import '../../../providers/authProvider.dart';
import '../../merchant/constants/merchantConstants.dart';
class MerchantProductsScreen extends ConsumerWidget {
 const MerchantProductsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final merchantId = ref.watch(currentUserIdProvider) ?? 'user1';
  final productsAsync = ref.watch(merchantProductsProvider(merchantId));
  return Scaffold(
   appBar: AppBar(title: const Text(MerchantConstants.productsTitle)),
   body: productsAsync.when(
    data: (products) {
     if (products.isEmpty) {
      return const Center(child: Text(MerchantConstants.noProductsFound));
     }
     return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
       final product = products[index];
       return Dismissible(
        key: Key(product['id'].toString()),
        direction: DismissDirection.endToStart,
        background: Container(
         alignment: Alignment.centerRight,
         padding: const EdgeInsets.only(right: 20),
         color: AppColors.error,
         child: const Icon(Icons.delete, color: Colors.white),
        ),
        confirmDismiss: (direction) async {
         return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
           title: const Text(MerchantConstants.deleteProductButton),
           content: Text('${product['name']}?'),
           actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text(MerchantConstants.cancel)),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text(MerchantConstants.deleteProductButton)),
           ],
          ),
         );
        },
        onDismissed: (direction) {
         ref.read(merchantRepositoryProvider).deleteProduct(product['id'].toString());
         ref.invalidate(merchantProductsProvider(merchantId));
        },
        child: Card(
         margin: const EdgeInsets.only(bottom: 12),
         child: ListTile(
          leading: Container(
           width: 50,
           height: 50,
           decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
           child: const Icon(Icons.image, color: Colors.grey),
          ),
          title: Text(product['name'] as String),
          subtitle: Text('\$${(product['price'] as num).toStringAsFixed(2)}'),
          trailing: Row(
           mainAxisSize: MainAxisSize.min,
           children: [
            IconButton(
             icon: const Icon(Icons.edit, color: AppColors.primary),
             onPressed: () {},
            ),
            IconButton(
             icon: const Icon(Icons.delete, color: AppColors.error),
             onPressed: () async {
              final confirm = await showDialog<bool>(
               context: context,
               builder: (ctx) => AlertDialog(
                title: const Text(MerchantConstants.deleteProductButton),
                content: Text('${product['name']}?'),
                actions: [
                 TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text(MerchantConstants.cancel)),
                 TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text(MerchantConstants.deleteProductButton)),
                ],
               ),
              );
              if (confirm == true) {
               await ref.read(merchantRepositoryProvider).deleteProduct(product['id'].toString());
               ref.invalidate(merchantProductsProvider(merchantId));
              }
             },
            ),
           ],
          ),
         ),
        ),
       );
      },
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, s) => Center(child: Text('${MerchantConstants.errorGeneric}: $e')),
   ),
   floatingActionButton: FloatingActionButton(onPressed: () {}, backgroundColor: AppColors.primary, child: const Icon(Icons.add)),
  );
 }
}