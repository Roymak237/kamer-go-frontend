# globetrotter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Google Maps Setup

The map screen uses `google_maps_flutter`. You need a valid Google Maps API key for each target platform.

### 1. Create an API key

1. Open the [Google Cloud Console](https://console.cloud.google.com/).
2. Create a new project or select an existing one.
3. Enable **Maps SDK for Android**, **Maps SDK for iOS**, and **Maps JavaScript API**.
4. Go to **APIs & Services > Credentials** and create an **API key**.
5. Restrict the key to those APIs and to your app's package name / bundle ID / web domains.

### 2. Add the key locally

#### Android

Open `android/local.properties` and add your key:

```properties
GOOGLE_MAPS_API_KEY=YOUR_ANDROID_KEY
```

The `android/app/src/main/AndroidManifest.xml` already reads this value via `${GOOGLE_MAPS_API_KEY}`.

#### iOS

Open `ios/Flutter/GoogleMaps.local.xcconfig` and add your key:

```xcconfig
GOOGLE_MAPS_API_KEY = YOUR_IOS_KEY;
```

The `ios/Runner/Info.plist` already references `$(GOOGLE_MAPS_API_KEY)`.

#### Web

Open `web/google_maps_api_key.js` and add your key:

```javascript
window.googleMapsApiKey = "YOUR_WEB_KEY";
```

### 3. Run the app

```bash
flutter run
```

For web:

```bash
flutter run -d chrome
```
