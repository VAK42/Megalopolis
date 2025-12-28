import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/profileProvider.dart';
import '../constants/profileConstants.dart';
class LanguageScreen extends ConsumerStatefulWidget {
 const LanguageScreen({super.key});
 @override
 ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}
class _LanguageScreenState extends ConsumerState<LanguageScreen> {
 String selectedLanguage = ProfileConstants.english;
 bool _loaded = false;
 final List<Map<String, String>> languages = [
  {'name': 'English', 'code': 'en'},
  {'name': 'Spanish', 'code': 'es'},
  {'name': 'French', 'code': 'fr'},
  {'name': 'German', 'code': 'de'},
  {'name': 'Italian', 'code': 'it'},
  {'name': 'Portuguese', 'code': 'pt'},
  {'name': 'Russian', 'code': 'ru'},
  {'name': 'Chinese', 'code': 'zh'},
  {'name': 'Japanese', 'code': 'ja'},
  {'name': 'Korean', 'code': 'ko'},
  {'name': 'Arabic', 'code': 'ar'},
  {'name': 'Hindi', 'code': 'hi'},
 ];
 @override
 void didChangeDependencies() {
  super.didChangeDependencies();
  if (!_loaded) {
   _loadSettings();
   _loaded = true;
  }
 }
 void _loadSettings() async {
  final userId = ref.read(currentUserIdProvider) ?? 'user1';
  final settings = await ref.read(profileRepositoryProvider).getUserSettings(userId);
  if (settings != null && mounted) {
   final code = settings['language']?.toString() ?? 'en';
   final lang = languages.firstWhere((l) => l['code'] == code, orElse: () => {'name': 'English', 'code': 'en'});
   setState(() => selectedLanguage = lang['name']!);
  }
 }
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ProfileConstants.languageTitle),
   ),
   body: RadioGroup<String>(
    groupValue: selectedLanguage,
    onChanged: (value) {
     if (value != null) {
      setState(() => selectedLanguage = value);
      final userId = ref.read(currentUserIdProvider) ?? 'user1';
      final lang = languages.firstWhere((l) => l['name'] == value);
      ref.read(profileRepositoryProvider).updateUserSettings(userId, {'language': lang['code']});
     }
    },
    child: ListView.builder(
     padding: const EdgeInsets.all(16),
     itemCount: languages.length,
     itemBuilder: (context, index) {
      final language = languages[index];
      final isSelected = selectedLanguage == language['name'];
      return Card(
       margin: const EdgeInsets.only(bottom: 8),
       child: RadioListTile<String>(
        title: Text(language['name']!, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        subtitle: Text(language['code']!.toUpperCase()),
        value: language['name']!,
        activeColor: AppColors.primary,
       ),
      );
     },
    ),
   ),
  );
 }
}