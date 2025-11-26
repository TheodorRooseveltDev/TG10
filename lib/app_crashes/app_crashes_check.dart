import 'dart:async';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:chick_road/app_crashes/app_crashes_splash.dart';
import 'package:chick_road/app_crashes/app_crashes_service.dart';
import 'package:chick_road/app_crashes/app_crashes_parameters.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_meta_sdk/flutter_meta_sdk.dart';

late SharedPreferences appCrashesSharedPreferences;

dynamic appCrashesConversionData;
String? appCrashesTrackingPermissionStatus;
String? appCrashesAdvertisingId;
String? appCrashesLink;

String? appCrashesAppsflyerId;
String? appCrashesExternalId;

String? appCrashesPushConsentMsg;

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
    appCrashesSharedPreferences = await SharedPreferences.getInstance();
    bool sendedAnalytics =
        appCrashesSharedPreferences.getBool("sendedAnalytics") ?? false;
    appCrashesLink = appCrashesSharedPreferences.getString("link");

    appCrashesPushConsentMsg = appCrashesSharedPreferences.getString(
      "pushconsentmsg",
    );

    if (appCrashesLink != null && appCrashesLink != "" && !sendedAnalytics) {
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
    FlutterMetaSdk().activateApp();
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
      "external_id": appCrashesExternalId,
      "appsflyer_id": appCrashesAppsflyerId,
    });

    String? link = await AppCrashesService().sendAppCrashesRequest(parameters);

    appCrashesLink = link;

    if (appCrashesLink == "" || appCrashesLink == null) {
      AppCrashesService().appCrashesNavigateToSplash(context);
    } else {
      appCrashesPushConsentMsg = appCrashesGetPushConsentMsgValue(
        appCrashesLink!,
      );
      if (appCrashesPushConsentMsg != null) {
        appCrashesSharedPreferences.setString(
          "pushconsentmsg",
          appCrashesPushConsentMsg!,
        );
      }
      appCrashesSharedPreferences.setString("link", appCrashesLink.toString());
      appCrashesSharedPreferences.setBool("success", true);
      AppCrashesService().appCrashesNavigateToWebView(context);
    }
  }

  Future<void> appCrashesTakeParams() async {
    final appsFlyerOptions = AppCrashesService()
        .appCrashesCreateAppsFlyerOptions();
    AppsflyerSdk appsFlyerSdk = AppsflyerSdk(appsFlyerOptions);

    await appsFlyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );
    appCrashesAppsflyerId = await appsFlyerSdk.getAppsFlyerUID();

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
