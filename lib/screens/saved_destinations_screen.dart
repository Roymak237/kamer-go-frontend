import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../models/destination.dart";
import "../providers/favorites_provider.dart";
import "../services/api_service.dart";
import "../utils/theme.dart";
import "../widgets/destination_card.dart";
import "../widgets/state_views.dart";

class SavedDestinationsScreen extends StatefulWidget {
  const SavedDestinationsScreen({super.key});

  @override
  State<SavedDestinationsScreen> createState() =>
      _SavedDestinationsScreenState();
}

class _SavedDestinationsScreenState extends State<SavedDestinationsScreen> {
  final _api = ApiService();
  List<Destination> _destinations = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final favorites = context.read<FavoritesProvider>();
      if (!favorites.isLoaded) await favorites.load();
      final ids = favorites.favoriteIds;
      final destinations = await Future.wait(
        ids.map((id) => _api.getDestination(id)),
      );
      if (mounted) {
        setState(() {
          _destinations = destinations;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.toString().replaceFirst("Exception: ", "");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved places"),
        actions: [
          IconButton(
            tooltip: "Refresh saved places",
            onPressed: _loadSaved,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: _loading
          ? const AppLoadingView(message: "Gathering your saved places…")
          : _error != null
              ? ErrorStateView(
                  title: "Your saved map went quiet.",
                  message: _error!,
                  onRetry: _loadSaved,
                )
              : _destinations.isEmpty
                  ? EmptyStateView(
                      icon: Icons.favorite_border_rounded,
                      title: "Keep a few places close.",
                      message:
                          "Tap the heart on any destination to build your own shortlist.",
                      action: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.explore_rounded),
                        label: const Text("Explore destinations"),
                      ),
                    )
                  : RefreshIndicator(
                      color: AppTheme.primary,
                      onRefresh: _loadSaved,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 8, bottom: 24),
                        itemCount: _destinations.length,
                        itemBuilder: (context, index) {
                          final destination = _destinations[index];
                          return DestinationCard(
                            destination: destination,
                            onTap: () async {
                              await Navigator.pushNamed(
                                context,
                                "/destination_detail",
                                arguments: destination,
                              );
                              _loadSaved();
                            },
                          );
                        },
                      ),
                    ),
    );
  }
}
