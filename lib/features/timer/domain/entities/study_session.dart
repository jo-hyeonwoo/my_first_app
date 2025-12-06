import 'package:freezed_annotation/freezed_annotation.dart';

part 'study_session.freezed.dart';
part 'study_session.g.dart';

enum StudySessionStatus { initial, running, paused, completed }

@freezed
class StudySession with _$StudySession {
  const factory StudySession({
    required String id,
    required String planId,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
        required DateTime startTime,
    @JsonKey(fromJson: _nullableDateTimeFromJson, toJson: _dateTimeToJson)
        DateTime? endTime,
    @Default(0) int durationSeconds,
    @Default(StudySessionStatus.initial) StudySessionStatus status,
  }) = _StudySession;

  factory StudySession.fromJson(Map<String, dynamic> json) =>
      _$StudySessionFromJson(json);
}

DateTime _dateTimeFromJson(Object value) => DateTime.parse(value as String);

DateTime? _nullableDateTimeFromJson(Object? value) =>
    value == null ? null : DateTime.parse(value as String);

String? _dateTimeToJson(DateTime? date) => date?.toIso8601String();
