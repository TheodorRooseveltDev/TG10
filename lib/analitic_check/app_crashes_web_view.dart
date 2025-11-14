import 'dart:ui';

import 'package:app_settings/app_settings.dart';
import 'package:chick_road/analitic_check/app_crashes_check.dart';
import 'package:chick_road/analitic_check/app_crashes_consent_prompt.dart';
import 'package:chick_road/analitic_check/app_crashes_service.dart';
import 'package:chick_road/analitic_check/app_crashes_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class AppCrashesWebViewWidget extends StatefulWidget {
  const AppCrashesWebViewWidget({super.key});

  @override
  State<AppCrashesWebViewWidget> createState() => _AppCrashesWebViewWidgetState();
}

class _AppCrashesWebViewWidgetState extends State<AppCrashesWebViewWidget>
    with WidgetsBindingObserver {
  late InAppWebViewController appCrashesWebViewController;

  bool appCrashesShowLoading = true;
  bool appCrashesShowConsentPrompt = false;

  bool appCrashesWasOpenNotification =
      aSharedPreferences.getBool("wasOpenNotification") ?? false;

  final bool savePermission =
      aSharedPreferences.getBool("savePermission") ?? false;

  bool waitingForSettingsReturn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      if (waitingForSettingsReturn) {
        waitingForSettingsReturn = false;
        Future.delayed(const Duration(milliseconds: 450), () {
          if (mounted) {
            appCrashesAfterSetting();
          }
        });
      }
    }
  }

  Future<void> appCrashesAfterSetting() async {
    final deviceState = OneSignal.User.pushSubscription;

    bool havePermission = deviceState.optedIn ?? false;
    final bool systemNotificationsEnabled = await AppCrashesService()
        .isSystemPermissionGranted();

    if (havePermission || systemNotificationsEnabled) {
      aSharedPreferences.setBool("wasOpenNotification", true);
      appCrashesWasOpenNotification = true;
      AppCrashesService().appCrashesSendRequiestToBack();
    }

    appCrashesShowConsentPrompt = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: appCrashesShowLoading ? 0 : 1,

          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: InAppWebView(
                      initialUrlRequest: URLRequest(
                        url: WebUri(analyticsLink!),
                      ),
                      initialSettings: InAppWebViewSettings(
                        allowsBackForwardNavigationGestures: false,
                        javaScriptEnabled: true,
                        allowsInlineMediaPlayback: true,
                      ),
                      onWebViewCreated: (controller) {
                        appCrashesWebViewController = controller;
                      },
                      onLoadStop: (controller, url) async {
                        appCrashesShowLoading = false;
                        setState(() {});
                        if (appCrashesWasOpenNotification) return;

                        final bool systemNotificationsEnabled =
                            await AppCrashesService().isSystemPermissionGranted();

                        await Future.delayed(Duration(milliseconds: 3000));

                        if (systemNotificationsEnabled) {
                          aSharedPreferences.setBool(
                            "wasOpenNotification",
                            true,
                          );
                          appCrashesWasOpenNotification = true;
                        }

                        if (!systemNotificationsEnabled) {
                          appCrashesShowConsentPrompt = true;
                          appCrashesWasOpenNotification = true;
                        }

                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                return appCrashesBuildWebBottomBar(orientation);
              },
            ),
          ),
        ),
        if (appCrashesShowLoading) const AppCrashesSplash(),
        if (!appCrashesShowLoading)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 450),
            reverseDuration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: appCrashesShowConsentPrompt
                ? AppCrashesConsentPromptPage(
                    key: const ValueKey('consent_prompt'),
                    onYes: () async {
                      if (savePermission == true) {
                        waitingForSettingsReturn = true;
                        await AppSettings.openAppSettings(
                          type: AppSettingsType.settings,
                        );
                      } else {
                        await AppCrashesService()
                            .appCrashesRequestPermissionOneSignal();

                        final bool systemNotificationsEnabled =
                            await AppCrashesService().isSystemPermissionGranted();

                        if (systemNotificationsEnabled) {
                          aSharedPreferences.setBool(
                            "wasOpenNotification",
                            true,
                          );
                        } else {
                          aSharedPreferences.setBool("savePermission", true);
                        }
                        appCrashesWasOpenNotification = true;
                        appCrashesShowConsentPrompt = false;
                        setState(() {});
                      }
                    },
                    onNo: () {
                      setState(() {
                        appCrashesWasOpenNotification = true;
                        appCrashesShowConsentPrompt = false;
                      });
                    },
                  )
                : const SizedBox.shrink(key: ValueKey('empty')),
          ),
      ],
    );
  }

  Widget appCrashesBuildWebBottomBar(Orientation orientation) {
    return Container(
      color: Colors.black,
      height: orientation == Orientation.portrait ? 25 : 30,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            color: Colors.white,
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (await appCrashesWebViewController.canGoBack()) {
                appCrashesWebViewController.goBack();
              }
            },
          ),
          const SizedBox.shrink(),
          IconButton(
            padding: EdgeInsets.zero,
            color: Colors.white,
            icon: const Icon(Icons.arrow_forward),
            onPressed: () async {
              if (await appCrashesWebViewController.canGoForward()) {
                appCrashesWebViewController.goForward();
              }
            },
          ),
        ],
      ),
    );
  }
}

