import "package:google_maps_flutter/google_maps_flutter.dart";

class RoadRoute {
  final List<LatLng> geometry;
  final double distanceMeters;
  final double durationSeconds;

  const RoadRoute({
    required this.geometry,
    required this.distanceMeters,
    required this.durationSeconds,
  });
}
