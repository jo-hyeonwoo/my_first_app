import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/study_session.dart';
import '../../domain/repositories/timer_repository.dart';
import '../../data/repositories/real_timer_repository.dart';

part 'timer_provider.g.dart';

/// Provider for TimerRepository (Real Supabase implementation)
final timerRepositoryProvider = Provider<TimerRepository>((ref) {
  return RealTimerRepository();
});

@riverpod
class TimerNotifier extends _$TimerNotifier {
  Timer? _ticker;

  @override
  StudySession build() {
    // initial empty session state
    final initial = StudySession(
      id: const Uuid().v4(),
      planId: '',
      startTime: DateTime.now(),
      durationSeconds: 0,
      status: StudySessionStatus.initial,
    );

    // ensure ticker is canceled when provider is disposed
    ref.onDispose(() {
      _stopTicker();
    });

    return initial;
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(durationSeconds: state.durationSeconds + 1);
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  Future<void> start(String planId) async {
    final now = DateTime.now();
    state = StudySession(
      id: const Uuid().v4(),
      planId: planId,
      startTime: now,
      durationSeconds: 0,
      status: StudySessionStatus.running,
    );
    _startTicker();
  }

  Future<void> pause() async {
    if (state.status != StudySessionStatus.running) return;
    _stopTicker();
    state = state.copyWith(status: StudySessionStatus.paused);
  }

  Future<void> resume() async {
    if (state.status != StudySessionStatus.paused) return;
    state = state.copyWith(status: StudySessionStatus.running);
    _startTicker();
  }

  Future<void> stop() async {
    if (state.status == StudySessionStatus.completed) return;
    _stopTicker();
    final finished = state.copyWith(
      endTime: DateTime.now(),
      status: StudySessionStatus.completed,
    );
    state = finished;

    // Get plan details to retrieve studentId and tenantId
    try {
      final supabase = Supabase.instance.client;
      final planData = await supabase
          .from('student_plans')
          .select('student_id, tenant_id')
          .eq('id', finished.planId)
          .single();

      final studentId = planData['student_id'] as String;
      final tenantId = planData['tenant_id'] as String;

      // persist via repository
      final repo = ref.read(timerRepositoryProvider);
      await repo.saveSession(finished, tenantId, studentId);
    } catch (e) {
      throw Exception('Failed to save study session: $e');
    }
  }

  // cleanup is handled via ref.onDispose in build()
}
