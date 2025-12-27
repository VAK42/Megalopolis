import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/merchantProvider.dart';
import '../../../providers/authProvider.dart';
import '../../../shared/widgets/sharedBottomNav.dart';
import '../../merchant/constants/merchantConstants.dart';
class MerchantDashboardScreen extends ConsumerWidget {
 const MerchantDashboardScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final merchantId = ref.watch(currentUserIdProvider) ?? 'user1';
  final statsAsync = ref.watch(merchantStatsProvider(merchantId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.home), onPressed: () => context.go(Routes.superDashboard)),
    title: const Text(MerchantConstants.dashboardTitle),
    actions: [IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () => context.go(Routes.notifications))],
   ),
   body: statsAsync.when(
    data: (stats) {
     return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
       children: [
        GridView.count(
         shrinkWrap: true,
         physics: const NeverScrollableScrollPhysics(),
         crossAxisCount: 2,
         mainAxisSpacing: 16,
         crossAxisSpacing: 16,
         children: [
          _buildStat(MerchantConstants.salesTitle, '\$${(stats['totalRevenue'] as num?)?.toStringAsFixed(2) ?? '0.00'}', Icons.attach_money, Colors.green, onTap: () => context.push(Routes.merchantOrders)),
          _buildStat(MerchantConstants.ordersTitle, '${stats['totalOrders'] ?? 0}', Icons.shopping_bag, Colors.orange, onTap: () => context.push(Routes.merchantOrders)),
          _buildStat(MerchantConstants.productsTitle, '${stats['totalProducts'] ?? 0}', Icons.inventory, Colors.blue, onTap: () => context.push(Routes.merchantProducts)),
          _buildStat(MerchantConstants.reviewsTitle, '${(stats['averageRating'] as num?)?.toStringAsFixed(1) ?? '0.0'}', Icons.star, Colors.amber, onTap: () => context.push(Routes.merchantReviews)),
          _buildQuickAction(context, MerchantConstants.promotionsTitle, Icons.campaign, () => context.push(Routes.merchantPromotions)),
          _buildQuickAction(context, MerchantConstants.payoutsTitle, Icons.payments, () => context.push(Routes.merchantPayouts)),
          _buildQuickAction(context, MerchantConstants.profileTitle, Icons.store, () => context.push(Routes.merchantProfile)),
         ],
        ),
       ],
      ),
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, s) => Center(child: Text('${MerchantConstants.errorGeneric}: $e')),
   ),
   bottomNavigationBar: const SharedBottomNavBar(),
  );
 }
 Widget _buildStat(String title, String value, IconData icon, Color color, {VoidCallback? onTap}) => GestureDetector(
  onTap: onTap,
  child: Container(
   padding: const EdgeInsets.all(16),
   decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
   ),
   child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
     Icon(icon, size: 32, color: color),
     const SizedBox(height: 8),
     Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
     Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    ],
   ),
  ),
 );
 Widget _buildQuickAction(BuildContext context, String title, IconData icon, VoidCallback onTap) {
  return GestureDetector(
   onTap: onTap,
   child: Container(
    decoration: BoxDecoration(
     color: Colors.white,
     borderRadius: BorderRadius.circular(12),
     boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
    ),
    child: Column(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
      Icon(icon, size: 32, color: AppColors.primary),
      const SizedBox(height: 8),
      Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
     ],
    ),
   ),
  );
 }
}