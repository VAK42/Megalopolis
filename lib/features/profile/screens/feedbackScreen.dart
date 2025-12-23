import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/profileProvider.dart';
import '../constants/profileConstants.dart';
class FeedbackScreen extends ConsumerStatefulWidget {
 const FeedbackScreen({super.key});
 @override
 ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}
class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
 final TextEditingController feedbackController = TextEditingController();
 String selectedCategory = 'General';
 double rating = 0;
 final List<String> categories = ['General', 'Bug Report', 'Feature Request', 'Improvement'];
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ProfileConstants.feedbackTitle),
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      const Text('How Would You Rate Your Experience?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Row(
       mainAxisAlignment: MainAxisAlignment.center,
       children: List.generate(5, (index) {
        return GestureDetector(
         onTap: () => setState(() => rating = index + 1),
         child: Icon(index < rating ? Icons.star : Icons.star_border, size: 40, color: Colors.amber),
        );
       }),
      ),
      const SizedBox(height: 24),
      const Text(ProfileConstants.category, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Wrap(
       spacing: 8,
       runSpacing: 8,
       children: categories.map((category) {
        final isSelected = selectedCategory == category;
        return ChoiceChip(
         label: Text(category),
         selected: isSelected,
         onSelected: (selected) => setState(() => selectedCategory = category),
         selectedColor: AppColors.primary,
         labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
        );
       }).toList(),
      ),
      const SizedBox(height: 24),
      const Text('Your Feedback', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      TextField(
       controller: feedbackController,
       maxLines: 8,
       decoration: InputDecoration(
        hintText: ProfileConstants.feedbackPlaceholder,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
       ),
      ),
      const SizedBox(height: 32),
      AppButton(
       text: ProfileConstants.submitFeedback,
       onPressed: () async {
        final userId = ref.read(currentUserIdProvider) ?? 'user1';
        await ref.read(profileRepositoryProvider).submitFeedback({'userId': userId, 'category': selectedCategory, 'rating': rating.toInt(), 'message': feedbackController.text});
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