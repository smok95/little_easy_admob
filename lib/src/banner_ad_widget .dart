import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// 일반 형태의 배너광고
class BannerAdWidget extends StatelessWidget {
  final String adUnitId;
  final Color? backgroundColor;
  final AdSize adSize;
  const BannerAdWidget(
      {Key? key,
      required this.adUnitId,
      required this.adSize,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listener = _createListener();

    print("call FutureBuilder , AnchoredAdaptiveBannerAdWidget");

    final banner = BannerAd(
        adUnitId: adUnitId,
        size: adSize,
        request: const AdRequest(),
        listener: listener);

    banner.load();

    return Container(
      width: adSize.width.toDouble(),
      height: adSize.height.toDouble(),
      color: backgroundColor,
      child: AdWidget(ad: banner),
    );
  }

  BannerAdListener _createListener() {
    return BannerAdListener(
      onAdLoaded: (ad) {
        // Called when ad ad is successfully received.
        print('BannerAd loaded.');
      },
      onAdFailedToLoad: (ad, error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        print('BannerAd failed to load: $error');
      },
      onAdOpened: (ad) {
        // Called when an ad opens an overlay that covers the screen.
        print('BannerAd opened.');
      },
      onAdClosed: (ad) {
        // Called when an ad removes an overlay that covers the screen.
        print('BannerAd closed.');
      },
      onAdImpression: (ad) {
        // Called when ad impression occurs on the ad.
        print('BannerAd impression.');
      },
    );
  }
}
