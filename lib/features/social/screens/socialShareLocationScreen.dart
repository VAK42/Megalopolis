import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/socialProvider.dart';
import '../constants/socialConstants.dart';
class SocialShareLocationScreen extends ConsumerStatefulWidget {
 const SocialShareLocationScreen({super.key});
 @override
 ConsumerState<SocialShareLocationScreen> createState() => _SocialShareLocationScreenState();
}
class _SocialShareLocationScreenState extends ConsumerState<SocialShareLocationScreen> {
 bool isSharing = false;
 List<String> selectedFriends = [];
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final friendsAsync = ref.watch(friendsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(SocialConstants.shareLocation),
   ),
   body: Column(
    children: [
     Container(
      height: 200,
      color: Colors.grey[200],
      child: const Center(child: Icon(Icons.map, size: 100, color: Colors.grey)),
     ),
     Expanded(
      child: ListView(
       padding: const EdgeInsets.all(16),
       children: [
        Card(
         child: ListTile(
          leading: Icon(isSharing ? Icons.location_on : Icons.location_off, color: isSharing ? AppColors.success : Colors.grey),
          title: Text(SocialConstants.yourLocation),
          subtitle: Text(isSharing ? SocialConstants.locationShared : SocialConstants.locationStopped),
          trailing: Switch(value: isSharing, onChanged: (v) => setState(() => isSharing = v)),
         ),
        ),
        const SizedBox(height: 16),
        const Text(SocialConstants.selectFriends, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        friendsAsync.when(
         data: (friends) => Column(
          children: friends.map((f) {
           final fId = f['id']?.toString() ?? '';
           final isSelected = selectedFriends.contains(fId);
           return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
             leading: Icon(isSelected ? Icons.check_circle : Icons.circle_outlined, color: isSelected ? AppColors.primary : Colors.grey),
             title: Text(f['name']?.toString() ?? SocialConstants.user),
             onTap: () {
              setState(() {
               if (isSelected) {
                selectedFriends.remove(fId);
               } else {
                selectedFriends.add(fId);
               }
              });
             },
            ),
           );
          }).toList(),
         ),
         loading: () => const Center(child: CircularProgressIndicator()),
         error: (_, __) => const Text(SocialConstants.errorLoadingFriends),
        ),
       ],
      ),
     ),
     Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
       width: double.infinity,
       child: ElevatedButton(
        onPressed: selectedFriends.isNotEmpty
          ? () async {
            if (isSharing) {
             await ref.read(socialRepositoryProvider).shareLocation(userId, selectedFriends, 0.0, 0.0);
             if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(SocialConstants.locationShared)));
            }
           }
          : null,
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.all(16)),
        child: Text(isSharing ? SocialConstants.shareWithFriends : SocialConstants.startSharing, style: const TextStyle(color: Colors.white)),
       ),
      ),
     ),
    ],
   ),
  );
 }
}