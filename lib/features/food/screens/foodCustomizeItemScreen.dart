import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/foodProvider.dart';
import '../../../shared/widgets/appButton.dart';
import '../constants/foodConstants.dart';
class FoodCustomizeItemScreen extends ConsumerStatefulWidget {
 final String itemId;
 const FoodCustomizeItemScreen({super.key, required this.itemId});
 @override
 ConsumerState<FoodCustomizeItemScreen> createState() => _FoodCustomizeItemScreenState();
}
class _FoodCustomizeItemScreenState extends ConsumerState<FoodCustomizeItemScreen> {
 Map<String, dynamic>? selectedSize;
 final Set<Map<String, dynamic>> selectedToppings = {};
 int quantity = 1;
 final TextEditingController instructionsController = TextEditingController();
 Map<String, dynamic>? metadata;
 bool _initialized = false;
 @override
 Widget build(BuildContext context) {
  final itemAsync = ref.watch(foodItemProvider(widget.itemId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(FoodConstants.customizeTitle),
   ),
   body: itemAsync.when(
    data: (item) {
     if (item == null) {
      return Center(child: Text(FoodConstants.noItems));
     }
     if (!_initialized) {
      try {
       final itemMetadata = item['metadata'] as String?;
       if (itemMetadata != null && itemMetadata.isNotEmpty) {
        try {
         metadata = jsonDecode(itemMetadata);
        } catch (e) {}
        if (metadata != null && metadata!['sizes'] != null && (metadata!['sizes'] as List).isNotEmpty) {
         selectedSize = (metadata!['sizes'] as List).first;
        }
       }
      } catch (e) {
       debugPrint('${FoodConstants.errorParsingMetadata}$e');
      }
      _initialized = true;
     }
     final sizes = metadata != null && metadata!['sizes'] != null ? List<Map<String, dynamic>>.from(metadata!['sizes']) : <Map<String, dynamic>>[];
     final toppings = metadata != null && metadata!['toppings'] != null ? List<Map<String, dynamic>>.from(metadata!['toppings']) : <Map<String, dynamic>>[];
     return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Text(item['name'] as String? ?? FoodConstants.defaultItem, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(item['description'] as String? ?? FoodConstants.deliciousAndFresh, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 24),
        if (sizes.isNotEmpty) ...[
         Text(FoodConstants.size, style: Theme.of(context).textTheme.titleLarge),
         const SizedBox(height: 12),
         RadioGroup<Map<String, dynamic>>(
          groupValue: selectedSize,
          onChanged: (value) => setState(() => selectedSize = value),
          child: Column(
           children: sizes.map((size) => RadioListTile<Map<String, dynamic>>(title: Text('${size['name']} (\$${size['price']})'), value: size)).toList(),
          ),
         ),
         const SizedBox(height: 16),
        ],
        if (toppings.isNotEmpty) ...[
         Text(FoodConstants.customizeTitle, style: Theme.of(context).textTheme.titleLarge),
         const SizedBox(height: 12),
         ...toppings.map(
          (topping) => CheckboxListTile(
           title: Text('${topping['name']} (+\$${topping['price']})'),
           value: selectedToppings.contains(topping),
           onChanged: (value) {
            setState(() {
             if (value == true) {
              selectedToppings.add(topping);
             } else {
              selectedToppings.remove(topping);
             }
            });
           },
          ),
         ),
         const SizedBox(height: 16),
        ],
        Text(FoodConstants.quantity, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Row(
         children: [
          IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => setState(() => quantity = quantity > 1 ? quantity - 1 : 1)),
          Text('$quantity', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => setState(() => quantity++)),
         ],
        ),
        const SizedBox(height: 16),
        Text(FoodConstants.specialInstructions, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        TextField(
         controller: instructionsController,
         maxLines: 3,
         decoration: InputDecoration(
          hintText: FoodConstants.noteHint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
         ),
        ),
       ],
      ),
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(child: Text('${FoodConstants.errorPrefix}$e')),
   ),
   bottomNavigationBar: Padding(
    padding: const EdgeInsets.all(16),
    child: AppButton(
     text: '${FoodConstants.addToCart} - \$${(itemAsync.value != null ? _calculateTotal((itemAsync.value!['price'] as num?)?.toDouble() ?? 0.0) : 0.0).toStringAsFixed(2)}',
     onPressed: () async {
      final userIdStr = ref.read(currentUserIdProvider);
      final userId = userIdStr ?? '1';
      await ref.read(foodCartProvider(userId).notifier).addItem(widget.itemId, quantity);
      if (context.mounted) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(FoodConstants.addedToCartSuffix)));
       context.pop();
      }
     },
     icon: Icons.shopping_cart,
    ),
   ),
  );
 }
 double _calculateTotal(double baseItemPrice) {
  double basePrice = (selectedSize != null ? (selectedSize!['price'] as num).toDouble() : baseItemPrice);
  double toppingsPrice = selectedToppings.fold(0, (sum, topping) => sum + (topping['price'] as num).toDouble());
  return (basePrice + toppingsPrice) * quantity;
 }
 @override
 void dispose() {
  instructionsController.dispose();
  super.dispose();
 }
}