import 'package:chick_road/core/providers/database_provider.dart';
import 'package:chick_road/core/providers/settings_provider.dart';
import 'package:chick_road/features/home/home_screen.dart';
import 'package:chick_road/features/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String appCrashesOneSignalString = "878bd231-d51c-42f4-a4a8-eb64f92e07c7";
String appCrashesDevKeypndAppId = "6755101754";

String appCrashesAfDevKey1 = "5dHcbZsrucn";
String appCrashesAfDevKey2 = "HdxkEmurwyU";

String appCrashesUrl = 'https://chickroadcity.com/appcrashes/';
String appCrashesStandartWord = "appcrashes";

void appCrashesOpenStandartAppLogic(BuildContext context) async {
  final container = ProviderScope.containerOf(context);
  try {
    await container.read(databaseHelperProvider).database;
  } catch (e) {
    debugPrint('Database initialization error: $e');
  }
  final settings = await container.read(settingsProvider.future);

  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (_) => settings.isFirstLaunch
          ? const OnboardingScreen()
          : const HomeScreen(),
    ),
  );
}

