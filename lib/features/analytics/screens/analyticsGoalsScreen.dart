import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/analyticsProvider.dart';
import '../constants/analyticsConstants.dart';
import '../widgets/analyticsScaffold.dart';
class AnalyticsGoalsScreen extends ConsumerWidget {
 const AnalyticsGoalsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Scaffold(body: Center(child: Text(AnalyticsConstants.loginRequired)));
  final goalsAsync = ref.watch(goalsProvider(userId));
  return AnalyticsScaffold(
   title: AnalyticsConstants.goalsTitle,
   body: RefreshIndicator(
    onRefresh: () async => ref.invalidate(goalsProvider(userId)),
    child: goalsAsync.when(
     data: (goals) {
      if (goals.isEmpty) {
       return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle), child: Icon(Icons.flag_outlined, size: 64, color: Colors.grey[400])),
        const SizedBox(height: 24),
        const Text(AnalyticsConstants.noGoalsYet, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(AnalyticsConstants.createFirstGoalHint, style: TextStyle(color: Colors.grey[600])),
       ]));
      }
      final totalTarget = goals.fold<double>(0, (sum, g) => sum + (g['target'] as num).toDouble());
      final totalCurrent = goals.fold<double>(0, (sum, g) => sum + (g['current'] as num).toDouble());
      return ListView(
       padding: const EdgeInsets.all(16),
       children: [
        Container(
         padding: const EdgeInsets.all(24),
         decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.primary, const Color(0xFF7C3AED)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 8))],
         ),
         child: Column(
          children: [
           Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Column(children: [
             const Text(AnalyticsConstants.totalGoals, style: TextStyle(color: Colors.white70, fontSize: 14)),
             const SizedBox(height: 4),
             Text('${goals.length}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            ]),
            Container(width: 1, height: 50, color: Colors.white.withValues(alpha: 0.3)),
            Column(children: [
             const Text(AnalyticsConstants.progress, style: TextStyle(color: Colors.white70, fontSize: 14)),
             const SizedBox(height: 4),
             Text('\$${totalCurrent.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            ]),
            Container(width: 1, height: 50, color: Colors.white.withValues(alpha: 0.3)),
            Column(children: [
             const Text(AnalyticsConstants.targetLabel, style: TextStyle(color: Colors.white70, fontSize: 14)),
             const SizedBox(height: 4),
             Text('\$${totalTarget.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            ]),
           ]),
           const SizedBox(height: 20),
           ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: totalTarget > 0 ? (totalCurrent / totalTarget).clamp(0.0, 1.0) : 0, backgroundColor: Colors.white.withValues(alpha: 0.3), valueColor: const AlwaysStoppedAnimation<Color>(Colors.white), minHeight: 10)),
           const SizedBox(height: 8),
           Text('${(totalTarget > 0 ? totalCurrent / totalTarget * 100 : 0).toStringAsFixed(1)}% ${AnalyticsConstants.overallProgress}', style: TextStyle(color: Colors.white.withValues(alpha: 0.8))),
          ],
         ),
        ),
        const SizedBox(height: 24),
        ...goals.map((goal) => _buildGoalCard(goal)),
       ],
      );
     },
     loading: () => const Center(child: CircularProgressIndicator()),
     error: (_, __) => const Center(child: Text(AnalyticsConstants.errorLoadingGoals)),
    ),
   ),
  );
 }
 Widget _buildGoalCard(Map<String, dynamic> goal) {
  final title = goal['title'] as String;
  final target = (goal['target'] as num).toDouble();
  final current = (goal['current'] as num).toDouble();
  final progress = target > 0 ? (current / target) : 0.0;
  final remaining = (target - current).clamp(0, double.infinity);
  final isComplete = current >= target;
  return Container(
   margin: const EdgeInsets.only(bottom: 16),
   padding: const EdgeInsets.all(20),
   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)], border: isComplete ? Border.all(color: AppColors.success.withValues(alpha: 0.5), width: 2) : null),
   child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     Row(children: [
      Container(
       width: 56, height: 56,
       decoration: BoxDecoration(color: isComplete ? AppColors.success.withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
       child: Stack(alignment: Alignment.center, children: [
        SizedBox(width: 56, height: 56, child: CircularProgressIndicator(value: progress.clamp(0.0, 1.0), strokeWidth: 4, backgroundColor: Colors.grey[200], valueColor: AlwaysStoppedAnimation<Color>(isComplete ? AppColors.success : AppColors.primary))),
        Text('${(progress * 100).toStringAsFixed(0)}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isComplete ? AppColors.success : AppColors.primary)),
       ]),
      ),
      const SizedBox(width: 16),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
       Row(children: [
        Expanded(child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        if (isComplete) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(12)), child: const Text(AnalyticsConstants.completeLabel, style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
       ]),
       const SizedBox(height: 4),
       Text('\$${current.toStringAsFixed(0)} of \$${target.toStringAsFixed(0)}', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      ])),
     ]),
     const SizedBox(height: 16),
     ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: progress.clamp(0.0, 1.0), backgroundColor: Colors.grey[200], valueColor: AlwaysStoppedAnimation<Color>(isComplete ? AppColors.success : AppColors.primary), minHeight: 8)),
     const SizedBox(height: 12),
     Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [Icon(Icons.trending_up_rounded, color: AppColors.success, size: 16), const SizedBox(width: 4), Text('${AnalyticsConstants.saved}\$${current.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, color: AppColors.success))]),
      Row(children: [Icon(Icons.flag_rounded, color: Colors.grey[500], size: 16), const SizedBox(width: 4), Text('${AnalyticsConstants.remainingGoal}\$${remaining.toStringAsFixed(0)}', style: TextStyle(fontSize: 12, color: Colors.grey[500]))]),
     ]),
    ],
   ),
  );
 }
}