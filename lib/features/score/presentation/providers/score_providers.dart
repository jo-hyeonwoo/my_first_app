import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/score.dart';
import '../../domain/repositories/score_repository.dart';
import '../../data/repositories/real_score_repository.dart';

part 'score_providers.g.dart';

/// Provide ScoreRepository implementation (Real Supabase implementation)
final scoreRepositoryProvider = Provider<ScoreRepository>((ref) {
  return RealScoreRepository();
});

@riverpod
Future<List<Score>> scoreList(ScoreListRef ref, String studentId) async {
  final repo = ref.read(scoreRepositoryProvider);
  return await repo.getScores(studentId);
}
