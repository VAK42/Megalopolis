import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../constants/foodConstants.dart';
class FoodRateDriverScreen extends ConsumerStatefulWidget {
 final String orderId;
 const FoodRateDriverScreen({super.key, required this.orderId});
 @override
 ConsumerState<FoodRateDriverScreen> createState() => _FoodRateDriverScreenState();
}
class _FoodRateDriverScreenState extends ConsumerState<FoodRateDriverScreen> {
 int rating = 0;
 final commentController = TextEditingController();
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(FoodConstants.rateDriverTitle),
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Column(
     children: [
      Container(
       width: 100,
       height: 100,
       decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
       child: const Icon(Icons.person, size: 50, color: Colors.white),
      ),
      const SizedBox(height: 16),
      const Text(FoodConstants.yourDriver, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 24),
      const Text(FoodConstants.howWasExperience, style: TextStyle(fontSize: 16)),
      const SizedBox(height: 16),
      Row(
       mainAxisAlignment: MainAxisAlignment.center,
       children: List.generate(5, (index) {
        return IconButton(
         icon: Icon(index < rating ? Icons.star : Icons.star_border, size: 40, color: Colors.amber[700]),
         onPressed: () => setState(() => rating = index + 1),
        );
       }),
      ),
      const SizedBox(height: 32),
      TextField(
       controller: commentController,
       maxLines: 4,
       decoration: InputDecoration(
        hintText: FoodConstants.shareFeedbackDriver,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
       ),
      ),
      const SizedBox(height: 24),
      Wrap(
       spacing: 8,
       runSpacing: 8,
       children: [FoodConstants.friendly, FoodConstants.professional, FoodConstants.onTime, FoodConstants.carefulDriver].map((tag) {
        return FilterChip(label: Text(tag), selected: false, onSelected: (selected) {});
       }).toList(),
      ),
      const SizedBox(height: 32),
      AppButton(text: FoodConstants.submitRating, onPressed: () => context.go(Routes.foodHome), icon: Icons.send),
     ],
    ),
   ),
  );
 }
 @override
 void dispose() {
  commentController.dispose();
  super.dispose();
 }
}