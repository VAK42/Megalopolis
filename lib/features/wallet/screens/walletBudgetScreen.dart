import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/walletProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/walletConstants.dart';
class WalletBudgetScreen extends ConsumerStatefulWidget {
 const WalletBudgetScreen({super.key});
 @override
 ConsumerState<WalletBudgetScreen> createState() => _WalletBudgetScreenState();
}
class _WalletBudgetScreenState extends ConsumerState<WalletBudgetScreen> {
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider) ?? WalletConstants.defaultUserId;
  final budgetAsync = ref.watch(budgetProvider(userId));
  final categoriesAsync = ref.watch(budgetCategoriesProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(WalletConstants.budget),
    actions: [IconButton(icon: const Icon(Icons.add), onPressed: () {})],
   ),
   body: budgetAsync.when(
    data: (budget) {
     final monthlyBudget = (budget['monthlyBudget'] as num?)?.toDouble() ?? 0.0;
     final spent = (budget['spent'] as num?)?.toDouble() ?? 0.0;
     final remaining = monthlyBudget - spent;
     return ListView(
      padding: const EdgeInsets.all(16),
      children: [
       Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
        child: Column(
         children: [
          const Text(WalletConstants.monthlyBudget, style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Text(
           '${WalletConstants.currencySymbol}${monthlyBudget.toStringAsFixed(2)}',
           style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: [
            Column(
             children: [
              const Text(WalletConstants.spending, style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text(
               '${WalletConstants.currencySymbol}${spent.toStringAsFixed(2)}',
               style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
             ],
            ),
            Column(
             children: [
              const Text(WalletConstants.budgetRemaining, style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text(
               '${WalletConstants.currencySymbol}${remaining.toStringAsFixed(2)}',
               style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
             ],
            ),
           ],
          ),
         ],
        ),
       ),
       const SizedBox(height: 24),
       const Text(WalletConstants.budget, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
       const SizedBox(height: 12),
       categoriesAsync.when(
        data: (categories) => Column(children: categories.map((cat) => _buildBudgetCategory(cat['name'] ?? WalletConstants.unknown, (cat['budget'] as num?)?.toDouble() ?? 0, (cat['spent'] as num?)?.toDouble() ?? 0, _getCategoryColor(cat['name'] ?? ''))).toList()),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Text(WalletConstants.errorLoadingWallet),
       ),
      ],
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(WalletConstants.errorLoadingWallet)),
   ),
  );
 }
 Color _getCategoryColor(String category) {
  switch (category.toLowerCase()) {
   case 'food':
    return AppColors.primary;
   case 'transport':
    return AppColors.accent;
   case 'shopping':
    return Colors.orange;
   case 'entertainment':
    return Colors.purple;
   case 'bills':
    return AppColors.error;
   default:
    return Colors.grey;
  }
 }
 Widget _buildBudgetCategory(String name, double budget, double spent, Color color) {
  final percentage = budget > 0 ? spent / budget : 0.0;
  return Container(
   margin: const EdgeInsets.only(bottom: 16),
   padding: const EdgeInsets.all(16),
   decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
   child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
       Text('${WalletConstants.currencySymbol}${spent.toStringAsFixed(0)} / ${WalletConstants.currencySymbol}${budget.toStringAsFixed(0)}', style: TextStyle(color: Colors.grey[600])),
      ],
     ),
     const SizedBox(height: 8),
     LinearProgressIndicator(value: percentage, backgroundColor: Colors.grey[300], valueColor: AlwaysStoppedAnimation<Color>(percentage > 0.9 ? AppColors.error : color), minHeight: 8, borderRadius: BorderRadius.circular(4)),
     const SizedBox(height: 4),
     Text('${(percentage * 100).toInt()}%', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
    ],
   ),
  );
 }
}