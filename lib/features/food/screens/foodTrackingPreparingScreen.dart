import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/foodProvider.dart';
import '../../../providers/authProvider.dart';
import '../../../core/routes/routeNames.dart';
import '../constants/foodConstants.dart';
class FoodTrackingPreparingScreen extends ConsumerStatefulWidget {
 final String orderId;
 const FoodTrackingPreparingScreen({super.key, required this.orderId});
 @override
 ConsumerState<FoodTrackingPreparingScreen> createState() => _FoodTrackingPreparingScreenState();
}
class _FoodTrackingPreparingScreenState extends ConsumerState<FoodTrackingPreparingScreen> {
 @override
 void initState() {
  super.initState();
  Future.delayed(const Duration(seconds: 5), () {
   if (mounted) {
    context.go('${Routes.foodTrackingPickedUp}/${widget.orderId}');
   }
  });
 }
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider) ?? '1';
  final orderAsync = ref.watch(foodLatestOrderProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.foodHome)),
    title: const Text(FoodConstants.orderInProgress),
   ),
   body: orderAsync.when(
    data: (order) {
     final total = (order?['total'] as num?)?.toDouble() ?? 0.0;
     final status = order?['status'] as String? ?? 'pending';
     double progress = 0.1;
     bool isConfirmed = false;
     bool isPreparing = false;
     bool isOut = false;
     bool isDelivered = false;
     if (status == 'confirmed') {
      progress = 0.33;
      isConfirmed = true;
     } else if (status == 'preparing') {
      progress = 0.66;
      isConfirmed = true;
      isPreparing = true;
     } else if (status == 'outForDelivery') {
      progress = 0.9;
      isConfirmed = true;
      isPreparing = true;
      isOut = true;
     } else if (status == 'completed' || status == 'delivered') {
      progress = 1.0;
      isConfirmed = true;
      isPreparing = true;
      isOut = true;
      isDelivered = true;
     }
     return Column(
      children: [
       LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[200], valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success)),
       Expanded(
        child: SingleChildScrollView(
         padding: const EdgeInsets.all(16),
         child: Column(
          children: [
           Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
            child: const Icon(Icons.restaurant, size: 60, color: Colors.white),
           ),
           const SizedBox(height: 24),
           const Text(FoodConstants.restaurantPreparingOrder, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
           const SizedBox(height: 12),
           Text('${FoodConstants.estimatedTimePrefix}${order?['estimatedTime'] ?? FoodConstants.defaultEstimatedTime}', style: TextStyle(color: Colors.grey[600])),
           const SizedBox(height: 32),
           _buildStatusItem(Icons.check_circle, FoodConstants.orderConfirmed, isConfirmed),
           _buildStatusItem(Icons.restaurant_menu, FoodConstants.preparingFood, isPreparing),
           _buildStatusItem(Icons.delivery_dining, FoodConstants.outForDelivery, isOut),
           _buildStatusItem(Icons.home, FoodConstants.delivered, isDelivered),
           const SizedBox(height: 32),
           Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
              const Text(FoodConstants.orderDetails, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                const Text(FoodConstants.orderId),
                Text('#${widget.orderId}', style: const TextStyle(fontWeight: FontWeight.bold)),
               ],
              ),
              const SizedBox(height: 8),
              Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                const Text(FoodConstants.total),
                Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
               ],
              ),
             ],
            ),
           ),
          ],
         ),
        ),
       ),
      ],
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(FoodConstants.errorLoadingOrder)),
   ),
  );
 }
 Widget _buildStatusItem(IconData icon, String text, bool isCompleted) {
  return Padding(
   padding: const EdgeInsets.symmetric(vertical: 12),
   child: Row(
    children: [
     Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: isCompleted ? AppColors.success : Colors.grey[300], shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 20),
     ),
     const SizedBox(width: 16),
     Text(text, style: TextStyle(fontSize: 16, color: isCompleted ? Colors.black : Colors.grey[600])),
    ],
   ),
  );
 }
}