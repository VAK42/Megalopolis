import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/adminProvider.dart';
import '../../../data/repositories/adminRepository.dart';
import '../widgets/adminScaffold.dart';
import '../constants/adminConstants.dart';
class AdminContentModerationScreen extends ConsumerStatefulWidget {
 const AdminContentModerationScreen({super.key});
 @override
 ConsumerState<AdminContentModerationScreen> createState() => _AdminContentModerationScreenState();
}
class _AdminContentModerationScreenState extends ConsumerState<AdminContentModerationScreen> with SingleTickerProviderStateMixin {
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
 Future<void> _updateReportStatus(String reportId, String newStatus) async {
  await repository.updateContentReportStatus(reportId, newStatus);
  ref.invalidate(adminReportsProvider);
  if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${newStatus[0].toUpperCase()}${newStatus.substring(1)}${AdminConstants.reportStatusSuccessSuffix}'), backgroundColor: newStatus == 'approved' ? AppColors.success : AppColors.error, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
 }
 void _showReportDetails(Map<String, dynamic> report) {
  final status = report['status']?.toString() ?? 'pending';
  final type = report['type']?.toString() ?? 'content';
  Color statusColor = status == 'approved' ? AppColors.success : (status == 'rejected' ? AppColors.error : AppColors.warning);
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
       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('${AdminConstants.reportPrefix}${report['id'].toString()}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)), child: Text(status.toUpperCase(), style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)))]),
       const SizedBox(height: 16),
       Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Text('${AdminConstants.typeLabel}: ${type.toUpperCase()}', style: const TextStyle(fontSize: 12, color: AppColors.info, fontWeight: FontWeight.bold))),
       const SizedBox(height: 24),
       Text(AdminConstants.reportedContentLabel, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
       const SizedBox(height: 8),
       Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12)), child: Text(report['content']?.toString() ?? AdminConstants.contentDefault, style: TextStyle(color: Colors.grey[700], height: 1.5))),
       const SizedBox(height: 16),
       Text(AdminConstants.reasonLabel, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
       const SizedBox(height: 8),
       Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.error.withValues(alpha: 0.2))), child: Row(children: [Icon(Icons.flag_rounded, color: AppColors.error.withValues(alpha: 0.7)), const SizedBox(width: 12), Expanded(child: Text(report['reason']?.toString() ?? AdminConstants.noReasonProvided, style: TextStyle(color: Colors.grey[700])))])),
       const SizedBox(height: 16),
       Row(children: [Icon(Icons.person_rounded, size: 18, color: Colors.grey[600]), const SizedBox(width: 8), Text('${AdminConstants.reportedByPrefix}${report['reportedBy']?.toString() ?? AdminConstants.anonymousLabel}', style: TextStyle(color: Colors.grey[600]))]),
       const SizedBox(height: 8),
       Row(children: [Icon(Icons.access_time_rounded, size: 18, color: Colors.grey[600]), const SizedBox(width: 8), Text('${AdminConstants.createdPrefix}${_formatDate(report['createdAt'])}', style: TextStyle(color: Colors.grey[600]))]),
       const SizedBox(height: 32),
       if (status == 'pending') ...[
        Row(
         children: [
          Expanded(child: ElevatedButton.icon(onPressed: () { Navigator.pop(context); _updateReportStatus(report['id'].toString(), 'approved'); }, icon: const Icon(Icons.check_circle_rounded), label: Text(AdminConstants.approveButton), style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white, padding: const EdgeInsets.all(16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
          const SizedBox(width: 12),
          Expanded(child: ElevatedButton.icon(onPressed: () { Navigator.pop(context); _updateReportStatus(report['id'].toString(), 'rejected'); }, icon: const Icon(Icons.cancel_rounded), label: Text(AdminConstants.rejectButton), style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white, padding: const EdgeInsets.all(16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
         ],
        ),
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
   title: AdminConstants.contentModerationTitle,
   body: Column(
    children: [
     Container(
      color: Colors.white,
      child: Column(
       children: [
        Padding(
         padding: const EdgeInsets.all(16),
         child: ref.watch(adminReportsProvider).when(
          data: (reports) {
           final pending = reports.where((r) => r['status'] == 'pending').length;
           final approved = reports.where((r) => r['status'] == 'approved').length;
           final rejected = reports.where((r) => r['status'] == 'rejected').length;
           return Row(children: [_buildStatChip(AdminConstants.pendingLabel, '$pending', AppColors.warning), const SizedBox(width: 12), _buildStatChip(AdminConstants.approvedLabel, '$approved', AppColors.success), const SizedBox(width: 12), _buildStatChip(AdminConstants.rejectedLabel, '$rejected', AppColors.error)]);
          },
          loading: () => Row(children: [_buildStatChip(AdminConstants.pendingLabel, '-', AppColors.warning), const SizedBox(width: 12), _buildStatChip(AdminConstants.approvedLabel, '-', AppColors.success), const SizedBox(width: 12), _buildStatChip(AdminConstants.rejectedLabel, '-', AppColors.error)]),
          error: (_, __) => const SizedBox(),
         ),
        ),
        TabBar(controller: _tabController, labelColor: AppColors.primary, unselectedLabelColor: Colors.grey, indicatorColor: AppColors.primary, tabs: [Tab(text: AdminConstants.tabPending), Tab(text: AdminConstants.tabApproved), Tab(text: AdminConstants.tabRejected)]),
       ],
      ),
     ),
     Expanded(
      child: ref.watch(adminReportsProvider).when(
       data: (reports) => TabBarView(
        controller: _tabController,
        children: ['pending', 'approved', 'rejected'].map((statusFilter) {
         final filteredReports = reports.where((r) => r['status'] == statusFilter).toList();
         if (filteredReports.isEmpty) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.inbox_rounded, size: 64, color: Colors.grey[300]), const SizedBox(height: 16), Text('${AdminConstants.noReportsPrefix}${statusFilter[0].toUpperCase()}${statusFilter.substring(1)}${AdminConstants.reportsSuffix}', style: TextStyle(color: Colors.grey[600]))]));
         return RefreshIndicator(
          onRefresh: () async => ref.invalidate(adminReportsProvider),
          child: ListView.builder(
           padding: const EdgeInsets.all(20),
           itemCount: filteredReports.length,
           itemBuilder: (context, index) {
            final report = filteredReports[index];
            final status = report['status']?.toString() ?? 'pending';
            final type = report['type']?.toString() ?? 'content';
            Color statusColor = status == 'approved' ? AppColors.success : (status == 'rejected' ? AppColors.error : AppColors.warning);
            return GestureDetector(
             onTap: () => _showReportDetails(report),
             child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: status == 'pending' ? AppColors.warning.withValues(alpha: 0.3) : Colors.grey.shade100), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2))]),
              child: Padding(
               padding: const EdgeInsets.all(16),
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Row(
                  children: [
                   Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(type == 'review' ? Icons.rate_review_rounded : (type == 'image' ? Icons.image_rounded : (type == 'profile' ? Icons.person_rounded : Icons.text_fields_rounded)), color: statusColor)),
                   const SizedBox(width: 16),
                   Expanded(
                    child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                      Text('${AdminConstants.reportPrefix}${report['id'].toString()}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      const SizedBox(height: 4),
                      Row(
                       children: [
                        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Text(status.toUpperCase(), style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.bold))),
                        const SizedBox(width: 8),
                        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Text(type.toUpperCase(), style: const TextStyle(fontSize: 10, color: AppColors.info, fontWeight: FontWeight.bold))),
                       ],
                      ),
                     ],
                    ),
                   ),
                   Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
                  ],
                 ),
                 const SizedBox(height: 12),
                 Text(report['content']?.toString() ?? AdminConstants.contentDefault, style: TextStyle(color: Colors.grey[600], fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                 const SizedBox(height: 12),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   Text(_formatDate(report['createdAt']), style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                   if (status == 'pending') Row(
                    children: [
                     TextButton.icon(onPressed: () => _updateReportStatus(report['id'].toString(), 'approved'), icon: const Icon(Icons.check_rounded, size: 18), label: Text(AdminConstants.approveActionButton), style: TextButton.styleFrom(foregroundColor: AppColors.success, padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap)),
                     const SizedBox(width: 16),
                     TextButton.icon(onPressed: () => _updateReportStatus(report['id'].toString(), 'rejected'), icon: const Icon(Icons.close_rounded, size: 18), label: Text(AdminConstants.rejectActionButton), style: TextButton.styleFrom(foregroundColor: AppColors.error, padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap)),
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
       error: (_, __) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.error_outline_rounded, size: 64, color: Colors.grey[400]), const SizedBox(height: 16), Text(AdminConstants.errorLoadingModeration, style: TextStyle(color: Colors.grey[600])), const SizedBox(height: 16), ElevatedButton.icon(onPressed: () => ref.invalidate(adminReportsProvider), icon: const Icon(Icons.refresh_rounded), label: Text(AdminConstants.retryButton), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary))])),
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