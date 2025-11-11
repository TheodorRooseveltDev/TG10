import 'package:flutter/animation.dart';

/// ChickRoad City Animation Configuration
/// Consistent animation durations and curves throughout the app
class AppAnimations {
  AppAnimations._();

  // Animation Durations
  static const Duration durationInstant = Duration(milliseconds: 100);
  static const Duration durationQuick = Duration(milliseconds: 200);
  static const Duration durationStandard = Duration(milliseconds: 300);
  static const Duration durationEmphasis = Duration(milliseconds: 400);
  static const Duration durationSlow = Duration(milliseconds: 500);
  static const Duration durationVerySlow = Duration(milliseconds: 800);

  // Specific use case durations
  static const Duration pageTransition = durationStandard; // 300ms
  static const Duration dialogTransition = durationStandard; // 300ms
  static const Duration buttonPress = durationQuick; // 200ms
  static const Duration cardExpand = durationEmphasis; // 400ms
  static const Duration loadingIndicator = durationSlow; // 500ms
  static const Duration tooltipFade = durationQuick; // 200ms
  static const Duration snackbarSlide = durationStandard; // 300ms

  // Animation Curves
  static const Curve curveStandard = Curves.easeInOutCubic;
  static const Curve curveEntrance = Curves.easeOutQuart;
  static const Curve curveExit = Curves.easeInQuart;
  static const Curve curveBounce = Curves.easeOutBack;
  static const Curve curveElastic = Curves.elasticOut;
  static const Curve curveLinear = Curves.linear;
  static const Curve curveDecelerate = Curves.decelerate;
  static const Curve curveAccelerate = Curves.easeIn;

  // Shimmer animation duration (for loading states)
  static const Duration shimmerDuration = Duration(milliseconds: 1500);

  // Splash screen animation
  static const Duration splashCarAnimation = Duration(milliseconds: 1500);
  static const Duration splashLogoFade = Duration(milliseconds: 500);
  static const Duration splashTotal = Duration(milliseconds: 2000);

  // Quiz animations
  static const Duration questionSlide = durationStandard; // 300ms
  static const Duration answerReveal = durationQuick; // 200ms
  static const Duration correctAnswerCelebration = durationEmphasis; // 400ms
  static const Duration incorrectAnswerShake = Duration(milliseconds: 600);

  // Achievement unlock animation
  static const Duration achievementSlideUp = durationEmphasis; // 400ms
  static const Duration achievementScale = durationStandard; // 300ms
  static const Duration achievementConfetti = Duration(milliseconds: 2000);

  // Streak animation
  static const Duration streakFireScale = durationStandard; // 300ms
  static const Duration streakCounterIncrement = durationQuick; // 200ms

  // Progress bar animation
  static const Duration progressBarFill = Duration(milliseconds: 1000);

  // Mascot (Chicky) animations
  static const Duration chickyEntrance = durationEmphasis; // 400ms
  static const Duration chickyExit = durationStandard; // 300ms
  static const Duration chickyExpressionChange = durationQuick; // 200ms

  // Card flip animation (for flashcards)
  static const Duration cardFlip = durationEmphasis; // 400ms

  // List item stagger delay
  static const Duration staggerDelay = Duration(milliseconds: 50);

  // Ripple effect
  static const Duration rippleDuration = durationStandard; // 300ms

  // Rotation animation
  static const Duration rotationSlow = Duration(milliseconds: 1000);
  static const Duration rotationFast = durationSlow; // 500ms

  // Fade durations
  static const Duration fadeIn = durationStandard; // 300ms
  static const Duration fadeOut = durationStandard; // 300ms

  // Scale animations
  static const Duration scaleUp = durationQuick; // 200ms
  static const Duration scaleDown = durationQuick; // 200ms

  // Slide animations
  static const Duration slideUp = durationStandard; // 300ms
  static const Duration slideDown = durationStandard; // 300ms
  static const Duration slideLeft = durationStandard; // 300ms
  static const Duration slideRight = durationStandard; // 300ms
}
