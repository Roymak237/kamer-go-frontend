import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:geolocator/geolocator.dart";
import "package:latlong2/latlong.dart";

import "../models/destination.dart";
import "../services/api_service.dart";
import "../utils/theme.dart";
import "../widgets/destination_map.dart";
import "../widgets/map_action_button.dart";
import "../widgets/state_views.dart";

class MapScreen extends StatefulWidget {
  final bool isActive;

  const MapScreen({
    super.key,
    this.isActive = true,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _api = ApiService();
  final _mapController = MapController();
  List<Destination> _destinations = [];
  Destination? _selectedDestination;
  LatLng? _currentLocation;
  bool _loading = false;
  bool _locating = false;
  bool _hasLoaded = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.isActive) _loadDestinations();
  }

  @override
  void didUpdateWidget(covariant MapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive && !_hasLoaded) {
      _loadDestinations();
    }
  }

  Future<void> _loadDestinations() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final destinations = await _api.searchDestinations();
      if (!mounted) return;
      setState(() {
        _destinations = destinations;
        _selectedDestination = destinations.isEmpty ? null : destinations.first;
        _loading = false;
        _hasLoaded = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _hasLoaded = true;
        _error = e.toString().replaceFirst("Exception: ", "");
      });
    }
  }

  void _selectDestination(Destination destination) {
    setState(() => _selectedDestination = destination);
  }

  Future<void> _recenterToCurrentLocation() async {
    if (_locating) return;
    setState(() => _locating = true);

    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw Exception("Turn on location services to find your position.");
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission was denied.");
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          "Location permission is blocked. Enable it in your device settings.",
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 12),
        ),
      );
      final location = LatLng(position.latitude, position.longitude);
      if (!mounted) return;
      setState(() => _currentLocation = location);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        try {
          _mapController.move(location, 15);
        } catch (_) {
          // The map may not have finished mounting yet; the marker is still
          // retained and the next press can recenter once it is ready.
        }
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst("Exception: ", "")),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) return const SizedBox.expand();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 16, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "THE CAMEROON MAP",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppTheme.secondary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Plan by place",
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontFamily: AppTheme.displayFontFamily,
                                height: 1,
                              ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () => Navigator.pushNamed(context, "/itineraries"),
                icon: const Icon(Icons.route_rounded, size: 18),
                label: const Text("My trips"),
              ),
            ],
          ),
        ),
        Expanded(
          child: _loading
              ? const AppLoadingView(message: "Unfolding the map…")
              : _error != null
                  ? ErrorStateView(
                      title: "The map lost its trail.",
                      message: _error!,
                      onRetry: _loadDestinations,
                    )
                  : _buildMap(context),
        ),
      ],
    );
  }

  Widget _buildMap(BuildContext context) {
    final mappedDestinations = _destinations
        .where((destination) => destination.hasCoordinates)
        .toList();

    if (mappedDestinations.isEmpty) {
      return const EmptyStateView(
        icon: Icons.location_off_outlined,
        title: "No mapped places yet.",
        message: "Add coordinates to destinations to bring them onto the map.",
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            child: DestinationMap(
              destinations: mappedDestinations,
              selectedDestination: _selectedDestination,
              currentLocation: _currentLocation,
              mapController: _mapController,
              onDestinationSelected: _selectDestination,
            ),
          ),
        ),
        Positioned(
          top: 14,
          left: 28,
          child: _MapCountPill(count: mappedDestinations.length),
        ),
        Positioned(
          top: 14,
          right: 28,
          child: MapActionButton(
            locating: _locating,
            hasCurrentLocation: _currentLocation != null,
            onPressed: _recenterToCurrentLocation,
          ),
        ),
        if (_selectedDestination != null)
          Positioned(
            left: 28,
            right: 28,
            bottom: 18,
            child: _SelectedDestinationCard(
              destination: _selectedDestination!,
              onOpen: () => Navigator.pushNamed(
                context,
                "/destination_detail",
                arguments: _selectedDestination,
              ),
            ),
          ),
      ],
    );
  }
}

class _MapCountPill extends StatelessWidget {
  final int count;

  const _MapCountPill({required this.count});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        decoration: BoxDecoration(
          color: AppTheme.surface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppTheme.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          "$count mapped place${count == 1 ? "" : "s"}",
          style: const TextStyle(
            color: AppTheme.primaryDark,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _SelectedDestinationCard extends StatelessWidget {
  final Destination destination;
  final VoidCallback onOpen;

  const _SelectedDestinationCard({
    required this.destination,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(AppTheme.radiusCard),
      elevation: 5,
      shadowColor: AppTheme.primaryDark.withValues(alpha: 0.18),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 13, 10, 13),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppTheme.primarySoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.place_rounded,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontFamily: AppTheme.displayFontFamily,
                          ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "${destination.region}  •  Tap to open field guide",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppTheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}
