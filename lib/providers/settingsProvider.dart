import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/settingsRepository.dart';
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) => SettingsRepository());
final accessibilitySettingsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
 return await ref.watch(settingsRepositoryProvider).getAccessibilitySettings(userId);
});
final networkSettingsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
 return await ref.watch(settingsRepositoryProvider).getNetworkSettings(userId);
});
final storageInfoProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
 return await ref.watch(settingsRepositoryProvider).getStorageInfo(userId);
});
final offlineSettingsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
 return await ref.watch(settingsRepositoryProvider).getOfflineSettings(userId);
});
final voiceSettingsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
 return await ref.watch(settingsRepositoryProvider).getVoiceSettings(userId);
});
final fontSettingsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
 return await ref.watch(settingsRepositoryProvider).getFontSettings(userId);
});
final colorBlindSettingsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
 return await ref.watch(settingsRepositoryProvider).getColorBlindSettings(userId);
});