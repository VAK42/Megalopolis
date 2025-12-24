import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/systemRepository.dart';
import '../shared/models/itemModel.dart';
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
final searchQueryProvider = StateProvider<String>((ref) => '');
final globalSearchProvider = FutureProvider<List<ItemModel>>((ref) async {
 final query = ref.watch(searchQueryProvider);
 if (query.isEmpty || query.length < 2) return [];
 return await ref.watch(systemRepositoryProvider).globalSearch(query);
});
final searchHistoryProvider = FutureProvider.family<List<String>, String>((ref, userId) async {
 return await ref.watch(systemRepositoryProvider).getSearchHistory(userId);
});
class SearchHistoryNotifier extends FamilyAsyncNotifier<List<String>, String> {
 late final SystemRepository _repository;
 late final String _userId;
 @override
 Future<List<String>> build(String arg) async {
  _repository = ref.watch(systemRepositoryProvider);
  _userId = arg;
  return _repository.getSearchHistory(_userId);
 }
 Future<void> addSearch(String query) async {
  await _repository.addSearchHistory(_userId, query);
  state = await AsyncValue.guard(() => _repository.getSearchHistory(_userId));
 }
 Future<void> clearHistory() async {
  await _repository.clearSearchHistory(_userId);
  state = await AsyncValue.guard(() => _repository.getSearchHistory(_userId));
 }
}
final searchHistoryNotifierProvider = AsyncNotifierProvider.family<SearchHistoryNotifier, List<String>, String>(() => SearchHistoryNotifier());