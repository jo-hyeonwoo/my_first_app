// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StudentPlan _$StudentPlanFromJson(Map<String, dynamic> json) {
  return _StudentPlan.fromJson(json);
}

/// @nodoc
mixin _$StudentPlan {
  String get id => throw _privateConstructorUsedError;
  String get tenantId => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  String get planGroupId => throw _privateConstructorUsedError;
  String? get subjectId => throw _privateConstructorUsedError;
  String? get masterBookId => throw _privateConstructorUsedError;
  String? get masterLectureId => throw _privateConstructorUsedError;
  String? get bookId => throw _privateConstructorUsedError;
  String? get lectureId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateOnlyFromJson, toJson: _dateOnlyToJson)
  DateTime get planDate => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? get startAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? get endAt => throw _privateConstructorUsedError;
  int? get expectedMinutes => throw _privateConstructorUsedError;
  PlanItemType get type => throw _privateConstructorUsedError;
  PlanItemStatus get status => throw _privateConstructorUsedError;
  String? get titleOverride => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  Map<String, dynamic> get meta => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this StudentPlan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudentPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentPlanCopyWith<StudentPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentPlanCopyWith<$Res> {
  factory $StudentPlanCopyWith(
    StudentPlan value,
    $Res Function(StudentPlan) then,
  ) = _$StudentPlanCopyWithImpl<$Res, StudentPlan>;
  @useResult
  $Res call({
    String id,
    String tenantId,
    String studentId,
    String planGroupId,
    String? subjectId,
    String? masterBookId,
    String? masterLectureId,
    String? bookId,
    String? lectureId,
    @JsonKey(fromJson: _dateOnlyFromJson, toJson: _dateOnlyToJson)
    DateTime planDate,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? startAt,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? endAt,
    int? expectedMinutes,
    PlanItemType type,
    PlanItemStatus status,
    String? titleOverride,
    String? notes,
    Map<String, dynamic> meta,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$StudentPlanCopyWithImpl<$Res, $Val extends StudentPlan>
    implements $StudentPlanCopyWith<$Res> {
  _$StudentPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudentPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? studentId = null,
    Object? planGroupId = null,
    Object? subjectId = freezed,
    Object? masterBookId = freezed,
    Object? masterLectureId = freezed,
    Object? bookId = freezed,
    Object? lectureId = freezed,
    Object? planDate = null,
    Object? startAt = freezed,
    Object? endAt = freezed,
    Object? expectedMinutes = freezed,
    Object? type = null,
    Object? status = null,
    Object? titleOverride = freezed,
    Object? notes = freezed,
    Object? meta = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            tenantId: null == tenantId
                ? _value.tenantId
                : tenantId // ignore: cast_nullable_to_non_nullable
                      as String,
            studentId: null == studentId
                ? _value.studentId
                : studentId // ignore: cast_nullable_to_non_nullable
                      as String,
            planGroupId: null == planGroupId
                ? _value.planGroupId
                : planGroupId // ignore: cast_nullable_to_non_nullable
                      as String,
            subjectId: freezed == subjectId
                ? _value.subjectId
                : subjectId // ignore: cast_nullable_to_non_nullable
                      as String?,
            masterBookId: freezed == masterBookId
                ? _value.masterBookId
                : masterBookId // ignore: cast_nullable_to_non_nullable
                      as String?,
            masterLectureId: freezed == masterLectureId
                ? _value.masterLectureId
                : masterLectureId // ignore: cast_nullable_to_non_nullable
                      as String?,
            bookId: freezed == bookId
                ? _value.bookId
                : bookId // ignore: cast_nullable_to_non_nullable
                      as String?,
            lectureId: freezed == lectureId
                ? _value.lectureId
                : lectureId // ignore: cast_nullable_to_non_nullable
                      as String?,
            planDate: null == planDate
                ? _value.planDate
                : planDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            startAt: freezed == startAt
                ? _value.startAt
                : startAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            endAt: freezed == endAt
                ? _value.endAt
                : endAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            expectedMinutes: freezed == expectedMinutes
                ? _value.expectedMinutes
                : expectedMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as PlanItemType,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as PlanItemStatus,
            titleOverride: freezed == titleOverride
                ? _value.titleOverride
                : titleOverride // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            meta: null == meta
                ? _value.meta
                : meta // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StudentPlanImplCopyWith<$Res>
    implements $StudentPlanCopyWith<$Res> {
  factory _$$StudentPlanImplCopyWith(
    _$StudentPlanImpl value,
    $Res Function(_$StudentPlanImpl) then,
  ) = __$$StudentPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String tenantId,
    String studentId,
    String planGroupId,
    String? subjectId,
    String? masterBookId,
    String? masterLectureId,
    String? bookId,
    String? lectureId,
    @JsonKey(fromJson: _dateOnlyFromJson, toJson: _dateOnlyToJson)
    DateTime planDate,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? startAt,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? endAt,
    int? expectedMinutes,
    PlanItemType type,
    PlanItemStatus status,
    String? titleOverride,
    String? notes,
    Map<String, dynamic> meta,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$StudentPlanImplCopyWithImpl<$Res>
    extends _$StudentPlanCopyWithImpl<$Res, _$StudentPlanImpl>
    implements _$$StudentPlanImplCopyWith<$Res> {
  __$$StudentPlanImplCopyWithImpl(
    _$StudentPlanImpl _value,
    $Res Function(_$StudentPlanImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudentPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? studentId = null,
    Object? planGroupId = null,
    Object? subjectId = freezed,
    Object? masterBookId = freezed,
    Object? masterLectureId = freezed,
    Object? bookId = freezed,
    Object? lectureId = freezed,
    Object? planDate = null,
    Object? startAt = freezed,
    Object? endAt = freezed,
    Object? expectedMinutes = freezed,
    Object? type = null,
    Object? status = null,
    Object? titleOverride = freezed,
    Object? notes = freezed,
    Object? meta = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$StudentPlanImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        tenantId: null == tenantId
            ? _value.tenantId
            : tenantId // ignore: cast_nullable_to_non_nullable
                  as String,
        studentId: null == studentId
            ? _value.studentId
            : studentId // ignore: cast_nullable_to_non_nullable
                  as String,
        planGroupId: null == planGroupId
            ? _value.planGroupId
            : planGroupId // ignore: cast_nullable_to_non_nullable
                  as String,
        subjectId: freezed == subjectId
            ? _value.subjectId
            : subjectId // ignore: cast_nullable_to_non_nullable
                  as String?,
        masterBookId: freezed == masterBookId
            ? _value.masterBookId
            : masterBookId // ignore: cast_nullable_to_non_nullable
                  as String?,
        masterLectureId: freezed == masterLectureId
            ? _value.masterLectureId
            : masterLectureId // ignore: cast_nullable_to_non_nullable
                  as String?,
        bookId: freezed == bookId
            ? _value.bookId
            : bookId // ignore: cast_nullable_to_non_nullable
                  as String?,
        lectureId: freezed == lectureId
            ? _value.lectureId
            : lectureId // ignore: cast_nullable_to_non_nullable
                  as String?,
        planDate: null == planDate
            ? _value.planDate
            : planDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        startAt: freezed == startAt
            ? _value.startAt
            : startAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        endAt: freezed == endAt
            ? _value.endAt
            : endAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        expectedMinutes: freezed == expectedMinutes
            ? _value.expectedMinutes
            : expectedMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as PlanItemType,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as PlanItemStatus,
        titleOverride: freezed == titleOverride
            ? _value.titleOverride
            : titleOverride // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        meta: null == meta
            ? _value._meta
            : meta // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentPlanImpl implements _StudentPlan {
  const _$StudentPlanImpl({
    required this.id,
    required this.tenantId,
    required this.studentId,
    required this.planGroupId,
    this.subjectId,
    this.masterBookId,
    this.masterLectureId,
    this.bookId,
    this.lectureId,
    @JsonKey(fromJson: _dateOnlyFromJson, toJson: _dateOnlyToJson)
    required this.planDate,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) this.startAt,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) this.endAt,
    this.expectedMinutes,
    this.type = PlanItemType.study,
    this.status = PlanItemStatus.pending,
    this.titleOverride,
    this.notes,
    final Map<String, dynamic> meta = const <String, dynamic>{},
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    this.createdAt,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    this.updatedAt,
  }) : _meta = meta;

  factory _$StudentPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentPlanImplFromJson(json);

  @override
  final String id;
  @override
  final String tenantId;
  @override
  final String studentId;
  @override
  final String planGroupId;
  @override
  final String? subjectId;
  @override
  final String? masterBookId;
  @override
  final String? masterLectureId;
  @override
  final String? bookId;
  @override
  final String? lectureId;
  @override
  @JsonKey(fromJson: _dateOnlyFromJson, toJson: _dateOnlyToJson)
  final DateTime planDate;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? startAt;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? endAt;
  @override
  final int? expectedMinutes;
  @override
  @JsonKey()
  final PlanItemType type;
  @override
  @JsonKey()
  final PlanItemStatus status;
  @override
  final String? titleOverride;
  @override
  final String? notes;
  final Map<String, dynamic> _meta;
  @override
  @JsonKey()
  Map<String, dynamic> get meta {
    if (_meta is EqualUnmodifiableMapView) return _meta;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_meta);
  }

  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? createdAt;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'StudentPlan(id: $id, tenantId: $tenantId, studentId: $studentId, planGroupId: $planGroupId, subjectId: $subjectId, masterBookId: $masterBookId, masterLectureId: $masterLectureId, bookId: $bookId, lectureId: $lectureId, planDate: $planDate, startAt: $startAt, endAt: $endAt, expectedMinutes: $expectedMinutes, type: $type, status: $status, titleOverride: $titleOverride, notes: $notes, meta: $meta, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentPlanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.planGroupId, planGroupId) ||
                other.planGroupId == planGroupId) &&
            (identical(other.subjectId, subjectId) ||
                other.subjectId == subjectId) &&
            (identical(other.masterBookId, masterBookId) ||
                other.masterBookId == masterBookId) &&
            (identical(other.masterLectureId, masterLectureId) ||
                other.masterLectureId == masterLectureId) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.lectureId, lectureId) ||
                other.lectureId == lectureId) &&
            (identical(other.planDate, planDate) ||
                other.planDate == planDate) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.endAt, endAt) || other.endAt == endAt) &&
            (identical(other.expectedMinutes, expectedMinutes) ||
                other.expectedMinutes == expectedMinutes) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.titleOverride, titleOverride) ||
                other.titleOverride == titleOverride) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._meta, _meta) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    tenantId,
    studentId,
    planGroupId,
    subjectId,
    masterBookId,
    masterLectureId,
    bookId,
    lectureId,
    planDate,
    startAt,
    endAt,
    expectedMinutes,
    type,
    status,
    titleOverride,
    notes,
    const DeepCollectionEquality().hash(_meta),
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of StudentPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentPlanImplCopyWith<_$StudentPlanImpl> get copyWith =>
      __$$StudentPlanImplCopyWithImpl<_$StudentPlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentPlanImplToJson(this);
  }
}

abstract class _StudentPlan implements StudentPlan {
  const factory _StudentPlan({
    required final String id,
    required final String tenantId,
    required final String studentId,
    required final String planGroupId,
    final String? subjectId,
    final String? masterBookId,
    final String? masterLectureId,
    final String? bookId,
    final String? lectureId,
    @JsonKey(fromJson: _dateOnlyFromJson, toJson: _dateOnlyToJson)
    required final DateTime planDate,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    final DateTime? startAt,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    final DateTime? endAt,
    final int? expectedMinutes,
    final PlanItemType type,
    final PlanItemStatus status,
    final String? titleOverride,
    final String? notes,
    final Map<String, dynamic> meta,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    final DateTime? createdAt,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    final DateTime? updatedAt,
  }) = _$StudentPlanImpl;

  factory _StudentPlan.fromJson(Map<String, dynamic> json) =
      _$StudentPlanImpl.fromJson;

  @override
  String get id;
  @override
  String get tenantId;
  @override
  String get studentId;
  @override
  String get planGroupId;
  @override
  String? get subjectId;
  @override
  String? get masterBookId;
  @override
  String? get masterLectureId;
  @override
  String? get bookId;
  @override
  String? get lectureId;
  @override
  @JsonKey(fromJson: _dateOnlyFromJson, toJson: _dateOnlyToJson)
  DateTime get planDate;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? get startAt;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? get endAt;
  @override
  int? get expectedMinutes;
  @override
  PlanItemType get type;
  @override
  PlanItemStatus get status;
  @override
  String? get titleOverride;
  @override
  String? get notes;
  @override
  Map<String, dynamic> get meta;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? get createdAt;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? get updatedAt;

  /// Create a copy of StudentPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentPlanImplCopyWith<_$StudentPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
