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
 @override
 Widget build(BuildContext context) {
  final userAsync = ref.watch(authProvider);
  final userId = userAsync.value?.id.toString() ?? '';
  final contactsAsync = ref.watch(contactsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ChatConstants.contactsTitle),
    actions: [IconButton(icon: const Icon(Icons.person_add), onPressed: () {})],
   ),
   body: Column(
    children: [
     Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
       controller: searchController,
       decoration: InputDecoration(
        hintText: ChatConstants.searchContacts,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
       ),
      ),
     ),
     Expanded(
      child: contactsAsync.when(
       data: (contacts) {
        if (contacts.isEmpty) {
         return const Center(child: Text(ChatConstants.noContacts));
        }
        return ListView.builder(itemCount: contacts.length, itemBuilder: (context, index) => _buildContactItem(contacts[index], userId));
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
      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
      child: const Icon(Icons.person, color: Colors.white, size: 25),
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
        router.push(Routes.chatConversation.replaceFirst(':chatId', chatId));
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