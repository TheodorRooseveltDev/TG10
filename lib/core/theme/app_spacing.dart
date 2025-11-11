/// ChickRoad City Spacing System
/// Base unit: 8px for consistent spacing throughout the app
class AppSpacing {
  AppSpacing._();

  // Base spacing unit
  static const double baseUnit = 8.0;

  // Spacing values
  static const double xxxs = baseUnit * 0.5; // 4px
  static const double xxs = baseUnit * 1; // 8px
  static const double xs = baseUnit * 1.5; // 12px
  static const double sm = baseUnit * 2; // 16px
  static const double md = baseUnit * 3; // 24px
  static const double lg = baseUnit * 4; // 32px
  static const double xl = baseUnit * 5; // 40px
  static const double xxl = baseUnit * 6; // 48px
  static const double xxxl = baseUnit * 8; // 64px

  // Common padding values
  static const double paddingXS = xs; // 12px
  static const double paddingSM = sm; // 16px
  static const double paddingMD = md; // 24px
  static const double paddingLG = lg; // 32px

  // Screen padding (horizontal margins for screens)
  static const double screenPaddingHorizontal = sm; // 16px
  static const double screenPaddingVertical = md; // 24px

  // Card padding
  static const double cardPaddingSmall = sm; // 16px
  static const double cardPaddingMedium = md; // 24px
  static const double cardPaddingLarge = lg; // 32px

  // List item spacing
  static const double listItemSpacing = sm; // 16px
  static const double listItemPadding = sm; // 16px

  // Section spacing (between major sections)
  static const double sectionSpacing = lg; // 32px
  static const double sectionSpacingLarge = xxl; // 48px

  // Icon sizes
  static const double iconXS = sm; // 16px
  static const double iconSM = md; // 24px
  static const double iconMD = lg; // 32px
  static const double iconLG = xxl; // 48px
  static const double iconXL = xxxl; // 64px

  // Button padding
  static const double buttonPaddingHorizontal = md; // 24px
  static const double buttonPaddingVertical = sm; // 16px
  static const double buttonPaddingSmall = xs; // 12px

  // Border radius values
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;
  static const double radiusRound = 999.0;

  // Common border radius for specific components
  static const double radiusCard = radiusMD; // 12px
  static const double radiusButton = radiusSM; // 8px
  static const double radiusModal = radiusLG; // 16px
  static const double radiusSheet = radiusXL; // 20px
  static const double radiusChip = radiusRound; // Fully rounded

  // Elevation (Material Design)
  static const double elevation0 = 0.0;
  static const double elevation2 = 2.0;
  static const double elevation4 = 4.0;
  static const double elevation8 = 8.0;
  static const double elevation12 = 12.0;
  static const double elevation16 = 16.0;

  // App bar heights
  static const double appBarHeight = 56.0;
  static const double appBarHeightLarge = 72.0;

  // Bottom navigation bar
  static const double bottomNavHeight = 64.0;

  // Minimum tap target size (for accessibility)
  static const double minTapTarget = 48.0;

  // Divider thickness
  static const double dividerThickness = 1.0;
  static const double dividerThicknessBold = 2.0;

  // Border width
  static const double borderWidthThin = 1.0;
  static const double borderWidthMedium = 2.0;
  static const double borderWidthThick = 3.0;
}
