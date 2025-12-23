import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/systemRepository.dart';
final systemRepositoryProvider = Provider((ref) => SystemRepository());
final systemSettingsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
 return await ref.watch(systemRepositoryProvider).getSettings();
});
final searchHintProvider = FutureProvider<String>((ref) async {
 return await ref.watch(systemRepositoryProvider).getSearchHint();
});
final globalCategoriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
 return await ref.watch(systemRepositoryProvider).getGlobalCategories();
});