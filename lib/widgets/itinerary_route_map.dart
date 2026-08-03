import "package:flutter/material.dart";
import "package:latlong2/latlong.dart";

import "../models/destination.dart";
import "../services/api_service.dart";
import "../utils/theme.dart";
import "destination_map.dart";

class ItineraryRouteMap extends StatelessWidget {
  final List<String> destinationNames;
  final List<Destination>? destinations;
  final double height;

  const ItineraryRouteMap({
    super.key,
    required this.destinationNames,
    this.destinations,
    this.height = 250,
  });

  @override
  Widget build(BuildContext context) {
    if (destinations != null) {
      return _buildCard(context, _orderedDestinations(destinations!));
    }

    return FutureBuilder<List<Destination>>(
      future: ApiService().searchDestinations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _MapMessage(
            height: height,
            icon: Icons.route_rounded,
            message: "Drawing your pathway…",
            loading: true,
          );
        }
        if (snapshot.hasError) {
          return _MapMessage(
            height: height,
            icon: Icons.map_outlined,
            message: "The route map is unavailable right now.",
          );
        }
        return _buildCard(
          context,
          _orderedDestinations(snapshot.data ?? const <Destination>[]),
        );
      },
    );
  }

  List<Destination> _orderedDestinations(List<Destination> available) {
    final byName = <String, Destination>{
      for (final destination in available) destination.name: destination,
    };
    return destinationNames
        .map((name) => byName[name])
        .whereType<Destination>()
        .where((destination) => destination.hasCoordinates)
        .toList();
  }

  Widget _buildCard(BuildContext context, List<Destination> route) {
    final points = route
        .map((destination) => LatLng(
              destination.latitude!,
              destination.longitude!,
            ))
        .toList();

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.alt_route_rounded,
                  color: AppTheme.primary, size: 19),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "MAPPED PATHWAY",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.secondary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                ),
              ),
              Text(
                "${route.length} stop${route.length == 1 ? "" : "s"}",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            route.length < 2
                ? "Add another mapped stop to draw the route between places."
                : "The line follows the order of your selected stops.",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.35,
                ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: DestinationMap(
              destinations: route,
              routePoints: points,
              height: height,
              compact: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapMessage extends StatelessWidget {
  final double height;
  final IconData icon;
  final String message;
  final bool loading;

  const _MapMessage({
    required this.height,
    required this.icon,
    required this.message,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height + 70,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppTheme.primary, size: 30),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (loading) ...[
            const SizedBox(height: 12),
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ],
      ),
    );
  }
}
