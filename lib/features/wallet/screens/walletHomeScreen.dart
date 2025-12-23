import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/walletProvider.dart';
import '../../../providers/authProvider.dart';
import '../constants/walletConstants.dart';
class WalletHomeScreen extends ConsumerWidget {
 const WalletHomeScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   body: SafeArea(
    child: CustomScrollView(
     slivers: [
      SliverAppBar(
       expandedHeight: 200,
       floating: false,
       pinned: true,
       flexibleSpace: FlexibleSpaceBar(
        background: Container(
         decoration: BoxDecoration(gradient: AppColors.primaryGradient),
         child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           const SizedBox(height: 40),
           const Text(WalletConstants.totalBalance, style: TextStyle(color: Colors.white70, fontSize: 14)),
           const SizedBox(height: 8),
           ref
             .watch(walletBalanceProvider(ref.watch(currentUserIdProvider) ?? WalletConstants.defaultUserId))
             .when(
              data: (balance) => Text(
               '\$${balance.toStringAsFixed(2)}',
               style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
              ),
              loading: () => const Text(
               '${WalletConstants.currencySymbol}${WalletConstants.amountHint}',
               style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
              ),
              error: (error, stack) => const Text(
               '${WalletConstants.currencySymbol}${WalletConstants.amountHint}',
               style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
              ),
             ),
           const SizedBox(height: 16),
           ref
             .watch(walletTrendProvider(ref.watch(currentUserIdProvider) ?? WalletConstants.defaultUserId))
             .when(
              data: (trend) => Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                Container(
                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                 decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                 child: Row(
                  children: [
                   Icon(trend >= 0 ? Icons.trending_up : Icons.trending_down, color: trend >= 0 ? Colors.green : Colors.red, size: 16),
                   const SizedBox(width: 4),
                   Text('${trend >= 0 ? '+' : ''}${trend.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                 ),
                ),
               ],
              ),
              loading: () => const SizedBox.shrink(),
              error: (err, stack) => const SizedBox.shrink(),
             ),
          ],
         ),
        ),
       ),
       title: const Text(WalletConstants.wallet),
       actions: [
        IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
        IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
       ],
      ),
      SliverToBoxAdapter(
       child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
          Row(
           children: [
            Expanded(child: _buildQuickAction(context, Icons.arrow_upward, WalletConstants.send, Routes.walletSend, AppColors.primary)),
            const SizedBox(width: 12),
            Expanded(child: _buildQuickAction(context, Icons.arrow_downward, WalletConstants.request, Routes.walletRequest, AppColors.success)),
            const SizedBox(width: 12),
            Expanded(child: _buildQuickAction(context, Icons.add, WalletConstants.topUp, Routes.walletTopUp, AppColors.accent)),
            const SizedBox(width: 12),
            Expanded(child: _buildQuickAction(context, Icons.qr_code_scanner, WalletConstants.scanQr, Routes.walletScan, Colors.purple)),
           ],
          ),
          const SizedBox(height: 24),
          Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
            const Text(WalletConstants.myCards, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () => context.go(Routes.walletCards), child: const Text(WalletConstants.viewAll)),
           ],
          ),
          const SizedBox(height: 12),
          SizedBox(
           height: 200,
           child: ref
             .watch(walletCardsProvider(ref.watch(currentUserIdProvider) ?? '1'))
             .when(
              data: (cards) => ListView.builder(
               scrollDirection: Axis.horizontal,
               itemCount: cards.length + 1,
               itemBuilder: (context, index) {
                if (index == cards.length) {
                 return _buildAddCard(context);
                }
                return _buildCard(context, ref, cards[index]);
               },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => const Center(child: Text(WalletConstants.errorLoadingCards)),
             ),
          ),
          const SizedBox(height: 24),
          Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
            const Text(WalletConstants.recentTransactions, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () => context.go(Routes.walletTransactions), child: const Text(WalletConstants.viewAll)),
           ],
          ),
          const SizedBox(height: 12),
          ref
            .watch(transactionsProvider(ref.watch(currentUserIdProvider) ?? '1'))
            .when(
             data: (transactions) => Column(children: transactions.take(5).map((t) => _buildTransaction(context, t)).toList()),
             loading: () => const Center(child: CircularProgressIndicator()),
             error: (error, stack) => const Center(child: Text(WalletConstants.errorLoadingTransactions)),
            ),
         ],
        ),
       ),
      ),
     ],
    ),
   ),
  );
 }
 Widget _buildQuickAction(BuildContext context, IconData icon, String label, String route, Color color) {
  return GestureDetector(
   onTap: () => context.go(route),
   child: Container(
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
    child: Column(
     children: [
      Icon(icon, color: color, size: 28),
      const SizedBox(height: 8),
      Text(
       label,
       style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
      ),
     ],
    ),
   ),
  );
 }
 Widget _buildCard(BuildContext context, WidgetRef ref, Map<String, dynamic> card) {
  return GestureDetector(
   onTap: () => context.go(Routes.walletCardDetail.replaceFirst(':id', card['id'].toString())),
   child: Container(
    width: 300,
    margin: const EdgeInsets.only(right: 16),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(gradient: card['type'] == WalletConstants.visaCardType ? AppColors.primaryGradient : AppColors.secondaryGradient, borderRadius: BorderRadius.circular(16)),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
        Text(
         card['type'] as String? ?? WalletConstants.cards,
         style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Icon(Icons.contactless, color: Colors.white),
       ],
      ),
      const Spacer(),
      Text(card['number'] as String? ?? WalletConstants.unknown, style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 2)),
      const SizedBox(height: 16),
      Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
        Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
          Text(WalletConstants.cardHolderName, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 10)),
          const SizedBox(height: 4),
          ref
            .watch(authProvider)
            .when(
             data: (user) => Text(
              user?.name ?? card['holder'] as String? ?? WalletConstants.unknown,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
             ),
             loading: () => const Text(WalletConstants.loading, style: TextStyle(color: Colors.white)),
             error: (error, stack) => const Text(WalletConstants.errorText, style: TextStyle(color: Colors.white)),
            ),
         ],
        ),
        Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
          Text(WalletConstants.expiryDate, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 10)),
          const SizedBox(height: 4),
          Text(
           card['expiry'] as String? ?? WalletConstants.unknown,
           style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
         ],
        ),
       ],
      ),
     ],
    ),
   ),
  );
 }
 Widget _buildAddCard(BuildContext context) {
  return GestureDetector(
   onTap: () => context.go(Routes.walletAddCard),
   child: Container(
    width: 100,
    margin: const EdgeInsets.only(right: 16),
    decoration: BoxDecoration(
     color: Colors.grey[200],
     borderRadius: BorderRadius.circular(16),
     border: Border.all(color: Colors.grey[400]!),
    ),
    child: const Center(
     child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       Icon(Icons.add, color: Colors.grey),
       SizedBox(height: 4),
       Text(WalletConstants.addCard, style: TextStyle(color: Colors.grey)),
      ],
     ),
    ),
   ),
  );
 }
 Widget _buildTransaction(BuildContext context, Map<String, dynamic> transaction) {
  final isDebit = transaction['type'] == 'debit';
  return Card(
   margin: const EdgeInsets.only(bottom: 12),
   child: ListTile(
    leading: Container(
     padding: const EdgeInsets.all(10),
     decoration: BoxDecoration(color: isDebit ? AppColors.error.withValues(alpha: 0.1) : AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
     child: Icon(isDebit ? Icons.arrow_upward : Icons.arrow_downward, color: isDebit ? AppColors.error : AppColors.success),
    ),
    title: Text(transaction['description'] as String? ?? WalletConstants.transactions, style: const TextStyle(fontWeight: FontWeight.w600)),
    subtitle: Text(transaction['date'] as String? ?? WalletConstants.today),
    trailing: Text(
     '${isDebit ? '-' : '+'}\$${transaction['amount']}',
     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDebit ? AppColors.error : AppColors.success),
    ),
   ),
  );
 }
}