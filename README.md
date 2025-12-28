# Little Easy AdMob

A simplified wrapper for Google Mobile Ads in Flutter, making it easier to integrate and manage AdMob ads in your Flutter applications.

## Features

- **Easy Initialization**: Simple setup with optional iOS App Tracking Transparency support
- **Banner Ads**: Ready-to-use banner ad widgets
- **Adaptive Banner Ads**: Responsive banner ads that adapt to screen size and orientation
- **App Open Ads**: Monetize app launches with customizable display intervals
- **App Lifecycle Management**: Built-in lifecycle handling for ads

## Getting started

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  little_easy_admob: ^0.1.8
```

### Prerequisites

1. Set up your AdMob account and get your Ad Unit IDs
2. Configure your app following the [Google Mobile Ads Flutter guide](https://developers.google.com/admob/flutter/quick-start)
3. Add your AdMob App ID to your platform-specific configuration files

## Usage

### Initialize AdMob

```dart
import 'package:little_easy_admob/little_easy_admob.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize with iOS tracking authorization request
  await LittleEasyAdmob.initialize(requestTrackingAuthorization: true);

  runApp(MyApp());
}
```

### Banner Ad Widget

```dart
import 'package:little_easy_admob/little_easy_admob.dart';

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Your content
          Spacer(),
          AnchoredAdaptiveBannerAdWidget(
            adUnitId: 'YOUR_AD_UNIT_ID',
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
```

### App Open Ad

```dart
import 'package:little_easy_admob/little_easy_admob.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppOpenAdManager appOpenAdManager;

  @override
  void initState() {
    super.initState();

    appOpenAdManager = AppOpenAdManager(
      'YOUR_APP_OPEN_AD_UNIT_ID',
      interval: Duration(minutes: 10), // Show ad every 10 minutes
      onAdLoaded: (manager) {
        print('Ad loaded, impression count: ${manager.impression}');
      },
      onAdDismissedFullScreenContent: (manager) {
        print('Ad dismissed');
      },
    );

    // Load the ad
    appOpenAdManager.loadAd();
  }

  void _showAppOpenAd() {
    appOpenAdManager.showAdIfAvailable();
  }

  // ...
}
```

### App Lifecycle Integration

Use `AppLifecycleReactor` to automatically show ads when your app resumes:

```dart
import 'package:little_easy_admob/little_easy_admob.dart';

final appLifecycleReactor = AppLifecycleReactor(
  appOpenAdManager: appOpenAdManager,
);
```

## Additional Information

### Issues and Feedback

Please file issues, bugs, or feature requests in our [issue tracker](https://github.com/smok95/little_easy_admob/issues).

### Contributing

Contributions are welcome! Feel free to submit pull requests.

### License

This project is licensed under the terms specified in the LICENSE file.
