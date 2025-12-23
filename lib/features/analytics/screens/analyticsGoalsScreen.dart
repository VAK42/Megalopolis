import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/analyticsProvider.dart';
import '../constants/analyticsConstants.dart';
class AnalyticsGoalsScreen extends ConsumerStatefulWidget {
 const AnalyticsGoalsScreen({super.key});
 @override
 ConsumerState<AnalyticsGoalsScreen> createState() => _AnalyticsGoalsScreenState();
}
class _AnalyticsGoalsScreenState extends ConsumerState<AnalyticsGoalsScreen> {
 Future<void> _showAddGoalDialog() async {
  final titleController = TextEditingController();
  final targetController = TextEditingController();
  final currentController = TextEditingController(text: '0');
  await showDialog(
   context: context,
   builder: (context) => AlertDialog(
    title: const Text(AnalyticsConstants.addGoalTitle),
    content: SingleChildScrollView(
     child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
       TextField(
        controller: titleController,
        decoration: const InputDecoration(labelText: AnalyticsConstants.goalTitleLabel),
       ),
       const SizedBox(height: 12),
       TextField(
        controller: targetController,
        decoration: const InputDecoration(labelText: AnalyticsConstants.targetAmountLabel, prefixText: '\$'),
        keyboardType: TextInputType.number,
       ),
       const SizedBox(height: 12),
       TextField(
        controller: currentController,
        decoration: const InputDecoration(labelText: AnalyticsConstants.currentProgressLabel, prefixText: '\$'),
        keyboardType: TextInputType.number,
       ),
      ],
     ),
    ),
    actions: [
     TextButton(onPressed: () => Navigator.pop(context), child: const Text(AnalyticsConstants.cancelButton)),
     ElevatedButton(
      onPressed: () async {
       final userId = ref.read(currentUserIdProvider);
       if (userId == null) return;
       await ref.read(analyticsRepositoryProvider).createGoal(userId: userId, title: titleController.text, target: double.tryParse(targetController.text) ?? 0, current: double.tryParse(currentController.text) ?? 0);
       if (mounted) {
        Navigator.pop(context);
        ref.invalidate(goalsProvider(userId));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AnalyticsConstants.goalCreatedSuccess)));
       }
      },
      child: const Text(AnalyticsConstants.createButton),
     ),
    ],
   ),
  );
 }
 Future<void> _showUpdateProgressDialog(Map<String, dynamic> goal) async {
  final amountController = TextEditingController();
  await showDialog(
   context: context,
   builder: (context) => AlertDialog(
    title: const Text(AnalyticsConstants.updateProgressTitle),
    content: TextField(
     controller: amountController,
     decoration: const InputDecoration(labelText: AnalyticsConstants.amountToAddLabel, prefixText: '\$'),
     keyboardType: TextInputType.number,
    ),
    actions: [
     TextButton(onPressed: () => Navigator.pop(context), child: const Text(AnalyticsConstants.cancelButton)),
     ElevatedButton(
      onPressed: () async {
       final userId = ref.read(currentUserIdProvider);
       if (userId == null) return;
       await ref.read(analyticsRepositoryProvider).updateGoalProgress(goal['id'].toString(), double.tryParse(amountController.text) ?? 0);
       if (mounted) {
        Navigator.pop(context);
        ref.invalidate(goalsProvider(userId));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AnalyticsConstants.progressUpdatedSuccess)));
       }
      },
      child: const Text(AnalyticsConstants.updateButton),
     ),
    ],
   ),
  );
 }
 Future<void> _deleteGoal(String goalId) async {
  final confirmed = await showDialog<bool>(
   context: context,
   builder: (context) => AlertDialog(
    title: const Text(AnalyticsConstants.deleteGoalTitle),
    content: const Text(AnalyticsConstants.deleteGoalConfirm),
    actions: [
     TextButton(onPressed: () => Navigator.pop(context, false), child: const Text(AnalyticsConstants.cancelButton)),
     ElevatedButton(
      onPressed: () => Navigator.pop(context, true),
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
      child: const Text(AnalyticsConstants.deleteButton),
     ),
    ],
   ),
  );
  if (confirmed == true) {
   final userId = ref.read(currentUserIdProvider);
   await ref.read(analyticsRepositoryProvider).deleteGoal(goalId);
   if (userId != null) ref.invalidate(goalsProvider(userId));
   if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AnalyticsConstants.goalDeletedSuccess)));
   }
  }
 }
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Scaffold(body: Center(child: Text(AnalyticsConstants.loginRequired)));
  final goalsAsync = ref.watch(goalsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    title: const Text(AnalyticsConstants.goalsTitle),
    actions: [IconButton(icon: const Icon(Icons.add), onPressed: _showAddGoalDialog)],
   ),
   body: goalsAsync.when(
    data: (goals) => goals.isEmpty
      ? Center(
        child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
          Icon(Icons.flag_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(AnalyticsConstants.noGoalsYet, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(AnalyticsConstants.createFirstGoalHint, style: TextStyle(color: Colors.grey)),
         ],
        ),
       )
      : ListView(padding: const EdgeInsets.all(16), children: goals.map((g) => _buildGoal(g)).toList()),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(AnalyticsConstants.errorLoadingGoals)),
   ),
   floatingActionButton: FloatingActionButton(onPressed: _showAddGoalDialog, child: const Icon(Icons.add)),
  );
 }
 Widget _buildGoal(Map<String, dynamic> goal) {
  final title = goal['title'] as String;
  final target = (goal['target'] as num).toDouble();
  final current = (goal['current'] as num).toDouble();
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
        Expanded(
         child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Text(
         '${(current / target * 100).toInt()}%',
         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
       ],
      ),
      const SizedBox(height: 12),
      LinearProgressIndicator(value: target > 0 ? (current / target).clamp(0.0, 1.0) : 0, backgroundColor: Colors.grey[300], valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary), minHeight: 10, borderRadius: BorderRadius.circular(5)),
      const SizedBox(height: 8),
      Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
        Text('\$${current.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w600)),
        Text('\$${target.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w600)),
       ],
      ),
      const SizedBox(height: 12),
      Row(
       children: [
        Expanded(
         child: OutlinedButton.icon(onPressed: () => _showUpdateProgressDialog(goal), icon: const Icon(Icons.add, size: 16), label: const Text(AnalyticsConstants.addProgressButton)),
        ),
        const SizedBox(width: 8),
        IconButton(
         icon: const Icon(Icons.delete_outline, color: AppColors.error),
         onPressed: () => _deleteGoal(goal['id'].toString()),
        ),
       ],
      ),
     ],
    ),
   ),
  );
 }
}