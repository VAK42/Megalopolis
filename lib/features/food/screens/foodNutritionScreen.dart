import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/foodProvider.dart';
import '../constants/foodConstants.dart';
class FoodNutritionScreen extends ConsumerWidget {
 final String itemId;
 const FoodNutritionScreen({super.key, required this.itemId});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final itemAsync = ref.watch(foodItemProvider(itemId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(FoodConstants.nutritionTitle),
   ),
   body: itemAsync.when(
    data: (item) {
     if (item == null) return const Center(child: Text(FoodConstants.itemNotFound));
     Map<String, dynamic> nutrition = {};
     try {
      final itemMetadata = item['metadata'] as String?;
      if (itemMetadata != null && itemMetadata.isNotEmpty) {
       final metadata = jsonDecode(itemMetadata);
       if (metadata != null && metadata['nutrition'] != null) {
        nutrition = Map<String, dynamic>.from(metadata['nutrition']);
       }
      }
     } catch (e) {}
     final calories = nutrition['calories']?.toString() ?? 'N/A';
     final protein = nutrition['protein']?.toString() ?? 'N/A';
     final fat = nutrition['fat']?.toString() ?? 'N/A';
     final carbs = nutrition['carbs']?.toString() ?? 'N/A';
     final fiber = nutrition['fiber']?.toString() ?? 'N/A';
     final sugar = nutrition['sugar']?.toString() ?? 'N/A';
     final sodium = nutrition['sodium']?.toString() ?? 'N/A';
     final cholesterol = nutrition['cholesterol']?.toString() ?? 'N/A';
     final vitaminA = nutrition['vitaminA']?.toString() ?? 'N/A';
     final vitaminC = nutrition['vitaminC']?.toString() ?? 'N/A';
     final calcium = nutrition['calcium']?.toString() ?? 'N/A';
     final iron = nutrition['iron']?.toString() ?? 'N/A';
     return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Text(item['name'] as String? ?? FoodConstants.defaultItem, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(FoodConstants.perServing, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 24),
        Container(
         padding: const EdgeInsets.all(20),
         decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
         child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
           Column(
            children: [
             Text(
              calories,
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
             ),
             Text(FoodConstants.calories, style: const TextStyle(color: Colors.white70)),
            ],
           ),
           Column(
            children: [
             Text(
              protein,
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
             ),
             Text(FoodConstants.protein, style: const TextStyle(color: Colors.white70)),
            ],
           ),
           Column(
            children: [
             Text(
              fat,
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
             ),
             Text(FoodConstants.fat, style: const TextStyle(color: Colors.white70)),
            ],
           ),
          ],
         ),
        ),
        const SizedBox(height: 24),
        Text(FoodConstants.detailedInfo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildNutrientRow(FoodConstants.totalCarbs, carbs, _calculateProgress(carbs, FoodConstants.dvCarbs)),
        _buildNutrientRow(FoodConstants.dietaryFiber, fiber, _calculateProgress(fiber, FoodConstants.dvFiber)),
        _buildNutrientRow(FoodConstants.sugars, sugar, _calculateProgress(sugar, FoodConstants.dvSugar)),
        _buildNutrientRow(FoodConstants.sodium, sodium, _calculateProgress(sodium, FoodConstants.dvSodium)),
        _buildNutrientRow(FoodConstants.cholesterol, cholesterol, _calculateProgress(cholesterol, FoodConstants.dvCholesterol)),
        _buildNutrientRow(FoodConstants.vitaminA, vitaminA, _calculateProgress(vitaminA, FoodConstants.dvStandard, isPercentage: true)),
        _buildNutrientRow(FoodConstants.vitaminC, vitaminC, _calculateProgress(vitaminC, FoodConstants.dvStandard, isPercentage: true)),
        _buildNutrientRow(FoodConstants.calcium, calcium, _calculateProgress(calcium, FoodConstants.dvStandard, isPercentage: true)),
        _buildNutrientRow(FoodConstants.iron, iron, _calculateProgress(iron, FoodConstants.dvStandard, isPercentage: true)),
        const SizedBox(height: 24),
        Container(
         padding: const EdgeInsets.all(16),
         decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange[200]!),
         ),
         child: Row(
          children: [
           const Icon(Icons.info_outline, color: Colors.orange),
           const SizedBox(width: 12),
           Expanded(child: Text(FoodConstants.calorieDisclaimer, style: const TextStyle(fontSize: 12))),
          ],
         ),
        ),
       ],
      ),
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(child: Text('${FoodConstants.errorPrefix}$e')),
   ),
  );
 }
 double _calculateProgress(String value, double standard, {bool isPercentage = false}) {
  if (value == 'N/A') return 0.0;
  try {
   String cleanValue = value.replaceAll(RegExp(r'[^0-9.]'), '');
   if (cleanValue.isEmpty) return 0.0;
   double numValue = double.parse(cleanValue);
   if (isPercentage || value.contains('%')) {
    return numValue / 100;
   }
   return (numValue / standard).clamp(0.0, 1.0);
  } catch (e) {
   return 0.0;
  }
 }
 Widget _buildNutrientRow(String name, String value, double percentage) {
  return Container(
   margin: const EdgeInsets.only(bottom: 12),
   padding: const EdgeInsets.all(12),
   decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
   child: Column(
    children: [
     Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
       Text(value, style: TextStyle(color: Colors.grey[700])),
      ],
     ),
     const SizedBox(height: 8),
     LinearProgressIndicator(value: percentage, backgroundColor: Colors.grey[300], valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary), minHeight: 4, borderRadius: BorderRadius.circular(2)),
    ],
   ),
  );
 }
}