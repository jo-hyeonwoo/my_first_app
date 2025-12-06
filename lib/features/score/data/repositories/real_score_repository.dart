import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/score.dart';
import '../../domain/repositories/score_repository.dart';

class RealScoreRepository implements ScoreRepository {
  final _supabase = Supabase.instance.client;

  @override
  Future<List<Score>> getScores(String studentId) async {
    try {
      final scores = await _supabase
          .from('scores')
          .select()
          .eq('student_id', studentId)
          .order('exam_date', ascending: false); // 내림차순 (최신순)

      // Convert JSON to Score entities
      // Map snake_case DB keys to camelCase entity keys
      return (scores as List)
          .map((data) {
            final dbData = data as Map<String, dynamic>;
            final mappedData = _mapDbToEntity(dbData);
            return Score.fromJson(mappedData);
          })
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch scores: $e');
    }
  }

  /// Maps database snake_case fields to entity camelCase fields
  Map<String, dynamic> _mapDbToEntity(Map<String, dynamic> json) {
    // Format exam_date for DateTime parsing (DB returns DATE as string YYYY-MM-DD)
    String examDateStr = json['exam_date'] as String;
    if (!examDateStr.contains('T')) {
      examDateStr = '${examDateStr}T00:00:00.000Z';
    }

    return {
      'id': json['id'] as String,
      'examName': json['exam_name'] as String,
      'date': examDateStr,
      'subject': json['subject'] as String,
      'rawScore': json['raw_score'] as int,
      'standardScore': json['standard_score'] as int?,
      'grade': json['grade'] as String?,
    };
  }
}

