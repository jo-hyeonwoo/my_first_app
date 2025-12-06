// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScoreImpl _$$ScoreImplFromJson(Map<String, dynamic> json) => _$ScoreImpl(
  id: json['id'] as String,
  examName: json['examName'] as String,
  date: _dateOnlyFromJson(json['date'] as Object),
  subject: json['subject'] as String,
  rawScore: (json['rawScore'] as num).toInt(),
  standardScore: (json['standardScore'] as num?)?.toInt(),
  grade: json['grade'] as String?,
);

Map<String, dynamic> _$$ScoreImplToJson(_$ScoreImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'examName': instance.examName,
      'date': _dateOnlyToJson(instance.date),
      'subject': instance.subject,
      'rawScore': instance.rawScore,
      'standardScore': instance.standardScore,
      'grade': instance.grade,
    };
