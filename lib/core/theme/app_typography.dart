import 'package:flutter/material.dart';
import 'package:chick_road/core/theme/app_colors.dart';

/// ChickRoad City Typography System
/// Using Inter for body text and Poppins for headings
class AppTypography {
  AppTypography._();

  // Font Families
  static const String fontFamilyInter = 'Inter';
  static const String fontFamilyPoppins = 'Poppins';

  // Headings (Poppins)
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamilyPoppins,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamilyPoppins,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamilyPoppins,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
  );

  // Body Text (Inter)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamilyInter,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamilyInter,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamilyInter,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textSecondary,
    letterSpacing: 0,
  );

  // Special Text Styles
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamilyInter,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: AppColors.textSecondary,
    letterSpacing: 0.2,
  );

  static const TextStyle captionBold = TextStyle(
    fontFamily: fontFamilyInter,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
    letterSpacing: 0.2,
  );

  static const TextStyle small = TextStyle(
    fontFamily: fontFamilyInter,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: AppColors.textSecondary,
    letterSpacing: 0.3,
  );

  // Button Text Styles
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: fontFamilyInter,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: fontFamilyInter,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: fontFamilyInter,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  // Label Styles
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamilyInter,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.2,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamilyInter,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.2,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamilyInter,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.2,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
  );

  // Display Styles (for large numbers, stats)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamilyPoppins,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.1,
    color: AppColors.textPrimary,
    letterSpacing: -1.0,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamilyPoppins,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.1,
    color: AppColors.textPrimary,
    letterSpacing: -0.8,
  );

  // Specific Use Case Styles
  static const TextStyle questionText = TextStyle(
    fontFamily: fontFamilyInter,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  static const TextStyle answerOption = TextStyle(
    fontFamily: fontFamilyInter,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  static const TextStyle timerText = TextStyle(
    fontFamily: fontFamilyPoppins,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.secondaryYellow,
    letterSpacing: 0,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle scoreText = TextStyle(
    fontFamily: fontFamilyPoppins,
    fontSize: 64,
    fontWeight: FontWeight.w700,
    height: 1.0,
    color: AppColors.secondaryYellow,
    letterSpacing: -1.5,
  );
}
