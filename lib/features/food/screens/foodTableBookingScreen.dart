import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/widgets/appButton.dart';
import '../constants/foodConstants.dart';
class FoodTableBookingScreen extends ConsumerStatefulWidget {
 const FoodTableBookingScreen({super.key});
 @override
 ConsumerState<FoodTableBookingScreen> createState() => _FoodTableBookingScreenState();
}
class _FoodTableBookingScreenState extends ConsumerState<FoodTableBookingScreen> {
 DateTime selectedDate = DateTime.now();
 String selectedTime = FoodConstants.defaultBookingTime;
 int guestCount = 2;
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(FoodConstants.tableBookingTitle),
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Container(
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
       child: Row(
        children: [
         const Icon(Icons.restaurant, size: 40, color: AppColors.primary),
         const SizedBox(width: 12),
         Expanded(
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Text(FoodConstants.italianBistro, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(FoodConstants.mainStreet),
           ],
          ),
         ),
        ],
       ),
      ),
      const SizedBox(height: 24),
      Text(FoodConstants.selectDate, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      GestureDetector(
       onTap: () async {
        final date = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 30)));
        if (date != null) setState(() => selectedDate = date);
       },
       child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
         border: Border.all(color: Colors.grey[300]!),
         borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [const Icon(Icons.calendar_today), const SizedBox(width: 12), Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}')]),
       ),
      ),
      const SizedBox(height: 24),
      Text(FoodConstants.selectTime, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Wrap(
       spacing: 8,
       runSpacing: 8,
       children: FoodConstants.bookingTimeSlots.map((time) {
        final isSelected = selectedTime == time;
        return ChoiceChip(
         label: Text(time),
         selected: isSelected,
         onSelected: (selected) => setState(() => selectedTime = time),
         selectedColor: AppColors.primary,
         labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
        );
       }).toList(),
      ),
      const SizedBox(height: 24),
      Text(FoodConstants.guests, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Container(
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
       ),
       child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         Text(FoodConstants.guests, style: const TextStyle(fontSize: 16)),
         Row(
          children: [
           IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => setState(() => guestCount = guestCount > 1 ? guestCount - 1 : 1)),
           Text('$guestCount', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
           IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => setState(() => guestCount++)),
          ],
         ),
        ],
       ),
      ),
      const SizedBox(height: 32),
      AppButton(text: FoodConstants.confirmBooking, onPressed: () => context.pop(), icon: Icons.check),
     ],
    ),
   ),
  );
 }
}