# 로그인 네트워크 오류 수정

## 문제 상황

"학생으로 로그인" 버튼을 클릭할 때 다음 오류가 발생했습니다:

```
Error: AuthException.networkError()
```

## 원인 분석

`AuthException.networkError()`가 발생하는 가능한 원인:

1. **Supabase 인증은 성공했지만, `users` 테이블에서 사용자 정보 조회 실패**
   - Supabase Auth에는 사용자가 있지만, `public.users` 테이블에 해당 사용자 레코드가 없을 수 있음
   - PostgrestException이 발생할 수 있음

2. **실제 네트워크 연결 문제**
   - 인터넷 연결 불안정
   - Supabase 서버 접근 불가

3. **Supabase 설정 문제**
   - `.env` 파일의 `SUPABASE_URL` 또는 `SUPABASE_ANON_KEY`가 잘못됨

## 해결 방법

### 1. 에러 메시지 개선

**변경 사항:**
- `LoginScreen`에서 `AuthException` 타입에 따라 다른 메시지 표시
- 사용자 친화적인 한국어 메시지 제공

**수정된 코드:**
```dart
try {
  await ref.read(authNotifierProvider.notifier).login(email, password);
  if (mounted) {
    context.go('/home');
  }
} on AuthException catch (e) {
  final errorMessage = e.when(
    invalidCredentials: () => '이메일 또는 비밀번호가 올바르지 않습니다.',
    networkError: () => '네트워크 연결을 확인해주세요. 서버에 연결할 수 없습니다.',
    unknown: (message) => '로그인 중 오류가 발생했습니다: $message',
  );
  _showError(errorMessage);
} catch (e) {
  _showError('로그인 실패: $e');
}
```

### 2. 상세 로깅 추가

**변경 사항:**
- `RealAuthRepository`에 상세한 에러 로깅 추가
- Sentry에 더 많은 컨텍스트 정보 전송

**추가된 로깅:**
```dart
print('AuthApiException during login: ${e.statusCode} - ${e.message}');
print('Error during login: $e');
print('Error type: ${e.runtimeType}');
print('Stack trace: $stackTrace');
```

## 문제 해결 체크리스트

### 1. Supabase 설정 확인

```bash
# .env 파일 확인
cat .env | grep SUPABASE
```

확인 사항:
- `SUPABASE_URL`이 올바른지 확인
- `SUPABASE_ANON_KEY`가 올바른지 확인

### 2. 사용자 데이터베이스 확인

Supabase 대시보드에서 확인:
1. **Authentication > Users**: `student@test.com` 사용자가 존재하는지 확인
2. **Table Editor > users**: 해당 사용자의 레코드가 있는지 확인

**확인 SQL:**
```sql
SELECT * FROM public.users WHERE email = 'student@test.com';
```

### 3. 사용자 레코드가 없는 경우

`users` 테이블에 사용자 레코드가 없다면 추가:

```sql
-- Authentication에서 사용자 UUID 확인 후
INSERT INTO public.users (id, email, name, role, tenant_id)
VALUES 
  ('USER_UUID_FROM_AUTH', 'student@test.com', 'Kim Student', 'student', 'TENANT_UUID')
ON CONFLICT (id) DO NOTHING;
```

### 4. 네트워크 연결 확인

- 인터넷 연결 상태 확인
- Wi-Fi 또는 모바일 데이터 활성화 확인
- 다른 앱에서 인터넷이 정상 작동하는지 확인

### 5. 로그 확인

앱을 실행하고 로그인을 시도한 후, 터미널에서 다음 로그를 확인:

```
AuthApiException during login: [statusCode] - [message]
Error during login: [error]
Error type: [errorType]
```

## 다음 단계

1. **앱을 다시 실행**하여 개선된 에러 메시지 확인
2. **터미널 로그**를 확인하여 실제 오류 원인 파악
3. **Supabase 대시보드**에서 사용자 데이터 확인
4. 필요시 사용자 레코드 추가

## 관련 파일

- `lib/features/auth/presentation/screens/login_screen.dart`: 로그인 화면 및 에러 메시지
- `lib/features/auth/data/repositories/real_auth_repository.dart`: 인증 로직 및 에러 처리
- `lib/features/auth/domain/exceptions/auth_exception.dart`: 인증 예외 정의

## 참고 문서

- [Supabase Setup Guide](docs/SUPABASE_SETUP_GUIDE.md)
- [Auth Implementation](docs/AUTH_IMPLEMENTATION.md)

