import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/profileProvider.dart';
import '../../ride/constants/rideConstants.dart';
class RideDriverEarningsScreen extends ConsumerWidget {
 const RideDriverEarningsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final statsAsync = ref.watch(userStatsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(RideConstants.earningsTitle),
   ),
   body: statsAsync.when(
    data: (stats) => _buildContent(stats),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => _buildContent({'todayEarnings': 0.0, 'weeklyEarnings': 0.0, 'monthlyEarnings': 0.0, 'tripsToday': 0, 'hoursOnline': 0}),
   ),
  );
 }
 Widget _buildContent(Map<String, dynamic> stats) {
  final todayEarnings = (stats['todayEarnings'] ?? 0.0).toStringAsFixed(2);
  final tripsToday = stats['tripsToday'] ?? 0;
  final hoursOnline = stats['hoursOnline'] ?? 0;
  final weeklyEarnings = (stats['weeklyEarnings'] ?? 0.0).toStringAsFixed(2);
  final monthlyEarnings = (stats['monthlyEarnings'] ?? 0.0).toStringAsFixed(2);
  return ListView(
   padding: const EdgeInsets.all(16),
   children: [
    Container(
     padding: const EdgeInsets.all(24),
     decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
     child: Column(
      children: [
       const Text(RideConstants.todayEarnings, style: TextStyle(color: Colors.white70)),
       const SizedBox(height: 8),
       Text(
        '\$$todayEarnings',
        style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
       ),
       const SizedBox(height: 16),
       Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
         Column(
          children: [
           Text(
            '$tripsToday',
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
           ),
           const Text(RideConstants.tripsCompleted, style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
         ),
         Column(
          children: [
           Text(
            '$hoursOnline hrs',
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
           ),
           const Text(RideConstants.onlineStatus, style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
         ),
        ],
       ),
      ],
     ),
    ),
    const SizedBox(height: 24),
    _buildEarningsCard(RideConstants.weeklyEarnings, '\$$weeklyEarnings', '+12%'),
    _buildEarningsCard(RideConstants.monthlyEarnings, '\$$monthlyEarnings', '+8%'),
   ],
  );
 }
 Widget _buildEarningsCard(String title, String amount, String change) {
  return Card(
   margin: const EdgeInsets.only(bottom: 12),
   child: Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
     mainAxisAlignment: MainAxisAlignment.spaceBetween,
     children: [
      Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Text(title, style: TextStyle(color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(amount, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
       ],
      ),
      Container(
       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
       decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
       child: Text(
        change,
        style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold),
       ),
      ),
     ],
    ),
   ),
  );
 }
}