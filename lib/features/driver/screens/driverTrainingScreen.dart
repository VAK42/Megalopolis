import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/driverProvider.dart';
import '../constants/driverConstants.dart';
class DriverTrainingScreen extends ConsumerWidget {
 const DriverTrainingScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final driverId = ref.watch(currentUserIdProvider) ?? 'user1';
  final modulesAsync = ref.watch(driverTrainingModulesProvider(driverId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(DriverConstants.trainingTitle),
   ),
   body: modulesAsync.when(
    data: (modules) {
     final completedCount = modules.where((m) => m['completed'] == 1).length;
     final progress = modules.isNotEmpty ? completedCount / modules.length : 0.0;
     return Column(
      children: [
       Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
        child: Column(
         children: [
          const Text(DriverConstants.trainingProgress, style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Text(
           '$completedCount/${modules.length}${DriverConstants.modulesSuffix}',
           style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(value: progress, backgroundColor: Colors.white.withValues(alpha: 0.3), valueColor: const AlwaysStoppedAnimation<Color>(Colors.white), minHeight: 8, borderRadius: BorderRadius.circular(4)),
         ],
        ),
       ),
       Expanded(
        child: ListView.builder(
         padding: const EdgeInsets.all(16),
         itemCount: modules.length,
         itemBuilder: (context, index) {
          final module = modules[index];
          final isCompleted = module['completed'] == 1;
          return Card(
           margin: const EdgeInsets.only(bottom: 12),
           child: ListTile(
            leading: Container(
             width: 48,
             height: 48,
             decoration: BoxDecoration(color: isCompleted ? AppColors.success.withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(24)),
             child: Icon(isCompleted ? Icons.check_circle : Icons.play_circle, color: isCompleted ? AppColors.success : AppColors.primary),
            ),
            title: Text(module['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(module['duration'] as String),
            trailing: isCompleted ? const Text(DriverConstants.completed, style: TextStyle(color: AppColors.success)) : ElevatedButton(onPressed: () {}, child: const Text(DriverConstants.start)),
           ),
          );
         },
        ),
       ),
      ],
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(child: Text('${DriverConstants.errorPrefix}$e')),
   ),
  );
 }
}