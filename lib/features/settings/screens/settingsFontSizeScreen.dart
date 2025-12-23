import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/settingsProvider.dart';
import '../constants/settingsConstants.dart';
class SettingsFontSizeScreen extends ConsumerStatefulWidget {
 const SettingsFontSizeScreen({super.key});
 @override
 ConsumerState<SettingsFontSizeScreen> createState() => _SettingsFontSizeScreenState();
}
class _SettingsFontSizeScreenState extends ConsumerState<SettingsFontSizeScreen> {
 String selectedSize = 'Medium';
 bool _initialized = false;
 final Map<String, double> fontSizes = {'Small': 12.0, 'Medium': 16.0, 'Large': 20.0, 'Extra Large': 24.0};
 @override
 Widget build(BuildContext context) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final settingsAsync = ref.watch(fontSettingsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(SettingsConstants.fontSize),
   ),
   body: settingsAsync.when(
    data: (settings) {
     if (!_initialized) {
      selectedSize = settings['fontSize'] ?? 'Medium';
      _initialized = true;
     }
     return ListView(
      padding: const EdgeInsets.all(16),
      children: [
       const Text(SettingsConstants.textSize, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
       const SizedBox(height: 16),
       _buildSizeOption(SettingsConstants.small, userId),
       _buildSizeOption(SettingsConstants.medium, userId),
       _buildSizeOption(SettingsConstants.large, userId),
       _buildSizeOption(SettingsConstants.extraLarge, userId),
       const SizedBox(height: 24),
       const Text(SettingsConstants.previewText, style: TextStyle(fontWeight: FontWeight.bold)),
       const SizedBox(height: 12),
       Card(
        child: Padding(
         padding: const EdgeInsets.all(16),
         child: Text(SettingsConstants.previewFontText, style: TextStyle(fontSize: fontSizes[selectedSize] ?? 16.0)),
        ),
       ),
      ],
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => const Center(child: Text(SettingsConstants.errorLoadingSettings)),
   ),
  );
 }
 Widget _buildSizeOption(String size, String userId) {
  final isSelected = selectedSize == size;
  return Card(
   margin: const EdgeInsets.only(bottom: 12),
   child: ListTile(
    leading: Icon(isSelected ? Icons.check_circle : Icons.circle_outlined, color: isSelected ? AppColors.primary : Colors.grey),
    title: Text(
     size,
     style: TextStyle(fontSize: fontSizes[size] ?? 16.0, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
    ),
    onTap: () {
     setState(() => selectedSize = size);
     ref.read(settingsRepositoryProvider).updateFontSettings(userId, size);
    },
   ),
  );
 }
}