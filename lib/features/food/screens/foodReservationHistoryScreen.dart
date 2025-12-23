import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/foodProvider.dart';
import '../constants/foodConstants.dart';
class FoodReservationHistoryScreen extends ConsumerWidget {
 const FoodReservationHistoryScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userIdStr = ref.watch(currentUserIdProvider);
  final userId = userIdStr ?? '1';
  final ordersAsync = ref.watch(foodOrdersProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(FoodConstants.reservationHistoryTitle),
   ),
   body: ordersAsync.when(
    data: (orders) {
     if (orders.isEmpty) {
      return Center(
       child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         const Icon(Icons.calendar_today, size: 64, color: Colors.grey),
         const SizedBox(height: 16),
         Text(FoodConstants.noReservations, style: const TextStyle(color: Colors.grey)),
        ],
       ),
      );
     }
     return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
       final order = orders[index];
       return Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
         leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.calendar_today, color: AppColors.primary),
         ),
         title: Text('${FoodConstants.orderPrefix}${order['id'].toString().substring(0, 6)}', style: const TextStyle(fontWeight: FontWeight.bold)),
         subtitle: Text('${FoodConstants.total}: \$${order['total'] ?? 0}'),
         trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Text(order['status']?.toString() ?? FoodConstants.completed, style: const TextStyle(color: AppColors.success, fontSize: 12)),
         ),
        ),
       );
      },
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(child: Text('${FoodConstants.errorPrefix}$e')),
   ),
  );
 }
}