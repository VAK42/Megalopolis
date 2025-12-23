import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/adminProvider.dart';
import '../../../data/repositories/adminRepository.dart';
import '../../admin/constants/adminConstants.dart';
class AdminContentModerationScreen extends ConsumerWidget {
 const AdminContentModerationScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final repository = AdminRepository();
  Future<void> updateReportStatus(String reportId, String newStatus) async {
   await repository.updateReportStatus(reportId, newStatus);
   ref.invalidate(adminReportsProvider);
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Report $newStatus${AdminConstants.reportStatusSuccessSuffix}')));
  }
  return DefaultTabController(
   length: 3,
   child: Scaffold(
    appBar: AppBar(
     title: const Text(AdminConstants.moderationTitle),
     bottom: const TabBar(
      tabs: [
       Tab(text: AdminConstants.tabPending),
       Tab(text: AdminConstants.tabApproved),
       Tab(text: AdminConstants.tabRejected),
      ],
     ),
    ),
    body: TabBarView(
     children: AdminConstants.reportStatuses.map((tabStatus) {
      final reportsAsync = ref.watch(adminReportsProvider);
      return reportsAsync.when(
       data: (reports) {
        final filteredReports = reports.where((r) => (r['status'] ?? 'pending') == tabStatus).toList();
        if (filteredReports.isEmpty) {
         return Center(child: Text('${AdminConstants.noReportsPrefix}${tabStatus[0].toUpperCase()}${tabStatus.substring(1)}${AdminConstants.reportsSuffix}'));
        }
        return ListView.builder(
         padding: const EdgeInsets.all(16),
         itemCount: filteredReports.length,
         itemBuilder: (c, i) {
          final report = filteredReports[i];
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
                Text('${AdminConstants.reportPrefix}${report['id'].toString().substring(0, 8)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Container(
                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                 decoration: BoxDecoration(
                  color: tabStatus == 'rejected'
                    ? AppColors.error.withValues(alpha: 0.2)
                    : tabStatus == 'approved'
                    ? AppColors.success.withValues(alpha: 0.2)
                    : Colors.orange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                 ),
                 child: Text(
                  tabStatus.toUpperCase(),
                  style: TextStyle(
                   fontSize: 10,
                   color: tabStatus == 'rejected'
                     ? AppColors.error
                     : tabStatus == 'approved'
                     ? AppColors.success
                     : Colors.orange,
                  ),
                 ),
                ),
               ],
              ),
              const SizedBox(height: 8),
              Text('${AdminConstants.typePrefix}${report['type']?.toString() ?? AdminConstants.contentDefault}', style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(report['reason']?.toString() ?? AdminConstants.noReasonProvided, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              if (tabStatus == 'pending') ...[
               const SizedBox(height: 12),
               Row(
                children: [
                 Expanded(
                  child: ElevatedButton(onPressed: () => updateReportStatus(report['id'].toString(), 'approved'), child: const Text(AdminConstants.approveButton)),
                 ),
                 const SizedBox(width: 8),
                 Expanded(
                  child: OutlinedButton(
                   onPressed: () => updateReportStatus(report['id'].toString(), 'rejected'),
                   style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
                   child: const Text(AdminConstants.rejectButton),
                  ),
                 ),
                ],
               ),
              ],
             ],
            ),
           ),
          );
         },
        );
       },
       loading: () => const Center(child: CircularProgressIndicator()),
       error: (_, __) => const Center(child: Text(AdminConstants.errorLoadingModeration)),
      );
     }).toList(),
    ),
   ),
  );
 }
}