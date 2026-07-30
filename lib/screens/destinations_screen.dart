import "package:flutter/material.dart";

import "../models/destination.dart";
import "../services/api_service.dart";
import "../utils/theme.dart";
import "../widgets/destination_card.dart";
import "../widgets/state_views.dart";

class DestinationsScreen extends StatefulWidget {
  const DestinationsScreen({super.key});

  @override
  State<DestinationsScreen> createState() => _DestinationsScreenState();
}

class _DestinationsScreenState extends State<DestinationsScreen> {
  final _api = ApiService();
  final _controller = TextEditingController();
  List<Destination> _destinations = [];
  bool _loading = true;
  String? _error;
  String? _selectedType;

  static const _typeFilters = [
    {"label": "All", "tag": ""},
    {"label": "Beach", "tag": "relaxation"},
    {"label": "Hiking", "tag": "hiking"},
    {"label": "Landmarks", "tag": "landmark"},
    {"label": "Family", "tag": "family"},
  ];

  @override
  void initState() {
    super.initState();
    _loadDestinations();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadDestinations(
      {String? query, String? tag, String? region}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await _api.searchDestinations(
        query: query ?? _controller.text,
        tag: tag,
        region: region,
      );
      if (mounted) {
        setState(() {
          _destinations = results;
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
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Find your next field note",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontFamily: AppTheme.displayFontFamily,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                "From quiet coastlines to mountain air, start with a place that pulls you in.",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                      height: 1.35,
                    ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _loadDestinations(),
                decoration: InputDecoration(
                  hintText: "Search places, regions, or moods",
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: IconButton(
                    tooltip: "Filter by region",
                    icon: const Icon(Icons.tune_rounded),
                    onPressed: () async {
                      final region = await _showFilterDialog(context);
                      if (region != null) {
                        _loadDestinations(
                          region: region.isEmpty ? null : region,
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: _typeFilters.map((filter) {
              final tag = filter["tag"] as String;
              final isSelected = (_selectedType ?? "") == tag;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(filter["label"] as String),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _selectedType = tag.isEmpty || isSelected ? null : tag;
                    });
                    _loadDestinations(tag: _selectedType);
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(),
        Expanded(
          child: _loading
              ? const AppLoadingView(
                  message: "Mapping places worth the detour…")
              : _error != null
                  ? ErrorStateView(
                      title: "We lost the trail.",
                      message: _error!,
                      onRetry: _loadDestinations,
                    )
                  : _destinations.isEmpty
                      ? const EmptyStateView(
                          icon: Icons.explore_off_rounded,
                          title: "No places on this path yet.",
                          message:
                              "Try another search or loosen your filters to keep exploring.",
                        )
                      : RefreshIndicator(
                          onRefresh: _loadDestinations,
                          color: AppTheme.primary,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(top: 4, bottom: 24),
                            itemCount: _destinations.length,
                            itemBuilder: (context, index) {
                              return DestinationCard(
                                destination: _destinations[index],
                                onTap: () {},
                              );
                            },
                          ),
                        ),
        ),
      ],
    );
  }

  Future<String?> _showFilterDialog(BuildContext context) async {
    const regions = [
      "Adamawa",
      "Centre",
      "East",
      "Far North",
      "Littoral",
      "North",
      "Northwest",
      "South",
      "Southwest",
      "West",
    ];

    return showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text("Filter by region"),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, ""),
            child: const Text("All regions"),
          ),
          ...regions.map(
            (region) => SimpleDialogOption(
              onPressed: () => Navigator.pop(context, region),
              child: Text(region),
            ),
          ),
        ],
      ),
    );
  }
}
