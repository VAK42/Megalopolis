import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/addressProvider.dart';
import '../constants/profileConstants.dart';
class AddressAddScreen extends ConsumerStatefulWidget {
 const AddressAddScreen({super.key});
 @override
 ConsumerState<AddressAddScreen> createState() => _AddressAddScreenState();
}
class _AddressAddScreenState extends ConsumerState<AddressAddScreen> {
 String selectedType = ProfileConstants.home;
 final TextEditingController address1Controller = TextEditingController();
 final TextEditingController address2Controller = TextEditingController();
 final TextEditingController cityController = TextEditingController();
 final TextEditingController zipController = TextEditingController();
 bool isDefault = false;
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ProfileConstants.addAddress),
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      const Text(ProfileConstants.addressType, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Row(
       children: [ProfileConstants.home, ProfileConstants.work, ProfileConstants.other].map((type) {
        final isSelected = selectedType == type;
        return Expanded(
         child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
           label: Center(child: Text(type)),
           selected: isSelected,
           onSelected: (selected) => setState(() => selectedType = type),
           selectedColor: AppColors.primary,
           labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
          ),
         ),
        );
       }).toList(),
      ),
      const SizedBox(height: 24),
      _buildTextField(ProfileConstants.streetAddress, address1Controller, Icons.location_on),
      const SizedBox(height: 16),
      _buildTextField(ProfileConstants.apartmentSuiteOptional, address2Controller, Icons.home),
      const SizedBox(height: 16),
      _buildTextField(ProfileConstants.city, cityController, Icons.location_city),
      const SizedBox(height: 16),
      _buildTextField(ProfileConstants.zipCode, zipController, Icons.pin_drop, keyboardType: TextInputType.number),
      const SizedBox(height: 24),
      SwitchListTile(title: const Text(ProfileConstants.setAsDefaultAddress), value: isDefault, onChanged: (value) => setState(() => isDefault = value), contentPadding: EdgeInsets.zero),
      const SizedBox(height: 32),
      AppButton(
       text: ProfileConstants.saveAddress,
       onPressed: () async {
        if (address1Controller.text.trim().isEmpty) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(ProfileConstants.pleaseEnterStreetAddress), backgroundColor: Colors.red));
         return;
        }
        final userId = ref.read(currentUserIdProvider) ?? 'user1';
        final fullAddress = '${address1Controller.text.trim()}${address2Controller.text.isNotEmpty ? ', ${address2Controller.text.trim()}' : ''}, ${cityController.text.trim()} ${zipController.text.trim()}'.trim();
        await ref.read(addressProvider(userId).notifier).addAddress(label: selectedType, fullAddress: fullAddress, isDefault: isDefault);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(ProfileConstants.addressSaved), backgroundColor: Colors.green));
          context.pop();
         }
       },
       icon: Icons.check,
      ),
     ],
    ),
   ),
  );
 }
 Widget _buildTextField(String label, TextEditingController controller, IconData icon, {TextInputType? keyboardType}) {
  return Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
    Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    const SizedBox(height: 8),
    TextField(
     controller: controller,
     keyboardType: keyboardType,
     decoration: InputDecoration(
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
     ),
    ),
   ],
  );
 }
}