import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/martProvider.dart';
import '../../../providers/authProvider.dart';
import '../../mart/constants/martConstants.dart';
class MartCartScreen extends ConsumerStatefulWidget {
 const MartCartScreen({super.key});
 @override
 ConsumerState<MartCartScreen> createState() => _MartCartScreenState();
}
class _MartCartScreenState extends ConsumerState<MartCartScreen> {
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final cartAsync = ref.watch(martCartProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.martHome)),
    title: const Text(MartConstants.cartTitle),
   ),
   body: cartAsync.when(
    data: (cartItems) {
     double subtotal = 0;
     for (var item in cartItems) {
      subtotal += ((item['price'] as num) * (item['quantity'] as int));
     }
     final shipping = 9.99;
     final tax = subtotal * 0.08;
     final total = subtotal + shipping + tax;
     return Column(
      children: [
       Expanded(
        child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: cartItems.length, itemBuilder: (context, index) => _buildCartItem(cartItems[index], userId)),
       ),
       Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
         color: Colors.white,
         boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)],
        ),
        child: Column(
         children: [
          _buildPriceRow(MartConstants.subtotalLabel, '\$${subtotal.toStringAsFixed(2)}'),
          _buildPriceRow(MartConstants.shippingLabel, '\$${shipping.toStringAsFixed(2)}'),
          _buildPriceRow(MartConstants.taxLabel, '\$${tax.toStringAsFixed(2)}'),
          const Divider(height: 24),
          _buildPriceRow(MartConstants.totalLabel, '\$${total.toStringAsFixed(2)}', isTotal: true),
          const SizedBox(height: 16),
          AppButton(text: MartConstants.proceedToCheckoutButton, onPressed: () => context.go(Routes.martCheckout), icon: Icons.arrow_forward),
         ],
        ),
       ),
      ],
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, stack) => Center(child: Text('${MartConstants.errorGeneric}: $e')),
   ),
  );
 }
 Widget _buildCartItem(Map<String, dynamic> item, String userId) {
  final imagesStr = item['images'] as String?;
  String? imageUrl;
  if (imagesStr != null && imagesStr.isNotEmpty) {
   try {
    final List<dynamic> list = jsonDecode(imagesStr);
    if (list.isNotEmpty) imageUrl = list.first as String;
   } catch (_) {}
  }
  return Card(
   margin: const EdgeInsets.only(bottom: 12),
   child: Padding(
    padding: const EdgeInsets.all(12),
    child: Row(
     children: [
      Container(
       width: 80,
       height: 80,
       decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        image: imageUrl != null ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover) : null,
       ),
       child: imageUrl == null ? Icon(Icons.image, size: 40, color: Colors.grey[400]) : null,
      ),
      const SizedBox(width: 12),
      Expanded(
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(item['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
         const SizedBox(height: 4),
         Text(
          '\$${item['price']}',
          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
         ),
         const SizedBox(height: 8),
         Row(
          children: [
           Container(
            decoration: BoxDecoration(
             border: Border.all(color: Colors.grey[300]!),
             borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
             children: [
              IconButton(
               icon: const Icon(Icons.remove, size: 16),
               onPressed: () {
                final qty = item['quantity'] as int;
                if (qty > 1) {
                 ref.read(martCartProvider(userId).notifier).updateQuantity(item['id'] as int, qty - 1);
                }
               },
              ),
              Text('${item['quantity']}', style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
               icon: const Icon(Icons.add, size: 16),
               onPressed: () {
                final qty = item['quantity'] as int;
                ref.read(martCartProvider(userId).notifier).updateQuantity(item['id'] as int, qty + 1);
               },
              ),
             ],
            ),
           ),
           const Spacer(),
           IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () => ref.read(martCartProvider(userId).notifier).removeItem(item['id'] as int),
           ),
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
 Widget _buildPriceRow(String label, String amount, {bool isTotal = false}) {
  return Padding(
   padding: const EdgeInsets.symmetric(vertical: 4),
   child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
     Text(
      label,
      style: TextStyle(fontSize: isTotal ? 18 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
     ),
     Text(
      amount,
      style: TextStyle(fontSize: isTotal ? 18 : 14, fontWeight: FontWeight.bold, color: isTotal ? AppColors.primary : null),
     ),
    ],
   ),
  );
 }
}