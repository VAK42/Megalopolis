import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/marketingProvider.dart';
import '../../../data/repositories/adminRepository.dart';
import '../../admin/constants/adminConstants.dart';
class AdminPromotionsScreen extends ConsumerStatefulWidget {
 const AdminPromotionsScreen({super.key});
 @override
 ConsumerState<AdminPromotionsScreen> createState() => _AdminPromotionsScreenState();
}
class _AdminPromotionsScreenState extends ConsumerState<AdminPromotionsScreen> {
 final AdminRepository repository = AdminRepository();
 Future<void> _showAddPromotionDialog() async {
  final codeController = TextEditingController();
  final descriptionController = TextEditingController();
  final discountController = TextEditingController();
  String promoType = 'general';
  await showDialog(
   context: context,
   builder: (context) => StatefulBuilder(
    builder: (context, setDialogState) => AlertDialog(
     title: const Text(AdminConstants.addPromotionTitle),
     content: SingleChildScrollView(
      child: Column(
       mainAxisSize: MainAxisSize.min,
       children: [
        TextField(
         controller: codeController,
         decoration: const InputDecoration(labelText: AdminConstants.promoCodeLabel),
         textCapitalization: TextCapitalization.characters,
        ),
        const SizedBox(height: 12),
        TextField(
         controller: descriptionController,
         decoration: const InputDecoration(labelText: AdminConstants.descriptionLabel),
         maxLines: 2,
        ),
        const SizedBox(height: 12),
        TextField(
         controller: discountController,
         decoration: const InputDecoration(labelText: AdminConstants.discountPercentLabel),
         keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
         initialValue: promoType,
         decoration: const InputDecoration(labelText: AdminConstants.typeLabel),
         items: AdminConstants.promoTypes.map((type) => DropdownMenuItem(value: type, child: Text(type.toUpperCase()))).toList(),
         onChanged: (value) => setDialogState(() => promoType = value!),
        ),
       ],
      ),
     ),
     actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text(AdminConstants.cancelButton)),
      ElevatedButton(
       onPressed: () async {
        final now = DateTime.now().millisecondsSinceEpoch;
        await repository.createPromotion({'title': codeController.text, 'code': codeController.text, 'description': descriptionController.text, 'discount': double.tryParse(discountController.text) ?? 0, 'type': promoType, 'startDate': now, 'endDate': now + 2592000000, 'usageCount': 0});
        if (mounted) {
         Navigator.pop(context);
         ref.invalidate(promotionsProvider);
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AdminConstants.promotionCreatedSuccess)));
        }
       },
       child: const Text(AdminConstants.createButton),
      ),
     ],
    ),
   ),
  );
 }
 Future<void> _deletePromotion(String promoId) async {
  final confirmed = await showDialog<bool>(
   context: context,
   builder: (context) => AlertDialog(
    title: const Text(AdminConstants.deletePromotionTitle),
    content: const Text(AdminConstants.deletePromotionConfirm),
    actions: [
     TextButton(onPressed: () => Navigator.pop(context, false), child: const Text(AdminConstants.cancelButton)),
     ElevatedButton(
      onPressed: () => Navigator.pop(context, true),
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
      child: const Text(AdminConstants.deleteButton),
     ),
    ],
   ),
  );
  if (confirmed == true) {
   await repository.deletePromotion(promoId);
   ref.invalidate(promotionsProvider);
   if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AdminConstants.promotionDeletedSuccess)));
   }
  }
 }
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    title: const Text(AdminConstants.promotionsTitle),
    actions: [IconButton(icon: const Icon(Icons.add), onPressed: _showAddPromotionDialog)],
   ),
   body: ref
     .watch(promotionsProvider)
     .when(
      data: (promotions) => ListView.builder(
       padding: const EdgeInsets.all(16),
       itemCount: promotions.length,
       itemBuilder: (context, index) {
        final promo = promotions[index];
        return Card(
         margin: const EdgeInsets.only(bottom: 12),
         child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
              Text(
               promo['code']?.toString() ?? AdminConstants.defaultPromoCode,
               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              Row(
               children: [
                Container(
                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                 decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                 child: const Text(AdminConstants.activeLabel, style: TextStyle(fontSize: 10, color: AppColors.success)),
                ),
                const SizedBox(width: 8),
                IconButton(
                 icon: const Icon(Icons.delete, color: AppColors.error, size: 20),
                 onPressed: () => _deletePromotion(promo['id'].toString()),
                ),
               ],
              ),
             ],
            ),
            const SizedBox(height: 8),
            Text('${promo['discount']}% ${AdminConstants.offLabel}', style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(promo['description']?.toString() ?? AdminConstants.defaultDiscountLabel, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
           ],
          ),
         ),
        );
       },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text(AdminConstants.errorLoadingPromotions)),
     ),
   floatingActionButton: FloatingActionButton(onPressed: _showAddPromotionDialog, child: const Icon(Icons.add)),
  );
 }
}