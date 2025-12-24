import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/systemProvider.dart';
import '../../core/constants/coreConstants.dart';
import '../../../shared/widgets/sharedBottomNav.dart';
class SuperDashboardScreen extends ConsumerWidget {
 const SuperDashboardScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userAsync = ref.watch(authProvider);
  return Scaffold(
   body: Container(
    decoration: BoxDecoration(color: AppColors.backgroundLight),
    child: SafeArea(
     child: Column(
      children: [
       Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
         children: [
          Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            userAsync.when(
             data: (user) => Text('${CoreConstants.hello}, ${user?.name.split(' ').first ?? CoreConstants.guest}!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
             loading: () => Text('${CoreConstants.hello}!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
             error: (_, __) => Text('${CoreConstants.hello}, ${CoreConstants.guest}!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 4),
            Text(CoreConstants.whatWouldYouLike, style: TextStyle(color: Colors.grey[600])),
           ],
          ),
          const Spacer(),
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () => context.go(Routes.notifications)),
          IconButton(icon: const Icon(Icons.qr_code_scanner), onPressed: () => context.go(Routes.scanQr)),
         ],
        ).animate().fadeIn().slideY(begin: -0.2, end: 0),
       ),
       Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: GestureDetector(
         onTap: () => context.go(Routes.globalSearch),
         child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.circular(12),
           boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, spreadRadius: 2)],
          ),
          child: Row(
           children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 12),
            Consumer(
             builder: (context, ref, child) {
              final hintAsync = ref.watch(searchHintProvider);
              return hintAsync.when(
               data: (hint) => Text(hint, style: TextStyle(color: Colors.grey[600])),
               loading: () => Text(CoreConstants.loading, style: TextStyle(color: Colors.grey[600])),
               error: (_, __) => Text(CoreConstants.searchHint, style: TextStyle(color: Colors.grey[600])),
              );
             },
            ),
           ],
          ),
         ),
        ),
       ).animate().fadeIn(delay: 200.ms),
       const SizedBox(height: 32),
       Expanded(
        child: GridView.count(crossAxisCount: 2, padding: const EdgeInsets.all(24), crossAxisSpacing: 16, mainAxisSpacing: 16, children: [_buildModuleCard(context, CoreConstants.foodDelivery, Icons.restaurant, Colors.orange, () => context.go(Routes.foodHome), 0), _buildModuleCard(context, CoreConstants.rideHailing, Icons.directions_car, AppColors.accent, () => context.go(Routes.rideHome), 100), _buildModuleCard(context, CoreConstants.shopping, Icons.shopping_bag, AppColors.success, () => context.go(Routes.martHome), 200), _buildModuleCard(context, CoreConstants.wallet, Icons.account_balance_wallet, AppColors.warning, () => context.go(Routes.walletHome), 300), _buildModuleCard(context, CoreConstants.services, Icons.home_repair_service, AppColors.secondary, () => context.go(Routes.servicesHome), 400), _buildModuleCard(context, CoreConstants.messages, Icons.chat_bubble, AppColors.cyan, () => context.go(Routes.chatInbox), 500)]),
       ),
      ],
     ),
    ),
   ),
   bottomNavigationBar: const SharedBottomNavBar(),
  );
 }
 Widget _buildModuleCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap, int delay) {
  return GestureDetector(
   onTap: onTap,
   child: Container(
    decoration: BoxDecoration(
     color: color,
     borderRadius: BorderRadius.circular(20),
     boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, spreadRadius: 2)],
    ),
    child: Column(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
      Icon(icon, size: 48, color: Colors.white),
      const SizedBox(height: 12),
      Text(
       title,
       textAlign: TextAlign.center,
       style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
      ),
     ],
    ),
   ).animate().fadeIn(delay: Duration(milliseconds: delay)).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
  );
 }
}