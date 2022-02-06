import 'package:flutter/material.dart';

import 'app_open_ad_manager.dart';

class AppLifecycleReactor extends WidgetsBindingObserver {
  final AppOpenAdManager appOpenAdManager;

  AppLifecycleReactor({required this.appOpenAdManager});

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    // Try to show an app open ad if the app is being resumed and
    // we're not alreay showing an app open ad.
    if (state == AppLifecycleState.resumed) {
      print('AppLifecycleState.resumed, showAdIfAvailable');
      appOpenAdManager.showAdIfAvailable();
    }
  }
}
