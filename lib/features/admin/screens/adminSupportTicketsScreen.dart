import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/adminProvider.dart';
import '../../../data/repositories/adminRepository.dart';
import '../widgets/adminScaffold.dart';
import '../constants/adminConstants.dart';
class AdminSupportTicketsScreen extends ConsumerStatefulWidget {
 const AdminSupportTicketsScreen({super.key});
 @override
 ConsumerState<AdminSupportTicketsScreen> createState() => _AdminSupportTicketsScreenState();
}
class _AdminSupportTicketsScreenState extends ConsumerState<AdminSupportTicketsScreen> with SingleTickerProviderStateMixin {
 late TabController _tabController;
 final AdminRepository repository = AdminRepository();
 @override
 void initState() {
  super.initState();
  _tabController = TabController(length: 3, vsync: this);
 }
 @override
 void dispose() {
  _tabController.dispose();
  super.dispose();
 }
 Future<void> _updateTicketStatus(String ticketId, String newStatus) async {
  await repository.updateSupportTicketStatus(ticketId, newStatus);
  ref.invalidate(adminTicketsProvider);
  if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AdminConstants.ticketStatusUpdatedPrefix}${newStatus[0].toUpperCase()}${newStatus.substring(1).replaceAll('_', ' ')}'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
 }
 Future<void> _showReplyDialog(Map<String, dynamic> ticket) async {
  final replyController = TextEditingController();
  await showDialog(
   context: context,
   builder: (context) => AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    title: Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.reply_rounded, color: AppColors.primary)), const SizedBox(width: 12), Text(AdminConstants.replyButton)]),
    content: Column(
     mainAxisSize: MainAxisSize.min,
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Container(
       padding: const EdgeInsets.all(12),
       decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(ticket['subject']?.toString() ?? AdminConstants.supportRequest, style: const TextStyle(fontWeight: FontWeight.bold)),
         const SizedBox(height: 8),
         Text(ticket['message']?.toString() ?? AdminConstants.noMessageContent, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        ],
       ),
      ),
      const SizedBox(height: 20),
      TextField(controller: replyController, maxLines: 4, decoration: InputDecoration(labelText: AdminConstants.messageTitle, alignLabelWithHint: true, prefixIcon: const Padding(padding: EdgeInsets.only(bottom: 60), child: Icon(Icons.message_rounded)), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50])),
     ],
    ),
    actions: [
     TextButton(onPressed: () => Navigator.pop(context), child: Text(AdminConstants.cancelButton, style: TextStyle(color: Colors.grey[600]))),
     ElevatedButton(
      onPressed: () async {
       if (replyController.text.isNotEmpty) {
        await _updateTicketStatus(ticket['id'].toString(), 'inProgress');
        if (mounted) Navigator.pop(context);
       }
      },
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: Text(AdminConstants.sendReplyButton),
     ),
    ],
   ),
  );
 }
 void _showTicketDetails(Map<String, dynamic> ticket) {
  final status = ticket['status']?.toString() ?? 'open';
  final priority = ticket['priority']?.toString() ?? 'normal';
  Color statusColor = status == 'closed' ? AppColors.success : (status == 'inProgress' ? AppColors.info : AppColors.warning);
  Color priorityColor = priority == 'high' ? AppColors.error : (priority == 'normal' ? AppColors.warning : Colors.grey);
  showModalBottomSheet(
   context: context,
   isScrollControlled: true,
   shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
   builder: (context) => DraggableScrollableSheet(
    initialChildSize: 0.7,
    minChildSize: 0.5,
    maxChildSize: 0.95,
    expand: false,
    builder: (context, scrollController) => SingleChildScrollView(
     controller: scrollController,
     padding: const EdgeInsets.all(24),
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
       const SizedBox(height: 20),
       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Text(ticket['subject']?.toString() ?? AdminConstants.supportRequest, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)), child: Text(status.toUpperCase().replaceAll('_', ' '), style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)))]),
       const SizedBox(height: 16),
       Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: priorityColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Row(children: [Icon(Icons.flag_rounded, size: 16, color: priorityColor), const SizedBox(width: 4), Text('${priority.toUpperCase()}${AdminConstants.prioritySuffix}', style: TextStyle(fontSize: 12, color: priorityColor, fontWeight: FontWeight.bold))])), const SizedBox(width: 12), Text('${AdminConstants.idPrefix}${ticket['id'].toString()}...', style: TextStyle(color: Colors.grey[600], fontSize: 12))]),
       const SizedBox(height: 24),
       Text(AdminConstants.messageTitle, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
       const SizedBox(height: 8),
       Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12)), child: Text(ticket['message']?.toString() ?? AdminConstants.noMessageContent, style: TextStyle(color: Colors.grey[700], height: 1.5))),
       const SizedBox(height: 16),
       Row(children: [Icon(Icons.person_rounded, size: 18, color: Colors.grey[600]), const SizedBox(width: 8), Text('${AdminConstants.userIdPrefix}${ticket['userId']?.toString() ?? AdminConstants.unknownText}', style: TextStyle(color: Colors.grey[600]))]),
       const SizedBox(height: 8),
       Row(children: [Icon(Icons.access_time_rounded, size: 18, color: Colors.grey[600]), const SizedBox(width: 8), Text('${AdminConstants.createdPrefix}${_formatDate(ticket['createdAt'])}', style: TextStyle(color: Colors.grey[600]))]),
       const SizedBox(height: 32),
       if (status != 'closed') ...[
        Row(
         children: [
          if (status == 'open') Expanded(child: ElevatedButton.icon(onPressed: () { Navigator.pop(context); _updateTicketStatus(ticket['id'].toString(), 'inProgress'); }, icon: const Icon(Icons.play_arrow_rounded), label: Text(AdminConstants.startButton), style: ElevatedButton.styleFrom(backgroundColor: AppColors.info, foregroundColor: Colors.white, padding: const EdgeInsets.all(16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
          if (status == 'inProgress') Expanded(child: ElevatedButton.icon(onPressed: () { Navigator.pop(context); _updateTicketStatus(ticket['id'].toString(), 'closed'); }, icon: const Icon(Icons.check_circle_rounded), label: Text(AdminConstants.closeButton), style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white, padding: const EdgeInsets.all(16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
          const SizedBox(width: 12),
          Expanded(child: OutlinedButton.icon(onPressed: () { Navigator.pop(context); _showReplyDialog(ticket); }, icon: const Icon(Icons.reply_rounded), label: Text(AdminConstants.replyButton), style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
         ],
        ),
       ] else ...[
        ElevatedButton.icon(onPressed: () { Navigator.pop(context); _updateTicketStatus(ticket['id'].toString(), 'open'); }, icon: const Icon(Icons.refresh_rounded), label: Text(AdminConstants.reopenButton), style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning, foregroundColor: Colors.white, padding: const EdgeInsets.all(16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), minimumSize: const Size(double.infinity, 50))),
       ],
      ],
     ),
    ),
   ),
  );
 }
 String _formatDate(dynamic timestamp) {
  if (timestamp == null) return AdminConstants.unknownText;
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp is int ? timestamp : int.tryParse(timestamp.toString()) ?? 0);
  return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
 }
 @override
 Widget build(BuildContext context) {
  return AdminScaffold(
   title: AdminConstants.supportTicketsTitle,
   body: Column(
    children: [
     Container(
      color: Colors.white,
      child: Column(
       children: [
        Padding(
         padding: const EdgeInsets.all(16),
         child: ref.watch(adminTicketsProvider).when(
          data: (tickets) {
           final open = tickets.where((t) => t['status'] == 'open').length;
           final inProgress = tickets.where((t) => t['status'] == 'inProgress').length;
           final closed = tickets.where((t) => t['status'] == 'closed').length;
           return Row(children: [_buildStatChip(AdminConstants.openLabel, '$open', AppColors.warning), const SizedBox(width: 12), _buildStatChip(AdminConstants.inProgressLabel, '$inProgress', AppColors.info), const SizedBox(width: 12), _buildStatChip(AdminConstants.resolvedLabel, '$closed', AppColors.success)]);
          },
          loading: () => Row(children: [_buildStatChip(AdminConstants.openLabel, '-', AppColors.warning), const SizedBox(width: 12), _buildStatChip(AdminConstants.inProgressLabel, '-', AppColors.info), const SizedBox(width: 12), _buildStatChip(AdminConstants.resolvedLabel, '-', AppColors.success)]),
          error: (_, __) => const SizedBox(),
         ),
        ),
        TabBar(controller: _tabController, labelColor: AppColors.primary, unselectedLabelColor: Colors.grey, indicatorColor: AppColors.primary, tabs: [Tab(text: AdminConstants.tabOpen), Tab(text: AdminConstants.tabInProgress), Tab(text: AdminConstants.tabClosed)]),
       ],
      ),
     ),
     Expanded(
      child: ref.watch(adminTicketsProvider).when(
       data: (tickets) => TabBarView(
        controller: _tabController,
        children: ['open', 'inProgress', 'closed'].map((statusFilter) {
         final filteredTickets = tickets.where((t) => t['status'] == statusFilter).toList();
         if (filteredTickets.isEmpty) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.inbox_rounded, size: 64, color: Colors.grey[300]), const SizedBox(height: 16), Text(AdminConstants.noSupportTickets, style: TextStyle(color: Colors.grey[600]))]));
         return RefreshIndicator(
          onRefresh: () async => ref.invalidate(adminTicketsProvider),
          child: ListView.builder(
           padding: const EdgeInsets.all(20),
           itemCount: filteredTickets.length,
           itemBuilder: (context, index) {
            final ticket = filteredTickets[index];
            final status = ticket['status']?.toString() ?? 'open';
            final priority = ticket['priority']?.toString() ?? 'normal';
            Color statusColor = status == 'closed' ? AppColors.success : (status == 'inProgress' ? AppColors.info : AppColors.warning);
            Color priorityColor = priority == 'high' ? AppColors.error : (priority == 'normal' ? AppColors.warning : Colors.grey);
            return GestureDetector(
             onTap: () => _showTicketDetails(ticket),
             child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: priority == 'high' ? AppColors.error.withValues(alpha: 0.3) : Colors.grey.shade100), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2))]),
              child: Padding(
               padding: const EdgeInsets.all(16),
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Row(
                  children: [
                   Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.support_agent_rounded, color: statusColor)),
                   const SizedBox(width: 16),
                   Expanded(
                    child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                      Text(ticket['subject']?.toString() ?? AdminConstants.supportRequest, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      const SizedBox(height: 4),
                      Row(
                       children: [
                        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Text(status.toUpperCase().replaceAll('_', ' '), style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.bold))),
                        const SizedBox(width: 8),
                        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: priorityColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Row(children: [Icon(Icons.flag_rounded, size: 12, color: priorityColor), const SizedBox(width: 2), Text(priority.toUpperCase(), style: TextStyle(fontSize: 10, color: priorityColor, fontWeight: FontWeight.bold))])),
                       ],
                      ),
                     ],
                    ),
                   ),
                   Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
                  ],
                 ),
                 const SizedBox(height: 12),
                 Text(ticket['message']?.toString() ?? AdminConstants.noMessageContent, style: TextStyle(color: Colors.grey[600], fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                 const SizedBox(height: 12),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   Text(_formatDate(ticket['createdAt']), style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                   if (status != 'closed') Row(
                    children: [
                     if (status == 'open') TextButton.icon(onPressed: () => _updateTicketStatus(ticket['id'].toString(), 'inProgress'), icon: const Icon(Icons.play_arrow_rounded, size: 18), label: Text(AdminConstants.startButton), style: TextButton.styleFrom(foregroundColor: AppColors.info, padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap)),
                     if (status == 'inProgress') TextButton.icon(onPressed: () => _updateTicketStatus(ticket['id'].toString(), 'closed'), icon: const Icon(Icons.check_circle_rounded, size: 18), label: Text(AdminConstants.closeButton), style: TextButton.styleFrom(foregroundColor: AppColors.success, padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap)),
                    ],
                   ),
                  ],
                 ),
                ],
               ),
              ),
             ),
            );
           },
          ),
         );
        }).toList(),
       ),
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (_, __) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.error_outline_rounded, size: 64, color: Colors.grey[400]), const SizedBox(height: 16), Text(AdminConstants.errorLoadingTicketsMessage, style: TextStyle(color: Colors.grey[600])), const SizedBox(height: 16), ElevatedButton.icon(onPressed: () => ref.invalidate(adminTicketsProvider), icon: const Icon(Icons.refresh_rounded), label: Text(AdminConstants.retryButton), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary))])),
      ),
     ),
    ],
   ),
  );
 }
 Widget _buildStatChip(String label, String count, Color color) {
  return Expanded(child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Column(children: [Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)), Text(label, style: TextStyle(fontSize: 12, color: color))])));
 }
}