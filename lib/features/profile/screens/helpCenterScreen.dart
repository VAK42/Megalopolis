import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../constants/profileConstants.dart';
class HelpCenterScreen extends ConsumerWidget {
 const HelpCenterScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ProfileConstants.helpSupport),
   ),
   body: ListView(
    padding: const EdgeInsets.all(16),
    children: [
     TextField(
      decoration: InputDecoration(
       hintText: ProfileConstants.searchHelp,
       prefixIcon: const Icon(Icons.search),
       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
     ),
     const SizedBox(height: 24),
     const Text(ProfileConstants.quickActions, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     Row(
      children: [
       Expanded(child: _buildQuickAction(context, Icons.chat, ProfileConstants.liveChat, Routes.supportChat)),
       const SizedBox(width: 12),
       Expanded(child: _buildQuickAction(context, Icons.email, ProfileConstants.emailUs, Routes.supportEmail)),
      ],
     ),
     const SizedBox(height: 24),
     const Text(ProfileConstants.faqs, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     _buildFAQItem(ProfileConstants.faqTrackOrder, ProfileConstants.faqTrackOrderAnswer),
     _buildFAQItem(ProfileConstants.faqChangePassword, ProfileConstants.faqChangePasswordAnswer),
     _buildFAQItem(ProfileConstants.faqAddPayment, ProfileConstants.faqAddPaymentAnswer),
     _buildFAQItem(ProfileConstants.faqCancelBooking, ProfileConstants.faqCancelBookingAnswer),
     const SizedBox(height: 24),
     const Text(ProfileConstants.contactUs, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     _buildContactItem(Icons.phone, ProfileConstants.phoneLabel, ProfileConstants.supportPhone),
     _buildContactItem(Icons.email, ProfileConstants.emailLabel, ProfileConstants.supportEmail),
     _buildContactItem(Icons.location_on, ProfileConstants.addressLabel, ProfileConstants.supportAddress),
    ],
   ),
  );
 }
 Widget _buildQuickAction(BuildContext context, IconData icon, String label, String route) {
  return GestureDetector(
   onTap: () => context.go(route),
   child: Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
    child: Column(
     children: [
      Icon(icon, size: 32, color: AppColors.primary),
      const SizedBox(height: 8),
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
     ],
    ),
   ),
  );
 }
 Widget _buildFAQItem(String question, String answer) {
  return Card(
   margin: const EdgeInsets.only(bottom: 12),
   child: ExpansionTile(
    title: Text(question, style: const TextStyle(fontWeight: FontWeight.w600)),
    children: [
     Padding(
      padding: const EdgeInsets.all(16),
      child: Text(answer, style: TextStyle(color: Colors.grey[700])),
     ),
    ],
   ),
  );
 }
 Widget _buildContactItem(IconData icon, String title, String value) {
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
        Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(color: Colors.grey[700])),
       ],
      ),
     ),
    ],
   ),
  );
 }
}