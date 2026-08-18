import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:pointer_interceptor/pointer_interceptor.dart";
import "package:webview_all/webview_all.dart";

import "../localization/app_localizations.dart";
import "../models/destination.dart";
import "../utils/theme.dart";

class DestinationMap extends StatefulWidget {
  final List<Destination> destinations;
  final Destination? selectedDestination;
  final ValueChanged<Destination>? onDestinationSelected;
  final LatLng? currentLocation;
  final ValueChanged<GoogleMapController>? onMapCreated;
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
    this.onMapCreated,
    this.routePoints = const [],
    this.height = double.infinity,
    this.zoom,
    this.compact = false,
  });

  @override
  State<DestinationMap> createState() => _DestinationMapState();
}

class _DestinationMapState extends State<DestinationMap> {
  bool get _useGoogleMaps => kIsWeb || !_isDesktopPlatform;

  bool get _isDesktopPlatform =>
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS;

  List<Destination> get _mappedDestinations => widget.destinations
      .where((destination) => destination.hasCoordinates)
      .toList();

  LatLng get _center {
    final locations = _mappedDestinations
        .map(
          (destination) => LatLng(
            destination.latitude!,
            destination.longitude!,
          ),
        )
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
    if (widget.zoom != null) return widget.zoom!;
    if (_mappedDestinations.length <= 1) return 14.5;
    return 7.2;
  }

  CameraPosition get _initialCameraPosition {
    final target = widget.currentLocation ??
        (widget.selectedDestination?.hasCoordinates == true
            ? LatLng(
                widget.selectedDestination!.latitude!,
                widget.selectedDestination!.longitude!,
              )
            : _center);
    return CameraPosition(
      target: target,
      zoom: widget.currentLocation != null || widget.selectedDestination != null
          ? (widget.zoom ?? 14.5)
          : _initialZoom,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_mappedDestinations.isEmpty && widget.routePoints.isEmpty) {
      return _bounded(
        _MapMessage(
          title: AppLocalizations.of(context).noMappedPlaces,
          message: AppLocalizations.of(context).noMappedPlacesMessage,
          icon: Icons.location_off_outlined,
        ),
      );
    }

    return _bounded(
      _useGoogleMaps
          ? _buildGoogleMap()
          : _buildDesktopGoogleMap(context),
    );
  }

  Widget _buildGoogleMap() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      child: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) {
          widget.onMapCreated?.call(controller);
        },
        markers: _markers,
        polylines: _polylines,
        compassEnabled: true,
        mapToolbarEnabled: true,
        myLocationButtonEnabled: true,
        myLocationEnabled: false,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        rotateGesturesEnabled: true,
        tiltGesturesEnabled: true,
        mapType: MapType.normal,
        minMaxZoomPreference: const MinMaxZoomPreference(3, 20),
        cameraTargetBounds: CameraTargetBounds.unbounded,
        onCameraMoveStarted: () {
          // Handle camera movement start
        },
        onCameraMove: (CameraPosition position) {
          // Handle camera movement
        },
        onCameraIdle: () {
          // Handle camera idle state
        },
      ),
    );
  }

  Widget _buildDesktopGoogleMap(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      child: _GoogleMapsWebView(
        url: _googleMapsUrl(),
      ),
    );
  }

  String _googleMapsUrl() {
    if (widget.routePoints.length >= 2) {
      final origin = _formatLatLng(widget.routePoints.first);
      final destination = _formatLatLng(widget.routePoints.last);
      final waypoints = widget.routePoints.length > 2
          ? widget.routePoints
              .skip(1)
              .take(widget.routePoints.length - 2)
              .map(_formatLatLng)
              .join("|")
          : "";

      final params = <String, String>{
        "api": "1",
        "origin": origin,
        "destination": destination,
        "travelmode": "driving",
      };
      if (waypoints.isNotEmpty) {
        params["waypoints"] = waypoints;
      }
      return Uri.https("www.google.com", "/maps/dir/", params).toString();
    }

    final target = widget.selectedDestination?.hasCoordinates == true
        ? LatLng(
            widget.selectedDestination!.latitude!,
            widget.selectedDestination!.longitude!,
          )
        : (widget.currentLocation ??
            (_mappedDestinations.isNotEmpty
                ? LatLng(
                    _mappedDestinations.first.latitude!,
                    _mappedDestinations.first.longitude!,
                  )
                : const LatLng(3.8480, 11.5021)));

    return Uri.https("www.google.com", "/maps/search/", {
      "api": "1",
      "query": _formatLatLng(target),
    }).toString();
  }

  String _formatLatLng(LatLng point) =>
      "${point.latitude.toStringAsFixed(6)},${point.longitude.toStringAsFixed(6)}";

  Set<Marker> get _markers {
    final markers = <Marker>{
      if (widget.currentLocation != null)
        Marker(
          markerId: const MarkerId("current-location"),
          position: widget.currentLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: const InfoWindow(title: "Your current location"),
          zIndexInt: 3,
        ),
      ..._mappedDestinations.map((destination) {
        final selected = destination.id == widget.selectedDestination?.id;
        return Marker(
          markerId: MarkerId("destination-${destination.id}"),
          position: LatLng(destination.latitude!, destination.longitude!),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            selected ? BitmapDescriptor.hueRed : BitmapDescriptor.hueGreen,
          ),
          infoWindow: InfoWindow(
            title: destination.name,
            snippet: destination.region,
          ),
          zIndexInt: selected ? 2 : 1,
          onTap: widget.onDestinationSelected == null
              ? null
              : () => widget.onDestinationSelected!(destination),
        );
      }),
    };
    return markers;
  }

  Set<Polyline> get _polylines {
    if (widget.routePoints.length < 2) return const <Polyline>{};
    return {
      Polyline(
        polylineId: const PolylineId("itinerary-route"),
        points: widget.routePoints,
        color: AppTheme.secondary,
        width: 5,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
    };
  }

  Widget _bounded(Widget child) => widget.height == double.infinity
      ? child
      : SizedBox(height: widget.height, child: child);
}

class _MapMessage extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const _MapMessage({
    required this.title,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.primarySoft,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppTheme.primary, size: 32),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.primaryDark,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// Keeps Flutter overlays clickable when Google Maps uses an HtmlElementView on
/// web. On mobile PointerInterceptor is a no-op and preserves the same layout.
Widget interceptMapOverlay(Widget child) =>
    kIsWeb ? PointerInterceptor(child: child) : child;

class _GoogleMapsWebView extends StatefulWidget {
  final String url;

  const _GoogleMapsWebView({required this.url});

  @override
  State<_GoogleMapsWebView> createState() => _GoogleMapsWebViewState();
}

class _GoogleMapsWebViewState extends State<_GoogleMapsWebView> {
  late final WebViewController _controller;
  late String _loadedUrl;

  @override
  void initState() {
    super.initState();
    _loadedUrl = widget.url;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  void didUpdateWidget(covariant _GoogleMapsWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.url == _loadedUrl) return;
    _loadedUrl = widget.url;
    _controller.loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
