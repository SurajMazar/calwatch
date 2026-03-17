import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF3BCE45);
  static const Color primaryLight = Color(0xFFE8F9E9);
  static const Color primaryDark = Color(0xFF2DA635);

  // Light theme
  static const Color backgroundLight = Color(0xFFF6F8F6);
  static const Color surfaceLight = Colors.white;
  static const Color cardLight = Colors.white;
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textTertiaryLight = Color(0xFF94A3B8);

  // Dark theme
  static const Color backgroundDark = Color(0xFF131F14);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color cardDark = Color(0xFF1E293B);
  static const Color borderDark = Color(0xFF334155);
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textTertiaryDark = Color(0xFF64748B);

  // Macro colors
  static const Color protein = primary;
  static const Color carbs = Color(0xFF3B82F6);
  static const Color fats = Color(0xFFF97316);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFEAB308);
  static const Color error = Color(0xFFEF4444);
}
