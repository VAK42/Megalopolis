import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/profileProvider.dart';
import '../constants/profileConstants.dart';
class SupportEmailScreen extends ConsumerStatefulWidget {
 const SupportEmailScreen({super.key});
 @override
 ConsumerState<SupportEmailScreen> createState() => _SupportEmailScreenState();
}
class _SupportEmailScreenState extends ConsumerState<SupportEmailScreen> {
 final TextEditingController subjectController = TextEditingController();
 final TextEditingController messageController = TextEditingController();
 String selectedCategory = ProfileConstants.generalInquiry;
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ProfileConstants.emailSupport),
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      const Text(ProfileConstants.category, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      DropdownButtonFormField<String>(
       initialValue: selectedCategory,
       decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: const Icon(Icons.category),
       ),
       items: [ProfileConstants.generalInquiry, ProfileConstants.orderIssue, ProfileConstants.paymentProblem, ProfileConstants.accountHelp, ProfileConstants.technicalSupport, ProfileConstants.feedback].map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
       onChanged: (value) => setState(() => selectedCategory = value!),
      ),
      const SizedBox(height: 24),
      const Text(ProfileConstants.subject, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      TextField(
       controller: subjectController,
       decoration: InputDecoration(
        hintText: ProfileConstants.briefDescription,
        prefixIcon: const Icon(Icons.subject),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
       ),
      ),
      const SizedBox(height: 24),
      const Text(ProfileConstants.message, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      TextField(
       controller: messageController,
       maxLines: 8,
       decoration: InputDecoration(
        hintText: ProfileConstants.describeIssue,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
       ),
      ),
      const SizedBox(height: 24),
      Container(
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
       ),
       child: Row(
        children: [
         const Icon(Icons.info_outline, color: AppColors.primary),
         const SizedBox(width: 12),
         Expanded(child: Text(ProfileConstants.respondWithin24, style: const TextStyle(fontSize: 12))),
        ],
       ),
      ),
      const SizedBox(height: 32),
      AppButton(
       text: ProfileConstants.sendEmail,
       onPressed: () async {
        final userId = ref.read(currentUserIdProvider) ?? 'user1';
        await ref.read(profileRepositoryProvider).createSupportTicket({'userId': userId, 'category': selectedCategory, 'title': subjectController.text, 'description': messageController.text, 'type': 'email'});
        if (mounted) context.pop();
       },
       icon: Icons.send,
      ),
     ],
    ),
   ),
  );
 }
}