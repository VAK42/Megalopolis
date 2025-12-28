import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/walletProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/walletConstants.dart';
class WalletAddCardScreen extends ConsumerStatefulWidget {
 const WalletAddCardScreen({super.key});
 @override
 ConsumerState<WalletAddCardScreen> createState() => _WalletAddCardScreenState();
}
class _WalletAddCardScreenState extends ConsumerState<WalletAddCardScreen> {
 final cardNumberController = TextEditingController();
 final holderNameController = TextEditingController();
 final expiryController = TextEditingController();
 final cvvController = TextEditingController();
 String selectedCardType = WalletConstants.visaCardType;
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(WalletConstants.addCard),
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Container(
       padding: const EdgeInsets.all(20),
       decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           Text(selectedCardType.toUpperCase(), style: const TextStyle(color: Colors.white70)),
           const Icon(Icons.credit_card, color: Colors.white),
          ],
         ),
         const SizedBox(height: 24),
         Text(cardNumberController.text.isEmpty ? WalletConstants.cardNumber : cardNumberController.text, style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 2)),
         const SizedBox(height: 16),
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             const Text(WalletConstants.cardHolderName, style: TextStyle(color: Colors.white70, fontSize: 10)),
             Text(holderNameController.text.isEmpty ? WalletConstants.unknown : holderNameController.text, style: const TextStyle(color: Colors.white)),
            ],
           ),
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             const Text(WalletConstants.expiryDate, style: TextStyle(color: Colors.white70, fontSize: 10)),
             Text(expiryController.text.isEmpty ? WalletConstants.unknown : expiryController.text, style: const TextStyle(color: Colors.white)),
            ],
           ),
          ],
         ),
        ],
       ),
      ),
      const SizedBox(height: 24),
      const Text(WalletConstants.cardDetails, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 16),
      DropdownButtonFormField<String>(
       initialValue: selectedCardType,
       decoration: InputDecoration(
        labelText: WalletConstants.cardType,
        prefixIcon: const Icon(Icons.credit_card),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
       ),
       items: [
        DropdownMenuItem(value: WalletConstants.visaCardType, child: Text(WalletConstants.visaCardType)),
        DropdownMenuItem(value: WalletConstants.masterCardType, child: Text(WalletConstants.masterCardType)),
       ],
       onChanged: (value) => setState(() => selectedCardType = value ?? WalletConstants.visaCardType),
      ),
      const SizedBox(height: 16),
      TextField(
       controller: cardNumberController,
       keyboardType: TextInputType.number,
       decoration: InputDecoration(
        labelText: WalletConstants.cardNumber,
        prefixIcon: const Icon(Icons.numbers),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
       ),
       onChanged: (value) => setState(() {}),
      ),
      const SizedBox(height: 16),
      TextField(
       controller: holderNameController,
       decoration: InputDecoration(
        labelText: WalletConstants.cardHolderName,
        prefixIcon: const Icon(Icons.person),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
       ),
       onChanged: (value) => setState(() {}),
      ),
      const SizedBox(height: 16),
      Row(
       children: [
        Expanded(
         child: TextField(
          controller: expiryController,
          decoration: InputDecoration(
           labelText: WalletConstants.expiryDate,
           prefixIcon: const Icon(Icons.calendar_today),
           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (value) => setState(() {}),
         ),
        ),
        const SizedBox(width: 16),
        Expanded(
         child: TextField(
          controller: cvvController,
          obscureText: true,
          decoration: InputDecoration(
           labelText: WalletConstants.cvv,
           prefixIcon: const Icon(Icons.lock),
           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
         ),
        ),
       ],
      ),
      const SizedBox(height: 32),
      AppButton(
       text: WalletConstants.saveCard,
       onPressed: () {
        if (cardNumberController.text.isEmpty || holderNameController.text.isEmpty || expiryController.text.isEmpty || cvvController.text.isEmpty) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(WalletConstants.msgFillAllFields)));
         return;
        }
        final userId = ref.read(currentUserIdProvider) ?? WalletConstants.defaultUserId;
        final newCard = {
         'id': 'card${DateTime.now().millisecondsSinceEpoch}',
         'userId': userId,
         'type': selectedCardType,
         'number': cardNumberController.text,
         'holder': holderNameController.text,
         'expiry': expiryController.text,
         'cvv': cvvController.text,
         'balance': 0.0,
        };
        ref.read(walletCardsProvider(userId).notifier).addCard(newCard);
        context.pop();
       },
       icon: Icons.save,
      ),
     ],
    ),
   ),
  );
 }
}