import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/driverProvider.dart';
import '../constants/driverConstants.dart';
class DriverIncentivesScreen extends ConsumerWidget {
 const DriverIncentivesScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? '';
  final incentivesAsync = ref.watch(driverIncentivesProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(DriverConstants.incentivesTitle),
   ),
   body: incentivesAsync.when(
    data: (incentives) => ListView(
     padding: const EdgeInsets.all(16),
     children: [
      Container(
       padding: const EdgeInsets.all(20),
       decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
       child: const Column(
        children: [
         Icon(Icons.card_giftcard, color: Colors.white, size: 48),
         SizedBox(height: 12),
         Text(DriverConstants.activeIncentives, style: TextStyle(color: Colors.white70)),
         SizedBox(height: 4),
         Text(
          DriverConstants.completeGoalsMessage,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
         ),
        ],
       ),
      ),
      const SizedBox(height: 24),
      ...incentives.map((incentive) => _buildIncentiveCard(incentive)),
     ],
    ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(child: Text('${DriverConstants.errorPrefix}$e')),
   ),
  );
 }
 Widget _buildIncentiveCard(Map<String, dynamic> incentive) {
  final earned = (incentive['earned'] as num).toDouble();
  final target = (incentive['target'] as num).toDouble();
  final progress = target > 0 ? (earned / target).clamp(0.0, 1.0) : 0.0;
  final isComplete = progress >= 1.0;
  return Card(
   margin: const EdgeInsets.only(bottom: 12),
   child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Row(
       children: [
        Expanded(
         child: Text(incentive['title'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        if (isComplete)
         Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(12)),
          child: const Text(DriverConstants.complete, style: TextStyle(color: Colors.white, fontSize: 12)),
         ),
       ],
      ),
      const SizedBox(height: 8),
      Text(incentive['description'] as String, style: TextStyle(color: Colors.grey.shade600)),
      const SizedBox(height: 12),
      LinearProgressIndicator(value: progress, backgroundColor: Colors.grey.shade200, valueColor: AlwaysStoppedAnimation<Color>(isComplete ? AppColors.success : AppColors.primary), minHeight: 8, borderRadius: BorderRadius.circular(4)),
      const SizedBox(height: 8),
      Text('${earned.toStringAsFixed(0)} / ${target.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w600)),
     ],
    ),
   ),
  );
 }
}