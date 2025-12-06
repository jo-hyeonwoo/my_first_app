// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'score.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Score _$ScoreFromJson(Map<String, dynamic> json) {
  return _Score.fromJson(json);
}

/// @nodoc
mixin _$Score {
  String get id => throw _privateConstructorUsedError;
  String get examName => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateOnlyFromJson, toJson: _dateOnlyToJson)
  DateTime get date => throw _privateConstructorUsedError;
  String get subject => throw _privateConstructorUsedError;
  int get rawScore => throw _privateConstructorUsedError;
  int? get standardScore => throw _privateConstructorUsedError;
  String? get grade => throw _privateConstructorUsedError;

  /// Serializes this Score to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Score
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScoreCopyWith<Score> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScoreCopyWith<$Res> {
  factory $ScoreCopyWith(Score value, $Res Function(Score) then) =
      _$ScoreCopyWithImpl<$Res, Score>;
  @useResult
  $Res call({
    String id,
    String examName,
    @JsonKey(fromJson: _dateOnlyFromJson, toJson: _dateOnlyToJson)
    DateTime date,
    String subject,
    int rawScore,
    int? standardScore,
    String? grade,
  });
}

/// @nodoc
class _$ScoreCopyWithImpl<$Res, $Val extends Score>
    implements $ScoreCopyWith<$Res> {
  _$ScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Score
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? examName = null,
    Object? date = null,
    Object? subject = null,
    Object? rawScore = null,
    Object? standardScore = freezed,
    Object? grade = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            examName: null == examName
                ? _value.examName
                : examName // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            subject: null == subject
                ? _value.subject
                : subject // ignore: cast_nullable_to_non_nullable
                      as String,
            rawScore: null == rawScore
                ? _value.rawScore
                : rawScore // ignore: cast_nullable_to_non_nullable
                      as int,
            standardScore: freezed == standardScore
                ? _value.standardScore
                : standardScore // ignore: cast_nullable_to_non_nullable
                      as int?,
            grade: freezed == grade
                ? _value.grade
                : grade // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScoreImplCopyWith<$Res> implements $ScoreCopyWith<$Res> {
  factory _$$ScoreImplCopyWith(
    _$ScoreImpl value,
    $Res Function(_$ScoreImpl) then,
  ) = __$$ScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String examName,
    @JsonKey(fromJson: _dateOnlyFromJson, toJson: _dateOnlyToJson)
    DateTime date,
    String subject,
    int rawScore,
    int? standardScore,
    String? grade,
  });
}

/// @nodoc
class __$$ScoreImplCopyWithImpl<$Res>
    extends _$ScoreCopyWithImpl<$Res, _$ScoreImpl>
    implements _$$ScoreImplCopyWith<$Res> {
  __$$ScoreImplCopyWithImpl(
    _$ScoreImpl _value,
    $Res Function(_$ScoreImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Score
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? examName = null,
    Object? date = null,
    Object? subject = null,
    Object? rawScore = null,
    Object? standardScore = freezed,
    Object? grade = freezed,
  }) {
    return _then(
      _$ScoreImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        examName: null == examName
            ? _value.examName
            : examName // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        subject: null == subject
            ? _value.subject
            : subject // ignore: cast_nullable_to_non_nullable
                  as String,
        rawScore: null == rawScore
            ? _value.rawScore
            : rawScore // ignore: cast_nullable_to_non_nullable
                  as int,
        standardScore: freezed == standardScore
            ? _value.standardScore
            : standardScore // ignore: cast_nullable_to_non_nullable
                  as int?,
        grade: freezed == grade
            ? _value.grade
            : grade // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScoreImpl implements _Score {
  const _$ScoreImpl({
    required this.id,
    required this.examName,
    @JsonKey(fromJson: _dateOnlyFromJson, toJson: _dateOnlyToJson)
    required this.date,
    required this.subject,
    required this.rawScore,
    this.standardScore,
    this.grade,
  });

  factory _$ScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScoreImplFromJson(json);

  @override
  final String id;
  @override
  final String examName;
  @override
  @JsonKey(fromJson: _dateOnlyFromJson, toJson: _dateOnlyToJson)
  final DateTime date;
  @override
  final String subject;
  @override
  final int rawScore;
  @override
  final int? standardScore;
  @override
  final String? grade;

  @override
  String toString() {
    return 'Score(id: $id, examName: $examName, date: $date, subject: $subject, rawScore: $rawScore, standardScore: $standardScore, grade: $grade)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScoreImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.examName, examName) ||
                other.examName == examName) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.rawScore, rawScore) ||
                other.rawScore == rawScore) &&
            (identical(other.standardScore, standardScore) ||
                other.standardScore == standardScore) &&
            (identical(other.grade, grade) || other.grade == grade));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    examName,
    date,
    subject,
    rawScore,
    standardScore,
    grade,
  );

  /// Create a copy of Score
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScoreImplCopyWith<_$ScoreImpl> get copyWith =>
      __$$ScoreImplCopyWithImpl<_$ScoreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScoreImplToJson(this);
  }
}

abstract class _Score implements Score {
  const factory _Score({
    required final String id,
    required final String examName,
    @JsonKey(fromJson: _dateOnlyFromJson, toJson: _dateOnlyToJson)
    required final DateTime date,
    required final String subject,
    required final int rawScore,
    final int? standardScore,
    final String? grade,
  }) = _$ScoreImpl;

  factory _Score.fromJson(Map<String, dynamic> json) = _$ScoreImpl.fromJson;

  @override
  String get id;
  @override
  String get examName;
  @override
  @JsonKey(fromJson: _dateOnlyFromJson, toJson: _dateOnlyToJson)
  DateTime get date;
  @override
  String get subject;
  @override
  int get rawScore;
  @override
  int? get standardScore;
  @override
  String? get grade;

  /// Create a copy of Score
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScoreImplCopyWith<_$ScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
