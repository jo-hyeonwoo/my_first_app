import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../domain/entities/student_plan.dart';
import '../../domain/services/ai_plan_service.dart';
import '../../data/services/ai_service_factory.dart';

part 'ai_plan_provider.g.dart';

/// Provider for AI Plan Service
/// Uses AiServiceFactory to create the appropriate service based on AI_PROVIDER env var
@riverpod
AiPlanService aiPlanService(Ref ref) {
  return AiServiceFactory.create();
}

/// Notifier for AI plan generation
@riverpod
class AiPlanNotifier extends _$AiPlanNotifier {
  @override
  Future<List<StudentPlan>?> build() async {
    return null; // Initially no generated plans
  }

  /// Generates plans using AI
  Future<void> generatePlans({
    required String studentId,
    required List<String> focusSubjects,
    required int availableMinutes,
    required String tenantId,
    required DateTime planDate,
  }) async {
    state = const AsyncValue.loading();

    try {
      final aiService = ref.read(aiPlanServiceProvider);
      final plans = await aiService.generatePlan(
        studentId: studentId,
        focusSubjects: focusSubjects,
        availableMinutes: availableMinutes,
        tenantId: tenantId,
        planDate: planDate,
      );

      state = AsyncValue.data(plans);
    } catch (e, stackTrace) {
      // Send error to Sentry for monitoring
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
        hint: Hint.withMap({
          'context': 'AI Plan Generation',
          'studentId': studentId,
          'focusSubjects': focusSubjects.join(', '),
          'availableMinutes': availableMinutes.toString(),
        }),
      );
      
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Clears generated plans
  void clear() {
    state = const AsyncValue.data(null);
  }
}

