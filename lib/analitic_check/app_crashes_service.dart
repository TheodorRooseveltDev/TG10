import 'dart:convert';
import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:chick_road/analitic_check/app_crashes_check.dart';
import 'package:chick_road/analitic_check/app_crashes_web_view.dart';
import 'package:chick_road/analitic_check/app_crashes_parameters.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:uuid/uuid.dart';

class AppCrashesService {
  Future<void> appCrashesInitializeOneSignal() async {
    await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    await OneSignal.Location.setShared(false);
    OneSignal.initialize(appCrashesOneSignalString);
    external_id = Uuid().v1();
  }

  Future<void> appCrashesRequestPermissionOneSignal() async {
    await OneSignal.Notifications.requestPermission(true);
    external_id = Uuid().v1();
    try {
      OneSignal.login(external_id!);
      OneSignal.User.pushSubscription.addObserver((state) {});
    } catch (_) {}
  }

  void appCrashesSendRequiestToBack() {
    try {
      OneSignal.login(external_id!);
      OneSignal.User.pushSubscription.addObserver((state) {});
    } catch (_) {}
  }

  Future appCrashesNavigateToSplash(BuildContext context) async {
    aSharedPreferences.setBool("sendedAnalytics", true);
    appCrashesOpenStandartAppLogic(context);
  }

  Future<bool> isSystemPermissionGranted() async {
    if (!Platform.isIOS) return false;
    try {
      final status = await OneSignal.Notifications.permissionNative();
      return status == OSNotificationPermission.authorized ||
          status == OSNotificationPermission.provisional ||
          status == OSNotificationPermission.ephemeral;
    } catch (_) {
      return false;
    }
  }

  void appCrashesNavigateToWebView(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AppCrashesWebViewWidget(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  AppsFlyerOptions appCrashesCreateAppsFlyerOptions() {
    return AppsFlyerOptions(
      afDevKey: (appCrashesAfDevKey1 + appCrashesAfDevKey2),
      appId: appCrashesDevKeypndAppId,
      timeToWaitForATTUserAuthorization: 7,
      showDebug: true,
      disableAdvertisingIdentifier: false,
      disableCollectASA: false,
      manualStart: true,
    );
  }

  Future<void> appCrashesRequestTrackingPermission() async {
    if (Platform.isIOS) {
      if (await AppTrackingTransparency.trackingAuthorizationStatus ==
          TrackingStatus.notDetermined) {
        await Future.delayed(const Duration(seconds: 2));
        final status =
            await AppTrackingTransparency.requestTrackingAuthorization();
        appCrashesTrackingPermissionStatus = status.toString();

        if (status == TrackingStatus.authorized) {
          appCrashesGetAdvertisingId();
        }
        if (status == TrackingStatus.notDetermined) {
          final status =
              await AppTrackingTransparency.requestTrackingAuthorization();
          appCrashesTrackingPermissionStatus = status.toString();

          if (status == TrackingStatus.authorized) {
            appCrashesGetAdvertisingId();
          }
        }
      }
    }
  }

  Future<void> appCrashesGetAdvertisingId() async {
    try {
      appCrashesAdvertisingId = await AdvertisingId.id(true);
    } catch (_) {}
  }

  Future<String?> sendAnalyticsRequest(Map<dynamic, dynamic> parameters) async {
    try {
      final jsonString = json.encode(parameters);
      final base64Parameters = base64.encode(utf8.encode(jsonString));

      final requestBody = {appCrashesStandartWord: base64Parameters};

      final response = await http.post(
        Uri.parse(appCrashesUrl),
        body: requestBody,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
