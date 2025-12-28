import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/addressProvider.dart';
import '../constants/profileConstants.dart';
class AddressesScreen extends ConsumerWidget {
 const AddressesScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? '';
  final addressesAsync = ref.watch(addressProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ProfileConstants.myAddresses),
   ),
   body: addressesAsync.when(
    data: (addresses) => ListView(
     padding: const EdgeInsets.all(16),
     children: [
      ...addresses.map((address) => _buildAddressCard(context, ref, address, userId)),
      const SizedBox(height: 8),
      OutlinedButton.icon(
       onPressed: () => context.go(Routes.addressAdd),
       icon: const Icon(Icons.add),
       label: const Text(ProfileConstants.addNewAddress),
       style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
      ),
     ],
    ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => Center(
     child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       const Text(ProfileConstants.noAddressesFound),
       const SizedBox(height: 16),
       OutlinedButton.icon(onPressed: () => context.go(Routes.addressAdd), icon: const Icon(Icons.add), label: const Text(ProfileConstants.addNewAddress)),
      ],
     ),
    ),
   ),
  );
 }
 Widget _buildAddressCard(BuildContext context, WidgetRef ref, Address address, String userId) {
  return Card(
   margin: const EdgeInsets.only(bottom: 12),
   child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
        Row(
         children: [
          Container(
           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
           decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
           child: Text(
            address.label ?? ProfileConstants.addressDefault,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
           ),
          ),
          if (address.isDefault) ...[
           const SizedBox(width: 8),
           Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: const Text(
             ProfileConstants.defaultLabel,
             style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success),
            ),
           ),
          ],
         ],
        ),
        Row(
         children: [
          IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () {}),
          IconButton(
           icon: const Icon(Icons.delete, size: 20, color: AppColors.error),
           onPressed: () => ref.read(addressProvider(userId).notifier).deleteAddress(address.id),
          ),
         ],
        ),
       ],
      ),
      const SizedBox(height: 8),
      Text(address.fullAddress, style: TextStyle(color: Colors.grey[700])),
     ],
    ),
   ),
  );
 }
}