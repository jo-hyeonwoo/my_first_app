import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../domain/entities/student_plan.dart';
import '../../domain/repositories/plan_repository.dart';

class MockPlanRepository implements PlanRepository {
  final _uuid = const Uuid();

  @override
  Future<List<StudentPlan>> getTodayPlans(String studentId, DateTime date) async {
    // simulate network / disk delay
    await Future.delayed(const Duration(seconds: 1));

    final planDate = DateTime(date.year, date.month, date.day);

    return [
      StudentPlan(
        id: _uuid.v4(),
        tenantId: 'tenant-1',
        studentId: studentId,
        planGroupId: 'group-1',
        subjectId: 'math',
        planDate: planDate,
        expectedMinutes: 60,
        titleOverride: '수학의 정석 - 집합 문제 풀기',
        notes: '챕터 3, 문제 1~20',
        status: PlanItemStatus.inProgress,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      StudentPlan(
        id: _uuid.v4(),
        tenantId: 'tenant-1',
        studentId: studentId,
        planGroupId: 'group-1',
        subjectId: 'english',
        planDate: planDate,
        expectedMinutes: 30,
        titleOverride: '영단어 50개 암기',
        notes: '뜻+예문 암기',
        status: PlanItemStatus.pending,
      ),
      StudentPlan(
        id: _uuid.v4(),
        tenantId: 'tenant-1',
        studentId: studentId,
        planGroupId: 'group-1',
        subjectId: 'korean',
        planDate: planDate,
        expectedMinutes: 45,
        titleOverride: '국어 비문학 지문 분석',
        notes: '지문 2개 분석, 요약 작성',
        status: PlanItemStatus.pending,
      ),
      StudentPlan(
        id: _uuid.v4(),
        tenantId: 'tenant-1',
        studentId: studentId,
        planGroupId: 'group-1',
        subjectId: 'history',
        planDate: planDate,
        expectedMinutes: 40,
        titleOverride: '한국사 암기(근대사)',
        notes: '중요 사건 위주',
        status: PlanItemStatus.completed,
      ),
      StudentPlan(
        id: _uuid.v4(),
        tenantId: 'tenant-1',
        studentId: studentId,
        planGroupId: 'group-1',
        subjectId: 'science',
        planDate: planDate,
        expectedMinutes: 25,
        titleOverride: '물리 개념 노트 정리',
        notes: '공식 정리',
        status: PlanItemStatus.missed,
      ),
    ];
  }

  @override
  Future<void> savePlan(StudentPlan plan) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock implementation: no-op
  }

  @override
  Future<void> savePlans(List<StudentPlan> plans) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock implementation: no-op
  }
}
