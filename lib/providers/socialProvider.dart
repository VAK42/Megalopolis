import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/socialRepository.dart';
final socialRepositoryProvider = Provider((ref) => SocialRepository());
final friendsProvider =
  FutureProvider.family<List<Map<String, dynamic>>, String>((
    ref,
    userId,
  ) async {
    return await ref.watch(socialRepositoryProvider).getFriends(userId);
  });
final activityFeedProvider =
  FutureProvider.family<List<Map<String, dynamic>>, String>((
    ref,
    userId,
  ) async {
    return await ref.watch(socialRepositoryProvider).getActivityFeed(userId);
  });