import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/auth_provider.dart";
import "../utils/theme.dart";
import "../widgets/auth_widgets.dart";

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _prefsController = TextEditingController();
  String? _error;
  bool _loading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _prefsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _error = null;
      _loading = true;
    });

    final preferences = _prefsController.text
        .split(",")
        .map((entry) => entry.trim().toLowerCase())
        .where((entry) => entry.isNotEmpty)
        .toList();

    try {
      await context.read<AuthProvider>().register(
            username: _usernameController.text.trim(),
            password: _passwordController.text,
            preferences: preferences,
          );
      if (mounted) {
        Navigator.pushReplacementNamed(context, "/login");
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceFirst("Exception: ", ""));
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackdrop(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 6, 4, 18),
            child: Row(
              children: [
                IconButton(
                  tooltip: "Back to login",
                  onPressed: _loading ? null : () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_rounded),
                  color: AppTheme.primaryDark,
                ),
                const SizedBox(width: 2),
                Text(
                  "Start with a better map.",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryDark,
                        fontFamily: AppTheme.displayFontFamily,
                        height: 1.25,
                      ),
                ),
              ],
            ),
          ),
          AuthFormCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AuthIntro(
                    eyebrow: "CREATE YOUR ACCOUNT",
                    title: "Make room for more detours.",
                    subtitle:
                        "Save places that spark something, then turn them into a trip that feels like yours.",
                    icon: Icons.map_rounded,
                  ),
                  const SizedBox(height: 28),
                  if (_error != null) ...[
                    AuthErrorBanner(message: _error!),
                    const SizedBox(height: 16),
                  ],
                  TextFormField(
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.username],
                    decoration: const InputDecoration(
                      labelText: "Username",
                      hintText: "What should we call you?",
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Choose a username";
                      }
                      if (value.trim().length < 3) {
                        return "Use at least 3 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.newPassword],
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Keep it memorable and private",
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        tooltip: _obscurePassword
                            ? "Show password"
                            : "Hide password",
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Choose a password";
                      }
                      if (value.length < 6) {
                        return "Use at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _prefsController,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: "What are you drawn to?",
                      hintText: "beach, food, culture",
                      prefixIcon: Icon(Icons.auto_awesome_outlined),
                      helperText: "Add a few comma-separated interests",
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _loading ? null : _submit,
                      icon: _loading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.auto_awesome_rounded, size: 20),
                      label: Text(_loading
                          ? "Creating your account…"
                          : "Create account"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const AuthDivider(label: "ALREADY HAVE AN ACCOUNT?"),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _loading ? null : () => Navigator.pop(context),
                    child: const Text("Return to sign in"),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            "Create once. Keep exploring at your own pace.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }
}
