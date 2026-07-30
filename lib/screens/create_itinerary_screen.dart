import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/auth_provider.dart";
import "../services/api_service.dart";
import "../utils/theme.dart";
import "../widgets/state_views.dart";

class CreateItineraryScreen extends StatefulWidget {
  const CreateItineraryScreen({super.key});

  @override
  State<CreateItineraryScreen> createState() => _CreateItineraryScreenState();
}

class _CreateItineraryScreenState extends State<CreateItineraryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _notesController = TextEditingController();
  final List<String> _selectedDestinations = [];
  List<String> _allDestinations = [];
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDestinations();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadDestinations() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await ApiService().searchDestinations();
      if (mounted) {
        setState(() {
          _allDestinations =
              results.map((destination) => destination.name).toList();
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

  Future<void> _saveItinerary() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _saving = true);
    try {
      await context.read<AuthProvider>().createItinerary(
            title: _titleController.text.trim(),
            destinations: _selectedDestinations,
            startDate: _startDateController.text.trim(),
            endDate: _endDateController.text.trim(),
            notes: _notesController.text.trim(),
          );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceFirst("Exception: ", ""));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Plan a new trip")),
      body: _loading
          ? const AppLoadingView(message: "Opening the destination guide…")
          : _error != null && _allDestinations.isEmpty
              ? ErrorStateView(
                  title: "The guide is out of reach.",
                  message: _error!,
                  onRetry: _loadDestinations,
                )
              : Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Give the journey a shape.",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontFamily: AppTheme.displayFontFamily,
                              ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Start with a name, then collect the places that belong together.",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textSecondary,
                                    height: 1.35,
                                  ),
                        ),
                        const SizedBox(height: 22),
                        if (_error != null) ...[
                          Container(
                            padding: const EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF0F0),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color:
                                    AppTheme.secondary.withValues(alpha: 0.22),
                              ),
                            ),
                            child: Text(
                              _error!,
                              style: const TextStyle(
                                color: Color(0xFF8A1721),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        TextFormField(
                          controller: _titleController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: "Trip title",
                            hintText: "Weekend on the coast",
                            prefixIcon: Icon(Icons.bookmark_outline_rounded),
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? "Give your trip a title"
                                  : null,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _startDateController,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: "Start date",
                                  hintText: "YYYY-MM-DD",
                                  prefixIcon: Icon(Icons.today_outlined),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _endDateController,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: "End date",
                                  hintText: "YYYY-MM-DD",
                                  prefixIcon:
                                      Icon(Icons.event_available_outlined),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _notesController,
                          maxLines: 4,
                          textInputAction: TextInputAction.newline,
                          decoration: const InputDecoration(
                            labelText: "Notes",
                            hintText: "Anything you want to remember…",
                            prefixIcon: Icon(Icons.sticky_note_2_outlined),
                            alignLabelWithHint: true,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Icon(Icons.route_rounded,
                                color: AppTheme.primary),
                            const SizedBox(width: 8),
                            Text(
                              "Choose your stops",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontFamily: AppTheme.displayFontFamily,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Select one or more destinations.",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _allDestinations.map((name) {
                            final selected =
                                _selectedDestinations.contains(name);
                            return FilterChip(
                              label: Text(name),
                              selected: selected,
                              onSelected: (value) {
                                setState(() {
                                  if (value) {
                                    _selectedDestinations.add(name);
                                  } else {
                                    _selectedDestinations.remove(name);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        if (_selectedDestinations.isEmpty) ...[
                          const SizedBox(height: 9),
                          Text(
                            "Choose at least one stop to save this trip.",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                          ),
                        ],
                        const SizedBox(height: 28),
                        ElevatedButton.icon(
                          onPressed: _saving ? null : _saveItinerary,
                          icon: _saving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.save_outlined),
                          label: Text(_saving
                              ? "Saving your route…"
                              : "Save itinerary"),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
