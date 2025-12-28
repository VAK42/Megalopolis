import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/socialProvider.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/walletProvider.dart';
import '../constants/walletConstants.dart';
class WalletRequestScreen extends ConsumerStatefulWidget {
 const WalletRequestScreen({super.key});
 @override
 ConsumerState<WalletRequestScreen> createState() => _WalletRequestScreenState();
}
class _WalletRequestScreenState extends ConsumerState<WalletRequestScreen> {
 final TextEditingController amountController = TextEditingController();
 final TextEditingController reasonController = TextEditingController();
 String? selectedContact;
 bool isLoading = false;
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider) ?? WalletConstants.defaultUserId;
  final friendsAsync = ref.watch(friendsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(WalletConstants.requestMoney),
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      const Text(WalletConstants.requestFrom, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      friendsAsync.when(
       data: (friends) => Container(
        height: 100,
        child: ListView.builder(
         scrollDirection: Axis.horizontal,
         itemCount: friends.length,
         itemBuilder: (context, index) {
          final friend = friends[index];
          final name = friend['name']?.toString() ?? WalletConstants.unknown;
          final avatar = friend['avatar']?.toString();
          final isSelected = selectedContact == name;
          return GestureDetector(
           onTap: () => setState(() => selectedContact = name),
           child: Container(
            margin: const EdgeInsets.only(right: 12),
            child: Column(
             children: [
              Container(
               width: 60,
               height: 60,
               decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
                gradient: avatar == null ? AppColors.primaryGradient : null,
                image: avatar != null ? DecorationImage(image: NetworkImage(avatar), fit: BoxFit.cover) : null,
               ),
               child: avatar == null ? const Icon(Icons.person, color: Colors.white) : null,
              ),
              const SizedBox(height: 4),
              Text(name, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
             ],
            ),
           ),
          );
         },
        ),
       ),
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (_, __) => const Text(WalletConstants.errorLoadingContacts),
      ),
      const SizedBox(height: 24),
      const Text(WalletConstants.amount, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
      ),
      const SizedBox(height: 16),
      Row(
       children: [
        Expanded(child: _buildQuickAmount(WalletConstants.quickAmount20)),
        const SizedBox(width: 8),
        Expanded(child: _buildQuickAmount(WalletConstants.quickAmount50)),
        const SizedBox(width: 8),
        Expanded(child: _buildQuickAmount(WalletConstants.quickAmount100)),
        const SizedBox(width: 8),
        Expanded(child: _buildQuickAmount(WalletConstants.quickAmount200)),
       ],
      ),
      const SizedBox(height: 16),
      TextField(
       controller: reasonController,
       decoration: InputDecoration(
        labelText: WalletConstants.reasonOptional,
        hintText: WalletConstants.enterReasonForRequest,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
       ),
      ),
      const SizedBox(height: 32),
      AppButton(
       text: isLoading ? WalletConstants.loading : WalletConstants.sendRequest,
       onPressed: isLoading ? null : () async {
        if (selectedContact == null || amountController.text.isEmpty) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(WalletConstants.msgSelectContactAndAmount)));
         return;
        }
        final amount = double.tryParse(amountController.text) ?? 0.0;
        if (amount <= 0) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(WalletConstants.msgEnterValidAmount)));
         return;
        }
        setState(() => isLoading = true);
        try {
         final repository = ref.read(walletRepositoryProvider);
         await repository.createMoneyRequest({
          'userId': userId,
          'amount': amount,
          'reason': reasonController.text.isNotEmpty ? reasonController.text : WalletConstants.moneyRequest,
          'fromContact': selectedContact,
         });
         setState(() => isLoading = false);
         if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${WalletConstants.requestSentTo} $selectedContact: ${WalletConstants.currencySymbol}${amount.toStringAsFixed(2)}')));
          context.pop();
         }
        } catch (e) {
         setState(() => isLoading = false);
         if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(WalletConstants.failedToSendRequest)));
         }
        }
       },
       icon: Icons.send,
      ),
     ],
    ),
   ),
  );
 }
 Widget _buildQuickAmount(String amount) {
  return OutlinedButton(onPressed: () => setState(() => amountController.text = amount.substring(1)), child: Text(amount));
 }
}