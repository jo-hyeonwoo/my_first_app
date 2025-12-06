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
  @override
  void initState() {
    super.initState();
    // Listen to auth state changes and navigate when determined
    WidgetsBinding.instance.addPostFrameCallback((_) {
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

      // Check initial state (in case session restore completed before listener was set)
      final currentState = ref.read(authNotifierProvider);
      currentState.when(
        data: (user) {
          if (user != null) {
            if (mounted) {
              context.go('/home');
            }
          } else {
            if (mounted) {
              context.go('/login');
            }
          }
        },
        loading: () {
          // Wait for completion
        },
        error: (error, stack) {
          if (mounted) {
            context.go('/login');
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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

