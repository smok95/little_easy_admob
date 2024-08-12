import 'package:flutter/foundation.dart';
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

  /// 광고화면이 표시될 때
  final ValueChanged<AppOpenAdManager>? onAdShowedFullScreenContent;

  /// 광고화면이 닫힐때 이벤트
  final ValueChanged<AppOpenAdManager>? onAdDismissedFullScreenContent;

  /// 광고화면 표시에 실패했을 때
  final ValueChanged<AppOpenAdManager>? onAdFailedToShowFullScreenContent;

  /// 광고가 로드되었을 때
  final ValueChanged<AppOpenAdManager>? onAdLoaded;

  /// 노출횟수
  int get impression => _impression;

  AppOpenAdManager(
    this.adUnitId, {
    this.interval = const Duration(minutes: 10),
    this.onAdShowedFullScreenContent,
    this.onAdDismissedFullScreenContent,
    this.onAdFailedToShowFullScreenContent,
    this.onAdLoaded,
  });

  /// Load an [AppOpenAd]
  void loadAd() {
    AppOpenAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(onAdLoaded: (ad) {
        if (kDebugMode) {
          print('$ad loaded');
        }
        _appOpenLoadTime = DateTime.now();
        _appOpenAd = ad;

        if (onAdLoaded != null) {
          onAdLoaded!(this);
        }
      }, onAdFailedToLoad: (error) {
        if (kDebugMode) {
          print('AppOpenAd failed to load: $error');
        }
      }),
    );
  }

  /// Whether an ad is available to be shown.
  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  void showAdIfAvailable() {
    if (!isAdAvailable) {
      if (kDebugMode) {
        print('Tried to show ad before available.');
      }
      loadAd();
      return;
    }

    if (_isShowingAd) {
      if (kDebugMode) {
        print('Tried to show ad while already showing an ad.');
      }
      return;
    }

    if (_lastShownTime != null && interval != null) {
      if (DateTime.now().subtract(interval!).isBefore(_lastShownTime!)) {
        if (kDebugMode) {
          print('${interval!.inMinutes}분내에 광고가 노출된 적이 있어, 이번에는 표시안함');
        }
        return;
      }
    }

    _lastShownTime = null;

    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      if (kDebugMode) {
        print('Maximum cache duration exceeded. Loading another ad.');
      }
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAd();
      return;
    }

    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _impression++;
        _isShowingAd = true;
        _lastShownTime = DateTime.now();
        if (kDebugMode) {
          print('$ad onAdShowedFullScreenContent');
        }

        if (onAdShowedFullScreenContent != null) {
          onAdShowedFullScreenContent!(this);
        }
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        if (kDebugMode) {
          print('$ad onAdFailedToShowFullScreenContent: $error');
        }
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;

        if (onAdFailedToShowFullScreenContent != null) {
          onAdFailedToShowFullScreenContent!(this);
        }
      },
      onAdDismissedFullScreenContent: (ad) {
        if (kDebugMode) {
          print('$ad onAdDismissedFullScreenContent');
        }
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();

        if (onAdDismissedFullScreenContent != null) {
          onAdDismissedFullScreenContent!(this);
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

  /// 노출횟수
  int _impression = 0;
}
