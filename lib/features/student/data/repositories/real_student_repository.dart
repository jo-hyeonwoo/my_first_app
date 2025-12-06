import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/student.dart';
import '../../domain/repositories/student_repository.dart';

class RealStudentRepository implements StudentRepository {
  final _supabase = Supabase.instance.client;

  @override
  Future<List<Student>> getManagedStudents(String consultantId) async {
    try {
      final students = await _supabase
          .from('students')
          .select()
          .eq('primary_consultant_id', consultantId)
          .order('status', ascending: true) // active first
          .order('last_login_at', ascending: false); // most recent login first

      // Convert JSON to Student entities
      // Map snake_case DB keys to camelCase entity keys
      return (students as List)
          .map((data) {
            final dbData = data as Map<String, dynamic>;
            final mappedData = _mapSnakeToCamel(dbData);
            return Student.fromJson(mappedData);
          })
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch managed students: $e');
    }
  }

  /// Maps snake_case database fields to camelCase entity fields
  Map<String, dynamic> _mapSnakeToCamel(Map<String, dynamic> json) {
    return {
      'id': json['id'] as String,
      'name': json['name'] as String,
      'schoolName': json['school_name'] as String? ?? '',
      'grade': (json['grade'] as num?)?.toInt() ?? 0,
      'status': json['status'] as String,
      'lastLoginAt': json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'] as String)
          : DateTime.now(),
      'tenantId': json['tenant_id'] as String,
    };
  }
}
