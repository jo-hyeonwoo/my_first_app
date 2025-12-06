import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../domain/entities/student_plan.dart';
import '../../domain/repositories/plan_repository.dart';

class RealPlanRepository implements PlanRepository {
  final _supabase = Supabase.instance.client;

  @override
  Future<List<StudentPlan>> getTodayPlans(String studentId, DateTime date) async {
    try {
      // Format date as YYYY-MM-DD for database query
      final formattedDate = '${date.year.toString().padLeft(4, '0')}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')}';

      final plans = await _supabase
          .from('student_plans')
          .select()
          .eq('student_id', studentId)
          .eq('plan_date', formattedDate)
          .order('created_at', ascending: true);

      // Convert JSON to StudentPlan entities
      // Map snake_case DB fields to camelCase entity fields
      return (plans as List)
          .map((data) {
            final mapped = _mapDbToEntity(data as Map<String, dynamic>);
            return StudentPlan.fromJson(mapped);
          })
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch today plans: $e');
    }
  }

  /// Maps database snake_case fields to entity camelCase fields
  /// DB schema: id, tenant_id, student_id, plan_date, title, type, expected_minutes, status, created_at, updated_at
  Map<String, dynamic> _mapDbToEntity(Map<String, dynamic> json) {
    // Convert status from DB format (in_progress) to enum format (inProgress)
    String? statusValue = json['status'] as String?;
    if (statusValue == 'in_progress') {
      statusValue = 'inProgress';
    }

    // Format plan_date for DateTime parsing (DB returns DATE as string YYYY-MM-DD)
    String planDateStr = json['plan_date'] as String;
    if (!planDateStr.contains('T')) {
      planDateStr = '${planDateStr}T00:00:00.000Z';
    }

    return {
      'id': json['id'] as String,
      'tenantId': json['tenant_id'] as String,
      'studentId': json['student_id'] as String,
      // planGroupId is required but not in DB schema, use plan ID as group ID
      'planGroupId': json['id'] as String,
      // Optional fields not in DB schema
      'subjectId': null,
      'masterBookId': null,
      'masterLectureId': null,
      'bookId': null,
      'lectureId': null,
      'planDate': planDateStr,
      'startAt': null,
      'endAt': null,
      'expectedMinutes': json['expected_minutes'] as int?,
      'type': json['type'] as String? ?? 'study',
      'status': statusValue ?? 'pending',
      'titleOverride': json['title'] as String?,
      'notes': null,
      'meta': <String, dynamic>{},
      'createdAt': json['created_at'] != null
          ? (json['created_at'] as String)
          : null,
      'updatedAt': json['updated_at'] != null
          ? (json['updated_at'] as String)
          : null,
    };
  }

  @override
  Future<void> savePlan(StudentPlan plan) async {
    await savePlans([plan]);
  }

  @override
  Future<void> savePlans(List<StudentPlan> plans) async {
    try {
      if (plans.isEmpty) return;

      final dbDataList = plans.map((plan) => _mapEntityToDb(plan)).toList();

      await _supabase
          .from('student_plans')
          .insert(dbDataList);
    } catch (e, stackTrace) {
      // Send database save errors to Sentry
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
        hint: Hint.withMap({
          'context': 'Save Plans to Database',
          'planCount': plans.length.toString(),
          'studentId': plans.isNotEmpty ? plans.first.studentId : 'unknown',
        }),
      );
      throw Exception('Failed to save plans: $e');
    }
  }

  /// Maps entity camelCase fields to database snake_case fields
  Map<String, dynamic> _mapEntityToDb(StudentPlan plan) {
    // Format plan_date as YYYY-MM-DD
    final formattedDate = '${plan.planDate.year.toString().padLeft(4, '0')}-'
        '${plan.planDate.month.toString().padLeft(2, '0')}-'
        '${plan.planDate.day.toString().padLeft(2, '0')}';

    // Convert status enum to DB format
    String statusValue = plan.status.name;
    if (statusValue == 'inProgress') {
      statusValue = 'in_progress';
    }

    // Convert type enum to DB format
    String typeValue = plan.type.name;

    return {
      'id': plan.id,
      'tenant_id': plan.tenantId,
      'student_id': plan.studentId,
      'plan_date': formattedDate,
      'title': plan.titleOverride,
      'type': typeValue,
      'expected_minutes': plan.expectedMinutes,
      'status': statusValue,
      'created_at': plan.createdAt?.toIso8601String(),
      'updated_at': plan.updatedAt?.toIso8601String(),
    };
  }
}
