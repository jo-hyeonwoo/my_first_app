import '../entities/student_plan.dart';

abstract class PlanRepository {
  /// Returns the list of plans for [studentId] on the given [date].
  Future<List<StudentPlan>> getTodayPlans(String studentId, DateTime date);
  
  /// Saves a plan to the database.
  Future<void> savePlan(StudentPlan plan);
  
  /// Saves multiple plans to the database in a batch.
  Future<void> savePlans(List<StudentPlan> plans);
}
