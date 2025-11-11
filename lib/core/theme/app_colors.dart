import 'package:flutter/material.dart';

/// ChickRoad City Color Palette
/// Following 60-30-10 rule for color distribution
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Colors (60% usage - backgrounds, main surfaces)
  static const Color primaryDark = Color(0xFF1A1F2E);
  static const Color surface = Color(0xFF2C3444);
  static const Color border = Color(0xFF394152);

  // Secondary Color (30% usage - chicken theme, interactive elements)
  static const Color secondaryYellow = Color(0xFFFDB623);
  static const Color secondaryYellowLight = Color(0xFFFFCA4F);
  static const Color secondaryYellowDark = Color(0xFFE5A31F);

  // Accent Color (10% usage - CTAs, alerts, incorrect answers)
  static const Color accentRed = Color(0xFFE74C3C);
  static const Color accentRedLight = Color(0xFFFF6B5B);
  static const Color accentRedDark = Color(0xFFC0392B);

  // Support Colors
  static const Color success = Color(0xFF27AE60);
  static const Color successLight = Color(0xFF2ECC71);
  static const Color successDark = Color(0xFF1E8449);

  static const Color info = Color(0xFF3498DB);
  static const Color infoLight = Color(0xFF5DADE2);
  static const Color infoDark = Color(0xFF2874A6);

  static const Color warning = Color(0xFFF39C12);
  static const Color warningLight = Color(0xFFF8C471);
  static const Color warningDark = Color(0xFFD68910);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A4A8);
  static const Color textTertiary = Color(0xFF6C7178);
  static const Color textOnLight = Color(0xFF1A1F2E);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  // Gradient Definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, surface],
  );

  static const LinearGradient yellowGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [secondaryYellowLight, secondaryYellow],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [successLight, success],
  );

  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [accentRedLight, accentRed],
  );

  // Achievement Badge Colors
  static const Color badgeLocked = Color(0xFFA0A4A8);
  static const Color badgeBronze = Color(0xFFCD7F32);
  static const Color badgeSilver = Color(0xFFC0C0C0);
  static const Color badgeGold = Color(0xFFFFD700);

  // Overlay Colors
  static Color overlay10 = black.withOpacity(0.1);
  static Color overlay20 = black.withOpacity(0.2);
  static Color overlay30 = black.withOpacity(0.3);
  static Color overlay40 = black.withOpacity(0.4);
  static Color overlay50 = black.withOpacity(0.5);
  static Color overlay60 = black.withOpacity(0.6);
  static Color overlay70 = black.withOpacity(0.7);
  static Color overlay80 = black.withOpacity(0.8);

  // Shadow Colors
  static Color shadow = black.withOpacity(0.25);
  static Color shadowLight = black.withOpacity(0.10);
  static Color shadowHeavy = black.withOpacity(0.40);

  // Shimmer Colors (for loading states)
  static const Color shimmerBase = surface;
  static const Color shimmerHighlight = Color(0xFF3D4556);
}
