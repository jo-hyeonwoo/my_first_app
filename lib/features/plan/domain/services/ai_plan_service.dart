import '../entities/student_plan.dart';

/// Service interface for AI-powered plan generation
abstract class AiPlanService {
  /// Generates a list of study plans using AI based on student requirements
  /// 
  /// [studentId] - The ID of the student for whom plans are being generated
  /// [focusSubjects] - List of subjects to focus on (e.g., ['수학', '영어'])
  /// [availableMinutes] - Total available study time in minutes
  /// [tenantId] - Tenant ID for multi-tenant support
  /// [planDate] - Date for which plans are being generated
  /// 
  /// Returns a list of generated [StudentPlan] entities
  Future<List<StudentPlan>> generatePlan({
    required String studentId,
    required List<String> focusSubjects,
    required int availableMinutes,
    required String tenantId,
    required DateTime planDate,
  });
}

