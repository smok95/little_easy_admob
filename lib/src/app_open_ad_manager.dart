import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// 참고페이지 : https://developers.google.com/admob/flutter/app-open
class AppOpenAdManager {
  /// AppOpen 광고 단위 ID
  final String adUnitId;

  /// Maximum dration allowed between loading and showing the ad.
  final Duration maxCacheDuration = const Duration(hours: 4);

  /// 광고 표시 간격 (default : 10min)
  /// app이 resume 될 때마다 보여주기에는 부담스러울때, 표시간격을 설정
  final Duration? interval;

  /// 광고화면이 닫힐때 이벤트
  final VoidCallback? onAdDismissedFullScreenContent;

  AppOpenAdManager(
    this.adUnitId, {
    this.interval = const Duration(minutes: 10),
    this.onAdDismissedFullScreenContent,
  });

  /// Load an [AppOpenAd]
  void loadAd() {
    const orientation = AppOpenAd.orientationPortrait;
    AppOpenAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(onAdLoaded: (ad) {
          print('$ad loaded');
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;
        }, onAdFailedToLoad: (error) {
          print('AppOpenAd failed to load: $error');
        }),
        orientation: orientation);
  }

  /// Whether an ad is available to be shown.
  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  void showAdIfAvailable() {
    if (!isAdAvailable) {
      print('Tried to show ad before available.');
      loadAd();
      return;
    }

    if (_isShowingAd) {
      print('Tried to show ad while already showing an ad.');
      return;
    }

    if (_lastShownTime != null && interval != null) {
      if (DateTime.now().subtract(interval!).isBefore(_lastShownTime!)) {
        print('${interval!.inMinutes}분내에 광고가 노출된 적이 있어, 이번에는 표시안함');
        return;
      }
    }

    _lastShownTime = null;

    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      print('Maximum cache duration exceeded. Loading another ad.');
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAd();
      return;
    }

    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        _lastShownTime = DateTime.now();
        print('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        print('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();

        if (onAdDismissedFullScreenContent != null) {
          onAdDismissedFullScreenContent!();
        }
      },
    );
    _appOpenAd!.show();
  }

  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;

  /// Keep track of load time so we don't show and expired ad.
  DateTime? _appOpenLoadTime;

  /// 가장 마지막으로 표시된 시각
  DateTime? _lastShownTime;
}
