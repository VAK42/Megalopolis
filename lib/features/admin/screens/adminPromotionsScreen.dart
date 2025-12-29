import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/marketingProvider.dart';
import '../../../data/repositories/adminRepository.dart';
import '../widgets/adminScaffold.dart';
import '../constants/adminConstants.dart';
class AdminPromotionsScreen extends ConsumerStatefulWidget {
 const AdminPromotionsScreen({super.key});
 @override
 ConsumerState<AdminPromotionsScreen> createState() => _AdminPromotionsScreenState();
}
class _AdminPromotionsScreenState extends ConsumerState<AdminPromotionsScreen> {
 final AdminRepository repository = AdminRepository();
 String selectedType = 'all';
 Future<void> _showAddPromotionDialog() async {
  final codeController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final discountController = TextEditingController();
  final minOrderController = TextEditingController(text: '0');
  final maxDiscountController = TextEditingController(text: '100');
  String promoType = 'general';
  int durationDays = 30;
  await showDialog(
   context: context,
   builder: (context) => StatefulBuilder(
    builder: (context, setDialogState) => AlertDialog(
     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
     title: Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.local_offer_rounded, color: AppColors.primary)), const SizedBox(width: 12), Text(AdminConstants.addPromotionTitle)]),
     content: SingleChildScrollView(
      child: Column(
       mainAxisSize: MainAxisSize.min,
       children: [
        TextField(controller: codeController, decoration: InputDecoration(labelText: AdminConstants.promoCodeLabel, prefixIcon: const Icon(Icons.code_rounded), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50]), textCapitalization: TextCapitalization.characters),
        const SizedBox(height: 16),
        TextField(controller: titleController, decoration: InputDecoration(labelText: AdminConstants.titleLabel, prefixIcon: const Icon(Icons.title_rounded), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50])),
        const SizedBox(height: 16),
        TextField(controller: descriptionController, maxLines: 2, decoration: InputDecoration(labelText: AdminConstants.descriptionLabel, prefixIcon: const Icon(Icons.description_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50])),
        const SizedBox(height: 16),
        Row(
         children: [
          Expanded(child: TextField(controller: discountController, decoration: InputDecoration(labelText: AdminConstants.discountPercentLabel, prefixIcon: const Icon(Icons.percent_rounded), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50]), keyboardType: TextInputType.number)),
          const SizedBox(width: 12),
          Expanded(child: DropdownButtonFormField<int>(initialValue: durationDays, decoration: InputDecoration(labelText: AdminConstants.durationLabel, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50]), items: [DropdownMenuItem(value: 7, child: Text(AdminConstants.days7)), DropdownMenuItem(value: 14, child: Text(AdminConstants.days14)), DropdownMenuItem(value: 30, child: Text(AdminConstants.days30)), DropdownMenuItem(value: 60, child: Text(AdminConstants.days60)), DropdownMenuItem(value: 90, child: Text(AdminConstants.days90))], onChanged: (v) => setDialogState(() => durationDays = v!))),
         ],
        ),
        const SizedBox(height: 16),
        Row(
         children: [
          Expanded(child: TextField(controller: minOrderController, decoration: InputDecoration(labelText: AdminConstants.minOrderLabel, prefixIcon: const Icon(Icons.attach_money_rounded), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50]), keyboardType: TextInputType.number)),
          const SizedBox(width: 12),
          Expanded(child: TextField(controller: maxDiscountController, decoration: InputDecoration(labelText: AdminConstants.maxDiscountLabel, prefixIcon: const Icon(Icons.money_off_rounded), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50]), keyboardType: TextInputType.number)),
         ],
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(initialValue: promoType, decoration: InputDecoration(labelText: AdminConstants.typeLabel, prefixIcon: const Icon(Icons.category_rounded), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50]), items: AdminConstants.promoTypes.map((type) => DropdownMenuItem(value: type, child: Text(type[0].toUpperCase() + type.substring(1)))).toList(), onChanged: (v) => setDialogState(() => promoType = v!)),
       ],
      ),
     ),
     actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: Text(AdminConstants.cancelButton, style: TextStyle(color: Colors.grey[600]))),
      ElevatedButton(
       onPressed: () async {
        if (codeController.text.trim().isEmpty || discountController.text.trim().isEmpty) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.fillAllFieldsError), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
         return;
        }
        final discount = double.tryParse(discountController.text) ?? 0;
        if (discount <= 0 || discount > 100) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.discountRangeError), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
         return;
         }
         if (titleController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.titleRequired), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
          return;
         }
         final minOrder = double.tryParse(minOrderController.text) ?? 0;
         if (minOrder < 0) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.minOrderNegativeError), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
          return;
         }
         final maxDiscountVal = double.tryParse(maxDiscountController.text) ?? 0;
         if (maxDiscountVal <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.maxDiscountPositiveError), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
          return;
         }
         final now = DateTime.now().millisecondsSinceEpoch;
        await repository.createPromotion({'title': titleController.text.trim().isNotEmpty ? titleController.text.trim() : codeController.text.trim(), 'code': codeController.text.trim().toUpperCase(), 'description': descriptionController.text.trim(), 'discount': discount, 'minOrder': double.tryParse(minOrderController.text) ?? 0, 'maxDiscount': double.tryParse(maxDiscountController.text) ?? 100, 'type': promoType, 'startDate': now, 'endDate': now + (durationDays * 86400000), 'usageCount': 0, 'usageLimit': 0, 'isActive': 1, 'createdAt': now});
        if (mounted) {
         Navigator.pop(context);
         ref.invalidate(promotionsProvider);
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.promotionCreatedSuccess), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
        }
       },
       style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
       child: Text(AdminConstants.createButton),
      ),
     ],
    ),
   ),
  );
 }
 Future<void> _showEditPromotionDialog(Map<String, dynamic> promo) async {
  final codeController = TextEditingController(text: promo['code']?.toString());
  final titleController = TextEditingController(text: promo['title']?.toString());
  final descriptionController = TextEditingController(text: promo['description']?.toString());
  final discountController = TextEditingController(text: promo['discount']?.toString() ?? '0');
  String promoType = promo['type']?.toString() ?? 'general';
  bool isActive = promo['isActive'] == 1;
  await showDialog(
   context: context,
   builder: (context) => StatefulBuilder(
    builder: (context, setDialogState) => AlertDialog(
     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
     title: Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.edit_rounded, color: AppColors.info)), const SizedBox(width: 12), Text(AdminConstants.editPromotionTitle)]),
     content: SingleChildScrollView(
      child: Column(
       mainAxisSize: MainAxisSize.min,
       children: [
        TextField(controller: codeController, decoration: InputDecoration(labelText: AdminConstants.promoCodeLabel, prefixIcon: const Icon(Icons.code_rounded), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50]), textCapitalization: TextCapitalization.characters),
        const SizedBox(height: 16),
        TextField(controller: titleController, decoration: InputDecoration(labelText: AdminConstants.titleLabel, prefixIcon: const Icon(Icons.title_rounded), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50])),
        const SizedBox(height: 16),
        TextField(controller: descriptionController, maxLines: 2, decoration: InputDecoration(labelText: AdminConstants.descriptionLabel, prefixIcon: const Icon(Icons.description_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50])),
        const SizedBox(height: 16),
        TextField(controller: discountController, decoration: InputDecoration(labelText: AdminConstants.discountPercentLabel, prefixIcon: const Icon(Icons.percent_rounded), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50]), keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(initialValue: promoType, decoration: InputDecoration(labelText: AdminConstants.typeLabel, prefixIcon: const Icon(Icons.category_rounded), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50]), items: AdminConstants.promoTypes.map((type) => DropdownMenuItem(value: type, child: Text(type[0].toUpperCase() + type.substring(1)))).toList(), onChanged: (v) => setDialogState(() => promoType = v!)),
        const SizedBox(height: 16),
        SwitchListTile(title: Text(AdminConstants.activeToggleLabel), subtitle: Text(isActive ? AdminConstants.promotionIsActive : AdminConstants.promotionIsInactive), value: isActive, onChanged: (v) => setDialogState(() => isActive = v), activeTrackColor: AppColors.success, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), tileColor: Colors.grey[50]),
       ],
      ),
     ),
     actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: Text(AdminConstants.cancelButton, style: TextStyle(color: Colors.grey[600]))),
      ElevatedButton(
       onPressed: () async {
        if (codeController.text.trim().isEmpty || discountController.text.trim().isEmpty) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.fillAllFieldsError), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
         return;
        }
        final discount = double.tryParse(discountController.text) ?? 0;
        if (discount <= 0 || discount > 100) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.discountRangeError), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
         return;
        }
         if (titleController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.titleRequired), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
          return;
         }
        await repository.updatePromotion(promo['id'].toString(), {'code': codeController.text.trim().toUpperCase(), 'title': titleController.text.trim(), 'description': descriptionController.text.trim(), 'discount': discount, 'type': promoType, 'isActive': isActive ? 1 : 0});
        if (mounted) {
         Navigator.pop(context);
         ref.invalidate(promotionsProvider);
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.promotionUpdatedSuccess), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
        }
       },
       style: ElevatedButton.styleFrom(backgroundColor: AppColors.info, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
       child: Text(AdminConstants.saveButton),
      ),
     ],
    ),
   ),
  );
 }
 Future<void> _confirmDeletePromotion(Map<String, dynamic> promo) async {
  final confirmed = await showDialog<bool>(
   context: context,
   builder: (context) => AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    title: Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.delete_rounded, color: AppColors.error)), const SizedBox(width: 12), Text(AdminConstants.deletePromotionTitle)]),
    content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(AdminConstants.deletePromotionConfirm), const SizedBox(height: 16), Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)]), borderRadius: BorderRadius.circular(12)), child: Row(children: [Text(promo['code']?.toString() ?? AdminConstants.defaultPromoCode, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)), const Spacer(), Text('${promo['discount'] ?? 0}${AdminConstants.offSuffix}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]))]),
    actions: [
     TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AdminConstants.cancelButton, style: TextStyle(color: Colors.grey[600]))),
     ElevatedButton(onPressed: () => Navigator.pop(context, true), style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: Text(AdminConstants.deleteButton)),
    ],
   ),
  );
  if (confirmed == true) {
   await repository.deletePromotion(promo['id'].toString());
   ref.invalidate(promotionsProvider);
   if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminConstants.promotionDeletedSuccess), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
  }
 }
 String _formatDate(dynamic timestamp) {
  if (timestamp == null) return '';
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp is int ? timestamp : int.tryParse(timestamp.toString()) ?? 0);
  return '${date.day}/${date.month}/${date.year}';
 }
 bool _isExpired(Map<String, dynamic> promo) {
  final endDate = promo['endDate'];
  if (endDate == null) return false;
  final end = endDate is int ? endDate : int.tryParse(endDate.toString()) ?? 0;
  return DateTime.now().millisecondsSinceEpoch > end;
 }
 @override
 Widget build(BuildContext context) {
  return AdminScaffold(
   title: AdminConstants.promotionsTitle,
   floatingActionButton: FloatingActionButton.extended(onPressed: _showAddPromotionDialog, backgroundColor: AppColors.primary, icon: const Icon(Icons.add_rounded), label: Text(AdminConstants.addPromoButton)),
   body: Column(
    children: [
     Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: SingleChildScrollView(
       scrollDirection: Axis.horizontal,
       child: Row(children: ['all', ...AdminConstants.promoTypes].map((type) { final isSelected = selectedType == type; return Padding(padding: const EdgeInsets.only(right: 8), child: FilterChip(label: Text(type[0].toUpperCase() + type.substring(1)), selected: isSelected, onSelected: (_) => setState(() => selectedType = type), selectedColor: AppColors.primary, labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey[700]), checkmarkColor: Colors.white)); }).toList()),
      ),
     ),
     Expanded(
      child: ref.watch(promotionsProvider).when(
       data: (promotions) {
        final filtered = selectedType == 'all' ? promotions : promotions.where((p) => p['type'] == selectedType).toList();
        if (filtered.isEmpty) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.local_offer_outlined, size: 64, color: Colors.grey[300]), const SizedBox(height: 16), Text(AdminConstants.noPromotionsYet, style: TextStyle(color: Colors.grey[600]))]));
        return RefreshIndicator(
         onRefresh: () async => ref.invalidate(promotionsProvider),
         child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
           final promo = filtered[index];
           final discount = promo['discount'] ?? 0;
           final isActive = promo['isActive'] == 1;
           final isExpired = _isExpired(promo);
           final usageCount = promo['usageCount'] ?? 0;
           return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(gradient: LinearGradient(colors: isExpired ? [Colors.grey, Colors.grey.shade600] : (isActive ? [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)] : [Colors.grey.shade700, Colors.grey.shade600]), begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: (isExpired || !isActive ? Colors.grey : AppColors.primary).withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))]),
            child: Padding(
             padding: const EdgeInsets.all(20),
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)), child: Text(promo['code']?.toString() ?? AdminConstants.defaultPromoCode, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                 Row(
                  children: [
                   Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)), child: Text(isExpired ? AdminConstants.expiredStatus : (isActive ? AdminConstants.promoActiveStatus : AdminConstants.inactiveStatus), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
                   const SizedBox(width: 8),
                   PopupMenuButton(icon: Icon(Icons.more_vert_rounded, color: Colors.white.withValues(alpha: 0.8)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), itemBuilder: (context) => [PopupMenuItem(value: 'edit', child: Row(children: [const Icon(Icons.edit_rounded, size: 20), const SizedBox(width: 12), Text(AdminConstants.editAction)])), PopupMenuItem(value: 'delete', child: Row(children: [const Icon(Icons.delete_rounded, size: 20, color: AppColors.error), const SizedBox(width: 12), Text(AdminConstants.deleteAction, style: const TextStyle(color: AppColors.error))]))], onSelected: (value) { if (value == 'edit') _showEditPromotionDialog(promo); else if (value == 'delete') _confirmDeletePromotion(promo); }),
                  ],
                 ),
                ],
               ),
               const SizedBox(height: 20),
               Text('$discount${AdminConstants.offSuffix}', style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
               const SizedBox(height: 8),
               Text(promo['title']?.toString() ?? promo['description']?.toString() ?? AdminConstants.discountDefaultDescription, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 15)),
               const Divider(color: Colors.white24, height: 32),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 Row(children: [Icon(Icons.category_rounded, size: 16, color: Colors.white.withValues(alpha: 0.7)), const SizedBox(width: 4), Text(promo['type']?.toString().toUpperCase() ?? 'GENERAL', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12))]),
                 Row(children: [Icon(Icons.people_rounded, size: 16, color: Colors.white.withValues(alpha: 0.7)), const SizedBox(width: 4), Text('$usageCount${AdminConstants.usedSuffix}', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12))]),
                 Row(children: [Icon(Icons.event_rounded, size: 16, color: Colors.white.withValues(alpha: 0.7)), const SizedBox(width: 4), Text('${AdminConstants.endsPrefix}${_formatDate(promo['endDate'])}', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12))]),
                ],
               ),
              ],
             ),
            ),
           );
          },
         ),
        );
       },
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (_, __) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.error_outline_rounded, size: 64, color: Colors.grey[400]), const SizedBox(height: 16), Text(AdminConstants.errorLoadingPromotionsMessage, style: TextStyle(color: Colors.grey[600])), const SizedBox(height: 16), ElevatedButton.icon(onPressed: () => ref.invalidate(promotionsProvider), icon: const Icon(Icons.refresh_rounded), label: Text(AdminConstants.retryButton), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary))])),
      ),
     ),
    ],
   ),
  );
 }
}