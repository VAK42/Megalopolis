import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/marketingProvider.dart';
import '../../marketing/constants/marketingConstants.dart';
class MarketingDailyCheckInScreen extends ConsumerWidget {
 const MarketingDailyCheckInScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? '';
  final checkInAsync = ref.watch(checkInStatusProvider(userId));
  return Scaffold(
   appBar: AppBar(
    title: const Text(MarketingConstants.checkInTitle),
    actions: [IconButton(icon: const Icon(Icons.delete_sweep), onPressed: () => _showClearHistoryDialog(context, ref, userId))],
   ),
   body: checkInAsync.when(
    data: (status) {
     final streak = status['streak'] as int;
     return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
       children: [
        Container(
         padding: const EdgeInsets.all(20),
         decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
         child: Column(
          children: [
           const Icon(Icons.check_circle, size: 60, color: Colors.white),
           const SizedBox(height: 16),
           Text(
            '$streak${MarketingConstants.checkInStreakSuffix}',
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
           ),
           const SizedBox(height: 8),
           const Text(MarketingConstants.checkInKeepGoing, style: TextStyle(color: Colors.white70)),
          ],
         ),
        ),
        const SizedBox(height: 24),
        Expanded(
         child: GridView.count(
          crossAxisCount: 4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: List.generate(7, (i) {
           final isCompleted = i < streak;
           return Container(
            decoration: BoxDecoration(
             color: isCompleted ? AppColors.success.withValues(alpha: 0.2) : Colors.grey[200],
             borderRadius: BorderRadius.circular(12),
             border: Border.all(color: isCompleted ? AppColors.success : Colors.grey[400]!),
            ),
            child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
              Text('${MarketingConstants.checkInDayPrefix}${i + 1}', style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 8),
              Icon(isCompleted ? Icons.check : Icons.lock, color: isCompleted ? AppColors.success : Colors.grey),
              const SizedBox(height: 4),
              Text('${MarketingConstants.checkInEarnedPrefix}${(i + 1) * 10}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
             ],
            ),
           );
          }),
         ),
        ),
        const SizedBox(height: 16),
        SizedBox(
         width: double.infinity,
         child: ElevatedButton(
          onPressed: () async {
           await ref.read(checkInStatusProvider(userId).notifier).performCheckIn();
           if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(MarketingConstants.checkInSuccess)));
           }
          },
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
          child: const Text(MarketingConstants.checkInButton),
         ),
        ),
       ],
      ),
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(child: Text('${MarketingConstants.errorPrefix}$e')),
   ),
  );
 }
 void _showClearHistoryDialog(BuildContext context, WidgetRef ref, String userId) {
  showDialog(
   context: context,
   builder: (ctx) => AlertDialog(
    title: const Text(MarketingConstants.clearHistoryTitle),
    content: const Text(MarketingConstants.clearHistoryMessage),
    actions: [
     TextButton(onPressed: () => Navigator.pop(ctx), child: const Text(MarketingConstants.cancel)),
     TextButton(
      onPressed: () async {
       await ref.read(checkInStatusProvider(userId).notifier).clearHistory();
       if (ctx.mounted) Navigator.pop(ctx);
       if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(MarketingConstants.historyCleared)));
       }
      },
      child: Text(MarketingConstants.clear, style: TextStyle(color: AppColors.error)),
     ),
    ],
   ),
  );
 }
}