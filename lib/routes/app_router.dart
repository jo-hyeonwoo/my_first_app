import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/logout_screen.dart';
import '../features/home/presentation/home_screen_wrapper.dart';
import '../features/timer/presentation/timer_screen.dart';
import '../features/score/presentation/score_screen.dart';
import '../features/student/presentation/screens/student_detail_screen.dart';
import '../features/plan/domain/entities/student_plan.dart';
import '../features/plan/presentation/screens/plan_generation_screen.dart';
import '../src/presentation/screens/calendar_screen.dart';
import '../src/presentation/screens/profile_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/timer',
      name: 'timer',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is StudentPlan) {
          return TimerScreen(plan: extra);
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Timer')),
          body: const Center(child: Text('No plan provided')),
        );
      },
    ),
    GoRoute(
      path: '/student-detail/:id',
      name: 'student-detail',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        final studentName = state.queryParameters['name'] ?? 'Student';
        return StudentDetailScreen(
          studentId: id,
          studentName: studentName,
        );
      },
    ),
    GoRoute(
      path: '/plan-generation/:studentId',
      name: 'plan-generation',
      builder: (context, state) {
        final studentId = state.pathParameters['studentId'] ?? '';
        final dateParam = state.queryParameters['date'];
        DateTime? planDate;
        if (dateParam != null) {
          planDate = DateTime.tryParse(dateParam);
        }
        return PlanGenerationScreen(
          studentId: studentId,
          planDate: planDate,
        );
      },
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/logout',
      name: 'logout',
      builder: (context, state) => const LogoutScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        final currentIndex = _locationToTabIndex(state.location);
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            elevation: 8,
            backgroundColor: Theme.of(context).colorScheme.surface,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            iconSize: 24,
            onTap: (i) {
              switch (i) {
                case 0:
                  context.go('/home');
                  break;
                case 1:
                  context.go('/scores');
                  break;
                case 2:
                  context.go('/calendar');
                  break;
                case 3:
                  context.go('/profile');
                  break;
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: '홈',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_outlined),
                activeIcon: Icon(Icons.bar_chart),
                label: '성적',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_outlined),
                activeIcon: Icon(Icons.calendar_today),
                label: '캘린더',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: '프로필',
              ),
            ],
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreenWrapper(),
        ),
        GoRoute(
          path: '/scores',
          name: 'scores',
          builder: (context, state) => const ScoreScreen(),
        ),
        GoRoute(
          path: '/calendar',
          name: 'calendar',
          builder: (context, state) => const CalendarScreen(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);

/// Maps the current route location to the corresponding bottom navigation bar index
/// 
/// Returns:
/// - 0 for /home and related routes
/// - 1 for /scores and related routes
/// - 2 for /calendar and related routes
/// - 3 for /profile and related routes
/// - 0 as default (home)
int _locationToTabIndex(String location) {
  // Handle exact matches first
  if (location == '/home') return 0;
  if (location == '/scores') return 1;
  if (location == '/calendar') return 2;
  if (location == '/profile') return 3;
  
  // Handle paths that start with these routes
  if (location.startsWith('/scores')) return 1;
  if (location.startsWith('/calendar')) return 2;
  if (location.startsWith('/profile')) return 3;
  
  // Default to home (index 0)
  // This includes /home and any other routes that should show home tab as active
  return 0;
}
