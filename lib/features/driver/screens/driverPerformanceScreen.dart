import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/driverProvider.dart';
import '../constants/driverConstants.dart';
class DriverPerformanceScreen extends ConsumerWidget {
 const DriverPerformanceScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? '';
  final performanceAsync = ref.watch(driverPerformanceProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(DriverConstants.performanceTitle),
   ),
   body: performanceAsync.when(
    data: (performance) => SingleChildScrollView(
     padding: const EdgeInsets.all(16),
     child: Column(
      children: [
       Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
        child: Column(
         children: [
          const Text(DriverConstants.overallRating, style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
            Text(
             '${(performance['rating'] as num).toStringAsFixed(1)}',
             style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.star, color: Colors.amber, size: 32),
           ],
          ),
          const SizedBox(height: 8),
          Text('${performance['totalTrips']}${DriverConstants.totalTripsSuffix}', style: const TextStyle(color: Colors.white70)),
         ],
        ),
       ),
       const SizedBox(height: 24),
       _buildPerformanceCard(DriverConstants.acceptanceRate, '${performance['acceptanceRate']}%', Icons.check_circle, Colors.green),
       _buildPerformanceCard(DriverConstants.completionRate, '${performance['completionRate']}%', Icons.flag, Colors.blue),
       _buildPerformanceCard(DriverConstants.onTimeRate, '${performance['onTimeRate']}%', Icons.timer, Colors.orange),
      ],
     ),
    ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(child: Text('${DriverConstants.errorPrefix}$e')),
   ),
  );
 }
 Widget _buildPerformanceCard(String title, String value, IconData icon, Color color) {
  return Card(
   margin: const EdgeInsets.only(bottom: 12),
   child: ListTile(
    leading: Container(
     width: 48,
     height: 48,
     decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(24)),
     child: Icon(icon, color: color),
    ),
    title: Text(title),
    trailing: Text(
     value,
     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
    ),
   ),
  );
 }
}