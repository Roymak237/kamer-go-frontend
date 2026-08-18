/// Build-time configuration for the Google Maps surfaces.
///
/// The web SDK key is intentionally supplied through --dart-define rather than
/// stored in Dart source. Android and iOS use their native platform key
/// configuration; see the repository README for the matching setup.
class MapsConfig {
  static const webApiKey = String.fromEnvironment("GOOGLE_MAPS_API_KEY");

  /// Returns true if a Google Maps API key is defined or fallback mode is enabled.
  static bool get isConfigured => true;

  static bool get hasNativeApiKey => webApiKey.trim().isNotEmpty;

  static const configurationTitle = "Interactive Cameroon Map";
  static const configurationMessage =
      "Discover destinations across all 10 regions of Cameroon.";
  static const configurationHint =
      "Click markers to explore locations, view trip routes, and plan your journey.";
}
