import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/socialProvider.dart';
import '../constants/socialConstants.dart';
class SocialGiftScreen extends ConsumerStatefulWidget {
 const SocialGiftScreen({super.key});
 @override
 ConsumerState<SocialGiftScreen> createState() => _SocialGiftScreenState();
}
class _SocialGiftScreenState extends ConsumerState<SocialGiftScreen> {
 String selectedGiftType = 'giftCard';
 double giftAmount = 10.0;
 final messageController = TextEditingController();
 String? selectedFriendId;
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final friendsAsync = ref.watch(friendsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(SocialConstants.sendGift),
   ),
   body: ListView(
    padding: const EdgeInsets.all(16),
    children: [
     const Text(SocialConstants.selectFriends, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     friendsAsync.when(
      data: (friends) => Column(
       children: friends
         .map(
          (f) => Card(
           margin: const EdgeInsets.only(bottom: 8),
           child: ListTile(
            leading: Icon(selectedFriendId == f['id']?.toString() ? Icons.check_circle : Icons.circle_outlined, color: selectedFriendId == f['id']?.toString() ? AppColors.primary : Colors.grey),
            title: Text(f['name']?.toString() ?? SocialConstants.user),
            onTap: () => setState(() => selectedFriendId = f['id']?.toString()),
           ),
          ),
         )
         .toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Text(SocialConstants.errorLoadingFriends),
     ),
     const SizedBox(height: 24),
     const Text(SocialConstants.selectGift, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     _buildGiftOption('giftCard', SocialConstants.giftCard, Icons.card_giftcard),
     _buildGiftOption('rideCredits', SocialConstants.rideCredits, Icons.directions_car),
     _buildGiftOption('foodVoucher', SocialConstants.foodVoucher, Icons.restaurant),
     const SizedBox(height: 24),
     const Text(SocialConstants.giftAmount, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     Slider(value: giftAmount, min: 5, max: 100, divisions: 19, label: '\$${giftAmount.toInt()}', onChanged: (v) => setState(() => giftAmount = v)),
     Center(
      child: Text(
       '\$${giftAmount.toInt()}',
       style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
      ),
     ),
     const SizedBox(height: 24),
     const Text(SocialConstants.addMessage, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
     const SizedBox(height: 12),
     TextField(
      controller: messageController,
      maxLines: 3,
      decoration: InputDecoration(
       hintText: SocialConstants.addMessage,
       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
     ),
     const SizedBox(height: 24),
     ElevatedButton(
      onPressed: selectedFriendId != null
        ? () async {
          await ref.read(socialRepositoryProvider).sendGift(userId, selectedFriendId!, selectedGiftType, giftAmount, messageController.text);
          if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(SocialConstants.giftSent)));
           context.pop();
          }
         }
        : null,
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.all(16)),
      child: const Text(SocialConstants.sendGiftButton, style: TextStyle(color: Colors.white)),
     ),
    ],
   ),
  );
 }
 Widget _buildGiftOption(String type, String label, IconData icon) {
  final isSelected = selectedGiftType == type;
  return Card(
   margin: const EdgeInsets.only(bottom: 8),
   child: ListTile(
    leading: Icon(icon, color: isSelected ? AppColors.primary : Colors.grey),
    title: Text(label, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
    trailing: Icon(isSelected ? Icons.check_circle : Icons.circle_outlined, color: isSelected ? AppColors.primary : Colors.grey),
    onTap: () => setState(() => selectedGiftType = type),
   ),
  );
 }
}