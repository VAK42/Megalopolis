import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/marketingRepository.dart';
final marketingRepositoryProvider = Provider((ref) => MarketingRepository());
final promotionsProvider = FutureProvider((ref) async {
  return await ref.watch(marketingRepositoryProvider).getPromotions();
});
final userBadgesProvider =
  FutureProvider.family<List<Map<String, dynamic>>, String>((
    ref,
    userId,
  ) async {
    return await ref.watch(marketingRepositoryProvider).getBadges(userId);
  });