import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/driverProvider.dart';
import '../constants/driverConstants.dart';
class DriverRegistrationScreen extends ConsumerStatefulWidget {
 const DriverRegistrationScreen({super.key});
 @override
 ConsumerState<DriverRegistrationScreen> createState() => _DriverRegistrationScreenState();
}
class _DriverRegistrationScreenState extends ConsumerState<DriverRegistrationScreen> {
 final formKey = GlobalKey<FormState>();
 final vehicleTypeController = TextEditingController();
 final vehicleNumberController = TextEditingController();
 final licenseNumberController = TextEditingController();
 bool isSubmitting = false;
 @override
 void dispose() {
  vehicleTypeController.dispose();
  vehicleNumberController.dispose();
  licenseNumberController.dispose();
  super.dispose();
 }
 Future<void> _submitRegistration() async {
  if (!formKey.currentState!.validate()) return;
  setState(() => isSubmitting = true);
  try {
   final userId = ref.read(currentUserIdProvider) ?? '';
   await ref.read(driverRepositoryProvider).registerAsDriver(userId, {'vehicleType': vehicleTypeController.text, 'vehicleNumber': vehicleNumberController.text, 'licenseNumber': licenseNumberController.text});
   if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(DriverConstants.registrationSuccess)));
    context.go(Routes.driverDashboard);
   }
  } catch (e) {
   if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${DriverConstants.errorPrefix}$e')));
   }
  } finally {
   if (mounted) setState(() => isSubmitting = false);
  }
 }
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(title: const Text(DriverConstants.registrationTitle)),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Form(
     key: formKey,
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
        child: const Row(
         children: [
          Icon(Icons.directions_car, size: 48, color: Colors.white),
          SizedBox(width: 16),
          Expanded(
           child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Text(
              DriverConstants.joinDriverTeam,
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
             ),
             SizedBox(height: 4),
             Text(DriverConstants.earnOnSchedule, style: TextStyle(color: Colors.white70)),
            ],
           ),
          ),
         ],
        ),
       ),
       const SizedBox(height: 24),
       TextFormField(
        controller: vehicleTypeController,
        decoration: InputDecoration(
         labelText: DriverConstants.vehicleType,
         hintText: DriverConstants.vehicleTypeHint,
         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (v) => v?.isEmpty ?? true ? DriverConstants.required : null,
       ),
       const SizedBox(height: 16),
       TextFormField(
        controller: vehicleNumberController,
        decoration: InputDecoration(
         labelText: DriverConstants.vehicleNumber,
         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (v) => v?.isEmpty ?? true ? DriverConstants.required : null,
       ),
       const SizedBox(height: 16),
       TextFormField(
        controller: licenseNumberController,
        decoration: InputDecoration(
         labelText: DriverConstants.licenseNumber,
         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (v) => v?.isEmpty ?? true ? DriverConstants.required : null,
       ),
       const SizedBox(height: 24),
       SizedBox(
        width: double.infinity,
        child: ElevatedButton(
         onPressed: isSubmitting ? null : _submitRegistration,
         style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
         child: isSubmitting ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text(DriverConstants.submitRegistration),
        ),
       ),
      ],
     ),
    ),
   ),
  );
 }
}