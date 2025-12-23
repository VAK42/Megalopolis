import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/profileProvider.dart';
import '../constants/profileConstants.dart';
class SupportTicketScreen extends ConsumerStatefulWidget {
 const SupportTicketScreen({super.key});
 @override
 ConsumerState<SupportTicketScreen> createState() => _SupportTicketScreenState();
}
class _SupportTicketScreenState extends ConsumerState<SupportTicketScreen> {
 final TextEditingController titleController = TextEditingController();
 final TextEditingController descriptionController = TextEditingController();
 String selectedCategory = ProfileConstants.orderIssue;
 String selectedPriority = ProfileConstants.medium;
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ProfileConstants.createTicket),
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
       decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
       items: [ProfileConstants.orderIssue, ProfileConstants.paymentProblem, ProfileConstants.technicalSupport, ProfileConstants.accountHelp, ProfileConstants.other].map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
       onChanged: (value) => setState(() => selectedCategory = value!),
      ),
      const SizedBox(height: 16),
      const Text(ProfileConstants.priority, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Row(
       children: [ProfileConstants.low, ProfileConstants.medium, ProfileConstants.high, ProfileConstants.urgent].map((priority) {
        final isSelected = selectedPriority == priority;
        return Expanded(
         child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
           label: Center(child: Text(priority)),
           selected: isSelected,
           onSelected: (selected) => setState(() => selectedPriority = priority),
           selectedColor: AppColors.error,
           labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 12),
          ),
         ),
        );
       }).toList(),
      ),
      const SizedBox(height: 16),
      const Text(ProfileConstants.title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      TextField(
       controller: titleController,
       decoration: InputDecoration(
        hintText: ProfileConstants.briefSummary,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
       ),
      ),
      const SizedBox(height: 16),
      const Text(ProfileConstants.description, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      TextField(
       controller: descriptionController,
       maxLines: 6,
       decoration: InputDecoration(
        hintText: ProfileConstants.describeIssue,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
       ),
      ),
      const SizedBox(height: 24),
      AppButton(
       text: ProfileConstants.createTicket,
       onPressed: () async {
        final userId = ref.read(currentUserIdProvider) ?? 'user1';
        await ref.read(profileRepositoryProvider).createSupportTicket({'userId': userId, 'category': selectedCategory, 'priority': selectedPriority, 'title': titleController.text, 'description': descriptionController.text});
        if (mounted) context.pop();
       },
       icon: Icons.confirmation_number,
      ),
     ],
    ),
   ),
  );
 }
}