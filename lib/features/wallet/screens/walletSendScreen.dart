import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/socialProvider.dart';
import '../constants/walletConstants.dart';
class WalletSendScreen extends ConsumerStatefulWidget {
 const WalletSendScreen({super.key});
 @override
 ConsumerState<WalletSendScreen> createState() => _WalletSendScreenState();
}
class _WalletSendScreenState extends ConsumerState<WalletSendScreen> {
 final TextEditingController amountController = TextEditingController();
 String? selectedContact;
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider) ?? WalletConstants.defaultUserId;
  final friendsAsync = ref.watch(friendsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(WalletConstants.sendMoney),
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      const Text(WalletConstants.sendTo, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
        Expanded(child: _buildQuickAmount(WalletConstants.quickAmount10)),
        const SizedBox(width: 8),
        Expanded(child: _buildQuickAmount(WalletConstants.quickAmount50)),
        const SizedBox(width: 8),
        Expanded(child: _buildQuickAmount(WalletConstants.quickAmount100)),
        const SizedBox(width: 8),
        Expanded(child: _buildQuickAmount(WalletConstants.quickAmount500)),
       ],
      ),
      const SizedBox(height: 32),
      AppButton(
       text: WalletConstants.continueText,
       onPressed: () {
        if (selectedContact == null || amountController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(WalletConstants.msgSelectContactAndAmount)));
          return;
        }
        final friend = friendsAsync.value?.firstWhere((f) => f['name'] == selectedContact, orElse: () => {});
        final email = friend?['email'] ?? WalletConstants.defaultEmail;
        final recipientId = friend?['id']?.toString() ?? WalletConstants.unknown;
        final avatar = friend?['avatar']?.toString() ?? '';
        final amount = double.tryParse(amountController.text) ?? 0.0;
        context.go(Routes.walletSendConfirm, extra: {
          'name': selectedContact,
          'email': email,
          'amount': amount,
          'recipientId': recipientId,
          'avatar': avatar,
        });
       },
       icon: Icons.arrow_forward,
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