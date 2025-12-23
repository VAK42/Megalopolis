import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/martProvider.dart';
import '../../../providers/authProvider.dart';
import '../../mart/constants/martConstants.dart';
class MartCheckoutScreen extends ConsumerStatefulWidget {
 const MartCheckoutScreen({super.key});
 @override
 ConsumerState<MartCheckoutScreen> createState() => _MartCheckoutScreenState();
}
class _MartCheckoutScreenState extends ConsumerState<MartCheckoutScreen> {
 final _formKey = GlobalKey<FormState>();
 final _addressController = TextEditingController();
 String _selectedPayment = MartConstants.creditCard;
 @override
 void dispose() {
  _addressController.dispose();
  super.dispose();
 }
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final cartAsync = ref.watch(martCartProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(MartConstants.checkoutTitle),
   ),
   body: cartAsync.when(
    data: (cartItems) {
     if (cartItems.isEmpty) return const SizedBox();
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
        child: SingleChildScrollView(
         padding: const EdgeInsets.all(16),
         child: Form(
          key: _formKey,
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            const Text(MartConstants.shippingAddress, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextFormField(
             controller: _addressController,
             decoration: InputDecoration(
              hintText: MartConstants.enterAddress,
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
             ),
             validator: (v) => v?.isEmpty == true ? MartConstants.addressRequired : null,
            ),
            const SizedBox(height: 24),
            const Text(MartConstants.paymentMethod, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
             padding: const EdgeInsets.all(4),
             decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
             ),
             child: RadioGroup<String>(
              groupValue: _selectedPayment,
              onChanged: (v) {
               if (v != null) setState(() => _selectedPayment = v);
              },
              child: Column(
               children: MartConstants.paymentMethods.map((method) {
                return RadioListTile<String>(value: method, title: Text(method), activeColor: AppColors.primary);
               }).toList(),
              ),
             ),
            ),
            const SizedBox(height: 24),
            const Text(MartConstants.orderSummary, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
             padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
             child: Column(children: [_buildSummaryRow(MartConstants.subtotalLabel, subtotal), _buildSummaryRow(MartConstants.shippingLabel, shipping), _buildSummaryRow(MartConstants.taxLabel, tax), const Divider(height: 24), _buildSummaryRow(MartConstants.totalLabel, total, isTotal: true)]),
            ),
           ],
          ),
         ),
        ),
       ),
       Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
         color: Colors.white,
         boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)],
        ),
        child: AppButton(
         text: MartConstants.placeOrder,
         onPressed: () async {
          if (_formKey.currentState?.validate() == true) {
           final order = {'userId': userId, 'total': total, 'status': MartConstants.processing, 'orderType': 'mart', 'address': _addressController.text, 'paymentMethod': _selectedPayment, 'createdAt': DateTime.now().millisecondsSinceEpoch};
           await ref.read(martRepositoryProvider).placeOrder(order);
           await ref.read(martRepositoryProvider).clearCart(userId);
           if (context.mounted) context.go(Routes.martOrderPlaced);
          }
         },
        ),
       ),
      ],
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, s) => Center(child: Text('${MartConstants.errorPrefix}$e')),
   ),
  );
 }
 Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
  return Padding(
   padding: const EdgeInsets.symmetric(vertical: 4),
   child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
     Text(
      label,
      style: TextStyle(fontSize: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
     ),
     Text(
      '\$${amount.toStringAsFixed(2)}',
      style: TextStyle(fontSize: isTotal ? 16 : 14, fontWeight: FontWeight.bold, color: isTotal ? AppColors.primary : null),
     ),
    ],
   ),
  );
 }
}