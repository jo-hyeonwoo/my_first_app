import 'dart:async';
import 'package:uuid/uuid.dart';

import '../../domain/entities/score.dart';
import '../../domain/repositories/score_repository.dart';

class MockScoreRepository implements ScoreRepository {
  final _uuid = const Uuid();

  @override
  Future<List<Score>> getScores(String studentId) async {
    // simulate fetching with delay
    await Future.delayed(const Duration(milliseconds: 800));

    // realistic score data across 3 exams + 3 subjects
    final scores = [
      // March Mock Exam
      Score(
        id: _uuid.v4(),
        examName: '3월 모의고사',
        date: DateTime(2025, 3, 20),
        subject: '국어',
        rawScore: 85,
        standardScore: 112,
        grade: '3',
      ),
      Score(
        id: _uuid.v4(),
        examName: '3월 모의고사',
        date: DateTime(2025, 3, 20),
        subject: '영어',
        rawScore: 78,
        standardScore: 105,
        grade: '4',
      ),
      Score(
        id: _uuid.v4(),
        examName: '3월 모의고사',
        date: DateTime(2025, 3, 20),
        subject: '수학',
        rawScore: 92,
        standardScore: 118,
        grade: '2',
      ),
      // June Mock Exam
      Score(
        id: _uuid.v4(),
        examName: '6월 모의고사',
        date: DateTime(2025, 6, 18),
        subject: '국어',
        rawScore: 88,
        standardScore: 115,
        grade: '2',
      ),
      Score(
        id: _uuid.v4(),
        examName: '6월 모의고사',
        date: DateTime(2025, 6, 18),
        subject: '영어',
        rawScore: 82,
        standardScore: 110,
        grade: '3',
      ),
      Score(
        id: _uuid.v4(),
        examName: '6월 모의고사',
        date: DateTime(2025, 6, 18),
        subject: '수학',
        rawScore: 95,
        standardScore: 122,
        grade: '1',
      ),
      // September Mock Exam
      Score(
        id: _uuid.v4(),
        examName: '9월 모의고사',
        date: DateTime(2025, 9, 17),
        subject: '국어',
        rawScore: 90,
        standardScore: 118,
        grade: '2',
      ),
      Score(
        id: _uuid.v4(),
        examName: '9월 모의고사',
        date: DateTime(2025, 9, 17),
        subject: '영어',
        rawScore: 86,
        standardScore: 114,
        grade: '2',
      ),
      Score(
        id: _uuid.v4(),
        examName: '9월 모의고사',
        date: DateTime(2025, 9, 17),
        subject: '수학',
        rawScore: 98,
        standardScore: 125,
        grade: '1',
      ),
      // November Practice Test
      Score(
        id: _uuid.v4(),
        examName: '11월 모의고사',
        date: DateTime(2025, 11, 19),
        subject: '국어',
        rawScore: 91,
        standardScore: 119,
        grade: '2',
      ),
    ];

    // sort by date
    scores.sort((a, b) => a.date.compareTo(b.date));
    return scores;
  }
}
