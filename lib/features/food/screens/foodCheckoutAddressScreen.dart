import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../constants/foodConstants.dart';
class FoodCheckoutAddressScreen extends ConsumerWidget {
 const FoodCheckoutAddressScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final addressesAsync = ref.watch(FutureProvider((ref) async => <Map<String, dynamic>>[]));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(FoodConstants.deliveryAddressTitle),
   ),
   body: addressesAsync.when(
    data: (addresses) => addresses.isEmpty
      ? Center(
        child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
          const Icon(Icons.location_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(FoodConstants.noAddressesSaved),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: () {}, child: const Text(FoodConstants.addAddress)),
         ],
        ),
       )
      : RadioGroup<int>(
        groupValue: 0,
        onChanged: (v) => context.pop(),
        child: ListView.builder(
         padding: const EdgeInsets.all(16),
         itemCount: addresses.length,
         itemBuilder: (context, index) {
          final address = addresses[index];
          return Card(
           margin: const EdgeInsets.only(bottom: 12),
           child: RadioListTile<int>(
            value: index,
            title: Text(address['label']?.toString() ?? FoodConstants.defaultAddress, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(address['address']?.toString() ?? ''),
            secondary: Container(
             width: 40,
             height: 40,
             decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
             child: const Icon(Icons.location_on, color: AppColors.primary),
            ),
           ),
          );
         },
        ),
       ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(child: Text('${FoodConstants.errorPrefix}$e')),
   ),
   floatingActionButton: FloatingActionButton.extended(onPressed: () {}, icon: const Icon(Icons.add), label: const Text(FoodConstants.addNew)),
  );
 }
}