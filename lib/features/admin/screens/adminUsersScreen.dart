import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/adminProvider.dart';
import '../../../data/repositories/adminRepository.dart';
import '../constants/adminConstants.dart';
class AdminUsersScreen extends ConsumerStatefulWidget {
 const AdminUsersScreen({super.key});
 @override
 ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}
class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
 final TextEditingController searchController = TextEditingController();
 final AdminRepository repository = AdminRepository();
 Future<void> _showAddUserDialog() async {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  String selectedRole = 'user';
  await showDialog(
   context: context,
   builder: (context) => StatefulBuilder(
    builder: (context, setDialogState) => AlertDialog(
     title: const Text(AdminConstants.addUserTitle),
     content: SingleChildScrollView(
      child: Column(
       mainAxisSize: MainAxisSize.min,
       children: [
        TextField(
         controller: nameController,
         decoration: const InputDecoration(labelText: AdminConstants.nameLabel),
        ),
        const SizedBox(height: 12),
        TextField(
         controller: emailController,
         decoration: const InputDecoration(labelText: AdminConstants.emailLabel),
         keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        TextField(
         controller: phoneController,
         decoration: const InputDecoration(labelText: AdminConstants.phoneLabel),
         keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
         initialValue: selectedRole,
         decoration: const InputDecoration(labelText: AdminConstants.roleLabel),
         items: AdminConstants.userRoles.map((role) => DropdownMenuItem(value: role, child: Text(role.toUpperCase()))).toList(),
         onChanged: (initialValue) => setDialogState(() => selectedRole = initialValue!),
        ),
       ],
      ),
     ),
     actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text(AdminConstants.cancelButton)),
      ElevatedButton(
       onPressed: () async {
        await repository.createUser({'name': nameController.text, 'email': emailController.text, 'phone': phoneController.text, 'role': selectedRole, 'status': 'active', 'rating': 0.0});
        if (mounted) {
         Navigator.pop(context);
         ref.invalidate(adminUsersProvider);
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AdminConstants.userCreatedSuccess)));
        }
       },
       child: const Text(AdminConstants.createButton),
      ),
     ],
    ),
   ),
  );
 }
 Future<void> _showEditUserDialog(Map<String, dynamic> user) async {
  final nameController = TextEditingController(text: user['name']?.toString());
  final emailController = TextEditingController(text: user['email']?.toString());
  final phoneController = TextEditingController(text: user['phone']?.toString());
  await showDialog(
   context: context,
   builder: (context) => AlertDialog(
    title: const Text(AdminConstants.editUserTitle),
    content: SingleChildScrollView(
     child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
       TextField(
        controller: nameController,
        decoration: const InputDecoration(labelText: AdminConstants.nameLabel),
       ),
       const SizedBox(height: 12),
       TextField(
        controller: emailController,
        decoration: const InputDecoration(labelText: AdminConstants.emailLabel),
       ),
       const SizedBox(height: 12),
       TextField(
        controller: phoneController,
        decoration: const InputDecoration(labelText: AdminConstants.phoneLabel),
       ),
      ],
     ),
    ),
    actions: [
     TextButton(onPressed: () => Navigator.pop(context), child: const Text(AdminConstants.cancelButton)),
     ElevatedButton(
      onPressed: () async {
       await repository.updateUser(user['id'].toString(), {'name': nameController.text, 'email': emailController.text, 'phone': phoneController.text});
       if (mounted) {
        Navigator.pop(context);
        ref.invalidate(adminUsersProvider);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AdminConstants.userUpdatedSuccess)));
       }
      },
      child: const Text(AdminConstants.saveButton),
     ),
    ],
   ),
  );
 }
 Future<void> _deleteUser(String userId) async {
  final confirmed = await showDialog<bool>(
   context: context,
   builder: (context) => AlertDialog(
    title: const Text(AdminConstants.deleteUserTitle),
    content: const Text(AdminConstants.deleteUserConfirm),
    actions: [
     TextButton(onPressed: () => Navigator.pop(context, false), child: const Text(AdminConstants.cancelButton)),
     ElevatedButton(
      onPressed: () => Navigator.pop(context, true),
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
      child: const Text(AdminConstants.deleteButton),
     ),
    ],
   ),
  );
  if (confirmed == true) {
   await repository.deleteUser(userId);
   ref.invalidate(adminUsersProvider);
   if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AdminConstants.userDeletedSuccess)));
   }
  }
 }
 Future<void> _blockUser(String userId) async {
  await repository.blockUser(userId);
  ref.invalidate(adminUsersProvider);
  if (mounted) {
   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AdminConstants.userBlockedSuccess)));
  }
 }
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    title: const Text(AdminConstants.userManagementTitle),
    actions: [IconButton(icon: const Icon(Icons.filter_list), onPressed: () {})],
   ),
   body: Column(
    children: [
     Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
       controller: searchController,
       decoration: InputDecoration(
        hintText: AdminConstants.searchUsersHint,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
       ),
      ),
     ),
     Expanded(
      child: ref
        .watch(adminUsersProvider)
        .when(
         data: (users) => ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: users.length,
          itemBuilder: (context, index) {
           final user = users[index];
           final status = user['status']?.toString() ?? 'active';
           return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
             leading: CircleAvatar(
              backgroundColor: status == 'blocked' ? AppColors.error : AppColors.primary,
              child: Text(user['name']?.toString().substring(0, 1).toUpperCase() ?? 'U', style: const TextStyle(color: Colors.white)),
             ),
             title: Text(user['name']?.toString() ?? AdminConstants.defaultUserName),
             subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Text(user['email']?.toString() ?? AdminConstants.noEmailText),
               Text('${AdminConstants.rolePrefixText}${user['role']?.toString().toUpperCase() ?? AdminConstants.defaultRole.toUpperCase()}', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
              ],
             ),
             trailing: PopupMenuButton(
              itemBuilder: (context) => AdminConstants.userActions.map((action) => PopupMenuItem(value: action, child: Text(action[0].toUpperCase() + action.substring(1)))).toList(),
              onSelected: (value) {
               switch (value) {
                case 'edit':
                 _showEditUserDialog(user);
                 break;
                case 'block':
                 _blockUser(user['id'].toString());
                 break;
                case 'delete':
                 _deleteUser(user['id'].toString());
                 break;
               }
              },
             ),
            ),
           );
          },
         ),
         loading: () => const Center(child: CircularProgressIndicator()),
         error: (_, __) => const Center(child: Text(AdminConstants.errorLoadingUsers)),
        ),
     ),
    ],
   ),
   floatingActionButton: FloatingActionButton(onPressed: _showAddUserDialog, child: const Icon(Icons.person_add)),
  );
 }
}