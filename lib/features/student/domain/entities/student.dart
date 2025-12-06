import 'package:freezed_annotation/freezed_annotation.dart';

part 'student.freezed.dart';
part 'student.g.dart';

enum StudentStatus {
  @JsonValue('active')
  active,
  @JsonValue('inactive')
  inactive,
}

@freezed
class Student with _$Student {
  const factory Student({
    required String id,
    required String name,
    required String schoolName,
    required int grade,
    required StudentStatus status,
    required DateTime lastLoginAt,
    required String tenantId,
  }) = _Student;

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
}
