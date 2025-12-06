import '../entities/score.dart';

abstract class ScoreRepository {
  Future<List<Score>> getScores(String studentId);
}
