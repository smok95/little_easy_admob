import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

enum BannerAdSize {
  /// The standard banner (320x50) size.
  banner,

  /// The large banner (320x100) size.
  largeBanner,

  /// The medium rectangle (300x250) size.
  mediumRectangle,

  /// The full banner (468x60) size.
  fullBanner,

  /// The leaderboard (728x90) size.
  leaderboard,

  /// A dynamically sized banner that matches its parent's width and expands/contracts its height to match the ad's content after loading completes.
  fluid,
}

/// 일반 형태의 배너광고
class BannerAdWidget extends StatelessWidget {
  final String adUnitId;
  final Color? backgroundColor;
  final BannerAdSize? bannerAdSize;
  const BannerAdWidget(
      {Key? key,
      required this.adUnitId,
      this.bannerAdSize = BannerAdSize.banner,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listener = _createListener();

    final adSize = _bannerAdSizeToAdSize(
        bannerAdSize == null ? bannerAdSize! : BannerAdSize.banner);
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

  AdSize _bannerAdSizeToAdSize(BannerAdSize value) {
    switch (value) {
      case BannerAdSize.banner:
        return AdSize.banner;
      case BannerAdSize.fluid:
        return AdSize.fluid;
      case BannerAdSize.fullBanner:
        return AdSize.fullBanner;
      case BannerAdSize.largeBanner:
        return AdSize.largeBanner;
      case BannerAdSize.leaderboard:
        return AdSize.leaderboard;
      case BannerAdSize.mediumRectangle:
        return AdSize.mediumRectangle;
      default:
        return AdSize.banner;
    }
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
