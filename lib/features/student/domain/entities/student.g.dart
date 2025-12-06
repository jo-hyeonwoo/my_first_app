// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudentImpl _$$StudentImplFromJson(Map<String, dynamic> json) =>
    _$StudentImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      schoolName: json['schoolName'] as String,
      grade: (json['grade'] as num).toInt(),
      status: $enumDecode(_$StudentStatusEnumMap, json['status']),
      lastLoginAt: DateTime.parse(json['lastLoginAt'] as String),
      tenantId: json['tenantId'] as String,
    );

Map<String, dynamic> _$$StudentImplToJson(_$StudentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'schoolName': instance.schoolName,
      'grade': instance.grade,
      'status': _$StudentStatusEnumMap[instance.status]!,
      'lastLoginAt': instance.lastLoginAt.toIso8601String(),
      'tenantId': instance.tenantId,
    };

const _$StudentStatusEnumMap = {
  StudentStatus.active: 'active',
  StudentStatus.inactive: 'inactive',
};
