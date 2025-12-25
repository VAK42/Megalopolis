import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/chatProvider.dart';
import '../../chat/constants/chatConstants.dart';
class ContactsScreen extends ConsumerStatefulWidget {
 const ContactsScreen({super.key});
 @override
 ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}
class _ContactsScreenState extends ConsumerState<ContactsScreen> {
 final TextEditingController searchController = TextEditingController();
 String searchQuery = '';
 @override
 void dispose() {
  searchController.dispose();
  super.dispose();
 }
 @override
 Widget build(BuildContext context) {
  final userAsync = ref.watch(authProvider);
  final userId = userAsync.value?.id.toString() ?? '';
  final contactsAsync = ref.watch(contactsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(
     icon: const Icon(Icons.arrow_back), 
     onPressed: () => context.go(Routes.chatInbox),
    ),
    title: const Text(ChatConstants.contactsTitle),
    actions: [IconButton(icon: const Icon(Icons.person_add), onPressed: () {})],
   ),
   body: Column(
    children: [
     Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
       controller: searchController,
       onChanged: (value) => setState(() => searchQuery = value.toLowerCase()),
       decoration: InputDecoration(
        hintText: ChatConstants.searchContacts,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: searchQuery.isNotEmpty
          ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
             searchController.clear();
             setState(() => searchQuery = '');
            },
           )
          : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
       ),
      ),
     ),
     Expanded(
      child: contactsAsync.when(
       data: (contacts) {
        final filteredContacts = searchQuery.isEmpty
          ? contacts
          : contacts.where((c) {
            final name = (c['name'] as String?)?.toLowerCase() ?? '';
            final email = (c['email'] as String?)?.toLowerCase() ?? '';
            return name.contains(searchQuery) || email.contains(searchQuery);
           }).toList();
        if (filteredContacts.isEmpty) {
         return Center(child: Text(searchQuery.isEmpty ? ChatConstants.noContacts : ChatConstants.noSearchResults));
        }
        return ListView.builder(itemCount: filteredContacts.length, itemBuilder: (context, index) => _buildContactItem(filteredContacts[index], userId));
       },
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (err, stack) => Center(child: Text('${ChatConstants.errorPrefix}$err')),
      ),
     ),
    ],
   ),
  );
 }
 Widget _buildContactItem(Map<String, dynamic> contact, String currentUserId) {
  return ListTile(
   leading: Stack(
    children: [
     Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: ClipOval(
       child: contact['avatar'] != null && (contact['avatar'] as String).isNotEmpty
         ? Image.network(
           contact['avatar'],
           fit: BoxFit.cover,
           errorBuilder: (context, error, stackTrace) => Container(
            color: AppColors.primary,
            child: const Icon(Icons.person, color: Colors.white, size: 25),
           ),
          )
         : Container(
           color: AppColors.primary,
           child: const Icon(Icons.person, color: Colors.white, size: 25),
          ),
      ),
     ),
    ],
   ),
   title: Text(contact['name'] ?? ChatConstants.unknownUser, style: const TextStyle(fontWeight: FontWeight.w600)),
   subtitle: Text(contact['email'] ?? ChatConstants.noEmail, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
   trailing: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
     IconButton(
      icon: const Icon(Icons.message, color: AppColors.primary),
      onPressed: () async {
       final router = GoRouter.of(context);
       final notifier = ref.read(chatProvider(currentUserId).notifier);
       try {
        final chatId = await notifier.getChatWithUser(contact['id'].toString());
        router.go('/chat/$chatId');
       } catch (e) {
        if (context.mounted) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${ChatConstants.errorCreatingChat}$e')));
        }
       }
      },
     ),
    ],
   ),
  );
 }
}