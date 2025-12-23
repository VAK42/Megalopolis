import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/settingsProvider.dart';
import '../constants/settingsConstants.dart';
class SettingsStorageScreen extends ConsumerWidget {
 const SettingsStorageScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final storageAsync = ref.watch(storageInfoProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(SettingsConstants.storageManagement),
   ),
   body: storageAsync.when(
    data: (storage) {
     final totalUsed = storage['totalUsed'] ?? 0;
     final available = storage['available'] ?? 2048;
     final images = storage['images'] ?? 0;
     final videos = storage['videos'] ?? 0;
     final documents = storage['documents'] ?? 0;
     final other = storage['other'] ?? 0;
     return ListView(
      padding: const EdgeInsets.all(16),
      children: [
       Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
        child: Column(
         children: [
          const Text(SettingsConstants.storageUsed, style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Text(
           '$totalUsed ${SettingsConstants.mb}',
           style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('${SettingsConstants.of} $available ${SettingsConstants.mb} ${SettingsConstants.available}', style: const TextStyle(color: Colors.white70)),
         ],
        ),
       ),
       const SizedBox(height: 24),
       _buildStorageItem(SettingsConstants.images, '$images ${SettingsConstants.mb}'),
       _buildStorageItem(SettingsConstants.videos, '$videos ${SettingsConstants.mb}'),
       _buildStorageItem(SettingsConstants.documents, '$documents ${SettingsConstants.mb}'),
       _buildStorageItem(SettingsConstants.other, '$other ${SettingsConstants.mb}'),
       const SizedBox(height: 24),
       SizedBox(
        width: double.infinity,
        child: OutlinedButton(
         onPressed: () async {
          await ref.read(settingsRepositoryProvider).clearCache(userId);
          ref.invalidate(storageInfoProvider);
          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(SettingsConstants.cacheCleared)));
         },
         child: const Text(SettingsConstants.clearAllCache),
        ),
       ),
      ],
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(SettingsConstants.errorLoadingStorage)),
   ),
  );
 }
 Widget _buildStorageItem(String name, String size) => Card(
  margin: const EdgeInsets.only(bottom: 12),
  child: ListTile(
   title: Text(name),
   trailing: Text(size, style: const TextStyle(fontWeight: FontWeight.bold)),
  ),
 );
}