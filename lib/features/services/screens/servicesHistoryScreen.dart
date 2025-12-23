import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/serviceProvider.dart';
import '../constants/servicesConstants.dart';
class ServicesHistoryScreen extends ConsumerWidget {
 const ServicesHistoryScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userId = ref.watch(currentUserIdProvider) ?? 'user1';
  final bookingsAsync = ref.watch(serviceBookingsProvider(userId));
  return DefaultTabController(
   length: 3,
   child: Scaffold(
    appBar: AppBar(
     leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
     title: const Text(ServicesConstants.bookingHistory),
     bottom: const TabBar(
      tabs: [
       Tab(text: ServicesConstants.upcoming),
       Tab(text: ServicesConstants.completed),
       Tab(text: ServicesConstants.cancelled),
      ],
     ),
    ),
    body: bookingsAsync.when(
     data: (bookings) {
      final upcoming = bookings.where((b) => b['status'] == 'pending' || b['status'] == 'confirmed').toList();
      final completed = bookings.where((b) => b['status'] == 'completed').toList();
      final cancelled = bookings.where((b) => b['status'] == 'cancelled').toList();
      return TabBarView(children: [_buildBookingList(context, ref, upcoming), _buildBookingList(context, ref, completed), _buildBookingList(context, ref, cancelled)]);
     },
     loading: () => const Center(child: CircularProgressIndicator()),
     error: (_, __) => const Center(child: Text(ServicesConstants.errorLoadingServices)),
    ),
   ),
  );
 }
 Widget _buildBookingList(BuildContext context, WidgetRef ref, List<Map<String, dynamic>> bookings) {
  if (bookings.isEmpty) return const Center(child: Text(ServicesConstants.noBookings));
  return ListView.builder(
   padding: const EdgeInsets.all(16),
   itemCount: bookings.length,
   itemBuilder: (context, index) {
    final booking = bookings[index];
    return Card(
     margin: const EdgeInsets.only(bottom: 12),
     child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
          Text(booking['serviceName'] ?? 'Service', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Container(
           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
           decoration: BoxDecoration(color: _getStatusColor(booking['status']).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
           child: Text(booking['status'] ?? 'pending', style: TextStyle(color: _getStatusColor(booking['status']), fontSize: 12)),
          ),
         ],
        ),
        const SizedBox(height: 8),
        Text(booking['providerName'] ?? ServicesConstants.serviceProvider, style: TextStyle(color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(booking['scheduledAt'] ?? '', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        const SizedBox(height: 12),
        Row(
         children: [
          Expanded(
           child: OutlinedButton(onPressed: () {}, child: const Text(ServicesConstants.viewDetails)),
          ),
          if (booking['status'] == 'pending' || booking['status'] == 'confirmed') ...[
           const SizedBox(width: 8),
           Expanded(
            child: OutlinedButton(
             onPressed: () async {
              await ref.read(serviceRepositoryProvider).cancelBooking(booking['id'].toString());
              ref.invalidate(serviceBookingsProvider);
             },
             style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
             child: const Text(ServicesConstants.cancelBooking),
            ),
           ),
          ],
         ],
        ),
       ],
      ),
     ),
    );
   },
  );
 }
 Color _getStatusColor(String? status) {
  switch (status) {
   case 'completed':
    return AppColors.success;
   case 'cancelled':
    return AppColors.error;
   default:
    return AppColors.primary;
  }
 }
}