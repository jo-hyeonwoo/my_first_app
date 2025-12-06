import 'dart:async';

import '../../domain/entities/study_session.dart';
import '../../domain/repositories/timer_repository.dart';

class MockTimerRepository implements TimerRepository {

  @override
  Future<void> saveSession(
    StudySession session,
    String tenantId,
    String studentId,
  ) async {
    // simulate saving with a delay
    await Future.delayed(const Duration(seconds: 1));
    // print to console to simulate persistence
    // ignore: avoid_print
    print('MockTimerRepository: saved session ${session.id} for plan ${session.planId} duration ${session.durationSeconds}s status=${session.status} tenant=$tenantId student=$studentId');
  }
}
