import 'package:flutter/material.dart';

class AppColors {
  // Light Mode Colors
  static const Color primary = Color(0xFF273A91);
  static const Color primaryLight = Color(0xFF3F54B0);
  static const Color primaryDark = Color(0xFF1A2761);
  static const Color primaryBg = Color(0xFFEBEFFA);
  static const Color primaryBorder = Color(0xFFC4D1ED);
  
  static const Color secondary = Color(0xFF1A2761);
  static const Color secondaryDark = Color(0xFF10183C);
  static const Color secondaryBg = Color(0xFFE4E7F2);

  // Status & Accents
  static const Color accentGreen = Color(0xFF007A1F);
  static const Color accentGreenLight = Color(0xFFE6F4E9);
  static const Color accentGreenBright = Color(0xFF00A828);
  static const Color accentGreenDark = Color(0xFF005A16);

  static const Color accentRed = Color(0xFFEF4444);
  static const Color accentRedLight = Color(0xFFFEF2F2);

  static const Color accentOrange = Color(0xFFF59E0B);
  static const Color accentOrangeLight = Color(0xFFFFFBEB);

  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color accentBlueLight = Color(0xFFEFF6FF);

  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentPurpleLight = Color(0xFFF5F3FF);

  static const Color accentPink = Color(0xFFEC4899);
  static const Color accentPinkLight = Color(0xFFFDF2F8);

  static const Color accentTeal = Color(0xFF0891B2);
  static const Color accentTealLight = Color(0xFFF0FBFF);

  // Neutrals (Light)
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray50 = Color(0xFFF4F7FB);
  static const Color gray100 = Color(0xFFEAEFF5);
  static const Color gray200 = Color(0xFFD8E1ED);
  static const Color gray300 = Color(0xFFB3C1D6);
  static const Color gray400 = Color(0xFF8899B0);
  static const Color gray500 = Color(0xFF60738C);
  static const Color gray600 = Color(0xFF3F526B);
  static const Color gray700 = Color(0xFF29384D);
  static const Color gray800 = Color(0xFF1B2638);
  static const Color gray900 = Color(0xFF0F1621);

  // Glassmorphism specific
  static Color glassBg = Colors.white.withOpacity(0.82);
  static Color glassBgHover = Colors.white.withOpacity(0.92);
  static Color glassBorder = Colors.white.withOpacity(0.68);
  static Color glassShadow = const Color(0xFF273A91).withOpacity(0.1);
  static const double glassBlur = 20.0;
}
