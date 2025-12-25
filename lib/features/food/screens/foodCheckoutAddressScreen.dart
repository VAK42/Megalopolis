import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/addressProvider.dart';
import '../../../providers/authProvider.dart';
import '../../../shared/widgets/appButton.dart';
import '../constants/foodConstants.dart';
class FoodCheckoutAddressScreen extends ConsumerStatefulWidget {
 const FoodCheckoutAddressScreen({super.key});
 @override
 ConsumerState<FoodCheckoutAddressScreen> createState() => _FoodCheckoutAddressScreenState();
}
class _FoodCheckoutAddressScreenState extends ConsumerState<FoodCheckoutAddressScreen> {
 String? selectedAddressId;
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider) ?? '1';
  final addressesAsync = ref.watch(addressProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.foodCart)),
    title: const Text(FoodConstants.deliveryAddressTitle),
   ),
   body: Column(
    children: [
     Expanded(
      child: addressesAsync.when(
       data: (addresses) {
        if (addresses.isEmpty) {
         return Center(
          child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
            const Icon(Icons.location_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(FoodConstants.noAddressesSaved),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => _showAddAddressDialog(userId), child: const Text(FoodConstants.addAddress)),
           ],
          ),
         );
        }
        if (selectedAddressId == null && addresses.isNotEmpty) {
         final defaultAddr = addresses.firstWhere((a) => a.isDefault, orElse: () => addresses.first);
         selectedAddressId = defaultAddr.id;
        }
        return ListView.builder(
         padding: const EdgeInsets.all(16),
         itemCount: addresses.length,
         itemBuilder: (context, index) {
          final address = addresses[index];
          final isSelected = address.id == selectedAddressId;
          return Card(
           margin: const EdgeInsets.only(bottom: 12),
           color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : null,
           child: ListTile(
            onTap: () => setState(() => selectedAddressId = address.id),
            leading: Container(
             width: 40, height: 40,
             decoration: BoxDecoration(color: isSelected ? AppColors.primary : Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
             child: Icon(Icons.location_on, color: isSelected ? Colors.white : Colors.grey),
            ),
            title: Text(address.label ?? FoodConstants.defaultAddress, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(address.fullAddress),
            trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.success) : null,
           ),
          );
         },
        );
       },
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (e, _) => Center(child: Text('${FoodConstants.errorPrefix}$e')),
      ),
     ),
     Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)]),
      child: AppButton(
       text: FoodConstants.next,
       onPressed: selectedAddressId != null ? () => context.go(Routes.foodCheckoutPromo) : null,
      ),
     ),
    ],
   ),
   floatingActionButton: FloatingActionButton(onPressed: () => _showAddAddressDialog(userId), child: const Icon(Icons.add)),
  );
 }
 void _showAddAddressDialog(String userId) {
  final controller = TextEditingController();
  showDialog(
   context: context,
   builder: (ctx) => AlertDialog(
    title: const Text(FoodConstants.addAddress),
    content: TextField(controller: controller, decoration: const InputDecoration(hintText: FoodConstants.enterAddress, border: OutlineInputBorder())),
    actions: [
     TextButton(onPressed: () => Navigator.pop(ctx), child: const Text(FoodConstants.cancel)),
     ElevatedButton(
      onPressed: () async {
       if (controller.text.isNotEmpty) {
        await ref.read(addressProvider(userId).notifier).addAddress(label: FoodConstants.homeLabel, fullAddress: controller.text);
        if (ctx.mounted) Navigator.pop(ctx);
       }
      },
      child: const Text(FoodConstants.save),
     ),
    ],
   ),
  );
 }
}