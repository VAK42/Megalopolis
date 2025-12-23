import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../constants/foodConstants.dart';
class FoodPaymentProcessingScreen extends ConsumerStatefulWidget {
 const FoodPaymentProcessingScreen({super.key});
 @override
 ConsumerState<FoodPaymentProcessingScreen> createState() => _FoodPaymentProcessingScreenState();
}
class _FoodPaymentProcessingScreenState extends ConsumerState<FoodPaymentProcessingScreen> {
 @override
 void initState() {
  super.initState();
  Future.delayed(const Duration(seconds: 3), () {
   if (mounted) context.go(Routes.foodOrderPlaced);
  });
 }
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   body: Container(
    decoration: BoxDecoration(gradient: AppColors.primaryGradient),
    child: Center(
     child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       const CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
       const SizedBox(height: 32),
       const Text(
        FoodConstants.paymentProcessingTitle,
        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
       ),
       const SizedBox(height: 12),
       const Text(FoodConstants.pleaseWait, style: TextStyle(color: Colors.white70)),
      ],
     ),
    ),
   ),
  );
 }
}