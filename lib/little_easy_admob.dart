library little_easy_admob;

export 'src/anchored_adaptive_banner_ad_widget.dart';
export 'src/app_lifecycle_reactor.dart';
export 'src/app_open_ad_manager.dart';
export 'src/banner_ad_widget .dart';

import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_mobile_ads/google_mobile_ads.dart';

class LittleEasyAdmob {
  /// Google Mobile Ads 초기화
  /// [requestTrackingAuthorization] iOS Only, AppTrackingTransparency 설정 권한 요청
  static Future<InitializationStatus> initialize(
      {bool requestTrackingAuthorization = false}) async {
    if (requestTrackingAuthorization && !kIsWeb && Platform.isIOS) {
      // AppTrackingTransparency 설정
      final status =
          await AppTrackingTransparency.requestTrackingAuthorization();
    }

    return await MobileAds.instance.initialize();
  }
}
