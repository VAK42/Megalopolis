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
   backgroundColor: Colors.white,
   body: SafeArea(
    child: SingleChildScrollView(
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
         children: [
          userAsync.when(
           data: (user) => CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary,
            backgroundImage: user?.avatar != null && user!.avatar!.isNotEmpty ? NetworkImage(user.avatar!) : null,
            child: user?.avatar == null || user!.avatar!.isEmpty ? const Icon(Icons.person, color: Colors.white) : null,
           ),
           loading: () => const CircleAvatar(radius: 24, backgroundColor: AppColors.primary, child: Icon(Icons.person, color: Colors.white)),
           error: (_, __) => const CircleAvatar(radius: 24, backgroundColor: AppColors.primary, child: Icon(Icons.person, color: Colors.white)),
          ),
          const SizedBox(width: 16),
          Expanded(
           child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             userAsync.when(
              data: (user) => Text('${CoreConstants.hello}, ${user?.name.split(' ').first ?? CoreConstants.guest}!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              loading: () => Text('${CoreConstants.hello}!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              error: (_, __) => Text('${CoreConstants.hello}, ${CoreConstants.guest}!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
             ),
             Text(CoreConstants.whatWouldYouLike, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            ],
           ),
          ),
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
           color: Colors.grey[100],
           borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
           children: [
            const Icon(Icons.search, color: AppColors.primary),
            const SizedBox(width: 12),
            Consumer(
             builder: (context, ref, child) {
              final hintAsync = ref.watch(searchHintProvider);
              return hintAsync.when(
               data: (hint) => Text(hint, style: TextStyle(color: Colors.grey[500])),
               loading: () => Text(CoreConstants.loading, style: TextStyle(color: Colors.grey[500])),
               error: (_, __) => Text(CoreConstants.searchHint, style: TextStyle(color: Colors.grey[500])),
              );
             },
            ),
           ],
          ),
         ),
        ),
       ).animate().fadeIn(delay: 200.ms),
       const SizedBox(height: 24),
       SizedBox(
        height: 180,
        child: PageView(
         controller: PageController(viewportFraction: 0.9),
         children: [
          _buildHeroCard(context, CoreConstants.orderDeliciousFood, CoreConstants.firstOrderDiscount, Colors.orange, Icons.restaurant, () => context.go(Routes.foodHome)),
          _buildHeroCard(context, CoreConstants.bookRideNow, CoreConstants.safeRides, AppColors.accent, Icons.directions_car, () => context.go(Routes.rideHome)),
          _buildHeroCard(context, CoreConstants.shopTopBrands, CoreConstants.flashSaleOff, AppColors.success, Icons.shopping_bag, () => context.go(Routes.martHome)),
         ],
        ).animate().fadeIn(delay: 300.ms),
       ),
       const SizedBox(height: 24),
       Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceAround,
         children: [
          _buildQuickAction(context, CoreConstants.food, Icons.fastfood, Colors.orange, () => context.go(Routes.foodHome)),
          _buildQuickAction(context, CoreConstants.ride, Icons.local_taxi, AppColors.accent, () => context.go(Routes.rideHome)),
          _buildQuickAction(context, CoreConstants.mart, Icons.store, AppColors.success, () => context.go(Routes.martHome)),
          _buildQuickAction(context, CoreConstants.services, Icons.build, AppColors.secondary, () => context.go(Routes.servicesHome)),
         ],
        ).animate().fadeIn(delay: 400.ms),
       ),
       const SizedBox(height: 24),
       Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(CoreConstants.ourServices, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
       ),
       const SizedBox(height: 16),
       Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: GridView.count(
         shrinkWrap: true,
         physics: const NeverScrollableScrollPhysics(),
         crossAxisCount: 3,
         mainAxisSpacing: 16,
         crossAxisSpacing: 16,
         children: [
          _buildServiceTile(context, CoreConstants.foodDelivery, Icons.restaurant, Colors.orange, () => context.go(Routes.foodHome)),
          _buildServiceTile(context, CoreConstants.rideHailing, Icons.directions_car, AppColors.accent, () => context.go(Routes.rideHome)),
          _buildServiceTile(context, CoreConstants.shopping, Icons.shopping_bag, AppColors.success, () => context.go(Routes.martHome)),
          _buildServiceTile(context, CoreConstants.wallet, Icons.account_balance_wallet, AppColors.warning, () => context.go(Routes.walletHome)),
          _buildServiceTile(context, CoreConstants.services, Icons.home_repair_service, AppColors.secondary, () => context.go(Routes.servicesHome)),
          _buildServiceTile(context, CoreConstants.messages, Icons.chat_bubble, AppColors.cyan, () => context.go(Routes.chatInbox)),
         ],
        ).animate().fadeIn(delay: 500.ms),
       ),
       const SizedBox(height: 24),
       Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(CoreConstants.specialOffers, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
       ),
       const SizedBox(height: 16),
       SizedBox(
        height: 120,
        child: ListView(
         scrollDirection: Axis.horizontal,
         padding: const EdgeInsets.symmetric(horizontal: 24),
         children: [
          _buildPromoCard(CoreConstants.freeDelivery, CoreConstants.ordersAbove, Colors.purple),
          _buildPromoCard(CoreConstants.flashSale, CoreConstants.upTo50Off, AppColors.error),
          _buildPromoCard(CoreConstants.referEarn, CoreConstants.getPer, AppColors.success),
         ],
        ).animate().fadeIn(delay: 600.ms),
       ),
       const SizedBox(height: 100),
      ],
     ),
    ),
   ),
   bottomNavigationBar: const SharedBottomNavBar(),
  );
 }
 Widget _buildHeroCard(BuildContext context, String title, String subtitle, Color color, IconData icon, VoidCallback onTap) {
  return GestureDetector(
   onTap: onTap,
   child: Container(
    margin: const EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
     gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
     borderRadius: BorderRadius.circular(20),
     boxShadow: [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 15, offset: const Offset(0, 8))],
    ),
    child: Stack(
     children: [
      Positioned(right: -30, bottom: -30, child: Icon(icon, size: 150, color: Colors.white.withValues(alpha: 0.2))),
      Padding(
       padding: const EdgeInsets.all(24),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         Text(title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
         const SizedBox(height: 8),
         Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14)),
         const SizedBox(height: 16),
         Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Text(CoreConstants.exploreNow, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
         ),
        ],
       ),
      ),
     ],
    ),
   ),
  );
 }
 Widget _buildQuickAction(BuildContext context, String label, IconData icon, Color color, VoidCallback onTap) {
  return GestureDetector(
   onTap: onTap,
   child: Column(
    children: [
     Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
      child: Icon(icon, color: color, size: 28),
     ),
     const SizedBox(height: 8),
     Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[700])),
    ],
   ),
  );
 }
 Widget _buildServiceTile(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
  return GestureDetector(
   onTap: onTap,
   child: Container(
    decoration: BoxDecoration(
     color: Colors.grey[50],
     borderRadius: BorderRadius.circular(16),
     border: Border.all(color: Colors.grey[200]!),
    ),
    child: Column(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
      Container(
       padding: const EdgeInsets.all(12),
       decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
       child: Icon(icon, color: color, size: 24),
      ),
      const SizedBox(height: 8),
      Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
     ],
    ),
   ),
  );
 }
 Widget _buildPromoCard(String title, String subtitle, Color color) {
  return Container(
   width: 180,
   margin: const EdgeInsets.only(right: 16),
   padding: const EdgeInsets.all(16),
   decoration: BoxDecoration(
    gradient: LinearGradient(colors: [color.withValues(alpha: 0.9), color.withValues(alpha: 0.7)]),
    borderRadius: BorderRadius.circular(16),
   ),
   child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
     Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
     const SizedBox(height: 4),
     Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12)),
    ],
   ),
  );
 }
}