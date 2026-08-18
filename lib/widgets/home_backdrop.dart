import "package:flutter/material.dart";

import "../utils/theme.dart";
import "asset_slideshow.dart";

class HomeBackdrop extends StatelessWidget {
  final Widget child;

  static const _yaoundeAssets = [
    "assets/images/reunification monument.avif",
    "assets/images/city council.webp",
    "assets/images/i love my country cameroon monument.webp",
  ];

  const HomeBackdrop({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const IgnorePointer(
          child: AssetSlideshow(
            assetPaths: _yaoundeAssets,
            opacity: 0.18,
            frameInterval: Duration(seconds: 8),
            transitionDuration: Duration(milliseconds: 1200),
          ),
        ),
        IgnorePointer(
          child: ColoredBox(
            color: AppTheme.background.withValues(alpha: 0.82),
          ),
        ),
        child,
      ],
    );
  }
}
