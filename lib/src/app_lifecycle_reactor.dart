import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app_open_ad_manager.dart';

/* 
https://github.com/googleads/googleads-mobile-flutter/blob/main/packages/app_open_example/lib/app_lifecycle_reactor.dart
구글 예제에서 WidgetBindingOvserver에서 AppStateEventNotifier로 변경됨.
아마도 광고사기(ad fraud)와 관련된 문제일 것으로 추측되어 동일하게 바꿈

WidgetBindingOvserver 사용방식
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
*/

class AppLifecycleReactor {
  final AppOpenAdManager appOpenAdManager;

  AppLifecycleReactor({required this.appOpenAdManager});

  void listenToAppStateChanges() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream
        .forEach((state) => _onAppStateChanged(state));
  }

  void _onAppStateChanged(AppState state) {
    if (kDebugMode) {
      print('New AppState state: $state');
    }

    // Try to show an app open ad if the app is being forground and
    // We're not alreay showing an app open ad.
    if (state == AppState.foreground) {
      appOpenAdManager.showAdIfAvailable();
    }
  }
}
