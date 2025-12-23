import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/serviceProvider.dart';
import '../constants/servicesConstants.dart';
class ServicesPromoScreen extends ConsumerWidget {
 const ServicesPromoScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final promosAsync = ref.watch(servicePromosProvider);
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ServicesConstants.promoTitle),
   ),
   body: promosAsync.when(
    data: (promos) {
     if (promos.isEmpty) {
      return const Center(child: Text(ServicesConstants.noServicesFound));
     }
     return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: promos.length + 1,
      itemBuilder: (context, index) {
       if (index == 0) {
        return const Padding(
         padding: EdgeInsets.only(bottom: 16),
         child: Text(ServicesConstants.activePromos, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        );
       }
       final promo = promos[index - 1];
       return _buildPromoCard(context, ref, userId, promo);
      },
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(ServicesConstants.errorLoadingServices)),
   ),
  );
 }
 Widget _buildPromoCard(BuildContext context, WidgetRef ref, String userId, Map<String, dynamic> promo) {
  final code = promo['code'] ?? '';
  final discount = promo['discount'] ?? 0;
  final service = promo['description'] ?? ServicesConstants.servicesTitle;
  final validUntil = promo['validUntil'] ?? '';
  return Card(
   margin: const EdgeInsets.only(bottom: 16),
   child: Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
     borderRadius: BorderRadius.circular(12),
     gradient: LinearGradient(colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)]),
    ),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
        Text(
         '$discount% OFF',
         style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Container(
         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
         child: Text(
          code,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
         ),
        ),
       ],
      ),
      const SizedBox(height: 8),
      Text(service, style: const TextStyle(color: Colors.white70)),
      const SizedBox(height: 12),
      Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
        Text('${ServicesConstants.validUntil}: $validUntil', style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ElevatedButton(
         onPressed: () async {
          await ref.read(serviceRepositoryProvider).applyPromo(userId, code);
          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$code Applied!')));
         },
         style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary),
         child: const Text(ServicesConstants.useNow),
        ),
       ],
      ),
     ],
    ),
   ),
  );
 }
}