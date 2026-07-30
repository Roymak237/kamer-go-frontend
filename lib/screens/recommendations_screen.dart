import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../models/destination.dart";
import "../providers/auth_provider.dart";
import "../services/api_service.dart";
import "../utils/theme.dart";
import "../widgets/destination_card.dart";
import "../widgets/state_views.dart";

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  final _api = ApiService();
  List<Destination> _recommendations = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final token = context.read<AuthProvider>().token;
      if (token == null) {
        if (mounted) {
          setState(() {
            _loading = false;
            _error = "Please sign in to see recommendations.";
          });
        }
        return;
      }

      final results = await _api.fetchRecommendations(token: token);
      if (mounted) {
        setState(() {
          _recommendations = results;
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
    if (_loading) {
      return const AppLoadingView(message: "Reading your travel signals…");
    }

    if (_error != null) {
      return ErrorStateView(
        title: "Your compass needs a reset.",
        message: _error!,
        onRetry: _loadRecommendations,
      );
    }

    if (_recommendations.isEmpty) {
      return EmptyStateView(
        icon: Icons.auto_awesome_outlined,
        title: "Your journey awaits.",
        message:
            "Add a few interests to your profile and we’ll shape a more personal path.",
        action: OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.tune_rounded),
          label: const Text("Tune my preferences"),
        ),
      );
    }

    return RefreshIndicator(
      color: AppTheme.primary,
      onRefresh: _loadRecommendations,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
        itemCount: _recommendations.length,
        itemBuilder: (context, index) {
          return DestinationCard(destination: _recommendations[index]);
        },
      ),
    );
  }
}
