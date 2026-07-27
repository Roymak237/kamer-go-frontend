import "package:flutter/material.dart";
import "../models/destination.dart";

class DestinationCard extends StatelessWidget {
  final Destination destination;
  final VoidCallback? onTap;

  const DestinationCard({super.key, required this.destination, this.onTap});

  @override
  Widget build(BuildContext context) {
    final tags = destination.tags.take(3).join(" • ");
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: _DestinationImage(destination: destination),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          destination.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${((destination.avgCostPerDay / 1000).toStringAsFixed(0))}k XAF",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          destination.region,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tags,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DestinationImage extends StatelessWidget {
  final Destination destination;

  const _DestinationImage({required this.destination});

  @override
  Widget build(BuildContext context) {
    final asset = destination.imageAsset.isNotEmpty ? destination.imageAsset : null;
    final url = destination.imageUrl.isNotEmpty ? destination.imageUrl : null;

    Widget? image;
    if (asset != null) {
      image = Image.asset(
        "assets/images/$asset",
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (c, o, s) => _placeholder(context),
      );
    } else if (url != null) {
      image = Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (c, child, progress) {
          if (progress == null) return child;
          return const Center(
            child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
          );
        },
        errorBuilder: (c, o, s) => _placeholder(context),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        if (image != null) image,
        if (image == null) _placeholder(context),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black26]),
            ),
            padding: const EdgeInsets.fromLTRB(12, 32, 12, 8),
          ),
        ),
      ],
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
      child: const Center(
        child: Icon(Icons.image_not_supported, size: 40, color: Colors.white70),
      ),
    );
  }
}
