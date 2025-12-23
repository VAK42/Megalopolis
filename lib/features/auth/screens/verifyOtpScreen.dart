import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/authConstants.dart';
class VerifyOtpScreen extends ConsumerStatefulWidget {
 const VerifyOtpScreen({super.key});
 @override
 ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}
class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen> {
 final otpController = TextEditingController();
 bool isLoading = false;
 int resendTimer = 60;
 @override
 void initState() {
  super.initState();
  startTimer();
 }
 void startTimer() {
  Future.delayed(const Duration(seconds: 1), () {
   if (mounted && resendTimer > 0) {
    setState(() => resendTimer--);
    startTimer();
   }
  });
 }
 void handleVerify() {
  if (otpController.text.length == 6) {
   setState(() => isLoading = true);
   Future.delayed(const Duration(seconds: 2), () {
    if (mounted) {
     context.go(Routes.setLocation);
    }
   });
  }
 }
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.login)),
   ),
   body: SafeArea(
    child: SingleChildScrollView(
     padding: const EdgeInsets.all(24.0),
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Text(AuthConstants.verifyNumberTitle, style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)).animate().fadeIn().slideX(begin: -0.2, end: 0),
       const SizedBox(height: 12),
       Text(AuthConstants.verifyNumberSubtitle, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600])).animate().fadeIn(delay: 200.ms),
       const SizedBox(height: 48),
       PinCodeTextField(
        appContext: context,
        length: 6,
        controller: otpController,
        keyboardType: TextInputType.number,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(shape: PinCodeFieldShape.box, borderRadius: BorderRadius.circular(12), fieldHeight: 56, fieldWidth: 48, activeFillColor: Colors.white, inactiveFillColor: Colors.white, selectedFillColor: Colors.white, activeColor: AppColors.primary, inactiveColor: Colors.grey[300]!, selectedColor: AppColors.primary),
        enableActiveFill: true,
        onCompleted: (value) => handleVerify(),
        onChanged: (value) {},
       ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
       const SizedBox(height: 32),
       Center(
        child: resendTimer > 0
          ? Text('${AuthConstants.resendCodePrefix}$resendTimer${AuthConstants.resendCodeSuffix}', style: TextStyle(color: Colors.grey[600]))
          : TextButton(
            onPressed: () {
             setState(() => resendTimer = 60);
             startTimer();
            },
            child: const Text(AuthConstants.resendCodeButton),
           ),
       ),
       const SizedBox(height: 32),
       AppButton(text: AuthConstants.verifyButton, onPressed: handleVerify, isLoading: isLoading, icon: Icons.check_circle_outline).animate().fadeIn(delay: 600.ms),
      ],
     ),
    ),
   ),
  );
 }
 @override
 void dispose() {
  otpController.dispose();
  super.dispose();
 }
}