import "dart:ui" as ui;

import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";

import "../models/destination.dart";
import "../utils/theme.dart";

class DestinationMap extends StatelessWidget {
  final List<Destination> destinations;
  final Destination? selectedDestination;
  final ValueChanged<Destination>? onDestinationSelected;
  final LatLng? currentLocation;
  final MapController? mapController;
  final List<LatLng> routePoints;
  final double height;
  final double? zoom;
  final bool compact;

  const DestinationMap({
    super.key,
    required this.destinations,
    this.selectedDestination,
    this.onDestinationSelected,
    this.currentLocation,
    this.mapController,
    this.routePoints = const [],
    this.height = double.infinity,
    this.zoom,
    this.compact = false,
  });

  List<Destination> get _mappedDestinations =>
      destinations.where((destination) => destination.hasCoordinates).toList();

  LatLng get _center {
    final locations = _mappedDestinations
        .map((destination) => LatLng(
              destination.latitude!,
              destination.longitude!,
            ))
        .toList();
    if (locations.isEmpty) return const LatLng(3.8480, 11.5021);
    if (locations.length == 1) return locations.first;

    final latitude = locations.fold<double>(
          0,
          (total, location) => total + location.latitude,
        ) /
        locations.length;
    final longitude = locations.fold<double>(
          0,
          (total, location) => total + location.longitude,
        ) /
        locations.length;
    return LatLng(latitude, longitude);
  }

  double get _initialZoom {
    if (zoom != null) return zoom!;
    if (_mappedDestinations.length <= 1) return 14.5;
    return 12.2;
  }

  @override
  Widget build(BuildContext context) {
    if (_mappedDestinations.isEmpty && routePoints.isEmpty) {
      return Container(
        height: height == double.infinity ? 220 : height,
        color: AppTheme.primarySoft,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_off_outlined,
                color: AppTheme.primary, size: 32),
            SizedBox(height: 10),
            Text(
              "Location details are not available yet.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.primaryDark,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    final controller = mapController ?? MapController();
    final map = FlutterMap(
      mapController: controller,
      options: MapOptions(
        initialCenter: currentLocation ??
            (selectedDestination?.hasCoordinates == true
                ? LatLng(
                    selectedDestination!.latitude!,
                    selectedDestination!.longitude!,
                  )
                : _center),
        initialZoom: currentLocation != null
            ? 14.5
            : selectedDestination != null
                ? 14.5
                : _initialZoom,
        minZoom: 3,
        maxZoom: 18,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate:
              "https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png",
          subdomains: const ["a", "b", "c", "d"],
          userAgentPackageName: "com.globetrotter.cameroon",
          maxNativeZoom: 19,
          panBuffer: 0,
        ),
        if (routePoints.length > 1)
          PolylineLayer(
            polylines: [
              Polyline(
                points: routePoints,
                color: AppTheme.secondary,
                strokeWidth: 5,
                borderColor: Colors.white,
                borderStrokeWidth: 2,
              ),
            ],
          ),
        MarkerLayer(
          markers: [
            if (currentLocation != null)
              Marker(
                point: currentLocation!,
                width: 48,
                height: 48,
                child: Semantics(
                  label: "Your current location",
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2878D0),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x40000000),
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.my_location_rounded,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
              ),
            ..._mappedDestinations.map((destination) {
              final selected = destination.id == selectedDestination?.id;
              return Marker(
                point: LatLng(destination.latitude!, destination.longitude!),
                width: selected ? 54 : 44,
                height: selected ? 64 : 54,
                child: Semantics(
                  button: true,
                  label: "View ${destination.name} on the map",
                  selected: selected,
                  child: GestureDetector(
                    onTap: onDestinationSelected == null
                        ? null
                        : () => onDestinationSelected!(destination),
                    child: AnimatedScale(
                      scale: selected ? 1.1 : 1,
                      duration: const Duration(milliseconds: 180),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: selected ? 38 : 32,
                            height: selected ? 38 : 32,
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppTheme.secondary
                                  : AppTheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x40000000),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(
                              selected
                                  ? Icons.near_me_rounded
                                  : Icons.place_rounded,
                              color: Colors.white,
                              size: selected ? 21 : 18,
                            ),
                          ),
                          CustomPaint(
                            size: const Size(12, 7),
                            painter: _MarkerTailPainter(
                              color: selected
                                  ? AppTheme.secondary
                                  : AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
        if (compact)
          const RichAttributionWidget(
            alignment: AttributionAlignment.bottomRight,
            attributions: [
              TextSourceAttribution("OpenStreetMap contributors"),
              TextSourceAttribution("CARTO"),
            ],
          )
        else
          const RichAttributionWidget(
            alignment: AttributionAlignment.bottomLeft,
            attributions: [
              TextSourceAttribution("OpenStreetMap contributors"),
              TextSourceAttribution("CARTO"),
            ],
          ),
      ],
    );

    return height == double.infinity
        ? map
        : SizedBox(height: height, child: map);
  }
}

class _MarkerTailPainter extends CustomPainter {
  final Color color;

  const _MarkerTailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = ui.Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _MarkerTailPainter oldDelegate) =>
      oldDelegate.color != color;
}
