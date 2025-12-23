import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/socialProvider.dart';
import '../constants/socialConstants.dart';
class SocialSplitExpenseScreen extends ConsumerStatefulWidget {
 const SocialSplitExpenseScreen({super.key});
 @override
 ConsumerState<SocialSplitExpenseScreen> createState() => _SocialSplitExpenseScreenState();
}
class _SocialSplitExpenseScreenState extends ConsumerState<SocialSplitExpenseScreen> {
 final amountController = TextEditingController();
 final descriptionController = TextEditingController();
 List<String> selectedFriends = [];
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final friendsAsync = ref.watch(friendsProvider(userId));
  final amount = double.tryParse(amountController.text) ?? 0;
  final splitCount = selectedFriends.length + 1;
  final perPerson = splitCount > 0 ? amount / splitCount : 0;
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(SocialConstants.splitExpense),
   ),
   body: ListView(
    padding: const EdgeInsets.all(16),
    children: [
     const Text(SocialConstants.totalAmount, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     TextField(
      controller: amountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
       hintText: SocialConstants.enterAmount,
       prefixText: '\$ ',
       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: (_) => setState(() {}),
     ),
     const SizedBox(height: 24),
     const Text(SocialConstants.selectFriends, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     friendsAsync.when(
      data: (friends) => Column(
       children: friends.map((f) {
        final fId = f['id']?.toString() ?? '';
        final isSelected = selectedFriends.contains(fId);
        return Card(
         margin: const EdgeInsets.only(bottom: 8),
         child: ListTile(
          leading: Icon(isSelected ? Icons.check_circle : Icons.circle_outlined, color: isSelected ? AppColors.primary : Colors.grey),
          title: Text(f['name']?.toString() ?? SocialConstants.user),
          trailing: isSelected
            ? Text(
              '\$${perPerson.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
             )
            : null,
          onTap: () {
           setState(() {
            if (isSelected) {
             selectedFriends.remove(fId);
            } else {
             selectedFriends.add(fId);
            }
           });
          },
         ),
        );
       }).toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Text(SocialConstants.errorLoadingFriends),
     ),
     const SizedBox(height: 24),
     Card(
      color: AppColors.primary.withValues(alpha: 0.1),
      child: Padding(
       padding: const EdgeInsets.all(16),
       child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         const Text(SocialConstants.yourShare, style: TextStyle(fontWeight: FontWeight.bold)),
         Text(
          '\$${perPerson.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
         ),
        ],
       ),
      ),
     ),
     const SizedBox(height: 12),
     Text(
      '${SocialConstants.perPerson}: \$${perPerson.toStringAsFixed(2)} x $splitCount',
      style: const TextStyle(color: Colors.grey),
      textAlign: TextAlign.center,
     ),
     const SizedBox(height: 24),
     ElevatedButton(
      onPressed: selectedFriends.isNotEmpty && amount > 0
        ? () async {
          await ref.read(socialRepositoryProvider).splitExpense(userId, selectedFriends, amount, descriptionController.text);
          if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(SocialConstants.requestSent)));
           context.pop();
          }
         }
        : null,
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.all(16)),
      child: const Text(SocialConstants.sendRequest, style: TextStyle(color: Colors.white)),
     ),
    ],
   ),
  );
 }
}