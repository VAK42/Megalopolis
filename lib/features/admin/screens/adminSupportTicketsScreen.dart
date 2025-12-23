import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/adminProvider.dart';
import '../../../data/repositories/adminRepository.dart';
import '../../admin/constants/adminConstants.dart';
class AdminSupportTicketsScreen extends ConsumerWidget {
 const AdminSupportTicketsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final repository = AdminRepository();
  Future<void> updateTicketStatus(String ticketId, String newStatus) async {
   await repository.updateTicketStatus(ticketId, newStatus);
   ref.invalidate(adminTicketsProvider);
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AdminConstants.ticketStatusUpdatedPrefix}$newStatus')));
  }
  return DefaultTabController(
   length: 3,
   child: Scaffold(
    appBar: AppBar(
     title: const Text(AdminConstants.ticketsTitle),
     bottom: const TabBar(
      tabs: [
       Tab(text: AdminConstants.tabOpen),
       Tab(text: AdminConstants.tabInProgress),
       Tab(text: AdminConstants.tabClosed),
      ],
     ),
    ),
    body: TabBarView(
     children: AdminConstants.ticketStatuses.map((tabStatus) {
      final ticketsAsync = ref.watch(adminTicketsProvider);
      return ticketsAsync.when(
       data: (tickets) {
        final filteredTickets = tickets.where((t) => t['status'] == tabStatus).toList();
        if (filteredTickets.isEmpty) {
         return const Center(child: Text(AdminConstants.noTicketsFound));
        }
        return ListView.builder(
         padding: const EdgeInsets.all(16),
         itemCount: filteredTickets.length,
         itemBuilder: (c, i) {
          final ticket = filteredTickets[i];
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
                Text('${AdminConstants.ticketPrefix}${ticket['id'].toString().substring(0, 8)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Container(
                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                 decoration: BoxDecoration(color: ticket['priority'] == 'high' ? AppColors.error.withValues(alpha: 0.2) : AppColors.success.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                 child: Text((ticket['priority']?.toString() ?? AdminConstants.defaultPriority).toUpperCase(), style: TextStyle(fontSize: 10, color: ticket['priority'] == 'high' ? AppColors.error : AppColors.success)),
                ),
               ],
              ),
              const SizedBox(height: 8),
              Text(ticket['subject']?.toString() ?? AdminConstants.issueLabel, style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(
               ticket['description']?.toString() ?? AdminConstants.noDescriptionText,
               maxLines: 2,
               overflow: TextOverflow.ellipsis,
               style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              Row(
               children: [
                if (tabStatus == 'open') ...[
                 Expanded(
                  child: OutlinedButton(onPressed: () => updateTicketStatus(ticket['id'].toString(), 'inProgress'), child: const Text(AdminConstants.startButton)),
                 ),
                 const SizedBox(width: 8),
                ],
                if (tabStatus != 'closed')
                 Expanded(
                  child: ElevatedButton(onPressed: () => updateTicketStatus(ticket['id'].toString(), 'closed'), child: const Text(AdminConstants.closeButton)),
                 ),
                if (tabStatus == 'closed')
                 Expanded(
                  child: OutlinedButton(onPressed: () => updateTicketStatus(ticket['id'].toString(), 'open'), child: const Text(AdminConstants.reopenButton)),
                 ),
               ],
              ),
             ],
            ),
           ),
          );
         },
        );
       },
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (_, __) => const Center(child: Text(AdminConstants.errorLoadingTickets)),
      );
     }).toList(),
    ),
   ),
  );
 }
}