import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/foodProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/foodConstants.dart';
class FoodGroupOrderScreen extends ConsumerWidget {
 const FoodGroupOrderScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userIdStr = ref.watch(currentUserIdProvider);
  final userId = userIdStr ?? '1';
  final cartAsync = ref.watch(foodCartProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(FoodConstants.groupOrderTitle),
   ),
   body: cartAsync.when(
    data: (cart) => SingleChildScrollView(
     padding: const EdgeInsets.all(16),
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
        child: Column(
         children: [
          const Icon(Icons.group, size: 48, color: Colors.white),
          const SizedBox(height: 16),
          const Text(
           FoodConstants.startGroupOrder,
           style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(FoodConstants.inviteFriends, style: const TextStyle(color: Colors.white70)),
         ],
        ),
       ),
       const SizedBox(height: 24),
       Text(FoodConstants.howItWorks, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
       const SizedBox(height: 16),
       _buildStep('1', FoodConstants.startGroupOrder),
       _buildStep('2', FoodConstants.shareLink),
       _buildStep('3', FoodConstants.everyoneAddsItems),
       _buildStep('4', FoodConstants.placeOrderTogether),
       const SizedBox(height: 24),
       SizedBox(
        width: double.infinity,
        child: ElevatedButton(
         onPressed: () {},
         style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
         child: const Text(FoodConstants.startGroupOrder),
        ),
       ),
      ],
     ),
    ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(child: Text('${FoodConstants.errorPrefix}$e')),
   ),
  );
 }
 Widget _buildStep(String number, String text) {
  return Padding(
   padding: const EdgeInsets.only(bottom: 16),
   child: Row(
    children: [
     Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
      child: Center(
       child: Text(
        number,
        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
       ),
      ),
     ),
     const SizedBox(width: 16),
     Text(text, style: const TextStyle(fontSize: 16)),
    ],
   ),
  );
 }
}