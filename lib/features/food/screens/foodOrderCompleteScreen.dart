import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/foodProvider.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../constants/foodConstants.dart';
class FoodOrderCompleteScreen extends ConsumerWidget {
 final String orderId;
 const FoodOrderCompleteScreen({super.key, required this.orderId});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userIdStr = ref.watch(currentUserIdProvider);
  final userId = userIdStr ?? '1';
  final ordersAsync = ref.watch(foodOrdersProvider(userId));
  return Scaffold(
   body: ordersAsync.when(
    data: (orders) {
     final order = orders.firstWhere((o) => o['id'].toString() == orderId, orElse: () => <String, dynamic>{});
     return SafeArea(
      child: Padding(
       padding: const EdgeInsets.all(24),
       child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         const Spacer(),
         Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: const Icon(Icons.check_circle, size: 80, color: AppColors.success),
         ),
         const SizedBox(height: 32),
         Text(FoodConstants.orderCompleteTitle, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
         const SizedBox(height: 8),
         Text(FoodConstants.hopeYouEnjoyed, style: const TextStyle(color: Colors.grey, fontSize: 16)),
         const SizedBox(height: 32),
         Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(16)),
          child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
            Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
              Text(FoodConstants.totalPaid),
              const SizedBox(height: 4),
              Text('\$${order['total'] ?? '0.00'}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
             ],
            ),
            const Icon(Icons.receipt_long, size: 48, color: AppColors.primary),
           ],
          ),
         ),
         const Spacer(),
         AppButton(text: FoodConstants.rateFoodTitle, onPressed: () => context.go('${Routes.foodRateFood}/$orderId'), icon: Icons.star),
         const SizedBox(height: 16),
         TextButton(onPressed: () => context.go(Routes.foodHome), child: Text(FoodConstants.backToHome)),
        ],
       ),
      ),
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(child: Text('${FoodConstants.errorPrefix}$e')),
   ),
  );
 }
}