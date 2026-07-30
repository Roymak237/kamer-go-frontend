import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/auth_provider.dart";
import "../utils/theme.dart";

class ProfileScreen extends StatefulWidget {
  final bool showScaffold;

  const ProfileScreen({super.key, this.showScaffold = true});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      await context.read<AuthProvider>().fetchProfile();
    } catch (_) {
      // The content state below gives the user a clear recovery path.
    }
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  Widget _buildContent(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (user == null) {
      return _ProfileMessage(
        icon: Icons.person_off_outlined,
        title: "Your profile is taking a detour.",
        message: "We could not load your details right now.",
        action: TextButton.icon(
          onPressed: _loadProfile,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text("Try again"),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.primary, AppTheme.primaryDark],
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: AppTheme.accent,
                  child: Text(
                    user.username.isNotEmpty
                        ? user.username[0].toUpperCase()
                        : "?",
                    style: const TextStyle(
                      fontFamily: AppTheme.displayFontFamily,
                      fontSize: 28,
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "YOUR TRAVEL PROFILE",
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.72),
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.1,
                            ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        user.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontFamily: AppTheme.displayFontFamily,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Member since today",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.78),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text(
            "Your travel signals",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontFamily: AppTheme.displayFontFamily,
                ),
          ),
          const SizedBox(height: 5),
          Text(
            "These details help shape recommendations that feel more like you.",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusCard),
              border: Border.all(color: AppTheme.border),
            ),
            child: user.preferences.isEmpty
                ? const _ProfileMessage(
                    icon: Icons.tune_rounded,
                    title: "No preferences yet",
                    message:
                        "Add a few interests to make your next recommendation more personal.",
                    action: null,
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: user.preferences.map((preference) {
                      return Chip(
                        label: Text(preference),
                        avatar: const Icon(Icons.check_rounded, size: 16),
                        backgroundColor: AppTheme.primarySoft,
                        labelStyle: const TextStyle(
                          color: AppTheme.primaryDark,
                          fontWeight: FontWeight.w700,
                        ),
                        side: BorderSide.none,
                      );
                    }).toList(),
                  ),
          ),
          const SizedBox(height: 28),
          OutlinedButton.icon(
            onPressed: () async {
              await auth.logout();
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/login",
                  (route) => false,
                );
              }
            },
            icon: const Icon(Icons.logout_rounded),
            label: const Text("LOG OUT"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = _buildContent(context);
    if (!widget.showScaffold) return content;

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: content,
    );
  }
}

class _ProfileMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  const _ProfileMessage({
    required this.icon,
    required this.title,
    required this.message,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppTheme.primary, size: 30),
        const SizedBox(height: 10),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontFamily: AppTheme.displayFontFamily,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
                height: 1.35,
              ),
        ),
        if (action != null) ...[
          const SizedBox(height: 8),
          action!,
        ],
      ],
    );
  }
}
