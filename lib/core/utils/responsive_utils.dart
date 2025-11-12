import 'package:flutter/material.dart';

class ResponsiveUtils {
  /// Check if device is a tablet (iPad, etc.)
  static bool isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Tablets typically have diagonal > 7 inches (600dp shortest side)
    return size.shortestSide >= 600;
  }

  /// Check if device is an iPad specifically
  static bool isIPad(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // iPad mini: 744 x 1133, iPad: 810 x 1080, iPad Pro: 1024 x 1366
    return size.shortestSide >= 744;
  }

  /// Get scale factor for tablet devices
  static double getScaleFactor(BuildContext context) {
    if (isTablet(context)) {
      return 0.7; // Scale down to 70% for tablets
    }
    return 1.0; // No scaling for phones
  }

  /// Get responsive font size
  static double getFontSize(BuildContext context, double baseSize) {
    return baseSize * getScaleFactor(context);
  }

  /// Get responsive spacing
  static double getSpacing(BuildContext context, double baseSpacing) {
    return baseSpacing * getScaleFactor(context);
  }

  /// Get responsive width
  static double getWidth(BuildContext context, double baseWidth) {
    return baseWidth * getScaleFactor(context);
  }

  /// Get responsive height
  static double getHeight(BuildContext context, double baseHeight) {
    return baseHeight * getScaleFactor(context);
  }

  /// Get maximum content width (for centering on large screens)
  static double getMaxContentWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (isTablet(context)) {
      return screenWidth * 0.7; // 70% of screen width on tablets
    }
    return screenWidth;
  }
}

/// Responsive wrapper widget that scales content for tablets
class ResponsiveScaffold extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const ResponsiveScaffold({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final scaleFactor = ResponsiveUtils.getScaleFactor(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    if (isTablet) {
      // Wrap content in a scaled container for tablets
      return Container(
        color: backgroundColor,
        child: Center(
          child: Transform.scale(
            scale: scaleFactor,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / scaleFactor,
              height: MediaQuery.of(context).size.height / scaleFactor,
              child: child,
            ),
          ),
        ),
      );
    }

    // Return child as-is for phones
    return child;
  }
}

/// Extension on BuildContext for easier access to responsive values
extension ResponsiveContext on BuildContext {
  bool get isTablet => ResponsiveUtils.isTablet(this);
  bool get isIPad => ResponsiveUtils.isIPad(this);
  double get scaleFactor => ResponsiveUtils.getScaleFactor(this);
  
  double responsive(double value) => value * scaleFactor;
  double responsiveFontSize(double fontSize) => ResponsiveUtils.getFontSize(this, fontSize);
  double responsiveSpacing(double spacing) => ResponsiveUtils.getSpacing(this, spacing);
}
