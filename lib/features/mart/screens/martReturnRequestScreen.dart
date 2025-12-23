import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../constants/martConstants.dart';
class MartReturnRequestScreen extends ConsumerStatefulWidget {
 const MartReturnRequestScreen({super.key});
 @override
 ConsumerState<MartReturnRequestScreen> createState() => _MartReturnRequestScreenState();
}
class _MartReturnRequestScreenState extends ConsumerState<MartReturnRequestScreen> {
 String selectedReason = MartConstants.defectiveProduct;
 final TextEditingController commentsController = TextEditingController();
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(MartConstants.returnRequestTitle),
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      const Text(MartConstants.orderDetails, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Container(
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
       child: Row(
        children: [
         Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
          child: Icon(Icons.image, color: Colors.grey[600]),
         ),
         const SizedBox(width: 12),
         Expanded(
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            const Text(MartConstants.wirelessHeadphones, style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${MartConstants.orderPrefix}OR2024123', style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            const Text(
             '\$79.99',
             style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
           ],
          ),
         ),
        ],
       ),
      ),
      const SizedBox(height: 24),
      const Text(MartConstants.reasonForReturn, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      RadioGroup<String>(
       groupValue: selectedReason,
       onChanged: (value) {
        if (value != null) setState(() => selectedReason = value);
       },
       child: Column(
        children: [MartConstants.defectiveProduct, MartConstants.wrongItemReceived, MartConstants.notAsDescribed, MartConstants.changedMyMind, MartConstants.betterPriceAvailable, MartConstants.other].map((reason) {
         return RadioListTile<String>(value: reason, title: Text(reason), contentPadding: EdgeInsets.zero);
        }).toList(),
       ),
      ),
      const SizedBox(height: 16),
      const Text(MartConstants.additionalComments, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      TextField(
       controller: commentsController,
       maxLines: 4,
       decoration: InputDecoration(
        hintText: MartConstants.provideDetails,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
       ),
      ),
      const SizedBox(height: 24),
      Container(
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
       ),
       child: const Row(
        children: [
         Icon(Icons.info_outline, color: AppColors.primary),
         SizedBox(width: 12),
         Expanded(
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Text(MartConstants.returnPolicy, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(MartConstants.returnPolicyText, style: TextStyle(fontSize: 12)),
           ],
          ),
         ),
        ],
       ),
      ),
      const SizedBox(height: 24),
      AppButton(text: MartConstants.submitRequest, onPressed: () => context.go(Routes.martReturnSubmitted), icon: Icons.check),
     ],
    ),
   ),
  );
 }
}