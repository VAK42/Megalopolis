import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';
class AppTypography {
 static TextTheme lightTextTheme = TextTheme(
  displayLarge: GoogleFonts.outfit(fontSize: 57, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
  displayMedium: GoogleFonts.outfit(fontSize: 45, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
  displaySmall: GoogleFonts.outfit(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
  headlineLarge: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
  headlineMedium: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
  headlineSmall: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
  titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
  titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
  titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
  bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.textPrimary),
  bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.textPrimary),
  bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.textSecondary),
  labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
  labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
  labelSmall: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
 );
 static TextTheme darkTextTheme = TextTheme(
  displayLarge: GoogleFonts.outfit(fontSize: 57, fontWeight: FontWeight.bold, color: AppColors.textLight),
  displayMedium: GoogleFonts.outfit(fontSize: 45, fontWeight: FontWeight.bold, color: AppColors.textLight),
  displaySmall: GoogleFonts.outfit(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.textLight),
  headlineLarge: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w600, color: AppColors.textLight),
  headlineMedium: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.textLight),
  headlineSmall: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textLight),
  titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textLight),
  titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textLight),
  titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textLight),
  bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.textLight),
  bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.textLight),
  bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey[400]),
  labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textLight),
  labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textLight),
  labelSmall: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey[400]),
 );
}