import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../shared/widgets/appTextField.dart';
import '../../ride/constants/rideConstants.dart';
class RideAddPaymentScreen extends ConsumerStatefulWidget {
 const RideAddPaymentScreen({super.key});
 @override
 ConsumerState<RideAddPaymentScreen> createState() => _RideAddPaymentScreenState();
}
class _RideAddPaymentScreenState extends ConsumerState<RideAddPaymentScreen> {
 final cardNumberController = TextEditingController();
 final expiryController = TextEditingController();
 final cvvController = TextEditingController();
 final nameController = TextEditingController();
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(RideConstants.addPaymentMethodTitle),
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Container(
       padding: const EdgeInsets.all(20),
       decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           Icon(Icons.credit_card, color: Colors.white, size: 32),
           Icon(Icons.contactless, color: Colors.white),
          ],
         ),
         const SizedBox(height: 32),
         Text(cardNumberController.text.isEmpty ? '**** **** **** ****' : cardNumberController.text, style: const TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 2)),
         const SizedBox(height: 16),
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             const Text('CARD HOLDER', style: TextStyle(color: Colors.white70, fontSize: 10)),
             Text(nameController.text.isEmpty ? 'YOUR NAME' : nameController.text.toUpperCase(), style: const TextStyle(color: Colors.white)),
            ],
           ),
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             const Text('EXPIRES', style: TextStyle(color: Colors.white70, fontSize: 10)),
             Text(expiryController.text.isEmpty ? 'MM/YY' : expiryController.text, style: const TextStyle(color: Colors.white)),
            ],
           ),
          ],
         ),
        ],
       ),
      ),
      const SizedBox(height: 32),
      AppTextField(controller: cardNumberController, hint: 'Card Number', keyboardType: TextInputType.number, onChanged: (_) => setState(() {})),
      const SizedBox(height: 16),
      Row(
       children: [
        Expanded(
         child: AppTextField(controller: expiryController, hint: 'MM/YY', onChanged: (_) => setState(() {})),
        ),
        const SizedBox(width: 16),
        Expanded(
         child: AppTextField(controller: cvvController, hint: 'CVV', keyboardType: TextInputType.number),
        ),
       ],
      ),
      const SizedBox(height: 16),
      AppTextField(controller: nameController, hint: 'Card Holder Name', onChanged: (_) => setState(() {})),
      const SizedBox(height: 32),
      AppButton(text: RideConstants.saveCardButton, onPressed: () => context.pop(), icon: Icons.check),
     ],
    ),
   ),
  );
 }
}