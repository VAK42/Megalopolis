import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/merchantProvider.dart';
import '../../../providers/authProvider.dart';
import '../../merchant/constants/merchantConstants.dart';
class MerchantProfileScreen extends ConsumerStatefulWidget {
 const MerchantProfileScreen({super.key});
 @override
 ConsumerState<MerchantProfileScreen> createState() => _MerchantProfileScreenState();
}
class _MerchantProfileScreenState extends ConsumerState<MerchantProfileScreen> {
 final _nameController = TextEditingController();
 final _emailController = TextEditingController();
 final _phoneController = TextEditingController();
 final _addressController = TextEditingController();
 bool _isEditing = false;
 @override
 void dispose() {
  _nameController.dispose();
  _emailController.dispose();
  _phoneController.dispose();
  _addressController.dispose();
  super.dispose();
 }
 @override
 Widget build(BuildContext context) {
  final merchantId = ref.watch(currentUserIdProvider) ?? 'user1';
  final profileAsync = ref.watch(merchantProfileProvider(merchantId));
  return Scaffold(
   appBar: AppBar(
    title: const Text(MerchantConstants.profileTitle),
    actions: [IconButton(icon: Icon(_isEditing ? Icons.close : Icons.edit), onPressed: () => setState(() => _isEditing = !_isEditing))],
   ),
   body: profileAsync.when(
    data: (profile) {
     final data = profile ?? {};
     if (!_isEditing) {
      _nameController.text = data['name'] ?? '';
      _emailController.text = data['email'] ?? '';
      _phoneController.text = data['phone'] ?? '';
      _addressController.text = data['address'] ?? '';
     }
     return ListView(
      padding: const EdgeInsets.all(16),
      children: [
       Center(
        child: Container(
         width: 100,
         height: 100,
         decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
         child: const Icon(Icons.store, size: 50),
        ),
       ),
       const SizedBox(height: 24),
       _buildField(MerchantConstants.businessNameLabel, _nameController),
       _buildField(MerchantConstants.emailLabel, _emailController),
       _buildField(MerchantConstants.contactPhoneLabel, _phoneController),
       _buildField(MerchantConstants.addressLabel, _addressController),
       const SizedBox(height: 24),
       if (_isEditing)
        ElevatedButton(
         onPressed: () async {
          await ref.read(merchantRepositoryProvider).updateMerchantProfile(merchantId, {'name': _nameController.text, 'email': _emailController.text, 'phone': _phoneController.text, 'address': _addressController.text});
          ref.invalidate(merchantProfileProvider(merchantId));
          setState(() => _isEditing = false);
          if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(MerchantConstants.success)));
          }
         },
         style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
         child: const Text(MerchantConstants.saveChangesButton),
        ),
      ],
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, s) => Center(child: Text('${MerchantConstants.errorGeneric}: $e')),
   ),
  );
 }
 Widget _buildField(String label, TextEditingController controller) => Card(
  margin: const EdgeInsets.only(bottom: 12),
  child: Padding(
   padding: const EdgeInsets.all(12),
   child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
     const SizedBox(height: 4),
     _isEditing
       ? TextField(
         controller: controller,
         decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 8)),
        )
       : Text(controller.text.isEmpty ? MerchantConstants.notAvailable : controller.text, style: const TextStyle(fontSize: 16)),
    ],
   ),
  ),
 );
}