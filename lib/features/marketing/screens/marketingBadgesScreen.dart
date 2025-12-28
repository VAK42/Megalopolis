import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/marketingProvider.dart';
import '../../../providers/authProvider.dart';
import '../../marketing/constants/marketingConstants.dart';
class MarketingBadgesScreen extends ConsumerWidget {
 const MarketingBadgesScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider).toString();
  return Scaffold(
   appBar: AppBar(title: const Text(MarketingConstants.badgesTitle)),
   body: ref
     .watch(userBadgesProvider(userId))
     .when(
      data: (badges) => GridView.builder(
       padding: const EdgeInsets.all(8),
       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8),
       itemCount: badges.length,
       itemBuilder: (c, i) {
        final unlocked = badges[i]['achieved'] == true || badges[i]['earnedAt'] != null;
        final badgeId = badges[i]['id']?.toString();
        final colors = [Colors.amber, Colors.teal, Colors.purple, Colors.orange, Colors.pink, Colors.indigo];
        final badgeColor = colors[i % colors.length];
        return GestureDetector(
         onLongPress: unlocked && badgeId != null ? () => _showDeleteDialog(context, ref, badgeId, userId) : null,
         child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.circular(16),
           border: Border.all(color: unlocked ? badgeColor : Colors.grey.shade300, width: 2),
          ),
          child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
            Icon(Icons.emoji_events, size: 40, color: unlocked ? badgeColor : Colors.grey),
            const SizedBox(height: 8),
            Text(
             badges[i]['name']?.toString() ?? MarketingConstants.badgeDefaultName,
             textAlign: TextAlign.center,
             style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: unlocked ? badgeColor.shade700 : Colors.grey),
            ),
           ],
          ),
         ),
        );
       },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text(MarketingConstants.errorLoadingBadges)),
     ),
  );
 }
 void _showDeleteDialog(BuildContext context, WidgetRef ref, String badgeId, String userId) {
  showDialog(
   context: context,
   builder: (ctx) => AlertDialog(
    title: const Text(MarketingConstants.deleteBadgeTitle),
    content: const Text(MarketingConstants.deleteBadgeMessage),
    actions: [
     TextButton(onPressed: () => Navigator.pop(ctx), child: const Text(MarketingConstants.cancel)),
     TextButton(
      onPressed: () async {
       await ref.read(userBadgesProvider(userId).notifier).deleteBadge(badgeId);
       if (ctx.mounted) Navigator.pop(ctx);
       if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(MarketingConstants.badgeDeleted)));
       }
      },
      child: Text(MarketingConstants.delete, style: TextStyle(color: AppColors.error)),
     ),
    ],
   ),
  );
 }
}