import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/driverProvider.dart';
import '../constants/driverConstants.dart';
class DriverEarningsScreen extends ConsumerWidget {
 const DriverEarningsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? '';
  final statsAsync = ref.watch(driverStatsProvider(userId));
  final earningsAsync = ref.watch(driverEarningsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(DriverConstants.earningsTitle),
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      statsAsync.when(
       data: (stats) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
        child: Column(
         children: [
          const Text(DriverConstants.thisWeek, style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Text(
           '\$${(stats['weekEarnings'] as num).toStringAsFixed(2)}',
           style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_buildMiniStat(DriverConstants.today, '\$${(stats['todayEarnings'] as num).toStringAsFixed(0)}'), _buildMiniStat(DriverConstants.thisMonth, '\$${(stats['monthEarnings'] as num).toStringAsFixed(0)}'), _buildMiniStat(DriverConstants.trips, '${stats['weekTrips']}')]),
         ],
        ),
       ),
       loading: () => Container(
        height: 180,
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
        child: const Center(child: CircularProgressIndicator(color: Colors.white)),
       ),
       error: (_, __) => const SizedBox(),
      ),
      const SizedBox(height: 24),
      const Text(DriverConstants.dailyBreakdown, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 16),
      earningsAsync.when(
       data: (earnings) => Column(
        children: earnings
          .map(
           (e) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
             leading: Text(e['day'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
             title: Text(e['date'] as String),
             trailing: Text(
              '\$${(e['earnings'] as num).toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success),
             ),
            ),
           ),
          )
          .toList(),
       ),
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (_, __) => const Text(DriverConstants.errorLoadingEarnings),
      ),
     ],
    ),
   ),
  );
 }
 Widget _buildMiniStat(String label, String value) {
  return Column(
   children: [
    Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
    const SizedBox(height: 4),
    Text(
     value,
     style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
   ],
  );
 }
}