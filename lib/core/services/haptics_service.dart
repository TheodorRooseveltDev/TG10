import 'package:vibration/vibration.dart';

/// Service for managing haptic feedback throughout the app
class HapticsService {
  // Singleton pattern
  HapticsService._();
  static final HapticsService instance = HapticsService._();

  bool _isSupported = false;
  bool _isEnabled = true;

  /// Initialize haptics service - check device support
  Future<void> initialize() async {
    _isSupported = await Vibration.hasVibrator();
  }

  /// Enable/disable haptics
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  /// Light tap - for button presses
  Future<void> light() async {
    if (!_isEnabled || !_isSupported) return;
    await Vibration.vibrate(duration: 10);
  }

  /// Medium tap - for selections
  Future<void> medium() async {
    if (!_isEnabled || !_isSupported) return;
    await Vibration.vibrate(duration: 25);
  }

  /// Heavy tap - for important actions
  Future<void> heavy() async {
    if (!_isEnabled || !_isSupported) return;
    await Vibration.vibrate(duration: 50);
  }

  /// Success pattern - for correct answers
  Future<void> success() async {
    if (!_isEnabled || !_isSupported) return;
    await Vibration.vibrate(duration: 100, amplitude: 128);
  }

  /// Error pattern - for wrong answers
  Future<void> error() async {
    if (!_isEnabled || !_isSupported) return;
    // Pattern: short, short, long
    await Vibration.vibrate(duration: 50);
    await Future.delayed(const Duration(milliseconds: 50));
    await Vibration.vibrate(duration: 50);
    await Future.delayed(const Duration(milliseconds: 50));
    await Vibration.vibrate(duration: 100);
  }

  /// Warning pattern - for important notifications
  Future<void> warning() async {
    if (!_isEnabled || !_isSupported) return;
    await Vibration.vibrate(duration: 75);
  }

  /// Achievement unlocked pattern - celebration
  Future<void> achievement() async {
    if (!_isEnabled || !_isSupported) return;
    // Pattern: short burst sequence
    for (int i = 0; i < 3; i++) {
      await Vibration.vibrate(duration: 50);
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  /// Selection change - for scrolling/sliding
  Future<void> selection() async {
    if (!_isEnabled || !_isSupported) return;
    await Vibration.vibrate(duration: 5);
  }
}
