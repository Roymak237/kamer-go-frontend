import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../models/itinerary.dart";
import "../providers/auth_provider.dart";
import "../utils/theme.dart";

class ItineraryDetailScreen extends StatelessWidget {
  const ItineraryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final itinerary = ModalRoute.of(context)!.settings.arguments as Itinerary;

    return Scaffold(
      appBar: AppBar(title: Text(itinerary.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.primary, AppTheme.primaryDark],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "FIELD NOTE",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.accent,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.3,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    itinerary.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontFamily: AppTheme.displayFontFamily,
                        ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(Icons.place_outlined,
                          color: Colors.white70, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        "${itinerary.destinations.length} destination${itinerary.destinations.length == 1 ? "" : "s"}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _DetailSection(
              icon: Icons.route_rounded,
              label: "ROUTE",
              child: Text(
                itinerary.destinations.isEmpty
                    ? "No destinations added yet"
                    : itinerary.destinations.join("  •  "),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: AppTheme.displayFontFamily,
                      height: 1.3,
                    ),
              ),
            ),
            const SizedBox(height: 18),
            _DetailSection(
              icon: Icons.calendar_month_outlined,
              label: "DATES",
              child: Text(
                "${itinerary.startDate}  →  ${itinerary.endDate}",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: AppTheme.displayFontFamily,
                    ),
              ),
            ),
            if (itinerary.notes.isNotEmpty) ...[
              const SizedBox(height: 18),
              _DetailSection(
                icon: Icons.sticky_note_2_outlined,
                label: "NOTES",
                child: Text(
                  itinerary.notes,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondary,
                        height: 1.45,
                      ),
                ),
              ),
            ],
            const SizedBox(height: 34),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        "/create_itinerary",
                        arguments: itinerary,
                      );
                    },
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text("Edit trip"),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.outlined(
                  tooltip: "Delete itinerary",
                  onPressed: () => _deleteItinerary(context, itinerary),
                  style: IconButton.styleFrom(
                    foregroundColor: AppTheme.secondary,
                    side: const BorderSide(color: AppTheme.secondary),
                    fixedSize: const Size(52, 52),
                  ),
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteItinerary(
      BuildContext context, Itinerary itinerary) async {
    final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Delete this trip?"),
            content: const Text(
              "This removes the itinerary from your saved journeys.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Keep it"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondary),
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Delete"),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirm) return;

    try {
      final auth = context.read<AuthProvider>();
      await auth.deleteItinerary(itinerary.id);
      if (!context.mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Itinerary deleted")),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }
}

class _DetailSection extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget child;

  const _DetailSection({
    required this.icon,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
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
              Icon(icon, size: 18, color: AppTheme.primary),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.secondary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          child,
        ],
      ),
    );
  }
}
