import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/profileProvider.dart';
import '../constants/profileConstants.dart';
class PaymentMethodsScreen extends ConsumerWidget {
 const PaymentMethodsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final methodsAsync = ref.watch(paymentMethodsProvider(userId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ProfileConstants.paymentMethods),
   ),
   body: methodsAsync.when(
    data: (methods) => ListView(
     padding: const EdgeInsets.all(16),
     children: [
      ...methods.asMap().entries.map((entry) => _buildPaymentCard(context, entry.key, entry.value, ref, userId)),
      const SizedBox(height: 8),
      OutlinedButton.icon(
       onPressed: () => context.go(Routes.walletAddCard),
       icon: const Icon(Icons.add),
       label: const Text(ProfileConstants.addPaymentMethodBtn),
       style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
      ),
     ],
    ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => Center(
     child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       const Text(ProfileConstants.noAddressesFound),
       const SizedBox(height: 16),
       OutlinedButton.icon(onPressed: () => context.go(Routes.walletAddCard), icon: const Icon(Icons.add), label: const Text(ProfileConstants.addPaymentMethodBtn)),
      ],
     ),
    ),
   ),
  );
 }
 Widget _buildPaymentCard(BuildContext context, int index, Map<String, dynamic> method, WidgetRef ref, String userId) {
  final gradients = [AppColors.primaryGradient, AppColors.secondaryGradient];
  final cardType = method['type']?.toString().toUpperCase() ?? 'Card';
  final numberStr = method['number']?.toString() ?? '';
  final lastFour = numberStr.length >= 4 ? numberStr.substring(numberStr.length - 4) : '****';
  final holderName = method['holder']?.toString() ?? '';
  final expiry = method['expiry']?.toString() ?? '';
  final isDefault = method['isDefault'] == 1 || method['isDefault'] == true;
  return Container(
   margin: const EdgeInsets.only(bottom: 16),
   padding: const EdgeInsets.all(20),
   decoration: BoxDecoration(gradient: gradients[index % gradients.length], borderRadius: BorderRadius.circular(16)),
   child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       Text(cardType, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Row(
         children: [
          if (isDefault)
           Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(12)),
            child: const Text(ProfileConstants.defaultLabel, style: TextStyle(color: Colors.white, fontSize: 10)),
           ),
         ],
        ),
      ],
     ),
     const SizedBox(height: 24),
     Text('**** **** **** $lastFour', style: const TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 2)),
     const SizedBox(height: 16),
     Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(ProfileConstants.cardHolder, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 10)),
         const SizedBox(height: 4),
         Text(holderName, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
       ),
       Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(ProfileConstants.expires, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 10)),
         const SizedBox(height: 4),
         Text(expiry, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
       ),
      ],
     ),
    ],
   ),
  );
 }
}