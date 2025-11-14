import 'dart:async';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:chick_road/analitic_check/app_crashes_service.dart';
import 'package:chick_road/analitic_check/app_crashes_splash.dart';
import 'package:chick_road/analitic_check/app_crashes_parameters.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences aSharedPreferences;

dynamic appCrashesConversionData;
String? appCrashesTrackingPermissionStatus;
String? appCrashesAdvertisingId;
String? analyticsLink;

String? appsflyer_id;
String? external_id;

String? appCrashesPushconsentmsg;

class AppCrashesCheck extends StatefulWidget {
  const AppCrashesCheck({super.key});

  @override
  State<AppCrashesCheck> createState() => _AppCrashesCheckState();
}

class _AppCrashesCheckState extends State<AppCrashesCheck> {
  @override
  void initState() {
    super.initState();
    appCrashesInitAll();
  }

  appCrashesInitAll() async {
    await Future.delayed(Duration(milliseconds: 10));
    aSharedPreferences = await SharedPreferences.getInstance();
    bool sendedAnalytics =
        aSharedPreferences.getBool("sendedAnalytics") ?? false;
    analyticsLink = aSharedPreferences.getString("link");

    appCrashesPushconsentmsg = aSharedPreferences.getString("pushconsentmsg");

    if (analyticsLink != null && analyticsLink != "" && !sendedAnalytics) {
      AppCrashesService().appCrashesNavigateToWebView(context);
    } else {
      if (sendedAnalytics) {
        AppCrashesService().appCrashesNavigateToSplash(context);
      } else {
        appCrashesInitializeMainPart();
      }
    }
  }

  void appCrashesInitializeMainPart() async {
    await AppCrashesService().appCrashesRequestTrackingPermission();
    await AppCrashesService().appCrashesInitializeOneSignal();
    await appCrashesTakeParams();
  }

  String? appCrashesGetPushConsentMsgValue(String link) {
    try {
      final uri = Uri.parse(link);
      final params = uri.queryParameters;

      return params['pushconsentmsg'];
    } catch (e) {
      return null;
    }
  }

  Future<void> appCrashesCreateLink() async {
    Map<dynamic, dynamic> parameters = appCrashesConversionData;

    parameters.addAll({
      "tracking_status": appCrashesTrackingPermissionStatus,
      "${appCrashesStandartWord}_id": appCrashesAdvertisingId,
      "external_id": external_id,
      "appsflyer_id": appsflyer_id,
    });

    String? link = await AppCrashesService().sendAnalyticsRequest(parameters);

    analyticsLink = link;

    if (analyticsLink == "" || analyticsLink == null) {
      AppCrashesService().appCrashesNavigateToSplash(context);
    } else {
      appCrashesPushconsentmsg = appCrashesGetPushConsentMsgValue(analyticsLink!);
      if (appCrashesPushconsentmsg != null) {
        aSharedPreferences.setString("pushconsentmsg", appCrashesPushconsentmsg!);
      }
      aSharedPreferences.setString("link", analyticsLink.toString());
      aSharedPreferences.setBool("success", true);
      AppCrashesService().appCrashesNavigateToWebView(context);
    }
  }

  Future<void> appCrashesTakeParams() async {
    final appsFlyerOptions = AppCrashesService().appCrashesCreateAppsFlyerOptions();
    AppsflyerSdk appsFlyerSdk = AppsflyerSdk(appsFlyerOptions);

    await appsFlyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );
    appsflyer_id = await appsFlyerSdk.getAppsFlyerUID();

    appsFlyerSdk.onInstallConversionData((res) async {
      appCrashesConversionData = res;
      await appCrashesCreateLink();
    });

    appsFlyerSdk.startSDK(
      onError: (errorCode, errorMessage) {
        AppCrashesService().appCrashesNavigateToSplash(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const AppCrashesSplash();
  }
}

