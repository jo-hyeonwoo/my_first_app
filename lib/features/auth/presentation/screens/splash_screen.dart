import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/user.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _hasNavigated = false;
  bool _hasCheckedInitialState = false;

  void _navigateBasedOnAuthState(AsyncValue<User?> authState) {
    if (_hasNavigated || !mounted) return;

    authState.when(
      data: (user) {
        if (_hasNavigated || !mounted) return;
        _hasNavigated = true;
        if (user != null) {
          context.go('/home');
        } else {
          context.go('/login');
        }
      },
      loading: () {
        // Still loading, wait for completion
      },
      error: (error, stack) {
        if (_hasNavigated || !mounted) return;
        _hasNavigated = true;
        context.go('/login');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes and navigate when determined
    ref.listen<AsyncValue<User?>>(authNotifierProvider, (previous, next) {
      _navigateBasedOnAuthState(next);
    });

    // Check initial state in case loading already completed before listener was set
    // Only check once to avoid multiple callback registrations
    if (!_hasCheckedInitialState) {
      _hasCheckedInitialState = true;
      final authState = ref.read(authNotifierProvider);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_hasNavigated && mounted) {
          _navigateBasedOnAuthState(authState);
        }
      });
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo (Text)
            Text(
              'TimeLevelUp',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 24),
            // Loading Indicator
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

