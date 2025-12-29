import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/adminProvider.dart';
import '../../../data/repositories/adminRepository.dart';
import '../widgets/adminScaffold.dart';
import '../constants/adminConstants.dart';
class AdminUsersScreen extends ConsumerStatefulWidget {
 const AdminUsersScreen({super.key});
 @override
 ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}
class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
 final AdminRepository repository = AdminRepository();
 final searchController = TextEditingController();
 String selectedFilter = AdminConstants.tabAll;
 Future<void> _showAddUserDialog() async {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedRole = 'user';
  await showDialog(
   context: context,
   builder: (context) => StatefulBuilder(
    builder: (context, setDialogState) => AlertDialog(
     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
     title: Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.person_add_rounded, color: AppColors.primary)), const SizedBox(width: 12), Text(AdminConstants.addUserTitle)]),
     content: SingleChildScrollView(
      child: Column(
       mainAxisSize: MainAxisSize.min,
       children: [
        TextField(controller: nameController, decoration: InputDecoration(labelText: AdminConstants.nameLabel, prefixIcon: const Icon(Icons.person_outline), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50])),
        const SizedBox(height: 16),
        TextField(controller: emailController, decoration: InputDecoration(labelText: AdminConstants.emailLabel, prefixIcon: const Icon(Icons.email_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50]), keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 16),
        TextField(controller: phoneController, decoration: InputDecoration(labelText: AdminConstants.phoneLabel, prefixIcon: const Icon(Icons.phone_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50]), keyboardType: TextInputType.phone),
        const SizedBox(height: 16),
        TextField(controller: passwordController, decoration: InputDecoration(labelText: AdminConstants.passwordLabel, prefixIcon: const Icon(Icons.lock_outline), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50]), obscureText: true),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
         initialValue: selectedRole,
         decoration: InputDecoration(labelText: AdminConstants.roleLabel, prefixIcon: const Icon(Icons.badge_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50]),
         items: AdminConstants.userRoles.map((role) => DropdownMenuItem(value: role, child: Text(role.toUpperCase()))).toList(),
         onChanged: (v) => setDialogState(() => selectedRole = v!),
        ),
       ],
      ),
     ),
     actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: Text(AdminConstants.cancelButton, style: TextStyle(color: Colors.grey[600]))),
      ElevatedButton(
       onPressed: () async {
         final name = nameController.text.trim();
         final email = emailController.text.trim();
         final phone = phoneController.text.trim();
         final password = passwordController.text;
         if (name.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.nameRequired), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
          return;
         }
         if (email.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.emailRequired), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
          return;
         }
         if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.emailInvalid), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
          return;
         }
         if (phone.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.phoneRequired), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
          return;
         }
         if (!RegExp(r'^[0-9+\-\s()]{7,}$').hasMatch(phone)) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.phoneInvalid), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
          return;
         }
         if (password.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.passwordRequired), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
          return;
         }
         if (password.length < 6) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.passwordTooShort), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
          return;
         }
         await repository.createUser({'name': name, 'email': email, 'phone': phone, 'password': password, 'role': selectedRole, 'status': 'active'});
        if (mounted) {
         Navigator.pop(context);
         ref.invalidate(adminUsersProvider);
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.userCreatedSuccess), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
        }
       },
       style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
       child: Text(AdminConstants.createButton),
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
  String selectedRole = user['role']?.toString() ?? 'user';
  String selectedStatus = user['status']?.toString() ?? 'active';
  await showDialog(
   context: context,
   builder: (context) => StatefulBuilder(
    builder: (context, setDialogState) => AlertDialog(
     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
     title: Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.edit_rounded, color: AppColors.info)), const SizedBox(width: 12), Text(AdminConstants.editUserTitle)]),
     content: SingleChildScrollView(
      child: Column(
       mainAxisSize: MainAxisSize.min,
       children: [
        TextField(controller: nameController, decoration: InputDecoration(labelText: AdminConstants.nameLabel, prefixIcon: const Icon(Icons.person_outline), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50])),
        const SizedBox(height: 16),
        TextField(controller: emailController, decoration: InputDecoration(labelText: AdminConstants.emailLabel, prefixIcon: const Icon(Icons.email_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50]), keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 16),
        TextField(controller: phoneController, decoration: InputDecoration(labelText: AdminConstants.phoneLabel, prefixIcon: const Icon(Icons.phone_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50]), keyboardType: TextInputType.phone),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(initialValue: selectedRole, decoration: InputDecoration(labelText: AdminConstants.roleLabel, prefixIcon: const Icon(Icons.badge_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50]), items: AdminConstants.userRoles.map((role) => DropdownMenuItem(value: role, child: Text(role.toUpperCase()))).toList(), onChanged: (v) => setDialogState(() => selectedRole = v!)),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(initialValue: selectedStatus, decoration: InputDecoration(labelText: AdminConstants.statusLabel, prefixIcon: const Icon(Icons.toggle_on_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50]), items: [DropdownMenuItem(value: 'active', child: Text(AdminConstants.activeStatus)), DropdownMenuItem(value: 'blocked', child: Text(AdminConstants.blockedStatus)), DropdownMenuItem(value: 'pending', child: Text(AdminConstants.pendingStatusLabel))], onChanged: (v) => setDialogState(() => selectedStatus = v!)),
       ],
      ),
     ),
     actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: Text(AdminConstants.cancelButton, style: TextStyle(color: Colors.grey[600]))),
      ElevatedButton(
       onPressed: () async {
         final name = nameController.text.trim();
         final email = emailController.text.trim();
         final phone = phoneController.text.trim();
         if (name.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.nameRequired), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
          return;
         }
         if (email.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.emailRequired), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
          return;
         }
         if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.emailInvalid), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
          return;
         }
         if (phone.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.phoneRequired), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
          return;
         }
         if (!RegExp(r'^[0-9+\-\s()]{7,}$').hasMatch(phone)) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.phoneInvalid), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
          return;
         }
         await repository.updateUser(user['id'].toString(), {'name': name, 'email': email, 'phone': phone, 'role': selectedRole, 'status': selectedStatus});
        if (mounted) {
         Navigator.pop(context);
         ref.invalidate(adminUsersProvider);
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.userUpdatedSuccess), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
        }
       },
       style: ElevatedButton.styleFrom(backgroundColor: AppColors.info, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
       child: Text(AdminConstants.saveButton),
      ),
     ],
    ),
   ),
  );
 }
 Future<void> _confirmDeleteUser(Map<String, dynamic> user) async {
  final confirmed = await showDialog<bool>(
   context: context,
   builder: (context) => AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    title: Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.delete_rounded, color: AppColors.error)), const SizedBox(width: 12), Text(AdminConstants.deleteUserTitle)]),
    content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(AdminConstants.deleteUserConfirm), const SizedBox(height: 16), Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)), child: Row(children: [CircleAvatar(backgroundColor: AppColors.primary, child: Text(user['name']?.toString().substring(0, 1).toUpperCase() ?? 'U', style: const TextStyle(color: Colors.white))), const SizedBox(width: 12), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(user['name']?.toString() ?? AdminConstants.defaultUserName, style: const TextStyle(fontWeight: FontWeight.w600)), Text(user['email']?.toString() ?? AdminConstants.noEmailText, style: TextStyle(color: Colors.grey[600], fontSize: 13))])]))]),
    actions: [
     TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AdminConstants.cancelButton, style: TextStyle(color: Colors.grey[600]))),
     ElevatedButton(onPressed: () => Navigator.pop(context, true), style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: Text(AdminConstants.deleteButton)),
    ],
   ),
  );
  if (confirmed == true) {
   await repository.deleteUser(user['id'].toString());
   ref.invalidate(adminUsersProvider);
   if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.userDeletedSuccess), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
  }
 }
 Future<void> _toggleBlockUser(Map<String, dynamic> user) async {
  final isBlocked = user['status'] == 'blocked';
  await repository.updateUser(user['id'].toString(), {'status': isBlocked ? 'active' : 'blocked'});
  ref.invalidate(adminUsersProvider);
  if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isBlocked ? AdminConstants.userUnblockedSuccess : AdminConstants.userBlockedSuccess), backgroundColor: isBlocked ? AppColors.success : AppColors.warning, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
 }
 @override
 Widget build(BuildContext context) {
  return AdminScaffold(
   title: AdminConstants.userManagementTitle,
   floatingActionButton: FloatingActionButton.extended(onPressed: _showAddUserDialog, backgroundColor: AppColors.primary, icon: const Icon(Icons.person_add_rounded), label: Text(AdminConstants.addUserButton)),
   body: Column(
    children: [
     Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
       children: [
        TextField(controller: searchController, onChanged: (value) => setState(() {}), decoration: InputDecoration(hintText: AdminConstants.searchUsersHint, prefixIcon: const Icon(Icons.search_rounded), suffixIcon: searchController.text.isNotEmpty ? IconButton(icon: const Icon(Icons.clear_rounded), onPressed: () { searchController.clear(); setState(() {}); }) : null, filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none))),
        const SizedBox(height: 12),
        SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [AdminConstants.tabAll, 'Active', 'Blocked', 'Admin', 'User', 'Driver', 'Merchant'].map((f) => Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(label: Text(f), selected: selectedFilter == f, onSelected: (s) => setState(() => selectedFilter = f), selectedColor: AppColors.primary, labelStyle: TextStyle(color: selectedFilter == f ? Colors.white : Colors.grey[700])))).toList())),
       ],
      ),
     ),
     Expanded(
      child: ref.watch(adminUsersProvider).when(
       data: (users) {
        var filteredUsers = users.where((u) {
         final matchesSearch = searchController.text.isEmpty || (u['name']?.toString().toLowerCase().contains(searchController.text.toLowerCase()) ?? false) || (u['email']?.toString().toLowerCase().contains(searchController.text.toLowerCase()) ?? false);
         final matchesFilter = selectedFilter == AdminConstants.tabAll || (selectedFilter == 'Active' && u['status'] == 'active') || (selectedFilter == 'Blocked' && u['status'] == 'blocked') || u['role']?.toString().toLowerCase() == selectedFilter.toLowerCase();
         return matchesSearch && matchesFilter;
        }).toList();
        if (filteredUsers.isEmpty) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.people_outline_rounded, size: 64, color: Colors.grey[300]), const SizedBox(height: 16), Text(AdminConstants.noUsersFound, style: TextStyle(color: Colors.grey[600]))]));
        return RefreshIndicator(
         onRefresh: () async => ref.invalidate(adminUsersProvider),
         child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
           final user = filteredUsers[index];
           final role = user['role']?.toString() ?? 'user';
           final status = user['status']?.toString() ?? 'active';
           final isBlocked = status == 'blocked';
           Color roleColor = role == 'admin' ? AppColors.error : (role == 'driver' ? AppColors.info : (role == 'merchant' ? AppColors.warning : AppColors.primary));
           return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: isBlocked ? AppColors.error.withValues(alpha: 0.3) : Colors.grey.shade100), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2))]),
            child: Padding(
             padding: const EdgeInsets.all(16),
             child: Row(
              children: [
               Builder(builder: (context) {
                final avatarUrl = user['avatar']?.toString();
                return Container(
                 width: 50,
                 height: 50,
                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
                 clipBehavior: Clip.antiAlias,
                 child: avatarUrl != null && avatarUrl.isNotEmpty
                   ? Image.network(avatarUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [roleColor, roleColor.withValues(alpha: 0.7)])), child: Center(child: Text(user['name']?.toString().substring(0, 1).toUpperCase() ?? 'U', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)))))
                   : Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [roleColor, roleColor.withValues(alpha: 0.7)])), child: Center(child: Text(user['name']?.toString().substring(0, 1).toUpperCase() ?? 'U', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)))),
                );
               }),
               const SizedBox(width: 16),
               Expanded(
                child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                  Row(
                   children: [
                    Text(user['name']?.toString() ?? AdminConstants.defaultUserName, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, decoration: isBlocked ? TextDecoration.lineThrough : null)),
                    const SizedBox(width: 8),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: roleColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Text(role.toUpperCase(), style: TextStyle(fontSize: 10, color: roleColor, fontWeight: FontWeight.bold))),
                    if (isBlocked) Container(margin: const EdgeInsets.only(left: 8), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Text(AdminConstants.blockedStatus, style: const TextStyle(fontSize: 10, color: AppColors.error, fontWeight: FontWeight.bold))),
                   ],
                  ),
                  const SizedBox(height: 4),
                  Text(user['email']?.toString() ?? AdminConstants.noEmailText, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                 ],
                ),
               ),
               PopupMenuButton(
                icon: Icon(Icons.more_vert_rounded, color: Colors.grey[400]),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                itemBuilder: (context) => [
                 PopupMenuItem(value: 'edit', child: Row(children: [const Icon(Icons.edit_rounded, size: 20), const SizedBox(width: 12), Text(AdminConstants.editAction)])),
                 PopupMenuItem(value: 'block', child: Row(children: [Icon(isBlocked ? Icons.lock_open_rounded : Icons.block_rounded, size: 20, color: isBlocked ? AppColors.success : AppColors.warning), const SizedBox(width: 12), Text(isBlocked ? AdminConstants.unblockAction : AdminConstants.blockAction, style: TextStyle(color: isBlocked ? AppColors.success : AppColors.warning))])),
                 PopupMenuItem(value: 'delete', child: Row(children: [const Icon(Icons.delete_rounded, size: 20, color: AppColors.error), const SizedBox(width: 12), Text(AdminConstants.deleteAction, style: const TextStyle(color: AppColors.error))])),
                ],
                onSelected: (value) {
                 if (value == 'edit') _showEditUserDialog(user);
                 else if (value == 'block') _toggleBlockUser(user);
                 else if (value == 'delete') _confirmDeleteUser(user);
                },
               ),
              ],
             ),
            ),
           );
          },
         ),
        );
       },
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (_, __) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.error_outline_rounded, size: 64, color: Colors.grey[400]), const SizedBox(height: 16), Text(AdminConstants.errorLoadingUsers, style: TextStyle(color: Colors.grey[600])), const SizedBox(height: 16), ElevatedButton.icon(onPressed: () => ref.invalidate(adminUsersProvider), icon: const Icon(Icons.refresh_rounded), label: Text(AdminConstants.retryButton), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary))])),
      ),
     ),
    ],
   ),
  );
 }
}