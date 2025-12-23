import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/analyticsProvider.dart';
import '../constants/analyticsConstants.dart';
class AnalyticsBudgetScreen extends ConsumerStatefulWidget {
 const AnalyticsBudgetScreen({super.key});
 @override
 ConsumerState<AnalyticsBudgetScreen> createState() => _AnalyticsBudgetScreenState();
}
class _AnalyticsBudgetScreenState extends ConsumerState<AnalyticsBudgetScreen> {
 Future<void> _showEditBudgetDialog(String category, double currentLimit) async {
  final limitController = TextEditingController(text: currentLimit.toStringAsFixed(0));
  await showDialog(
   context: context,
   builder: (context) => AlertDialog(
    title: Text('${AnalyticsConstants.editBudgetPrefix}${category[0].toUpperCase()}${category.substring(1)}${AnalyticsConstants.budgetSuffix}'),
    content: TextField(
     controller: limitController,
     decoration: const InputDecoration(labelText: AnalyticsConstants.budgetLimitLabel, prefixText: '\$'),
     keyboardType: TextInputType.number,
    ),
    actions: [
     TextButton(onPressed: () => Navigator.pop(context), child: const Text(AnalyticsConstants.cancelButton)),
     ElevatedButton(
      onPressed: () async {
       final userId = ref.read(currentUserIdProvider);
       if (userId == null) return;
       Navigator.pop(context);
       ref.invalidate(budgetsProvider(userId));
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${category[0].toUpperCase()}${category.substring(1)}${AnalyticsConstants.budgetUpdatedSuffix}')));
      },
      child: const Text(AnalyticsConstants.saveButton),
     ),
    ],
   ),
  );
 }
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Scaffold(body: Center(child: Text(AnalyticsConstants.loginRequired)));
  final budgetsAsync = ref.watch(budgetsProvider(userId));
  return Scaffold(
   appBar: AppBar(title: const Text(AnalyticsConstants.budgetTitle)),
   body: budgetsAsync.when(
    data: (budgets) => ListView(padding: const EdgeInsets.all(16), children: budgets.map((b) => _buildBudget(b['category'] as String, (b['limit'] as num).toDouble(), (b['spent'] as num).toDouble())).toList()),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(AnalyticsConstants.errorLoadingBudgets)),
   ),
  );
 }
 Widget _buildBudget(String category, double budget, double actual) {
  final isOver = actual > budget;
  return Card(
   margin: const EdgeInsets.only(bottom: 16),
   child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
        Text(category.toUpperCase(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () => _showEditBudgetDialog(category, budget)),
       ],
      ),
      const SizedBox(height: 8),
      Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
        Text('${AnalyticsConstants.budgetPrefix}\$${budget.toStringAsFixed(0)}'),
        Text(
         '${AnalyticsConstants.actualPrefix}\$${actual.toStringAsFixed(0)}',
         style: TextStyle(fontWeight: FontWeight.bold, color: isOver ? AppColors.error : AppColors.success),
        ),
       ],
      ),
      const SizedBox(height: 8),
      LinearProgressIndicator(value: budget > 0 ? (actual / budget).clamp(0.0, 1.0) : 0, backgroundColor: Colors.grey[300], valueColor: AlwaysStoppedAnimation<Color>(isOver ? AppColors.error : AppColors.success), minHeight: 8, borderRadius: BorderRadius.circular(4)),
     ],
    ),
   ),
  );
 }
}