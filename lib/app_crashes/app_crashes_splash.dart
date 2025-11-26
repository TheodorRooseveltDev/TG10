import 'package:chick_road/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class AppCrashesSplash extends StatefulWidget {
  const AppCrashesSplash({super.key});

  @override
  State<AppCrashesSplash> createState() => _AppCrashesSplashState();
}

class _AppCrashesSplashState extends State<AppCrashesSplash> {
  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}

