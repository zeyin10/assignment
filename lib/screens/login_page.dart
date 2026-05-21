import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../animations/animations.dart';

class Credentials {
  Credentials(this.username, this.password);
  final String username;
  final String password;
}

class LoginPage extends StatelessWidget {
  const LoginPage({required this.onLogIn, super.key});
  final Future<void> Function(Credentials) onLogIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 700) {
            return Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.asset(
                      'assets/login_background.webp',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: FractionallySizedBox(
                    widthFactor: 0.70,
                    child: LoginForm(onLogIn: onLogIn),
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Expanded(child: LoginForm(onLogIn: onLogIn)),
              ],
            );
          }
        },
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({required this.onLogIn, super.key});
  final Future<void> Function(Credentials) onLogIn;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email    = _usernameController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Please enter your email and password.');
      return;
    }

    setState(() { _loading = true; _error = null; });

    try {
      await widget.onLogIn(Credentials(email, password));
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SlideFadeIn(
                index: 0,
                child: Icon(Icons.movie_filter_rounded,
                    size: 72, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 16),
              SlideFadeIn(
                index: 1,
                child: Text('CinemaScope',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              SlideFadeIn(
                index: 2,
                child: Text('Your world of movies',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium),
              ),
              const SizedBox(height: 40),

              SlideFadeIn(
                index: 3,
                child: TextField(
                controller: _usernameController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              ),
              const SizedBox(height: 16),

              SlideFadeIn(
                index: 4,
                child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _submit(),
              ),
              ),
              const SizedBox(height: 12),

              if (_error != null)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _error!,
                    style: TextStyle(color: theme.colorScheme.onErrorContainer),
                  ),
                ),

              const SizedBox(height: 16),

              SlideFadeIn(
                index: 5,
                child: AnimatedScaleButton(
                  enabled: !_loading,
                  onPressed: _loading ? null : _submit,
                  child: FilledButton.icon(
                    onPressed: _loading ? null : _submit,
                    icon: _loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.login),
                    label: Text(_loading ? 'Signing in…' : 'Sign In'),
                  ),
                ),
              ),

              if (_loading) ...[
                const SizedBox(height: 24),
                const LottieLoadingIndicator(size: 80),
              ],

              const SizedBox(height: 12),

              SlideFadeIn(
                index: 6,
                child: AnimatedScaleButton(
                  onPressed: () => context.go('/register'),
                  child: OutlinedButton.icon(
                    onPressed: () => context.go('/register'),
                    icon: const Icon(Icons.person_add_outlined),
                    label: const Text('Create Account'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}