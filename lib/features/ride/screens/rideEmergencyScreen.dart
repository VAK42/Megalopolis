import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../ride/constants/rideConstants.dart';
class RideEmergencyScreen extends ConsumerWidget {
 const RideEmergencyScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(RideConstants.emergencyTitle),
    backgroundColor: AppColors.error,
    foregroundColor: Colors.white,
   ),
   body: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
     children: [
      Container(
       padding: const EdgeInsets.all(24),
       decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error),
       ),
       child: const Column(
        children: [
         Icon(Icons.warning_amber_rounded, size: 60, color: AppColors.error),
         SizedBox(height: 16),
         Text(
          RideConstants.emergencyAssistanceTitle,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
         ),
         SizedBox(height: 8),
         Text(RideConstants.emergencySafetyMessage, textAlign: TextAlign.center),
        ],
       ),
      ),
      const SizedBox(height: 24),
      _buildEmergencyOption(Icons.call, RideConstants.callPolice, RideConstants.callEmergencyServices, AppColors.error),
      _buildEmergencyOption(Icons.local_hospital, RideConstants.callAmbulance, RideConstants.callEmergencyServices, Colors.orange),
      _buildEmergencyOption(Icons.location_on, RideConstants.shareLocation, RideConstants.shareWithContacts, AppColors.primary),
      _buildEmergencyOption(Icons.report, RideConstants.reportIncident, RideConstants.tripDetails, AppColors.accent),
      _buildEmergencyOption(Icons.support_agent, RideConstants.support, RideConstants.support, AppColors.secondary),
      const Spacer(),
      Container(
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
       ),
       child: const Row(
        children: [
         Icon(Icons.info_outline, color: AppColors.primary),
         SizedBox(width: 12),
         Expanded(child: Text(RideConstants.safetyDisclaimer, style: TextStyle(fontSize: 12))),
        ],
       ),
      ),
     ],
    ),
   ),
  );
 }
 Widget _buildEmergencyOption(IconData icon, String title, String subtitle, Color color) {
  return Card(
   margin: const EdgeInsets.only(bottom: 12),
   child: ListTile(
    leading: Container(
     padding: const EdgeInsets.all(10),
     decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
     child: Icon(icon, color: color),
    ),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text(subtitle),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
   ),
  );
 }
}