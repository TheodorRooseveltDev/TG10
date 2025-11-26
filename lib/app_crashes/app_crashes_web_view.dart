import 'dart:ui';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:chick_road/app_crashes/app_crashes_check.dart';
import 'package:chick_road/app_crashes/app_crashes_consent_prompt.dart';
import 'package:chick_road/app_crashes/app_crashes_service.dart';
import 'package:chick_road/app_crashes/app_crashes_splash.dart';

class AppCrashesWebViewWidget extends StatefulWidget {
  const AppCrashesWebViewWidget({super.key});

  @override
  State<AppCrashesWebViewWidget> createState() =>
      _AppCrashesWebViewWidgetState();
}

class _AppCrashesWebViewWidgetState extends State<AppCrashesWebViewWidget>
    with WidgetsBindingObserver {
  late InAppWebViewController appCrashesWebViewController;

  bool appCrashesShowLoading = true;
  bool appCrashesShowConsentPrompt = false;

  bool appCrashesWasOpenNotification =
      appCrashesSharedPreferences.getBool("wasOpenNotification") ?? false;

  final bool savePermission =
      appCrashesSharedPreferences.getBool("savePermission") ?? false;

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
      appCrashesSharedPreferences.setBool("wasOpenNotification", true);
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
                      onCreateWindow:
                          (
                            controller,
                            CreateWindowAction createWindowRequest,
                          ) async {
                            await showDialog(
                              context: context,
                              builder: (dialogContext) {
                                final dialogSize = MediaQuery.of(
                                  dialogContext,
                                ).size;

                                return AlertDialog(
                                  contentPadding: EdgeInsets.zero,
                                  content: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      SizedBox(
                                        width: dialogSize.width,
                                        height: dialogSize.height * 0.8,
                                        child: InAppWebView(
                                          windowId:
                                              createWindowRequest.windowId,
                                          initialSettings: InAppWebViewSettings(
                                            javaScriptEnabled: true,
                                          ),
                                          onCloseWindow: (controller) {
                                            Navigator.of(dialogContext).pop();
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        top: -18,
                                        right: -18,
                                        child: Material(
                                          color: Colors.black.withOpacity(0.7),
                                          shape: const CircleBorder(),
                                          child: InkWell(
                                            customBorder: const CircleBorder(),
                                            onTap: () {
                                              Navigator.of(dialogContext).pop();
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                            return true;
                          },
                      initialUrlRequest: URLRequest(
                        url: WebUri(appCrashesLink!),
                      ),
                      initialSettings: InAppWebViewSettings(
                        allowsBackForwardNavigationGestures: false,
                        javaScriptEnabled: true,
                        allowsInlineMediaPlayback: true,
                        mediaPlaybackRequiresUserGesture: false,
                        supportMultipleWindows: true,
                        javaScriptCanOpenWindowsAutomatically: true,
                      ),
                      onWebViewCreated: (controller) {
                        appCrashesWebViewController = controller;
                      },
                      onLoadStop: (controller, url) async {
                        appCrashesShowLoading = false;
                        setState(() {});
                        if (appCrashesWasOpenNotification) return;

                        final bool systemNotificationsEnabled =
                            await AppCrashesService()
                                .isSystemPermissionGranted();

                        await Future.delayed(Duration(milliseconds: 3000));

                        if (systemNotificationsEnabled) {
                          appCrashesSharedPreferences.setBool(
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
                            await AppCrashesService()
                                .isSystemPermissionGranted();

                        if (systemNotificationsEnabled) {
                          appCrashesSharedPreferences.setBool(
                            "wasOpenNotification",
                            true,
                          );
                        } else {
                          appCrashesSharedPreferences.setBool(
                            "savePermission",
                            true,
                          );
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

