import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/marketingRepository.dart';
final marketingRepositoryProvider = Provider((ref) => MarketingRepository());
final promotionsProvider = FutureProvider((ref) async {
 return await ref.watch(marketingRepositoryProvider).getPromotions();
});
class BadgesNotifier extends FamilyAsyncNotifier<List<Map<String, dynamic>>, String> {
 late final MarketingRepository _repository;
 late final String _argUserId;
 @override
 Future<List<Map<String, dynamic>>> build(String arg) async {
  _repository = ref.watch(marketingRepositoryProvider);
  _argUserId = arg;
  return _repository.getBadges(_argUserId);
 }
 Future<void> deleteBadge(int badgeId) async {
  try {
   await _repository.deleteBadge(badgeId);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getBadges(_argUserId));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
 Future<void> awardBadge(String badgeName) async {
  try {
   await _repository.awardBadge(_argUserId, badgeName);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getBadges(_argUserId));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
}
final userBadgesProvider = AsyncNotifierProvider.family<BadgesNotifier, List<Map<String, dynamic>>, String>(() => BadgesNotifier());
class ChallengesNotifier extends FamilyAsyncNotifier<List<Map<String, dynamic>>, String> {
 late final MarketingRepository _repository;
 late final String _argUserId;
 @override
 Future<List<Map<String, dynamic>>> build(String arg) async {
  _repository = ref.watch(marketingRepositoryProvider);
  _argUserId = arg;
  return _repository.getChallenges(_argUserId);
 }
 Future<void> joinChallenge(int challengeId) async {
  try {
   await _repository.joinChallenge(_argUserId, challengeId);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getChallenges(_argUserId));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
 Future<void> leaveChallenge(int challengeId) async {
  try {
   await _repository.leaveChallenge(_argUserId, challengeId);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getChallenges(_argUserId));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
 Future<void> completeChallenge(int challengeId) async {
  try {
   await _repository.completeChallenge(_argUserId, challengeId);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getChallenges(_argUserId));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
}
final challengesProvider = AsyncNotifierProvider.family<ChallengesNotifier, List<Map<String, dynamic>>, String>(() => ChallengesNotifier());
class CheckInNotifier extends FamilyAsyncNotifier<Map<String, dynamic>, String> {
 late final MarketingRepository _repository;
 late final String _argUserId;
 @override
 Future<Map<String, dynamic>> build(String arg) async {
  _repository = ref.watch(marketingRepositoryProvider);
  _argUserId = arg;
  return _repository.getCheckInStatus(_argUserId);
 }
 Future<void> performCheckIn() async {
  try {
   await _repository.performCheckIn(_argUserId);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getCheckInStatus(_argUserId));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
 Future<void> clearHistory() async {
  try {
   await _repository.clearCheckInHistory(_argUserId);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getCheckInStatus(_argUserId));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
}
final checkInStatusProvider = AsyncNotifierProvider.family<CheckInNotifier, Map<String, dynamic>, String>(() => CheckInNotifier());
final leaderboardProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
 return await ref.watch(marketingRepositoryProvider).getLeaderboard();
});
final userRankProvider = FutureProvider.family<int, String>((ref, userId) async {
 return await ref.watch(marketingRepositoryProvider).getUserRank(userId);
});
class ScratchCardNotifier extends FamilyAsyncNotifier<Map<String, dynamic>, String> {
 late final MarketingRepository _repository;
 late final String _argUserId;
 @override
 Future<Map<String, dynamic>> build(String arg) async {
  _repository = ref.watch(marketingRepositoryProvider);
  _argUserId = arg;
  return _repository.getScratchCard(_argUserId);
 }
 Future<void> scratchCard(int cardId) async {
  try {
   await _repository.scratchCard(cardId);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getScratchCard(_argUserId));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
 Future<void> claimReward(int cardId) async {
  try {
   await _repository.claimReward(cardId, _argUserId);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getScratchCard(_argUserId));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
 Future<void> deleteCard(int cardId) async {
  try {
   await _repository.deleteScratchCard(cardId);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _repository.getScratchCard(_argUserId));
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
}
final scratchCardProvider = AsyncNotifierProvider.family<ScratchCardNotifier, Map<String, dynamic>, String>(() => ScratchCardNotifier());
final spinWheelOptionsProvider = FutureProvider<List<int>>((ref) async {
 return await ref.watch(marketingRepositoryProvider).getSpinWheelOptions();
});