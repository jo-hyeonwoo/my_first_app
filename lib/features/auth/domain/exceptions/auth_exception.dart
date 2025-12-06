import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_exception.freezed.dart';

@freezed
class AuthException with _$AuthException {
  const factory AuthException.invalidCredentials() = InvalidCredentials;
  const factory AuthException.networkError() = NetworkError;
  const factory AuthException.unknown(String message) = Unknown;
}
