import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/merchantProvider.dart';
import '../../../providers/authProvider.dart';
import '../../merchant/constants/merchantConstants.dart';
class MerchantPromotionsScreen extends ConsumerWidget {
 const MerchantPromotionsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final merchantId = ref.watch(currentUserIdProvider) ?? 'user1';
  final promotionsAsync = ref.watch(merchantPromotionsProvider(merchantId));
  return Scaffold(
   appBar: AppBar(
    title: const Text(MerchantConstants.promotionsTitle),
    actions: [IconButton(icon: const Icon(Icons.add), onPressed: () {})],
   ),
   body: promotionsAsync.when(
    data: (promotions) {
     if (promotions.isEmpty) {
      return const Center(child: Text(MerchantConstants.noPromotionsFound));
     }
     return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: promotions.length,
      itemBuilder: (c, i) {
       final promo = promotions[i];
       return Dismissible(
        key: Key(promo['id'].toString()),
        direction: DismissDirection.endToStart,
        background: Container(
         alignment: Alignment.centerRight,
         padding: const EdgeInsets.only(right: 20),
         color: AppColors.error,
         child: const Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (direction) {
         ref.read(merchantRepositoryProvider).deletePromotion(promo['id'].toString());
         ref.invalidate(merchantPromotionsProvider(merchantId));
        },
        child: Card(
         margin: const EdgeInsets.only(bottom: 12),
         child: ListTile(
          title: Text(promo['title'] as String),
          subtitle: Text('${MerchantConstants.validUntil}${DateFormat('MMM dd, yyyy').format(DateTime.fromMillisecondsSinceEpoch(promo['endDate'] as int))}'),
          trailing: Switch(
           value: promo['isActive'] == 1,
           activeThumbColor: AppColors.primary,
           onChanged: (v) {
            ref.read(merchantRepositoryProvider).togglePromotionStatus(promo['id'].toString(), v);
            ref.invalidate(merchantPromotionsProvider(merchantId));
           },
          ),
         ),
        ),
       );
      },
     );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, s) => Center(child: Text('${MerchantConstants.errorGeneric}: $e')),
   ),
  );
 }
}