import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../merchant/constants/merchantConstants.dart';
class MerchantRegistrationScreen extends ConsumerStatefulWidget {
 const MerchantRegistrationScreen({super.key});
 @override
 ConsumerState<MerchantRegistrationScreen> createState() => _MerchantRegistrationScreenState();
}
class _MerchantRegistrationScreenState extends ConsumerState<MerchantRegistrationScreen> {
 final TextEditingController businessNameController = TextEditingController();
 final TextEditingController emailController = TextEditingController();
 final TextEditingController phoneController = TextEditingController();
 @override
 void dispose() {
  businessNameController.dispose();
  emailController.dispose();
  phoneController.dispose();
  super.dispose();
 }
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(title: const Text(MerchantConstants.registrationTitle)),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Column(
     children: [
      TextField(
       controller: businessNameController,
       decoration: InputDecoration(
        labelText: MerchantConstants.businessNameLabel,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
         borderRadius: BorderRadius.circular(12),
         borderSide: const BorderSide(color: AppColors.primary),
        ),
       ),
      ),
      const SizedBox(height: 16),
      TextField(
       controller: emailController,
       decoration: InputDecoration(
        labelText: MerchantConstants.emailLabel,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
         borderRadius: BorderRadius.circular(12),
         borderSide: const BorderSide(color: AppColors.primary),
        ),
       ),
      ),
      const SizedBox(height: 16),
      TextField(
       controller: phoneController,
       decoration: InputDecoration(
        labelText: MerchantConstants.contactPhoneLabel,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
         borderRadius: BorderRadius.circular(12),
         borderSide: const BorderSide(color: AppColors.primary),
        ),
       ),
      ),
      const SizedBox(height: 32),
      SizedBox(
       width: double.infinity,
       child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
        child: const Text(MerchantConstants.registerButton),
       ),
      ),
     ],
    ),
   ),
  );
 }
}