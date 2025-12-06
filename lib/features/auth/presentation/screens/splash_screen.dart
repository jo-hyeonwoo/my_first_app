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
  bool _hasCheckedInitialState = false;

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes and navigate when determined
    ref.listen<AsyncValue<User?>>(authNotifierProvider, (previous, next) {
      next.when(
        data: (user) {
          if (user != null) {
            // User is authenticated, navigate to home
            if (mounted) {
              context.go('/home');
            }
          } else {
            // User is not authenticated, navigate to login
            if (mounted) {
              context.go('/login');
            }
          }
        },
        loading: () {
          // Still loading, wait for completion
        },
        error: (error, stack) {
          // Error occurred, navigate to login
          if (mounted) {
            context.go('/login');
          }
        },
      );
    });

    // Check initial state in case loading already completed before listener was set
    // Only check once to avoid multiple navigation attempts
    if (!_hasCheckedInitialState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _hasCheckedInitialState = true;
        final authState = ref.read(authNotifierProvider);
        authState.when(
          data: (user) {
            if (user != null && mounted) {
              context.go('/home');
            } else if (mounted) {
              context.go('/login');
            }
          },
          loading: () {
            // Still loading, wait for ref.listen to handle it
          },
          error: (error, stack) {
            if (mounted) {
              context.go('/login');
            }
          },
        );
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

