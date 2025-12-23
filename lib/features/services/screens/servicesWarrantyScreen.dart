import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/serviceProvider.dart';
import '../constants/servicesConstants.dart';
class ServicesWarrantyScreen extends ConsumerWidget {
 final String? bookingId;
 const ServicesWarrantyScreen({super.key, this.bookingId});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final warrantyAsync = ref.watch(serviceWarrantyProvider(bookingId ?? ''));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ServicesConstants.warrantyTitle),
   ),
   body: warrantyAsync.when(
    data: (warranty) {
     final period = warranty?['period'] ?? '30 Days';
     final status = warranty?['status'] ?? 'Active';
     final description = warranty?['description'] ?? ServicesConstants.satisfactionGuarantee;
     final benefits = (warranty?['benefits'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
     return ListView(
      padding: const EdgeInsets.all(16),
      children: [
       Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
        child: Column(
         children: [
          const Icon(Icons.verified_user, size: 60, color: AppColors.success),
          const SizedBox(height: 16),
          const Text(ServicesConstants.warrantyTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
           description,
           textAlign: TextAlign.center,
           style: const TextStyle(color: Colors.grey),
          ),
         ],
        ),
       ),
       const SizedBox(height: 24),
       const Text(ServicesConstants.warrantyDetails, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
       const SizedBox(height: 12),
       if (benefits.isEmpty) const Text(ServicesConstants.noServicesFound, style: TextStyle(color: Colors.grey)) else ...benefits.map((b) => _buildWarrantyItem(_getIcon(b['icon']), b['title'] ?? '', b['subtitle'] ?? '')),
       const SizedBox(height: 24),
       const Text(ServicesConstants.warrantyPeriod, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
       const SizedBox(height: 12),
       Card(
        child: Padding(
         padding: const EdgeInsets.all(16),
         child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             const Text(ServicesConstants.standardWarranty, style: TextStyle(fontWeight: FontWeight.bold)),
             Text('$period ${ServicesConstants.coverage}', style: const TextStyle(color: Colors.grey)),
            ],
           ),
           Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
            child: Text(
             status,
             style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold),
            ),
           ),
          ],
         ),
        ),
       ),
       const SizedBox(height: 24),
       ElevatedButton(
        onPressed: () async {
         if (bookingId != null) {
          await ref.read(serviceRepositoryProvider).claimWarranty(bookingId!, 'Service Issue');
          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(ServicesConstants.warrantyClaimSubmitted)));
         }
        },
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.all(16)),
        child: const Text(ServicesConstants.claimWarranty, style: TextStyle(color: Colors.white)),
       ),
      ],
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(ServicesConstants.errorLoadingServices)),
   ),
  );
 }
 IconData _getIcon(String? iconName) {
  switch (iconName) {
   case 'refresh':
    return Icons.refresh;
   case 'money':
    return Icons.attach_money;
   case 'support':
    return Icons.support_agent;
   default:
    return Icons.verified_user;
  }
 }
 Widget _buildWarrantyItem(IconData icon, String title, String subtitle) {
  return Card(
   margin: const EdgeInsets.only(bottom: 8),
   child: ListTile(
    leading: Icon(icon, color: AppColors.success),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text(subtitle),
   ),
  );
 }
}