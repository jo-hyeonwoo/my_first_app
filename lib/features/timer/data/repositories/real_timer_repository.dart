import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/study_session.dart';
import '../../domain/repositories/timer_repository.dart';

class RealTimerRepository implements TimerRepository {
  final _supabase = Supabase.instance.client;

  @override
  Future<void> saveSession(
    StudySession session,
    String tenantId,
    String studentId,
  ) async {
    try {
      // Convert StudySession entity to database format (camelCase -> snake_case)
      final dbData = _mapEntityToDb(session, tenantId, studentId);

      await _supabase
          .from('student_study_sessions')
          .insert(dbData);
    } catch (e) {
      throw Exception('Failed to save study session: $e');
    }
  }

  /// Maps entity camelCase fields to database snake_case fields
  Map<String, dynamic> _mapEntityToDb(
    StudySession session,
    String tenantId,
    String studentId,
  ) {
    // Convert status enum to string (matches DB CHECK constraint values)
    String statusValue = session.status.name; // 'initial', 'running', 'paused', 'completed'

    return {
      'id': session.id,
      'tenant_id': tenantId,
      'student_id': studentId,
      'plan_id': session.planId,
      'start_time': session.startTime.toIso8601String(),
      'end_time': session.endTime?.toIso8601String(),
      'duration_seconds': session.durationSeconds,
      'status': statusValue,
    };
  }
}

