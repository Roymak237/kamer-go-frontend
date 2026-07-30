import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../models/itinerary.dart";
import "../providers/auth_provider.dart";
import "../utils/theme.dart";
import "../widgets/itinerary_card.dart";
import "../widgets/state_views.dart";

class ItinerariesScreen extends StatefulWidget {
  const ItinerariesScreen({super.key});

  @override
  State<ItinerariesScreen> createState() => _ItinerariesScreenState();
}

class _ItinerariesScreenState extends State<ItinerariesScreen> {
  List<Itinerary> _itineraries = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItineraries();
  }

  Future<void> _loadItineraries() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await context.read<AuthProvider>().fetchItineraries();
      if (mounted) {
        setState(() {
          _itineraries = list;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your journeys",
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontFamily: AppTheme.displayFontFamily,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Keep the good ideas in one place.",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              IconButton.filled(
                tooltip: "Create a new itinerary",
                onPressed: () async {
                  await Navigator.pushNamed(context, "/create_itinerary");
                  _loadItineraries();
                },
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
        ),
        Expanded(
          child: _loading
              ? const AppLoadingView(message: "Gathering your routes…")
              : _error != null
                  ? ErrorStateView(
                      title: "Your map went quiet.",
                      message: _error!,
                      onRetry: _loadItineraries,
                    )
                  : _itineraries.isEmpty
                      ? EmptyStateView(
                          icon: Icons.map_outlined,
                          title: "Your first trip is still unwritten.",
                          message:
                              "Save the places you love, then turn them into a route with room for detours.",
                          action: ElevatedButton.icon(
                            onPressed: () async {
                              await Navigator.pushNamed(
                                  context, "/create_itinerary");
                              _loadItineraries();
                            },
                            icon: const Icon(Icons.add_rounded),
                            label: const Text("Plan a new trip"),
                          ),
                        )
                      : RefreshIndicator(
                          color: AppTheme.primary,
                          onRefresh: _loadItineraries,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(top: 2, bottom: 24),
                            itemCount: _itineraries.length,
                            itemBuilder: (context, index) {
                              final itinerary = _itineraries[index];
                              return ItineraryCard(
                                itinerary: itinerary,
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  "/itinerary_detail",
                                  arguments: itinerary,
                                ),
                                onShare: () async {
                                  final username = await _showShareDialog(
                                    context,
                                    itinerary.id,
                                  );
                                  if (!mounted || username == null) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("Shared with $username")),
                                  );
                                },
                              );
                            },
                          ),
                        ),
        ),
      ],
    );
  }

  Future<String?> _showShareDialog(BuildContext context, String itineraryId) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Share this trip",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: AppTheme.displayFontFamily,
              ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            labelText: "Username to share with",
            prefixIcon: Icon(Icons.person_add_alt_1_outlined),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final username = controller.text.trim();
              if (username.isNotEmpty) {
                try {
                  await context.read<AuthProvider>().shareItinerary(
                        itineraryId: itineraryId,
                        sharedWith: username,
                      );
                  if (context.mounted) Navigator.pop(context, username);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: $e")),
                    );
                  }
                }
              }
            },
            child: const Text("Share"),
          ),
        ],
      ),
    );
  }
}
