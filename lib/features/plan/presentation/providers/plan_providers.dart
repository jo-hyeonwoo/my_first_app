import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/student_plan.dart';
import '../../domain/repositories/plan_repository.dart';
import '../../data/repositories/real_plan_repository.dart';

part 'plan_providers.g.dart';

/// Simple provider for the currently selected student id (mocked).
final currentStudentIdProvider = Provider<String>((ref) => 'student-1');

/// Simple provider for the current date (can be overridden in tests).
final currentDateProvider = Provider<DateTime>((ref) => DateTime.now());

/// Provide PlanRepository implementation (Real Supabase implementation).
final planRepositoryProvider = Provider<PlanRepository>((ref) {
  return RealPlanRepository();
});

@riverpod
Future<List<StudentPlan>> todayPlans(Ref ref, String studentId) async {
  final repo = ref.read(planRepositoryProvider);
  final date = ref.read(currentDateProvider);

  final plans = await repo.getTodayPlans(studentId, date);
  return plans;
}
