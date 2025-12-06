import '../entities/study_session.dart';

abstract class TimerRepository {
  /// Saves a study session to the database.
  /// [tenantId] and [studentId] are required for multi-tenant support and data isolation.
  Future<void> saveSession(
    StudySession session,
    String tenantId,
    String studentId,
  );
}
