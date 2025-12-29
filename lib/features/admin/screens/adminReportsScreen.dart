import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/adminProvider.dart';
import '../../../data/repositories/adminRepository.dart';
import '../widgets/adminScaffold.dart';
import '../constants/adminConstants.dart';
class AdminReportsScreen extends ConsumerStatefulWidget {
 const AdminReportsScreen({super.key});
 @override
 ConsumerState<AdminReportsScreen> createState() => _AdminReportsScreenState();
}
class _AdminReportsScreenState extends ConsumerState<AdminReportsScreen> {
 final AdminRepository repository = AdminRepository();
 Map<String, bool> generatingReports = {};
 Future<void> _generateReport(String reportName, String format) async {
  setState(() => generatingReports[reportName] = true);
  await Future.delayed(const Duration(seconds: 2));
  if (mounted) {
   setState(() => generatingReports[reportName] = false);
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AdminConstants.generatedPrefix}$reportName.$format'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
  }
 }
 @override
 Widget build(BuildContext context) {
  return AdminScaffold(
   title: AdminConstants.reportsScreenTitle,
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Text(AdminConstants.generateReportsTitle, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[800])),
      const SizedBox(height: 8),
      Text(AdminConstants.generateReportsSubtitle, style: TextStyle(color: Colors.grey[600])),
      const SizedBox(height: 24),
      ref.watch(reportTypesProvider).when(
       data: (reportTypes) {
        if (reportTypes.isEmpty) {
         return Column(
          children: [
           _buildReportCard(AdminConstants.salesReportTitle, AdminConstants.salesReportDescription, Icons.point_of_sale_rounded, const Color(0xFF6366F1), 'CSV'),
           _buildReportCard(AdminConstants.userAnalyticsTitle, AdminConstants.userAnalyticsDescription, Icons.people_rounded, const Color(0xFF10B981), 'CSV'),
           _buildReportCard(AdminConstants.orderSummaryTitle, AdminConstants.orderSummaryDescription, Icons.receipt_long_rounded, const Color(0xFFF59E0B), 'CSV'),
           _buildReportCard(AdminConstants.revenueReportTitle, AdminConstants.revenueReportDescription, Icons.attach_money_rounded, const Color(0xFFEC4899), 'CSV'),
           _buildReportCard(AdminConstants.supportMetricsTitle, AdminConstants.supportMetricsDescription, Icons.support_agent_rounded, const Color(0xFF8B5CF6), 'CSV'),
          ],
         );
        }
        return Column(children: reportTypes.map((type) {
         final name = type['name']?.toString() ?? 'Report';
         final description = type['description']?.toString() ?? '';
         final format = type['format']?.toString() ?? 'CSV';
         final icon = type['icon']?.toString() ?? 'receipt';
         IconData iconData;
         Color color;
         switch (icon) { case 'sales': iconData = Icons.point_of_sale_rounded; color = const Color(0xFF6366F1); break; case 'users': iconData = Icons.people_rounded; color = const Color(0xFF10B981); break; case 'orders': iconData = Icons.receipt_long_rounded; color = const Color(0xFFF59E0B); break; case 'revenue': iconData = Icons.attach_money_rounded; color = const Color(0xFFEC4899); break; case 'support': iconData = Icons.support_agent_rounded; color = const Color(0xFF8B5CF6); break; default: iconData = Icons.description_rounded; color = AppColors.primary; }
         return _buildReportCard(name, description, iconData, color, format);
        }).toList());
       },
       loading: () => const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator())),
       error: (_, __) => Column(
        children: [
         _buildReportCard(AdminConstants.salesReportTitle, AdminConstants.salesReportDescription, Icons.point_of_sale_rounded, const Color(0xFF6366F1), 'CSV'),
         _buildReportCard(AdminConstants.userAnalyticsTitle, AdminConstants.userAnalyticsDescription, Icons.people_rounded, const Color(0xFF10B981), 'CSV'),
         _buildReportCard(AdminConstants.orderSummaryTitle, AdminConstants.orderSummaryDescription, Icons.receipt_long_rounded, const Color(0xFFF59E0B), 'CSV'),
         _buildReportCard(AdminConstants.revenueReportTitle, AdminConstants.revenueReportDescription, Icons.attach_money_rounded, const Color(0xFFEC4899), 'CSV'),
         _buildReportCard(AdminConstants.supportMetricsTitle, AdminConstants.supportMetricsDescription, Icons.support_agent_rounded, const Color(0xFF8B5CF6), 'CSV'),
        ],
       ),
      ),
      const SizedBox(height: 32),
      Text(AdminConstants.quickStatsTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800])),
      const SizedBox(height: 16),
      FutureBuilder<Map<String, dynamic>>(
       future: repository.getSystemStats(),
       builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final stats = snapshot.data!;
        return Container(
         padding: const EdgeInsets.all(20),
         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade100)),
         child: Column(
          children: [
           Row(
            children: [
             Expanded(child: _buildStatItem(AdminConstants.totalUsersLabel, '${stats['totalUsers']}', Icons.people_rounded, const Color(0xFF6366F1))),
             Container(width: 1, height: 40, color: Colors.grey[200]),
             Expanded(child: _buildStatItem(AdminConstants.drawerOrders, '${stats['totalOrders']}', Icons.shopping_bag_rounded, const Color(0xFFF59E0B))),
             Container(width: 1, height: 40, color: Colors.grey[200]),
             Expanded(child: _buildStatItem(AdminConstants.revenueLabel, '\$${(stats['totalRevenue'] as num).toStringAsFixed(0)}', Icons.attach_money_rounded, const Color(0xFF10B981))),
            ],
           ),
          ],
         ),
        );
       },
      ),
      const SizedBox(height: 24),
      Text(AdminConstants.revenueBreakdownTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800])),
      const SizedBox(height: 16),
      FutureBuilder<Map<String, double>>(
       future: repository.getModuleRevenue(),
       builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final moduleRevenue = snapshot.data!;
        final total = moduleRevenue.values.fold(0.0, (a, b) => a + b);
        return Container(
         padding: const EdgeInsets.all(20),
         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade100)),
         child: Column(
          children: moduleRevenue.entries.map((entry) {
           final percentage = total > 0 ? entry.value / total : 0.0;
           Color color;
           switch (entry.key) { case 'food': color = const Color(0xFFF59E0B); break; case 'ride': color = const Color(0xFF6366F1); break; case 'mart': color = const Color(0xFF10B981); break; case 'service': color = const Color(0xFFEC4899); break; default: color = Colors.grey; }
           return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
             children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(entry.key[0].toUpperCase() + entry.key.substring(1), style: const TextStyle(fontWeight: FontWeight.w500)), Text('\$${entry.value.toStringAsFixed(0)} (${(percentage * 100).toStringAsFixed(1)}%)', style: TextStyle(fontWeight: FontWeight.bold, color: color))]),
              const SizedBox(height: 8),
              ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: percentage, minHeight: 8, backgroundColor: Colors.grey[200], valueColor: AlwaysStoppedAnimation(color))),
             ],
            ),
           );
          }).toList(),
         ),
        );
       },
      ),
     ],
    ),
   ),
  );
 }
 Widget _buildReportCard(String title, String description, IconData icon, Color color, String format) {
  final isGenerating = generatingReports[title] == true;
  return Container(
   margin: const EdgeInsets.only(bottom: 16),
   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2))]),
   child: ListTile(
    contentPadding: const EdgeInsets.all(16),
    leading: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: color, size: 28)),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
    subtitle: Padding(padding: const EdgeInsets.only(top: 4), child: Text(description, style: TextStyle(color: Colors.grey[600], fontSize: 13))),
    trailing: ElevatedButton.icon(
     onPressed: isGenerating ? null : () => _generateReport(title, format),
     icon: isGenerating ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.download_rounded, size: 18),
     label: Text(isGenerating ? '...' : format),
     style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, disabledBackgroundColor: color.withValues(alpha: 0.6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
    ),
   ),
  );
 }
 Widget _buildStatItem(String label, String value, IconData icon, Color color) {
  return Column(
   children: [
    Icon(icon, color: color, size: 24),
    const SizedBox(height: 8),
    Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
    const SizedBox(height: 4),
    Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
   ],
  );
 }
}