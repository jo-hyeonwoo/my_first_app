import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
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
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _locationToTabIndex(state.location),
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
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Scores'),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
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

int _locationToTabIndex(String location) {
  if (location.startsWith('/scores')) return 1;
  if (location.startsWith('/calendar')) return 2;
  if (location.startsWith('/profile')) return 3;
  return 0;
}
