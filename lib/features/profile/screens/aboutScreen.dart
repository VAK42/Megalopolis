import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../constants/profileConstants.dart';
class AboutScreen extends ConsumerWidget {
 const AboutScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ProfileConstants.about),
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
     children: [
      const SizedBox(height: 32),
      Container(
       width: 100,
       height: 100,
       decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(20)),
       child: const Icon(Icons.apps, color: Colors.white, size: 50),
      ),
      const SizedBox(height: 16),
      const Text(ProfileConstants.aboutAppName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text(ProfileConstants.versionInfo, style: TextStyle(color: Colors.grey)),
      const SizedBox(height: 32),
      _buildInfoCard(Icons.info, ProfileConstants.appVersion, ProfileConstants.versionNumber),
      _buildInfoCard(Icons.person, ProfileConstants.developedBy, ProfileConstants.companyName),
      _buildInfoCard(Icons.copyright, ProfileConstants.allRightsReserved, ProfileConstants.copyrightYear),
      const SizedBox(height: 24),
      _buildActionButton(Icons.star, ProfileConstants.rateApp, () {}),
      _buildActionButton(Icons.share, ProfileConstants.shareApp, () {}),
      _buildActionButton(Icons.description, ProfileConstants.termsOfService, () {}),
      _buildActionButton(Icons.policy, ProfileConstants.privacyPolicy, () {}),
      _buildActionButton(Icons.article, ProfileConstants.licenses, () {}),
     ],
    ),
   ),
  );
 }
 Widget _buildInfoCard(IconData icon, String title, String value) {
  return Card(
   margin: const EdgeInsets.only(bottom: 12),
   child: ListTile(
    leading: Icon(icon, color: AppColors.primary),
    title: Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
   ),
  );
 }
 Widget _buildActionButton(IconData icon, String title, VoidCallback onTap) {
  return Card(
   margin: const EdgeInsets.only(bottom: 8),
   child: ListTile(
    leading: Icon(icon, color: AppColors.primary),
    title: Text(title),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    onTap: onTap,
   ),
  );
 }
}