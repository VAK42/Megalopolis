import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../constants/foodConstants.dart';
class FoodCartEmptyScreen extends ConsumerWidget {
 const FoodCartEmptyScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.foodHome)),
    title: const Text(FoodConstants.cartTitle),
   ),
   body: Center(
    child: Padding(
     padding: const EdgeInsets.all(32),
     child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
        child: const Icon(Icons.shopping_cart_outlined, size: 60, color: AppColors.primary),
       ),
       const SizedBox(height: 32),
       const Text(FoodConstants.cartEmpty, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
       const SizedBox(height: 8),
       Text(FoodConstants.addItemsToStart, style: const TextStyle(color: Colors.grey, fontSize: 16)),
       const SizedBox(height: 32),
       AppButton(text: FoodConstants.startShopping, onPressed: () => context.go(Routes.foodHome), icon: Icons.restaurant),
      ],
     ),
    ),
   ),
  );
 }
}