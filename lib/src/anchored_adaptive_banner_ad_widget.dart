import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

double gDeviceWidth = 0;

class AnchoredAdaptiveBannerAdWidget extends StatefulWidget {
  final String adUnitId;
  final Color? backgroundColor;
  const AnchoredAdaptiveBannerAdWidget(
      {Key? key, required this.adUnitId, this.backgroundColor})
      : super(key: key);

  @override
  State<AnchoredAdaptiveBannerAdWidget> createState() =>
      _AnchoredAdaptiveBannerAdWidgetState();
}

class _AnchoredAdaptiveBannerAdWidgetState
    extends State<AnchoredAdaptiveBannerAdWidget> {
  @override
  void initState() {
    super.initState();
  }

  Future<double> _getDeviceWidth(BuildContext context) async {
    for (var i = 0; i < 50; i++) {
      final media = MediaQuery.maybeOf(context);
      final width = media == null ? 0.0 : media.size.width;
      if (width > 0) {
        return width;
      }

      await Future.delayed(const Duration(milliseconds: 100));
    }
    return 0;
  }

  Future<AdSize?>? _getAdSize(BuildContext context) async {
    if (gDeviceWidth <= 0) {
      gDeviceWidth = await _getDeviceWidth(context);

      if (kDebugMode) {
        print("AnchoredAdaptiveBannerAdWidget MediaQuery width=$gDeviceWidth");
      }
    }

    var orientation = Orientation.portrait;
    if (mounted) {
      final media = MediaQuery.maybeOf(context);
      if (media != null) {
        orientation = media.orientation;
      }
    }

    return AdSize.getAnchoredAdaptiveBannerAdSize(
        orientation, gDeviceWidth.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AdSize?>(
      future: _getAdSize(context),
      builder: (context, snapshot) {
        var adSize = AdSize.banner;
        Widget? child;
        if (snapshot.hasData) {
          final listener = _createListener();
          adSize = snapshot.data ?? AdSize.banner;

          if (kDebugMode) {
            print(
                "call FutureBuilder , AnchoredAdaptiveBannerAdWidget, size(w=${adSize.width}. h=${adSize.height})");
          }

          final banner = BannerAd(
              adUnitId: widget.adUnitId,
              size: adSize,
              request: const AdRequest(),
              listener: listener);

          banner.load();

          child = AdWidget(ad: banner);
        }

        return Container(
          width: adSize.width.toDouble(),
          height: adSize.height.toDouble(),
          color: widget.backgroundColor,
          child: child,
        );
      },
    );
  }

  BannerAdListener _createListener() {
    return BannerAdListener(
      onAdLoaded: (ad) {
        // Called when ad ad is successfully received.
        if (kDebugMode) {
          print('BannerAd loaded.');
        }
      },
      onAdFailedToLoad: (ad, error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        if (kDebugMode) {
          print('BannerAd failed to load: $error');
        }
      },
      onAdOpened: (ad) {
        // Called when an ad opens an overlay that covers the screen.
        if (kDebugMode) {
          print('BannerAd opened.');
        }
      },
      onAdClosed: (ad) {
        // Called when an ad removes an overlay that covers the screen.
        if (kDebugMode) {
          print('BannerAd closed.');
        }
      },
      onAdImpression: (ad) {
        // Called when ad impression occurs on the ad.
        if (kDebugMode) {
          print('BannerAd impression.');
        }
      },
    );
  }
}
