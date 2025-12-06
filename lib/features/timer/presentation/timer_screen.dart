import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../plan/domain/entities/student_plan.dart';
import 'providers/timer_provider.dart';
import '../domain/entities/study_session.dart';

String _formatDuration(int seconds) {
  final h = (seconds ~/ 3600).toString().padLeft(2, '0');
  final m = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
  final s = (seconds % 60).toString().padLeft(2, '0');
  return '$h:$m:$s';
}

class TimerScreen extends ConsumerWidget {
  final StudentPlan plan;

  const TimerScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(timerNotifierProvider);
    final notifier = ref.read(timerNotifierProvider.notifier);

    // Auto-start when navigated with a plan and no active session for that plan
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if ((session.status == StudySessionStatus.initial || session.planId != plan.id)) {
        // start a new session for this plan
        notifier.start(plan.id);
      }
    });

    final isRunning = session.status == StudySessionStatus.running;
    final isPaused = session.status == StudySessionStatus.paused;

    return Scaffold(
      appBar: AppBar(title: Text(plan.titleOverride ?? '타이머')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              plan.titleOverride ?? '학습',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            Text(
              _formatDuration(session.durationSeconds),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isRunning)
                  ElevatedButton.icon(
                    onPressed: () => notifier.start(plan.id),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start'),
                  ),
                if (isRunning)
                  ElevatedButton.icon(
                    onPressed: () => notifier.pause(),
                    icon: const Icon(Icons.pause),
                    label: const Text('Pause'),
                  ),
                const SizedBox(width: 12),
                if (isPaused)
                  ElevatedButton.icon(
                    onPressed: () => notifier.resume(),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Resume'),
                  ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    await notifier.stop();
                    // go back after stopping
                    if (context.mounted) {
                      context.pop();
                    }
                  },
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
