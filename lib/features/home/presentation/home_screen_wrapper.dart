import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/domain/entities/user.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../student/presentation/screens/consultant_dashboard_screen.dart';
import './student_home_screen.dart';

/// Wrapper widget that renders different home screens based on user role
class HomeScreenWrapper extends ConsumerWidget {
  const HomeScreenWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          // Should not reach here due to router redirect, but handle gracefully
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Not authenticated')),
          );
        }

        // Route based on user role
        switch (user.role) {
          case UserRole.student:
            return const StudentHomeScreen();
          case UserRole.consultant:
            return const ConsultantDashboardScreen();
          case UserRole.admin:
            // TODO: Implement admin dashboard in future
            return Scaffold(
              appBar: AppBar(title: const Text('Admin Dashboard')),
              body: const Center(child: Text('Admin dashboard coming soon')),
            );
        }
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Loading')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error: $err')),
      ),
    );
  }
}
