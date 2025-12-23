import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/authProvider.dart';
import '../../../shared/models/userModel.dart';
import '../constants/profileConstants.dart';
class ProfileEditScreen extends ConsumerStatefulWidget {
 const ProfileEditScreen({super.key});
 @override
 ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}
class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
 late TextEditingController nameController;
 late TextEditingController emailController;
 late TextEditingController phoneController;
 late TextEditingController bioController;
 @override
 void initState() {
  super.initState();
  nameController = TextEditingController();
  emailController = TextEditingController();
  phoneController = TextEditingController();
  bioController = TextEditingController();
 }
 @override
 void dispose() {
  nameController.dispose();
  emailController.dispose();
  phoneController.dispose();
  bioController.dispose();
  super.dispose();
 }
 void _loadUserData() {
  final userAsync = ref.read(authProvider);
  userAsync.whenData((user) {
   if (user != null) {
    nameController.text = user.name;
    emailController.text = user.email ?? '';
    phoneController.text = user.phone ?? '';
   }
  });
 }
 @override
 Widget build(BuildContext context) {
  final userAsync = ref.watch(authProvider);
  userAsync.whenData((user) {
   if (user != null && nameController.text.isEmpty) {
    _loadUserData();
   }
  });
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ProfileConstants.editProfile),
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
     children: [
      Stack(
       children: [
        Container(
         width: 100,
         height: 100,
         decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
         child: const Icon(Icons.person, size: 50, color: Colors.white),
        ),
        Positioned(
         bottom: 0,
         right: 0,
         child: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
          child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
         ),
        ),
       ],
      ),
      const SizedBox(height: 32),
      _buildTextField(ProfileConstants.fullName, nameController, Icons.person),
      const SizedBox(height: 16),
      _buildTextField(ProfileConstants.email, emailController, Icons.email, keyboardType: TextInputType.emailAddress),
      const SizedBox(height: 16),
      _buildTextField(ProfileConstants.phone, phoneController, Icons.phone, keyboardType: TextInputType.phone),
      const SizedBox(height: 16),
      _buildTextField(ProfileConstants.bio, bioController, Icons.edit, maxLines: 3),
      const SizedBox(height: 32),
      AppButton(
       text: ProfileConstants.saveChanges,
       onPressed: () {
        final userAsync = ref.read(authProvider);
        userAsync.whenData((user) {
         if (user != null) {
          final updatedUser = UserModel(id: user.id, role: user.role, name: nameController.text, email: emailController.text.isEmpty ? null : emailController.text, phone: phoneController.text.isEmpty ? null : phoneController.text, password: user.password, avatar: user.avatar, rating: user.rating, status: user.status, createdAt: user.createdAt, updatedAt: DateTime.now());
          ref.read(userRepositoryProvider).updateUser(updatedUser);
          context.pop();
         }
        });
       },
       icon: Icons.check,
      ),
     ],
    ),
   ),
  );
 }
 Widget _buildTextField(String label, TextEditingController controller, IconData icon, {TextInputType? keyboardType, int maxLines = 1}) {
  return Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
    Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    const SizedBox(height: 8),
    TextField(
     controller: controller,
     keyboardType: keyboardType,
     maxLines: maxLines,
     decoration: InputDecoration(
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
     ),
    ),
   ],
  );
 }
}