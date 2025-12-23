import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/constants/appConstants.dart';
class AppButton extends StatelessWidget {
 final String text;
 final VoidCallback? onPressed;
 final bool isLoading;
 final bool isOutline;
 final IconData? icon;
 final Color? backgroundColor;
 final Color? textColor;
 final double? width;
 const AppButton({super.key, required this.text, this.onPressed, this.isLoading = false, this.isOutline = false, this.icon, this.backgroundColor, this.textColor, this.width});
 @override
 Widget build(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return SizedBox(
   width: width ?? double.infinity,
   height: 56,
   child: isOutline
     ? OutlinedButton(
       onPressed: isLoading ? null : onPressed,
       style: OutlinedButton.styleFrom(
        side: BorderSide(color: backgroundColor ?? AppColors.primary, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
       ),
       child: _buildContent(context, isDark),
      )
     : ElevatedButton(
       onPressed: isLoading ? null : onPressed,
       style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        foregroundColor: textColor ?? Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
        elevation: 0,
       ),
       child: _buildContent(context, isDark),
      ),
  );
 }
 Widget _buildContent(BuildContext context, bool isDark) {
  if (isLoading) {
   return SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(isOutline ? (backgroundColor ?? AppColors.primary) : Colors.white)));
  }
  if (icon != null) {
   return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
     Icon(icon, size: 20),
     const SizedBox(width: 8),
     Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    ],
   );
  }
  return Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600));
 }
}