import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/profileProvider.dart';
import '../constants/profileConstants.dart';
class ReferralScreen extends ConsumerWidget {
 const ReferralScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final referralAsync = ref.watch(referralInfoProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ProfileConstants.referEarn),
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
     children: [
      Container(
       padding: const EdgeInsets.all(24),
       decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
       child: Column(
        children: [
         const Icon(Icons.card_giftcard, size: 60, color: Colors.white),
         const SizedBox(height: 16),
         const Text(
          ProfileConstants.giveGetTen,
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
         ),
         const SizedBox(height: 8),
         const Text(
          ProfileConstants.referFriends,
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.center,
         ),
         const SizedBox(height: 24),
         referralAsync.when(
          data: (info) => Container(
           padding: const EdgeInsets.all(16),
           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
           child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
             Text(
              info?['referralCode'] ?? ProfileConstants.referralCode,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1.5),
             ),
             const SizedBox(width: 12),
             const Icon(Icons.copy, color: AppColors.primary),
            ],
           ),
          ),
          loading: () => const CircularProgressIndicator(color: Colors.white),
          error: (_, __) => Container(
           padding: const EdgeInsets.all(16),
           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
           child: const Text(
            ProfileConstants.referralCode,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
           ),
          ),
         ),
         const SizedBox(height: 16),
         ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.share),
          label: const Text(ProfileConstants.shareCode),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
         ),
        ],
       ),
      ),
      const SizedBox(height: 24),
      referralAsync.when(
       data: (info) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
        child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceAround,
         children: [
          Column(
           children: [
            Text(
             '${info?['referralCount'] ?? 0}',
             style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            Text(ProfileConstants.referrals, style: TextStyle(color: Colors.grey[600])),
           ],
          ),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          Column(
           children: [
            Text(
             '\$${info?['referralEarnings'] ?? 0}',
             style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            Text(ProfileConstants.earned, style: TextStyle(color: Colors.grey[600])),
           ],
          ),
         ],
        ),
       ),
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (_, __) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
        child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceAround,
         children: [
          Column(
           children: [
            const Text(
             '0',
             style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            Text(ProfileConstants.referrals, style: TextStyle(color: Colors.grey[600])),
           ],
          ),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          Column(
           children: [
            const Text(
             '\$0',
             style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            Text(ProfileConstants.earned, style: TextStyle(color: Colors.grey[600])),
           ],
          ),
         ],
        ),
       ),
      ),
      const SizedBox(height: 24),
      const Align(
       alignment: Alignment.centerLeft,
       child: Text(ProfileConstants.howItWorks, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      const SizedBox(height: 12),
      _buildStep(1, ProfileConstants.shareYourCode, ProfileConstants.sendYourCode),
      _buildStep(2, ProfileConstants.friendSignsUp, ProfileConstants.createAccount),
      _buildStep(3, ProfileConstants.bothGetRewarded, ProfileConstants.rewardCredit),
     ],
    ),
   ),
  );
 }
 Widget _buildStep(int number, String title, String description) {
  return Padding(
   padding: const EdgeInsets.only(bottom: 16),
   child: Row(
    children: [
     Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
      child: Center(
       child: Text(
        '$number',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
       ),
      ),
     ),
     const SizedBox(width: 16),
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