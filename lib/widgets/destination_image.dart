import "package:flutter/material.dart";

import "../models/destination.dart";
import "../utils/theme.dart";

class DestinationImage extends StatelessWidget {
  final Destination destination;
  final BoxFit fit;

  const DestinationImage({
    super.key,
    required this.destination,
    this.fit = BoxFit.cover,
  });

  String get _semanticLabel {
    final attribution = destination.imageAttribution;
    if (attribution.isEmpty) return "Image of ${destination.name}";
    return "Image of ${destination.name}. $attribution";
  }

  @override
  Widget build(BuildContext context) {
    final fallback = _placeholder;
    final url = destination.imageUrl.trim();

    if (destination.imageAsset.trim().isNotEmpty) {
      return Image.asset(
        "assets/images/${destination.imageAsset}",
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        semanticLabel: _semanticLabel,
        errorBuilder: (_, __, ___) =>
            url.isEmpty ? fallback : _networkImage(url, fallback: fallback),
      );
    }

    if (url.isNotEmpty) {
      return _networkImage(url, fallback: fallback);
    }

    return fallback;
  }

  Widget _networkImage(String url, {required Widget fallback}) {
    return Image.network(
      url,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      semanticLabel: _semanticLabel,
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppTheme.primary,
            ),
          ),
        );
      },
      errorBuilder: (_, __, ___) => fallback,
    );
  }

  Widget get _placeholder => Container(
        color: AppTheme.primarySoft,
        alignment: Alignment.center,
        child: const Icon(
          Icons.landscape_outlined,
          size: 44,
          color: AppTheme.primary,
        ),
      );
}
