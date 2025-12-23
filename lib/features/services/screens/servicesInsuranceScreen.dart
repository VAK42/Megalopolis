import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/serviceProvider.dart';
import '../constants/servicesConstants.dart';
class ServicesInsuranceScreen extends ConsumerWidget {
 const ServicesInsuranceScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final plansAsync = ref.watch(serviceInsurancePlansProvider);
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ServicesConstants.insuranceTitle),
   ),
   body: plansAsync.when(
    data: (plans) => ListView(
     padding: const EdgeInsets.all(16),
     children: [
      Container(
       padding: const EdgeInsets.all(24),
       decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
       child: const Column(
        children: [
         Icon(Icons.security, size: 60, color: AppColors.primary),
         SizedBox(height: 16),
         Text(ServicesConstants.serviceInsurance, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
         SizedBox(height: 8),
         Text(
          ServicesConstants.insuranceDescription,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
         ),
        ],
       ),
      ),
      const SizedBox(height: 24),
      const Text(ServicesConstants.coverageDetails, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      if (plans.isEmpty) const Text(ServicesConstants.noServicesFound, style: TextStyle(color: Colors.grey)) else ...plans.map((plan) => _buildCoverageItem(_getIcon(plan['icon']), plan['name'] ?? ServicesConstants.insuranceTitle, plan['coverage'] ?? '')),
      const SizedBox(height: 24),
      ElevatedButton(
       onPressed: () async {
        if (plans.isNotEmpty) {
         await ref.read(serviceRepositoryProvider).purchaseInsurance(userId, plans.first['id']?.toString() ?? '');
         if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(ServicesConstants.insuranceAdded)));
        }
       },
       style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.all(16)),
       child: const Text(ServicesConstants.addInsurance, style: TextStyle(color: Colors.white)),
      ),
     ],
    ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(ServicesConstants.errorLoadingServices)),
   ),
  );
 }
 IconData _getIcon(String? iconName) {
  switch (iconName) {
   case 'home':
    return Icons.home;
   case 'equipment':
    return Icons.cleaning_services;
   case 'injury':
    return Icons.person_off;
   default:
    return Icons.security;
  }
 }
 Widget _buildCoverageItem(IconData icon, String title, String value) {
  return Card(
   margin: const EdgeInsets.only(bottom: 8),
   child: ListTile(
    leading: Icon(icon, color: AppColors.primary),
    title: Text(title),
    trailing: Text(
     value,
     style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success),
    ),
   ),
  );
 }
}