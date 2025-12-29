import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/analyticsProvider.dart';
import '../../analytics/constants/analyticsConstants.dart';
import '../widgets/analyticsScaffold.dart';
class AnalyticsReportsScreen extends ConsumerWidget {
 const AnalyticsReportsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return AnalyticsScaffold(
   title: AnalyticsConstants.reportsTitle,
   body: ListView(
    padding: const EdgeInsets.all(16),
    children: [
     Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
       gradient: LinearGradient(colors: [AppColors.secondary, AppColors.secondary.withValues(alpha: 0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
       borderRadius: BorderRadius.circular(24),
       boxShadow: [BoxShadow(color: AppColors.secondary.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: Column(
       children: [
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle), child: const Icon(Icons.insert_drive_file_rounded, color: Colors.white, size: 40)),
        const SizedBox(height: 16),
        const Text(AnalyticsConstants.financialReports, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(AnalyticsConstants.downloadExportDesc, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
       ],
      ),
     ),
     const SizedBox(height: 24),
     Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12)]),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Row(children: [
         Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.folder_rounded, color: AppColors.primary, size: 24)),
         const SizedBox(width: 12),
         const Text(AnalyticsConstants.availableReportsLabel, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ]),
        const SizedBox(height: 20),
        ...AnalyticsConstants.availableReports.map((report) => _buildReportCard(context, ref, report['name']!, report['format']!)),
       ],
      ),
     ),
     const SizedBox(height: 24),
     Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.info.withValues(alpha: 0.3))),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Row(children: [Icon(Icons.info_rounded, color: AppColors.info, size: 24), const SizedBox(width: 8), const Text(AnalyticsConstants.exportTips, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),
        const SizedBox(height: 12),
        _buildTip(AnalyticsConstants.exportTip1),
        _buildTip(AnalyticsConstants.exportTip2),
        _buildTip(AnalyticsConstants.exportTip3),
       ],
      ),
     ),
    ],
   ),
  );
 }
 Widget _buildReportCard(BuildContext context, WidgetRef ref, String name, String format) {
  final icon = format == 'CSV' ? Icons.table_chart_rounded : Icons.picture_as_pdf_rounded;
  final color = format == 'CSV' ? AppColors.success : AppColors.error;
  return Container(
   margin: const EdgeInsets.only(bottom: 16),
   padding: const EdgeInsets.all(16),
   decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
   child: Row(
    children: [
     Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 28)),
     const SizedBox(width: 16),
     Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      const SizedBox(height: 4),
      Row(children: [
       Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Text(format, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold))),
       const SizedBox(width: 8),
       Text(AnalyticsConstants.readyToExport, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
      ]),
     ])),
     ElevatedButton.icon(
      onPressed: () => _downloadReport(context, ref, name, format),
      icon: const Icon(Icons.download_rounded, size: 18),
      label: const Text(AnalyticsConstants.exportButton),
      style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
     ),
    ],
   ),
  );
 }
 Future<void> _downloadReport(BuildContext context, WidgetRef ref, String name, String format) async {
  final userId = ref.read(currentUserIdProvider);
  if (userId == null) {
   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AnalyticsConstants.loginFirstError)));
   return;
  }
  try {
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Row(children: [const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)), const SizedBox(width: 16), Text('${AnalyticsConstants.generatingPrefix}$name...')]),
    duration: const Duration(seconds: 10),
   ));
   final content = await ref.read(analyticsRepositoryProvider).generateReport(userId, name);
   final directory = await getApplicationDocumentsDirectory();
   final fileName = name.split(' ').asMap().entries.map((e) => e.key == 0 ? e.value.toLowerCase() : e.value[0].toUpperCase() + e.value.substring(1).toLowerCase()).join('');
   final file = File('${directory.path}/$fileName.${format.toLowerCase()}');
   await file.writeAsString(content);
   if (context.mounted) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
      content: Row(children: [const Icon(Icons.check_circle_rounded, color: Colors.white), const SizedBox(width: 12), Expanded(child: Text('${AnalyticsConstants.reportSaved}$fileName.${format.toLowerCase()}'))]),
      backgroundColor: AppColors.success,
      action: SnackBarAction(label: AnalyticsConstants.okButton, textColor: Colors.white, onPressed: () {}),
      duration: const Duration(seconds: 5),
     ),
    );
   }
  } catch (e) {
   if (context.mounted) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AnalyticsConstants.errorPrefix}$e'), backgroundColor: AppColors.error));
   }
  }
 }
 Widget _buildTip(String tip) {
  return Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.check_circle_rounded, color: AppColors.info, size: 18), const SizedBox(width: 8), Expanded(child: Text(tip, style: TextStyle(color: Colors.grey[700])))]));
 }
}