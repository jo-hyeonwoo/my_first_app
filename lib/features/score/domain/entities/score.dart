import 'package:freezed_annotation/freezed_annotation.dart';

part 'score.freezed.dart';
part 'score.g.dart';

@freezed
class Score with _$Score {
  const factory Score({
    required String id,
    required String examName,
    @JsonKey(fromJson: _dateOnlyFromJson, toJson: _dateOnlyToJson)
        required DateTime date,
    required String subject,
    required int rawScore,
    int? standardScore,
    String? grade,
  }) = _Score;

  factory Score.fromJson(Map<String, dynamic> json) => _$ScoreFromJson(json);
}

DateTime _dateOnlyFromJson(Object value) => DateTime.parse(value as String);

String _dateOnlyToJson(DateTime date) => date.toIso8601String().split('T').first;
