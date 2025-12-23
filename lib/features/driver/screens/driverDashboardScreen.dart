import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/driverProvider.dart';
import '../constants/driverConstants.dart';
class DriverDashboardScreen extends ConsumerWidget {
 const DriverDashboardScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final statsAsync = ref.watch(driverStatsProvider(userId));
  final perfAsync = ref.watch(driverPerformanceProvider(userId));
  final driverStatus = ref.watch(driverStatusProvider);
  final isOnline = driverStatus == DriverConstants.statusOnline;
  return Scaffold(
   appBar: AppBar(
    title: const Text(DriverConstants.dashboardTitle),
    actions: [IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () => context.go(Routes.notifications))],
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
     children: [
      statsAsync.when(
       data: (stats) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
        child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceAround,
         children: [
          _buildStat(DriverConstants.today, '\$${(stats['todayEarnings'] as num).toStringAsFixed(0)}'),
          _buildStat(DriverConstants.trips, '${stats['todayTrips']}'),
          perfAsync.when(data: (perf) => _buildStat(DriverConstants.rating, '${perf['rating']}'), loading: () => _buildStat(DriverConstants.rating, DriverConstants.ratingLoading), error: (_, __) => _buildStat(DriverConstants.rating, DriverConstants.ratingError)),
         ],
        ),
       ),
       loading: () => Container(
        height: 120,
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
        child: const Center(child: CircularProgressIndicator(color: Colors.white)),
       ),
       error: (_, __) => const SizedBox(),
      ),
      const SizedBox(height: 24),
      Container(
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(
        color: isOnline ? Colors.green.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isOnline ? Colors.green : Colors.grey.shade300),
       ),
       child: Row(
        children: [
         Icon(isOnline ? Icons.circle : Icons.circle_outlined, color: isOnline ? Colors.green : Colors.grey, size: 16),
         const SizedBox(width: 12),
         Text(
          isOnline ? DriverConstants.youAreOnline : DriverConstants.youAreOffline,
          style: TextStyle(fontWeight: FontWeight.bold, color: isOnline ? Colors.green.shade700 : Colors.grey.shade700),
         ),
         const Spacer(),
         Switch(
          value: isOnline,
          onChanged: (value) async {
           final newStatus = value ? DriverConstants.statusOnline : DriverConstants.statusOffline;
           ref.read(driverStatusProvider.notifier).state = newStatus;
           await ref.read(driverRepositoryProvider).updateDriverStatus(userId, newStatus);
          },
          activeThumbColor: Colors.green,
         ),
        ],
       ),
      ),
      const SizedBox(height: 24),
      GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.5, children: [_buildQuickAction(context, DriverConstants.myTrips, Icons.directions_car, () => context.push(Routes.driverTrips)), _buildQuickAction(context, DriverConstants.earnings, Icons.attach_money, () => context.push(Routes.driverEarnings)), _buildQuickAction(context, DriverConstants.performance, Icons.trending_up, () => context.push(Routes.driverPerformance)), _buildQuickAction(context, DriverConstants.incentives, Icons.card_giftcard, () => context.push(Routes.driverIncentives))]),
     ],
    ),
   ),
  );
 }
 Widget _buildStat(String label, String value) {
  return Column(
   children: [
    Text(label, style: const TextStyle(color: Colors.white70)),
    const SizedBox(height: 8),
    Text(
     value,
     style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    ),
   ],
  );
 }
 Widget _buildQuickAction(BuildContext context, String title, IconData icon, VoidCallback onTap) {
  return GestureDetector(
   onTap: onTap,
   child: Container(
    decoration: BoxDecoration(
     color: Colors.white,
     borderRadius: BorderRadius.circular(12),
     boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
    ),
    child: Column(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
      Icon(icon, size: 32, color: AppColors.primary),
      const SizedBox(height: 8),
      Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
     ],
    ),
   ),
  );
 }
}