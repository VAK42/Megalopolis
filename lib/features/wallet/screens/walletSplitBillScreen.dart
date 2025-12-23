import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/socialProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/walletConstants.dart';
class WalletSplitBillScreen extends ConsumerStatefulWidget {
 const WalletSplitBillScreen({super.key});
 @override
 ConsumerState<WalletSplitBillScreen> createState() => _WalletSplitBillScreenState();
}
class _WalletSplitBillScreenState extends ConsumerState<WalletSplitBillScreen> {
 final TextEditingController amountController = TextEditingController();
 int splitWith = 2;
 @override
 Widget build(BuildContext context) {
  final totalAmount = double.tryParse(amountController.text) ?? 0;
  final perPerson = totalAmount / (splitWith + 1);
  final userId = ref.watch(currentUserIdProvider) ?? WalletConstants.defaultUserId;
  final friendsAsync = ref.watch(friendsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(WalletConstants.splitBill),
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      const Text(WalletConstants.totalAmount, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      TextField(
       controller: amountController,
       keyboardType: TextInputType.number,
       style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
       decoration: InputDecoration(
        prefixIcon: const Padding(
         padding: EdgeInsets.only(top: 12, left: 12),
         child: Text(WalletConstants.currencySymbol, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        ),
        hintText: WalletConstants.amountHint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
       ),
       onChanged: (value) => setState(() {}),
      ),
      const SizedBox(height: 24),
      const Text(WalletConstants.splitWith, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Container(
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
       ),
       child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         friendsAsync.when(
          data: (friends) => Text('${friends.length} ${WalletConstants.numberOfPeople}', style: const TextStyle(fontSize: 16)),
          loading: () => const Text(WalletConstants.loading),
          error: (_, __) => const Text(WalletConstants.splitWith, style: TextStyle(fontSize: 16)),
         ),
         Row(
          children: [
           IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => setState(() => splitWith = splitWith > 1 ? splitWith - 1 : 1)),
           Text('$splitWith', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
           IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => setState(() => splitWith++)),
          ],
         ),
        ],
       ),
      ),
      const SizedBox(height: 32),
      Container(
       padding: const EdgeInsets.all(20),
       decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
       child: Column(
        children: [
         const Text(WalletConstants.eachPersonPays, style: TextStyle(color: Colors.white70)),
         const SizedBox(height: 8),
         Text(
          '${WalletConstants.currencySymbol}${perPerson.toStringAsFixed(2)}',
          style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
         ),
        ],
       ),
      ),
      const SizedBox(height: 32),
      AppButton(text: '${WalletConstants.sendRequest} ${splitWith + 1}', onPressed: () => context.pop(), icon: Icons.send),
     ],
    ),
   ),
  );
 }
}