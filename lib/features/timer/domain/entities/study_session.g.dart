// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudySessionImpl _$$StudySessionImplFromJson(Map<String, dynamic> json) =>
    _$StudySessionImpl(
      id: json['id'] as String,
      planId: json['planId'] as String,
      startTime: _dateTimeFromJson(json['startTime'] as Object),
      endTime: _nullableDateTimeFromJson(json['endTime']),
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      status:
          $enumDecodeNullable(_$StudySessionStatusEnumMap, json['status']) ??
          StudySessionStatus.initial,
    );

Map<String, dynamic> _$$StudySessionImplToJson(_$StudySessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'planId': instance.planId,
      'startTime': _dateTimeToJson(instance.startTime),
      'endTime': _dateTimeToJson(instance.endTime),
      'durationSeconds': instance.durationSeconds,
      'status': _$StudySessionStatusEnumMap[instance.status]!,
    };

const _$StudySessionStatusEnumMap = {
  StudySessionStatus.initial: 'initial',
  StudySessionStatus.running: 'running',
  StudySessionStatus.paused: 'paused',
  StudySessionStatus.completed: 'completed',
};
