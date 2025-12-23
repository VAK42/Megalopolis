import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../constants/foodConstants.dart';
class FoodRateFoodScreen extends ConsumerStatefulWidget {
 final String orderId;
 const FoodRateFoodScreen({super.key, required this.orderId});
 @override
 ConsumerState<FoodRateFoodScreen> createState() => _FoodRateFoodScreenState();
}
class _FoodRateFoodScreenState extends ConsumerState<FoodRateFoodScreen> {
 int rating = 0;
 final commentController = TextEditingController();
 @override
 void dispose() {
  commentController.dispose();
  super.dispose();
 }
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(FoodConstants.rateFoodTitle),
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Column(
     children: [
      Container(
       width: 100,
       height: 100,
       decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(50)),
       child: const Icon(Icons.restaurant, size: 50, color: Colors.white),
      ),
      const SizedBox(height: 24),
      const Text(FoodConstants.howWasYourFood, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 24),
      Row(
       mainAxisAlignment: MainAxisAlignment.center,
       children: List.generate(5, (index) {
        return IconButton(
         icon: Icon(index < rating ? Icons.star : Icons.star_border, color: Colors.amber, size: 40),
         onPressed: () => setState(() => rating = index + 1),
        );
       }),
      ),
      const SizedBox(height: 24),
      TextField(
       controller: commentController,
       maxLines: 4,
       decoration: InputDecoration(
        hintText: FoodConstants.addCommentOptional,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
       ),
      ),
      const SizedBox(height: 32),
      AppButton(
       text: FoodConstants.submitRating,
       onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(FoodConstants.thankYouForRating)));
        context.go(Routes.foodHome);
       },
      ),
     ],
    ),
   ),
  );
 }
}