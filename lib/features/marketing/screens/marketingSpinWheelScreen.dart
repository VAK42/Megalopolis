import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/marketingProvider.dart';
import '../../../shared/widgets/sharedBottomNav.dart';
import '../../marketing/constants/marketingConstants.dart';
class MarketingSpinWheelScreen extends ConsumerStatefulWidget {
 const MarketingSpinWheelScreen({super.key});
 @override
 ConsumerState<MarketingSpinWheelScreen> createState() => _MarketingSpinWheelScreenState();
}
class _MarketingSpinWheelScreenState extends ConsumerState<MarketingSpinWheelScreen> with SingleTickerProviderStateMixin {
 late AnimationController spinController;
 bool isSpinning = false;
 int? reward;
 @override
 void initState() {
  super.initState();
  spinController = AnimationController(vsync: this, duration: const Duration(seconds: 4));
 }
 @override
 void dispose() {
  spinController.dispose();
  super.dispose();
 }
 Future<void> _spin(List<int> rewards) async {
  if (isSpinning) return;
  setState(() { isSpinning = true; reward = null; });
  spinController.reset();
  await spinController.forward();
  final random = Random();
  final wonReward = rewards[random.nextInt(rewards.length)];
  setState(() { reward = wonReward; isSpinning = false; });
  if (wonReward > 0) {
   final userId = ref.read(currentUserIdProvider) ?? '';
   await ref.read(marketingRepositoryProvider).processSpinWin(userId, wonReward);
  }
 }
 @override
 Widget build(BuildContext context) {
  final rewardsAsync = ref.watch(spinWheelOptionsProvider);
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.home), onPressed: () => context.go(Routes.superDashboard)),
    title: const Text(MarketingConstants.spinWheelTitle),
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
     children: [
      GridView.count(
       shrinkWrap: true,
       physics: const NeverScrollableScrollPhysics(),
       crossAxisCount: 3,
       mainAxisSpacing: 12,
       crossAxisSpacing: 12,
       childAspectRatio: 1.0,
       children: [
        _buildQuickAction(context, MarketingConstants.scratchCardTitle, Icons.style, () => context.push(Routes.marketingScratch)),
        _buildQuickAction(context, MarketingConstants.checkInTitle, Icons.calendar_today, () => context.push(Routes.marketingCheckin)),
        _buildQuickAction(context, MarketingConstants.leaderboardTitle, Icons.leaderboard, () => context.push(Routes.marketingLeaderboard)),
        _buildQuickAction(context, MarketingConstants.badgesTitle, Icons.military_tech, () => context.push(Routes.marketingBadges)),
        _buildQuickAction(context, MarketingConstants.bannersTitle, Icons.image, () => context.push(Routes.marketingBanners)),
       ],
      ),
      const SizedBox(height: 24),
      const Text(MarketingConstants.spinWheelHeader, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 24),
      rewardsAsync.when(
       data: (rewards) => Column(
        children: [
         RotationTransition(
          turns: Tween(begin: 0.0, end: 5.0).animate(CurvedAnimation(parent: spinController, curve: Curves.easeOut)),
          child: Container(
           width: 200,
           height: 200,
           decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20)],
           ),
           child: const Center(child: Icon(Icons.card_giftcard, size: 60, color: Colors.white)),
          ),
         ),
         const SizedBox(height: 24),
         if (reward != null)
          Container(
           padding: const EdgeInsets.all(16),
           decoration: BoxDecoration(color: reward! > 0 ? AppColors.success.withValues(alpha: 0.1) : Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
           child: Text(
            reward! > 0 ? '${MarketingConstants.spinWinPrefix}${MarketingConstants.currencySymbol}$reward${MarketingConstants.spinWinSuffix}' : MarketingConstants.spinLose,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: reward! > 0 ? AppColors.success : Colors.grey),
           ),
          ),
         const SizedBox(height: 24),
         ElevatedButton(
          onPressed: isSpinning ? null : () => _spin(rewards),
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16)),
          child: Text(isSpinning ? MarketingConstants.spinningButton : MarketingConstants.spinButton),
         ),
        ],
       ),
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (_, __) => const Center(child: Text(MarketingConstants.errorLoadingGame)),
      ),
     ],
    ),
   ),
   bottomNavigationBar: const SharedBottomNavBar(),
  );
 }
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
      Icon(icon, size: 28, color: AppColors.primary),
      const SizedBox(height: 4),
      Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
     ],
    ),
   ),
  );
 }
}