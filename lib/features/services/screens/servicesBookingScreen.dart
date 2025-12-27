import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/serviceProvider.dart';
import '../constants/servicesConstants.dart';
class ServicesBookingScreen extends ConsumerStatefulWidget {
 const ServicesBookingScreen({super.key});
 @override
 ConsumerState<ServicesBookingScreen> createState() => _ServicesBookingScreenState();
}
class _ServicesBookingScreenState extends ConsumerState<ServicesBookingScreen> {
 DateTime selectedDate = DateTime.now();
 String selectedTime = '09:00 AM';
 String selectedService = ServicesConstants.houseCleaning;
 final TextEditingController addressController = TextEditingController();
 final TextEditingController notesController = TextEditingController();
 final List<String> timeSlots = ['09:00 AM', '11:00 AM', '02:00 PM', '04:00 PM', '06:00 PM'];
 final List<String> services = [ServicesConstants.houseCleaning, ServicesConstants.deepCleaning, ServicesConstants.officeCleaning, ServicesConstants.moveInOutCleaning];
 @override
 Widget build(BuildContext context) {
  final bookingState = ref.watch(serviceBookingProvider);
  final serviceName = bookingState['serviceName'] ?? selectedService;
  final servicePrice = bookingState['price'] ?? 50.0;
  final platformFee = 2.50;
  final total = servicePrice + platformFee;
  final providerName = bookingState['providerName'] ?? ServicesConstants.serviceProvider;
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ServicesConstants.bookService),
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      const Text(ServicesConstants.selectService, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Container(
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
       ),
       child: Row(
        children: [
         Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.cleaning_services, color: Colors.white),
         ),
         const SizedBox(width: 12),
         Expanded(
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Text(serviceName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('\$${(servicePrice is num ? servicePrice : 50.0).toStringAsFixed(2)}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
           ],
          ),
         ),
        ],
       ),
      ),
      const SizedBox(height: 24),
      const Text(ServicesConstants.selectDate, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      GestureDetector(
       onTap: () async {
        final date = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 90)));
        if (date != null) setState(() => selectedDate = date);
       },
       child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
         border: Border.all(color: Colors.grey[300]!),
         borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
         children: [
          const Icon(Icons.calendar_today),
          const SizedBox(width: 12),
          Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}', style: const TextStyle(fontSize: 16)),
         ],
        ),
       ),
      ),
      const SizedBox(height: 24),
      const Text(ServicesConstants.selectTime, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      SizedBox(
       height: 50,
       child: ListView(
        scrollDirection: Axis.horizontal,
        children: timeSlots.map((time) {
         final isSelected = selectedTime == time;
         return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
           label: Text(time),
           selected: isSelected,
           onSelected: (selected) => setState(() => selectedTime = time),
           selectedColor: AppColors.primary,
           labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
          ),
         );
        }).toList(),
       ),
      ),
      const SizedBox(height: 24),
      const Text(ServicesConstants.serviceAddress, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      TextField(
       controller: addressController,
       maxLines: 2,
       decoration: InputDecoration(
        hintText: ServicesConstants.enterAddress,
        prefixIcon: const Icon(Icons.location_on),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
       ),
      ),
      const SizedBox(height: 24),
      const Text(ServicesConstants.additionalNotes, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      TextField(
       controller: notesController,
       maxLines: 3,
       decoration: InputDecoration(
        hintText: ServicesConstants.specialRequirements,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
       ),
      ),
      const SizedBox(height: 24),
      Container(
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
       child: Column(
        children: [
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           const Text(ServicesConstants.serviceFee),
           Text('\$${servicePrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
         ),
         const SizedBox(height: 8),
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           const Text(ServicesConstants.platformFee),
           Text('\$${platformFee.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
         ),
         const Divider(height: 24),
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           const Text(ServicesConstants.total, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
           Text(
            '\$${total.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
           ),
          ],
         ),
        ],
       ),
      ),
      const SizedBox(height: 32),
      AppButton(
       text: ServicesConstants.confirmBooking,
       onPressed: () async {
        final userId = ref.read(currentUserIdProvider) ?? '1';
        final bookingState = ref.read(serviceBookingProvider);
        if (bookingState['serviceName'] == null) {
         ref.read(serviceBookingProvider.notifier).setService('', selectedService, servicePrice is num ? servicePrice.toDouble() : 50.0);
        }
        ref.read(serviceBookingProvider.notifier).setDateTime(selectedDate);
        ref.read(serviceBookingProvider.notifier).setAddress(addressController.text);
        await ref.read(serviceBookingProvider.notifier).bookService(userId);
        ref.invalidate(serviceBookingsProvider(userId));
        if (mounted) context.go(Routes.servicesBookingConfirmed);
       },
       icon: Icons.check,
      ),
     ],
    ),
   ),
  );
 }
}