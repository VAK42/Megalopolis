import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../constants/foodConstants.dart';
class FoodAllergiesScreen extends ConsumerStatefulWidget {
 const FoodAllergiesScreen({super.key});
 @override
 ConsumerState<FoodAllergiesScreen> createState() => _FoodAllergiesScreenState();
}
class _FoodAllergiesScreenState extends ConsumerState<FoodAllergiesScreen> {
 final Set<String> selectedAllergies = {};
 final Set<String> selectedPreferences = {};
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(FoodConstants.allergiesTitle),
    actions: [TextButton(onPressed: () => context.pop(), child: const Text(FoodConstants.save))],
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Text(FoodConstants.allergyDescription, style: const TextStyle(color: Colors.grey)),
      const SizedBox(height: 24),
      Text(FoodConstants.commonAllergies, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Wrap(spacing: 8, runSpacing: 8, children: [FoodConstants.peanuts, FoodConstants.treeNuts, FoodConstants.dairy, FoodConstants.eggs, FoodConstants.gluten, FoodConstants.soy, FoodConstants.shellfish, FoodConstants.fish].map((allergy) => _buildChip(allergy, selectedAllergies)).toList()),
      const SizedBox(height: 24),
      Text(FoodConstants.dietaryPreferences, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Wrap(spacing: 8, runSpacing: 8, children: [FoodConstants.vegetarian, FoodConstants.vegan, FoodConstants.halal, FoodConstants.kosher, FoodConstants.organic].map((pref) => _buildChip(pref, selectedPreferences)).toList()),
     ],
    ),
   ),
  );
 }
 Widget _buildChip(String label, Set<String> selectedSet) {
  final isSelected = selectedSet.contains(label);
  return FilterChip(
   label: Text(label),
   selected: isSelected,
   selectedColor: AppColors.primary.withValues(alpha: 0.2),
   checkmarkColor: AppColors.primary,
   onSelected: (selected) {
    setState(() {
     if (selected) {
      selectedSet.add(label);
     } else {
      selectedSet.remove(label);
     }
    });
   },
  );
 }
}