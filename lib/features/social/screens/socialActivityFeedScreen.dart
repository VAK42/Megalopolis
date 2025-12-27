import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/socialProvider.dart';
import '../constants/socialConstants.dart';
class SocialActivityFeedScreen extends ConsumerWidget {
 const SocialActivityFeedScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
   return Scaffold(
    appBar: AppBar(
     leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
     title: const Text(SocialConstants.friendActivity),
    ),
    body: const Center(child: Text(SocialConstants.pleaseLoginToSeeActivity)),
   );
  }
  final activityAsync = ref.watch(activityFeedProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(SocialConstants.friendActivity),
   ),
   body: activityAsync.when(
    data: (activities) {
     if (activities.isEmpty) {
      return const Center(child: Text(SocialConstants.noRecentActivity));
     }
     return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activities.length,
      itemBuilder: (c, i) {
       final activity = activities[i];
       return Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
         padding: const EdgeInsets.all(12),
         child: Row(
          children: [
           const CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, color: Colors.white),
           ),
           const SizedBox(width: 12),
           Expanded(
            child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
              Text(_toTitleCase(activity['targetType']?.toString() ?? SocialConstants.activity), style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(activity['comment'] ?? SocialConstants.performedAnAction),
             ],
            ),
           ),
          ],
         ),
        ),
       );
      },
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(SocialConstants.errorLoadingActivity)),
   ),
  );
 }
 String _toTitleCase(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
 }
}