import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/driverProvider.dart';
import '../constants/driverConstants.dart';
class DriverDocumentsScreen extends ConsumerWidget {
 const DriverDocumentsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? '';
  final documentsAsync = ref.watch(driverDocumentsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(DriverConstants.documentsTitle),
   ),
   body: documentsAsync.when(
    data: (documents) => ListView(
     padding: const EdgeInsets.all(16),
     children: [
      ...documents.map((doc) => _buildDocumentCard(context, ref, doc, userId)),
      const SizedBox(height: 16),
      OutlinedButton.icon(
       onPressed: () => _showUploadDialog(context, ref, userId),
       icon: const Icon(Icons.add),
       label: const Text(DriverConstants.uploadNewDocument),
       style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
      ),
     ],
    ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(child: Text('${DriverConstants.errorPrefix}$e')),
   ),
  );
 }
 Widget _buildDocumentCard(BuildContext context, WidgetRef ref, Map<String, dynamic> doc, String userId) {
  final status = doc['status'] as String;
  final statusColor = status == 'verified' ? AppColors.success : (status == 'pending' ? Colors.orange : AppColors.error);
  return GestureDetector(
   onLongPress: () => _showDeleteDialog(context, ref, doc, userId),
   child: Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: ListTile(
     leading: Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(24)),
      child: const Icon(Icons.description, color: AppColors.primary),
     ),
     title: Text(doc['name'] as String),
     subtitle: Text('${DriverConstants.expirePrefix}${doc['expiry'] ?? 'N/A'}'),
     trailing: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(
       status[0].toUpperCase() + status.substring(1),
       style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
      ),
     ),
    ),
   ),
  );
 }
 Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref, Map<String, dynamic> doc, String userId) async {
  final confirmed = await showDialog<bool>(
   context: context,
   builder: (context) => AlertDialog(
    title: const Text(DriverConstants.deleteDocumentTitle),
    content: const Text(DriverConstants.deleteDocumentConfirm),
    actions: [
     TextButton(onPressed: () => Navigator.pop(context, false), child: const Text(DriverConstants.cancel)),
     ElevatedButton(
      onPressed: () => Navigator.pop(context, true),
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
      child: const Text(DriverConstants.delete),
     ),
    ],
   ),
  );
  if (confirmed == true) {
   await ref.read(driverRepositoryProvider).deleteDocument(doc['id'].toString());
   ref.invalidate(driverDocumentsProvider(userId));
   if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(DriverConstants.documentDeleted)));
   }
  }
 }
 Future<void> _showUploadDialog(BuildContext context, WidgetRef ref, String userId) async {
  await showDialog(
   context: context,
   builder: (context) => AlertDialog(
    title: const Text(DriverConstants.uploadDocument),
    content: Column(
     mainAxisSize: MainAxisSize.min,
     children: DriverConstants.documentTypes
       .map(
        (type) => ListTile(
         title: Text(type),
         trailing: const Icon(Icons.upload),
         onTap: () async {
          Navigator.pop(context);
          await ref.read(driverRepositoryProvider).uploadDocument(userId, type, '/path/to/$type');
          ref.invalidate(driverDocumentsProvider(userId));
          if (context.mounted) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$type${DriverConstants.uploadedSuffix}')));
          }
         },
        ),
       )
       .toList(),
    ),
    actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text(DriverConstants.cancel))],
   ),
  );
 }
}