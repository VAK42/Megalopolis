import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/serviceProvider.dart';
import '../constants/servicesConstants.dart';
class ServicesSubscriptionScreen extends ConsumerWidget {
 const ServicesSubscriptionScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final plansAsync = ref.watch(serviceSubscriptionPlansProvider);
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ServicesConstants.subscriptionTitle),
   ),
   body: plansAsync.when(
    data: (plans) {
     if (plans.isEmpty) {
      return const Center(child: Text(ServicesConstants.noServicesFound));
     }
     return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: plans.length,
      itemBuilder: (context, index) {
       final plan = plans[index];
       return _buildPlanCard(context, ref, userId, plan);
      },
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(ServicesConstants.errorLoadingServices)),
   ),
  );
 }
 Widget _buildPlanCard(BuildContext context, WidgetRef ref, String userId, Map<String, dynamic> plan) {
  final title = plan['name'] ?? ServicesConstants.monthlyPlan;
  final price = (plan['price'] ?? 0.0).toDouble();
  final benefits = (plan['benefits'] as List<dynamic>?)?.cast<String>() ?? [];
  final isPopular = plan['isPopular'] == 1 || plan['isPopular'] == true;
  final period = plan['period'] ?? 'Month';
  final color = isPopular ? AppColors.accent : AppColors.primary;
  return Card(
   margin: const EdgeInsets.only(bottom: 16),
   child: Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
     borderRadius: BorderRadius.circular(12),
     border: isPopular ? Border.all(color: color, width: 2) : null,
    ),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      if (isPopular)
       Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
        child: const Text(ServicesConstants.bestValue, style: TextStyle(color: Colors.white, fontSize: 12)),
       ),
      Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Row(
       crossAxisAlignment: CrossAxisAlignment.end,
       children: [
        Text(
         '\$${price.toStringAsFixed(2)}',
         style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color),
        ),
        Text('/$period', style: const TextStyle(color: Colors.grey)),
       ],
      ),
      const SizedBox(height: 16),
      const Text(ServicesConstants.planBenefits, style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      ...benefits.map(
       (b) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
         children: [
          Icon(Icons.check_circle, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(b)),
         ],
        ),
       ),
      ),
      const SizedBox(height: 16),
      AppButton(
       text: ServicesConstants.subscribe,
       onPressed: () async {
        await ref.read(serviceRepositoryProvider).purchaseSubscription(userId, plan['id']?.toString() ?? '');
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(ServicesConstants.subscribed)));
       },
      ),
     ],
    ),
   ),
  );
 }
}