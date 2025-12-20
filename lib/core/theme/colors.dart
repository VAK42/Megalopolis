import 'package:flutter/material.dart';
class AppColors {
  static const primary = Color(0xFF6366F1);
  static const primaryDark = Color(0xFF4F46E5);
  static const accent = Color(0xFFF97316);
  static const cyan = Color(0xFF06B6D4);
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFFBBF24);
  static const error = Color(0xFFEF4444);
  static const backgroundDark = Color(0xFF0F172A);
  static const backgroundLight = Color(0xFFF8FAFC);
  static const cardDark = Color(0xFF1E293B);
  static const cardLight = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1F2937);
  static const textSecondary = Color(0xFF6B7280);
  static const textLight = Color(0xFFF9FAFB);
  static const border = Color(0xFFE5E7EB);
  static const borderDark = Color(0xFF374151);
  static const shimmerBase = Color(0xFFE5E7EB);
  static const shimmerHighlight = Color(0xFFF9FAFB);
  static const shimmerBaseDark = Color(0xFF1F2937);
  static const shimmerHighlightDark = Color(0xFF374151);
  static LinearGradient primaryGradient = const LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static LinearGradient successGradient = const LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static LinearGradient accentGradient = const LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFEF4444)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static LinearGradient errorGradient = const LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFF97316)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static LinearGradient darkGradient = const LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const secondary = Color(0xFF8B5CF6);
  static LinearGradient secondaryGradient = const LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}