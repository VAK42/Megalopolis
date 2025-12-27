import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/socialRepository.dart';
final socialRepositoryProvider = Provider((ref) => SocialRepository());
final friendsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 return await ref.watch(socialRepositoryProvider).getFriends(userId);
});
final activityFeedProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 return await ref.watch(socialRepositoryProvider).getActivityFeed(userId);
});
final userSearchProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, query) async {
 if (query.isEmpty) return [];
 return await ref.watch(socialRepositoryProvider).searchUsers(query);
});
final socialChallengesProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 return await ref.watch(socialRepositoryProvider).getChallenges(userId);
});
final expenseSplitsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
 return await ref.watch(socialRepositoryProvider).getExpenseSplits(userId);
});
final userProfileProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, userId) async {
 return await ref.watch(socialRepositoryProvider).getUserProfile(userId);
});
final userStatsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
 return await ref.watch(socialRepositoryProvider).getUserStats(userId);
});