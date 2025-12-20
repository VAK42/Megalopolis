import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/merchantRepository.dart';
final merchantRepositoryProvider = Provider((ref) => MerchantRepository());
final merchantOrdersProvider =
  FutureProvider.family<List<Map<String, dynamic>>, String>((
    ref,
    merchantId,
  ) async {
    return await ref
      .watch(merchantRepositoryProvider)
      .getMerchantOrders(merchantId);
  });
final merchantProductsProvider =
  FutureProvider.family<List<Map<String, dynamic>>, String>((
    ref,
    merchantId,
  ) async {
    return await ref
      .watch(merchantRepositoryProvider)
      .getMerchantProducts(merchantId);
  });
final merchantStatsProvider =
  FutureProvider.family<Map<String, dynamic>, String>((
    ref,
    merchantId,
  ) async {
    return await ref
      .watch(merchantRepositoryProvider)
      .getMerchantStats(merchantId);
  });