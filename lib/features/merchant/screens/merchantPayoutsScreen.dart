import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/merchantProvider.dart';
import '../../../providers/authProvider.dart';
import '../../merchant/constants/merchantConstants.dart';
class MerchantPayoutsScreen extends ConsumerWidget {
 const MerchantPayoutsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final merchantId = ref.watch(currentUserIdProvider) ?? 'user1';
  final payoutsAsync = ref.watch(merchantPayoutsProvider(merchantId));
  return Scaffold(
   appBar: AppBar(title: const Text(MerchantConstants.payoutsTitle)),
   body: Column(
    children: [
     Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      color: AppColors.primary,
      child: Column(
       children: [
        const Text(MerchantConstants.availableBalance, style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        Consumer(
         builder: (context, ref, child) {
          final statsAsync = ref.watch(merchantStatsProvider(merchantId));
          return statsAsync.when(
           data: (stats) => Text('\$${(stats['totalRevenue'] as num?)?.toStringAsFixed(2) ?? '0.00'}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
           loading: () => const Text('\$0.00', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
           error: (e, s) => const Text('\$0.00', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
          );
         },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
         onPressed: () async {
          final amount = await showDialog<double>(
           context: context,
           builder: (ctx) {
            final controller = TextEditingController();
            return AlertDialog(
             title: const Text(MerchantConstants.withdrawFundsButton),
             content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(prefixText: '\$'),
             ),
             actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text(MerchantConstants.cancel)),
              TextButton(
               onPressed: () {
                final val = double.tryParse(controller.text);
                Navigator.pop(ctx, val);
               },
               child: const Text(MerchantConstants.withdrawFundsButton),
              ),
             ],
            );
           },
          );
          if (amount != null && amount > 0) {
           await ref.read(merchantRepositoryProvider).requestWithdrawal(merchantId, amount);
           ref.invalidate(merchantPayoutsProvider(merchantId));
          }
         },
         style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary),
         child: const Text(MerchantConstants.withdrawFundsButton),
        ),
       ],
      ),
     ),
     Expanded(
      child: payoutsAsync.when(
       data: (payouts) {
        if (payouts.isEmpty) {
         return const Center(child: Text(MerchantConstants.noPayoutHistory));
        }
        return ListView.builder(
         padding: const EdgeInsets.all(16),
         itemCount: payouts.length,
         itemBuilder: (context, index) {
          final payout = payouts[index];
          final status = payout['status'].toString();
          final displayStatus = status.isNotEmpty ? status[0].toUpperCase() + status.substring(1) : status;
          final isPending = status == 'pending';
          return Dismissible(
           key: Key(payout['id'].toString()),
           direction: isPending ? DismissDirection.endToStart : DismissDirection.none,
           background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: AppColors.error,
            child: const Icon(Icons.cancel, color: Colors.white),
           ),
           onDismissed: (direction) {
            ref.read(merchantRepositoryProvider).cancelWithdrawal(payout['id'].toString());
            ref.invalidate(merchantPayoutsProvider(merchantId));
           },
           child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
             title: Text('${MerchantConstants.withdrawalPrefix}${payout['id']}'),
             subtitle: Text(DateFormat('MMM dd, yyyy').format(DateTime.fromMillisecondsSinceEpoch(payout['createdAt'] as int))),
             trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
               Text(
                '-\$${(payout['amount'] as num).toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.error),
               ),
               Text(displayStatus, style: TextStyle(fontSize: 12, color: (status == 'completed') ? Colors.green : Colors.orange)),
              ],
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
     ),
    ],
   ),
  );
 }
}