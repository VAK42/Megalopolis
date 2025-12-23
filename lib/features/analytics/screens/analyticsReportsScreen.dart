import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/analyticsProvider.dart';
import '../../analytics/constants/analyticsConstants.dart';
class AnalyticsReportsScreen extends ConsumerWidget {
 const AnalyticsReportsScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   appBar: AppBar(title: const Text(AnalyticsConstants.reportsTitle)),
   body: ListView(padding: const EdgeInsets.all(16), children: AnalyticsConstants.availableReports.map((report) => _buildReport(context, ref, report['name']!, report['format']!)).toList()),
  );
 }
 Widget _buildReport(BuildContext context, WidgetRef ref, String name, String format) {
  return Card(
   margin: const EdgeInsets.only(bottom: 12),
   child: ListTile(
    leading: const Icon(Icons.description, color: AppColors.primary),
    title: Text(name),
    subtitle: Text(format),
    trailing: IconButton(
     icon: const Icon(Icons.download),
     onPressed: () async {
      final userId = ref.read(currentUserIdProvider);
      if (userId == null) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AnalyticsConstants.loginFirstError)));
       return;
      }
      try {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AnalyticsConstants.generatingPrefix}$name...')));
       final content = await ref.read(analyticsRepositoryProvider).generateReport(userId, name);
       final directory = await getApplicationDocumentsDirectory();
       final file = File('${directory.path}/${name.replaceAll(' ', '_')}.${format.toLowerCase()}');
       await file.writeAsString(content);
       if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text('${AnalyticsConstants.savedToPrefix}${file.path}'),
          action: SnackBarAction(label: AnalyticsConstants.okButton, onPressed: () {}),
          duration: const Duration(seconds: 5),
         ),
        );
       }
      } catch (e) {
       if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AnalyticsConstants.errorPrefix}$e')));
       }
      }
     },
    ),
   ),
  );
 }
}