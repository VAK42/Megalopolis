import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/rideProvider.dart';
import '../../ride/constants/rideConstants.dart';
class RideScheduleScreen extends ConsumerStatefulWidget {
 const RideScheduleScreen({super.key});
 @override
 ConsumerState<RideScheduleScreen> createState() => _RideScheduleScreenState();
}
class _RideScheduleScreenState extends ConsumerState<RideScheduleScreen> {
 DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
 TimeOfDay selectedTime = TimeOfDay.now();
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(RideConstants.scheduleTitle),
   ),
   body: Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      const Text('When Do You Want To Ride?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 24),
      GestureDetector(
       onTap: () async {
        final date = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 30)));
        if (date != null) setState(() => selectedDate = date);
       },
       child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
        child: Row(
         children: [
          const Icon(Icons.calendar_today, color: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
           child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             const Text(RideConstants.selectDate, style: TextStyle(fontSize: 12)),
             Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
           ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
         ],
        ),
       ),
      ),
      const SizedBox(height: 16),
      GestureDetector(
       onTap: () async {
        final time = await showTimePicker(context: context, initialTime: selectedTime);
        if (time != null) setState(() => selectedTime = time);
       },
       child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
        child: Row(
         children: [
          const Icon(Icons.access_time, color: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
           child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             const Text(RideConstants.selectTime, style: TextStyle(fontSize: 12)),
             Text(selectedTime.format(context), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
           ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
         ],
        ),
       ),
      ),
      const Spacer(),
      AppButton(
       text: RideConstants.scheduleRideBtn,
       onPressed: () async {
        final userId = ref.read(currentUserIdProvider) ?? 'user1';
        final bookingState = ref.read(rideBookingProvider);
        await ref.read(rideRepositoryProvider).scheduleRide({'userId': userId, 'type': 'ride', 'status': 'scheduled', 'scheduledDate': selectedDate.millisecondsSinceEpoch, 'scheduledTime': '${selectedTime.hour}:${selectedTime.minute}', ...bookingState});
        if (mounted) context.go(Routes.rideHome);
       },
       icon: Icons.schedule,
      ),
     ],
    ),
   ),
  );
 }
}