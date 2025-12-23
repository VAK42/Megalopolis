import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/profileProvider.dart';
import '../constants/profileConstants.dart';
class ProfileScreen extends ConsumerWidget {
 const ProfileScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userAsync = ref.watch(authProvider);
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final statsAsync = ref.watch(userStatsProvider(userId));
  return Scaffold(
   body: SafeArea(
    child: SingleChildScrollView(
     child: Column(
      children: [
       Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        child: Column(
         children: [
          Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
            IconButton(
             icon: const Icon(Icons.arrow_back, color: Colors.white),
             onPressed: () => context.pop(),
            ),
            IconButton(
             icon: const Icon(Icons.settings, color: Colors.white),
             onPressed: () => context.go(Routes.settings),
            ),
           ],
          ),
          const SizedBox(height: 16),
          Stack(
           children: [
            Container(
             width: 100,
             height: 100,
             decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
             ),
             child: const Icon(Icons.person, size: 50, color: AppColors.primary),
            ),
            Positioned(
             bottom: 0,
             right: 0,
             child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.camera_alt, size: 20, color: AppColors.primary),
             ),
            ),
           ],
          ),
          const SizedBox(height: 16),
          userAsync.when(
           data: (user) => Column(
            children: [
             Text(
              user?.name ?? ProfileConstants.guestUser,
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
             ),
             Text(user?.phone ?? user?.email ?? '', style: const TextStyle(color: Colors.white70)),
            ],
           ),
           loading: () => const Column(
            children: [
             CircularProgressIndicator(color: Colors.white),
             SizedBox(height: 8),
             Text(ProfileConstants.loading, style: TextStyle(color: Colors.white70)),
            ],
           ),
           error: (_, __) => const Text(ProfileConstants.errorLoadingProfile, style: TextStyle(color: Colors.white70)),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
           onPressed: () => context.go(Routes.profileEdit),
           icon: const Icon(Icons.edit),
           label: const Text(ProfileConstants.editProfile),
           style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary),
          ),
         ],
        ),
       ),
       Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
         children: [
          statsAsync.when(
           data: (stats) => Row(
            children: [
             Expanded(child: _buildStatCard(ProfileConstants.orders, '${stats['ordersCount'] ?? 0}')),
             const SizedBox(width: 12),
             Expanded(child: _buildStatCard(ProfileConstants.points, '${stats['points'] ?? 0}')),
             const SizedBox(width: 12),
             Expanded(child: _buildStatCard(ProfileConstants.rewards, '${stats['rewards'] ?? 0}')),
            ],
           ),
           loading: () => Row(
            children: [
             Expanded(child: _buildStatCard(ProfileConstants.orders, '...')),
             const SizedBox(width: 12),
             Expanded(child: _buildStatCard(ProfileConstants.points, '...')),
             const SizedBox(width: 12),
             Expanded(child: _buildStatCard(ProfileConstants.rewards, '...')),
            ],
           ),
           error: (_, __) => Row(
            children: [
             Expanded(child: _buildStatCard(ProfileConstants.orders, '0')),
             const SizedBox(width: 12),
             Expanded(child: _buildStatCard(ProfileConstants.points, '0')),
             const SizedBox(width: 12),
             Expanded(child: _buildStatCard(ProfileConstants.rewards, '0')),
            ],
           ),
          ),
          const SizedBox(height: 24),
          _buildMenuItem(Icons.qr_code, ProfileConstants.myQrCode, () => context.go(Routes.profileQr)),
          _buildMenuItem(Icons.card_membership, ProfileConstants.membership, () => context.go(Routes.membership)),
          _buildMenuItem(Icons.location_on, ProfileConstants.addresses, () => context.go(Routes.addresses)),
          _buildMenuItem(Icons.payment, ProfileConstants.paymentMethods, () => context.go(Routes.paymentMethods)),
          _buildMenuItem(Icons.notifications, ProfileConstants.notifications, () => context.go(Routes.notificationSettings)),
          _buildMenuItem(Icons.privacy_tip, ProfileConstants.privacy, () => context.go(Routes.privacySettings)),
          _buildMenuItem(Icons.help, ProfileConstants.helpSupport, () => context.go(Routes.helpCenter)),
          _buildMenuItem(Icons.info, ProfileConstants.about, () => context.go(Routes.about)),
          _buildMenuItem(Icons.logout, ProfileConstants.logout, () {}, isDestructive: true),
         ],
        ),
       ),
      ],
     ),
    ),
   ),
  );
 }
 Widget _buildStatCard(String label, String value) {
  return Container(
   padding: const EdgeInsets.all(16),
   decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
   child: Column(
    children: [
     Text(
      value,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
     ),
     const SizedBox(height: 4),
     Text(
      label,
      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      textAlign: TextAlign.center,
     ),
    ],
   ),
  );
 }
 Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
  return Card(
   margin: const EdgeInsets.only(bottom: 8),
   child: ListTile(
    leading: Icon(icon, color: isDestructive ? AppColors.error : AppColors.primary),
    title: Text(title, style: TextStyle(color: isDestructive ? AppColors.error : null)),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    onTap: onTap,
   ),
  );
 }
}