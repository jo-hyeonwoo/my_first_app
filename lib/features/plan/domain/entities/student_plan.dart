import 'package:freezed_annotation/freezed_annotation.dart';

part 'student_plan.freezed.dart';
part 'student_plan.g.dart';

enum PlanItemType { study, review }

enum PlanItemStatus { pending, inProgress, completed, missed }

@freezed
class StudentPlan with _$StudentPlan {
  const factory StudentPlan({
    required String id,
    required String tenantId,
    required String studentId,
    required String planGroupId,
    String? subjectId,
    String? masterBookId,
    String? masterLectureId,
    String? bookId,
    String? lectureId,
    @JsonKey(fromJson: _dateOnlyFromJson, toJson: _dateOnlyToJson)
        required DateTime planDate,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
        DateTime? startAt,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
        DateTime? endAt,
    int? expectedMinutes,
    @Default(PlanItemType.study) PlanItemType type,
    @Default(PlanItemStatus.pending) PlanItemStatus status,
    String? titleOverride,
    String? notes,
    @Default(<String, dynamic>{}) Map<String, dynamic> meta,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
        DateTime? createdAt,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
        DateTime? updatedAt,
  }) = _StudentPlan;

  factory StudentPlan.fromJson(Map<String, dynamic> json) =>
      _$StudentPlanFromJson(json);
}

DateTime _dateOnlyFromJson(Object? value) => DateTime.parse(value as String);

String _dateOnlyToJson(DateTime date) => date.toIso8601String().split('T').first;

DateTime? _dateTimeFromJson(Object? value) =>
    value == null ? null : DateTime.parse(value as String);

String? _dateTimeToJson(DateTime? date) => date?.toIso8601String();
