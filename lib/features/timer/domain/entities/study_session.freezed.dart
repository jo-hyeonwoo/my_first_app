// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'study_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StudySession _$StudySessionFromJson(Map<String, dynamic> json) {
  return _StudySession.fromJson(json);
}

/// @nodoc
mixin _$StudySession {
  String get id => throw _privateConstructorUsedError;
  String get planId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime get startTime => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _nullableDateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? get endTime => throw _privateConstructorUsedError;
  int get durationSeconds => throw _privateConstructorUsedError;
  StudySessionStatus get status => throw _privateConstructorUsedError;

  /// Serializes this StudySession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudySession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudySessionCopyWith<StudySession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudySessionCopyWith<$Res> {
  factory $StudySessionCopyWith(
    StudySession value,
    $Res Function(StudySession) then,
  ) = _$StudySessionCopyWithImpl<$Res, StudySession>;
  @useResult
  $Res call({
    String id,
    String planId,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime startTime,
    @JsonKey(fromJson: _nullableDateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? endTime,
    int durationSeconds,
    StudySessionStatus status,
  });
}

/// @nodoc
class _$StudySessionCopyWithImpl<$Res, $Val extends StudySession>
    implements $StudySessionCopyWith<$Res> {
  _$StudySessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudySession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? planId = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? durationSeconds = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            planId: null == planId
                ? _value.planId
                : planId // ignore: cast_nullable_to_non_nullable
                      as String,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endTime: freezed == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            durationSeconds: null == durationSeconds
                ? _value.durationSeconds
                : durationSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as StudySessionStatus,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StudySessionImplCopyWith<$Res>
    implements $StudySessionCopyWith<$Res> {
  factory _$$StudySessionImplCopyWith(
    _$StudySessionImpl value,
    $Res Function(_$StudySessionImpl) then,
  ) = __$$StudySessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String planId,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime startTime,
    @JsonKey(fromJson: _nullableDateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? endTime,
    int durationSeconds,
    StudySessionStatus status,
  });
}

/// @nodoc
class __$$StudySessionImplCopyWithImpl<$Res>
    extends _$StudySessionCopyWithImpl<$Res, _$StudySessionImpl>
    implements _$$StudySessionImplCopyWith<$Res> {
  __$$StudySessionImplCopyWithImpl(
    _$StudySessionImpl _value,
    $Res Function(_$StudySessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudySession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? planId = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? durationSeconds = null,
    Object? status = null,
  }) {
    return _then(
      _$StudySessionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        planId: null == planId
            ? _value.planId
            : planId // ignore: cast_nullable_to_non_nullable
                  as String,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endTime: freezed == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        durationSeconds: null == durationSeconds
            ? _value.durationSeconds
            : durationSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as StudySessionStatus,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StudySessionImpl implements _StudySession {
  const _$StudySessionImpl({
    required this.id,
    required this.planId,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    required this.startTime,
    @JsonKey(fromJson: _nullableDateTimeFromJson, toJson: _dateTimeToJson)
    this.endTime,
    this.durationSeconds = 0,
    this.status = StudySessionStatus.initial,
  });

  factory _$StudySessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudySessionImplFromJson(json);

  @override
  final String id;
  @override
  final String planId;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime startTime;
  @override
  @JsonKey(fromJson: _nullableDateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? endTime;
  @override
  @JsonKey()
  final int durationSeconds;
  @override
  @JsonKey()
  final StudySessionStatus status;

  @override
  String toString() {
    return 'StudySession(id: $id, planId: $planId, startTime: $startTime, endTime: $endTime, durationSeconds: $durationSeconds, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudySessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.planId, planId) || other.planId == planId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    planId,
    startTime,
    endTime,
    durationSeconds,
    status,
  );

  /// Create a copy of StudySession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudySessionImplCopyWith<_$StudySessionImpl> get copyWith =>
      __$$StudySessionImplCopyWithImpl<_$StudySessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StudySessionImplToJson(this);
  }
}

abstract class _StudySession implements StudySession {
  const factory _StudySession({
    required final String id,
    required final String planId,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    required final DateTime startTime,
    @JsonKey(fromJson: _nullableDateTimeFromJson, toJson: _dateTimeToJson)
    final DateTime? endTime,
    final int durationSeconds,
    final StudySessionStatus status,
  }) = _$StudySessionImpl;

  factory _StudySession.fromJson(Map<String, dynamic> json) =
      _$StudySessionImpl.fromJson;

  @override
  String get id;
  @override
  String get planId;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime get startTime;
  @override
  @JsonKey(fromJson: _nullableDateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? get endTime;
  @override
  int get durationSeconds;
  @override
  StudySessionStatus get status;

  /// Create a copy of StudySession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudySessionImplCopyWith<_$StudySessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
