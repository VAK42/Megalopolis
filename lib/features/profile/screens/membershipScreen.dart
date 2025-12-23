import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/profileProvider.dart';
import '../constants/profileConstants.dart';
class MembershipScreen extends ConsumerWidget {
 const MembershipScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final statsAsync = ref.watch(userStatsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ProfileConstants.membershipTitle),
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      statsAsync.when(data: (stats) => _buildMembershipCard(stats), loading: () => _buildMembershipCard({'points': 0, 'rewards': 0}), error: (_, __) => _buildMembershipCard({'points': 0, 'rewards': 0})),
      const SizedBox(height: 24),
      const Text(ProfileConstants.rewards, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      ...List.generate(4, (index) => _buildRewardCard(index)),
      const SizedBox(height: 24),
      const Text(ProfileConstants.benefits, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      _buildBenefitItem(Icons.local_shipping, ProfileConstants.freeDelivery, 'On Orders Above \$20'),
      _buildBenefitItem(Icons.discount, '10% Cashback', 'On All Services'),
      _buildBenefitItem(Icons.priority_high, ProfileConstants.prioritySupport, '24/7 Dedicated Support'),
      _buildBenefitItem(Icons.calendar_today, 'Early Access', 'To New Features And Offers'),
     ],
    ),
   ),
  );
 }
 Widget _buildMembershipCard(Map<String, dynamic> stats) {
  final points = stats['points'] ?? 0;
  final nextTier = 3000;
  final progress = (points / nextTier).clamp(0.0, 1.0);
  final remaining = nextTier - points;
  return Container(
   padding: const EdgeInsets.all(20),
   decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
   child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       Text(
        'Gold Member',
        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
       ),
       Icon(Icons.star, color: Colors.amber, size: 32),
      ],
     ),
     const SizedBox(height: 16),
     Text(ProfileConstants.points, style: const TextStyle(color: Colors.white70, fontSize: 12)),
     const SizedBox(height: 4),
     Text(
      '$points',
      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
     ),
     const SizedBox(height: 16),
     LinearProgressIndicator(value: progress, backgroundColor: Colors.white.withValues(alpha: 0.3), valueColor: const AlwaysStoppedAnimation<Color>(Colors.white), minHeight: 8, borderRadius: BorderRadius.circular(4)),
     const SizedBox(height: 8),
     Text('$remaining More Points To Platinum', style: const TextStyle(color: Colors.white70, fontSize: 12)),
    ],
   ),
  );
 }
 Widget _buildRewardCard(int index) {
  final titles = ['20% Off Food Delivery', 'Free Ride', '\$10 Service Voucher', '2x Points Weekend'];
  final expires = ['Expires In 5 Days', 'Expires In 12 Days', 'Expires In 20 Days', 'Active Now'];
  return Card(
   margin: const EdgeInsets.only(bottom: 12),
   child: Padding(
    padding: const EdgeInsets.all(12),
    child: Row(
     children: [
      Container(
       padding: const EdgeInsets.all(12),
       decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
       child: const Icon(Icons.card_giftcard, color: AppColors.primary, size: 32),
      ),
      const SizedBox(width: 12),
      Expanded(
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(titles[index], style: const TextStyle(fontWeight: FontWeight.bold)),
         Text(expires[index], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
       ),
      ),
      ElevatedButton(
       onPressed: () {},
       child: const Text('Use', style: TextStyle(fontSize: 12)),
      ),
     ],
    ),
   ),
  );
 }
 Widget _buildBenefitItem(IconData icon, String title, String description) {
  return Container(
   margin: const EdgeInsets.only(bottom: 12),
   padding: const EdgeInsets.all(12),
   decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
   child: Row(
    children: [
     Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, color: AppColors.primary),
     ),
     const SizedBox(width: 12),
     Expanded(
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(description, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
       ],
      ),
     ),
    ],
   ),
  );
 }
}