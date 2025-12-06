// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudentPlanImpl _$$StudentPlanImplFromJson(Map<String, dynamic> json) =>
    _$StudentPlanImpl(
      id: json['id'] as String,
      tenantId: json['tenantId'] as String,
      studentId: json['studentId'] as String,
      planGroupId: json['planGroupId'] as String,
      subjectId: json['subjectId'] as String?,
      masterBookId: json['masterBookId'] as String?,
      masterLectureId: json['masterLectureId'] as String?,
      bookId: json['bookId'] as String?,
      lectureId: json['lectureId'] as String?,
      planDate: _dateOnlyFromJson(json['planDate']),
      startAt: _dateTimeFromJson(json['startAt']),
      endAt: _dateTimeFromJson(json['endAt']),
      expectedMinutes: (json['expectedMinutes'] as num?)?.toInt(),
      type:
          $enumDecodeNullable(_$PlanItemTypeEnumMap, json['type']) ??
          PlanItemType.study,
      status:
          $enumDecodeNullable(_$PlanItemStatusEnumMap, json['status']) ??
          PlanItemStatus.pending,
      titleOverride: json['titleOverride'] as String?,
      notes: json['notes'] as String?,
      meta: json['meta'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      createdAt: _dateTimeFromJson(json['createdAt']),
      updatedAt: _dateTimeFromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$StudentPlanImplToJson(_$StudentPlanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenantId': instance.tenantId,
      'studentId': instance.studentId,
      'planGroupId': instance.planGroupId,
      'subjectId': instance.subjectId,
      'masterBookId': instance.masterBookId,
      'masterLectureId': instance.masterLectureId,
      'bookId': instance.bookId,
      'lectureId': instance.lectureId,
      'planDate': _dateOnlyToJson(instance.planDate),
      'startAt': _dateTimeToJson(instance.startAt),
      'endAt': _dateTimeToJson(instance.endAt),
      'expectedMinutes': instance.expectedMinutes,
      'type': _$PlanItemTypeEnumMap[instance.type]!,
      'status': _$PlanItemStatusEnumMap[instance.status]!,
      'titleOverride': instance.titleOverride,
      'notes': instance.notes,
      'meta': instance.meta,
      'createdAt': _dateTimeToJson(instance.createdAt),
      'updatedAt': _dateTimeToJson(instance.updatedAt),
    };

const _$PlanItemTypeEnumMap = {
  PlanItemType.study: 'study',
  PlanItemType.review: 'review',
};

const _$PlanItemStatusEnumMap = {
  PlanItemStatus.pending: 'pending',
  PlanItemStatus.inProgress: 'inProgress',
  PlanItemStatus.completed: 'completed',
  PlanItemStatus.missed: 'missed',
};
