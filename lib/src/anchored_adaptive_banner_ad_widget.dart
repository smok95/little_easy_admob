import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
  Future<AdSize?>? _adSize;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_adSize == null) {
      final orientation = MediaQuery.of(context).orientation;
      final width = MediaQuery.of(context).size.width;
      _adSize =
          AdSize.getAnchoredAdaptiveBannerAdSize(orientation, width.toInt());
    } else {
      print("adSize determined");
    }

    return FutureBuilder<AdSize?>(
      future: _adSize,
      builder: (context, snapshot) {
        var adSize = AdSize.banner;
        Widget? child;
        if (snapshot.hasData) {
          final listener = _createListener();
          adSize = snapshot.data ?? AdSize.banner;

          print("call FutureBuilder , AnchoredAdaptiveBannerAdWidget");

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
