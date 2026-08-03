import "dart:ui";

import "package:flutter/material.dart";

import "../utils/theme.dart";

class AuthBackdrop extends StatelessWidget {
  final Widget child;

  const AuthBackdrop({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(color: AppTheme.background),
        child: Stack(
          children: [
            Positioned(
              top: 42,
              right: -96,
              child: IgnorePointer(
                child: Transform.rotate(
                  angle: -0.07,
                  child: const _TravelImagePanel(
                    width: 500,
                    height: 300,
                  ),
                ),
              ),
            ),
            Positioned(
              left: -110,
              bottom: 12,
              child: IgnorePointer(
                child: Transform.rotate(
                  angle: 0.06,
                  child: const _TravelImagePanel(
                    width: 360,
                    height: 220,
                    opacity: 0.1,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.background.withValues(alpha: 0.4),
                        AppTheme.background.withValues(alpha: 0.94),
                      ],
                      stops: const [0, 0.72],
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: child,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TravelImagePanel extends StatelessWidget {
  final double width;
  final double height;
  final double opacity;

  const _TravelImagePanel({
    required this.width,
    required this.height,
    this.opacity = 0.16,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(44),
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Image.asset(
                  "assets/images/travel-collage-login.jpeg",
                  fit: BoxFit.cover,
                  semanticLabel:
                      "Travel collage with landmarks and an airplane",
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.36),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthFormCard extends StatelessWidget {
  final Widget child;

  const AuthFormCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 22),
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: AppTheme.surface),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryDark.withValues(alpha: 0.1),
            blurRadius: 34,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: child,
    );
  }
}

class AuthIntro extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;
  final IconData icon;

  const AuthIntro({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primarySoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: AppTheme.primaryDark, size: 25),
            ),
            const SizedBox(width: 12),
            Text(
              "GLOBETROTTER / CAMEROON",
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 26),
        Text(
          eyebrow,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppTheme.secondary,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.4,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontFamily: AppTheme.displayFontFamily,
                height: 1.05,
              ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
                height: 1.45,
              ),
        ),
      ],
    );
  }
}

class AuthErrorBanner extends StatelessWidget {
  final String message;

  const AuthErrorBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: "Authentication error: $message",
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0F0),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.secondary.withValues(alpha: 0.22)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline_rounded,
                color: AppTheme.secondary, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Color(0xFF8A1721),
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthDivider extends StatelessWidget {
  final String label;

  const AuthDivider({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.8,
                ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
