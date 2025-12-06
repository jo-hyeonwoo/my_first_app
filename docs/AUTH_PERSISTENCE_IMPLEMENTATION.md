# Auth Persistence & Session Restoration Implementation

## Phase 2 완료: 자동 로그인 및 세션 유지 기능

### 구현 완료 사항

#### 1. Splash Screen 생성 (`lib/features/auth/presentation/screens/splash_screen.dart`)

**주요 기능:**

- 앱 시작 시 첫 화면으로 표시
- 중앙에 "TimeLevelUp" 로고와 CircularProgressIndicator 표시
- Auth 상태를 감시하고, 세션 복구 후 적절한 화면으로 자동 이동

**구현 상세:**

- `ConsumerStatefulWidget`으로 구현하여 Riverpod과 통합
- `ref.watch(authNotifierProvider)`로 auth 상태 감시
- 상태에 따라 `/home` 또는 `/login`으로 자동 네비게이션

#### 2. Auth Provider 업데이트 (`lib/features/auth/presentation/providers/auth_provider.dart`)

**주요 변경사항:**

- `build()` 메서드에서 앱 시작 시 자동으로 세션 복구 시도
- `restoreSession()` 메서드 추가 (명시적 호출 가능)

**세션 복구 로직:**

1. `Supabase.instance.client.auth.currentSession` 확인
2. 세션이 있으면 `RealAuthRepository.getCurrentUser()` 호출
3. DB에서 유저 정보 조회 (role, tenantId 등)
4. User 엔티티로 변환하여 상태 업데이트
5. 세션이 없거나 오류 발생 시 `null` 반환

#### 3. Auth Repository 확장

**인터페이스 추가:**

- `AuthRepository.getCurrentUser()` 메서드 추가
  - 반환: `Future<User?>` (세션이 있으면 User, 없으면 null)

**RealAuthRepository 구현:**

- `getCurrentUser()` 메서드 구현
- `currentSession` 확인 후 유저 정보 조회
- 오류 발생 시 `null` 반환 (예외 처리)

**MockAuthRepository 구현:**

- `getCurrentUser()` 메서드 추가
- 항상 `null` 반환 (Mock에서는 세션 없음)

#### 4. Router 업데이트 (`lib/routes/app_router.dart`)

**주요 변경사항:**

- `initialLocation`을 `/splash`로 변경
- `/splash` 경로 추가 (SplashScreen 연결)
- 기존 redirect 로직 제거 (SplashScreen에서 처리)

#### 5. Main.dart

**현재 상태:**

- Supabase 초기화 완료
- ProviderScope 설정 완료
- 추가 초기화 불필요 (Auth Provider의 build()에서 자동 처리)

---

## 앱 진입 흐름

### 앱 시작 시:

1. **앱 실행** (`main.dart`)

   - Supabase 초기화
   - ProviderScope 생성
   - MyApp 위젯 렌더링

2. **Router 초기화** (`app_router.dart`)

   - `initialLocation: '/splash'`로 설정
   - SplashScreen 표시

3. **Auth Provider 초기화** (`auth_provider.dart`)

   - `build()` 메서드 자동 실행
   - `getCurrentUser()` 호출하여 세션 복구 시도
   - 상태를 `loading` → `data` 또는 `error`로 변경

4. **SplashScreen 로직** (`splash_screen.dart`)
   - Auth 상태 감시 (`ref.watch(authNotifierProvider)`)
   - **세션이 있으면** → `/home`으로 이동
   - **세션이 없으면** → `/login`으로 이동
   - **로딩 중** → 로딩 인디케이터 표시

### 사용자 시나리오:

**시나리오 1: 기존 세션이 있는 경우**

```
앱 실행 → SplashScreen → 세션 복구 성공 → /home (자동)
```

**시나리오 2: 세션이 없는 경우**

```
앱 실행 → SplashScreen → 세션 없음 → /login
```

**시나리오 3: 세션 복구 실패**

```
앱 실행 → SplashScreen → 오류 발생 → /login
```

---

## 구현 파일 목록

### 새로 생성된 파일:

1. `lib/features/auth/presentation/screens/splash_screen.dart` - Splash Screen

### 수정된 파일:

1. `lib/features/auth/domain/repositories/auth_repository.dart` - getCurrentUser() 메서드 추가
2. `lib/features/auth/data/repositories/real_auth_repository.dart` - getCurrentUser() 구현
3. `lib/features/auth/data/repositories/mock_auth_repository.dart` - getCurrentUser() 구현 (null 반환)
4. `lib/features/auth/presentation/providers/auth_provider.dart` - build()에서 세션 복구, restoreSession() 메서드 추가
5. `lib/routes/app_router.dart` - initialLocation 변경, splash 경로 추가

---

## 테스트 방법

### 1. 세션 없는 상태에서 시작

1. 앱 실행
2. SplashScreen이 잠깐 표시됨
3. 자동으로 LoginScreen으로 이동

### 2. 로그인 후 앱 재시작

1. 앱 실행 후 로그인
2. 앱 종료 (완전히 종료)
3. 앱 재실행
4. SplashScreen이 잠깐 표시됨
5. **자동으로 HomeScreen으로 이동** (재로그인 불필요)

### 3. 로그아웃 후 재시작

1. 앱에서 로그아웃
2. 앱 종료
3. 앱 재실행
4. SplashScreen 후 LoginScreen으로 이동

---

## 기술적 세부사항

### 세션 저장 메커니즘

Supabase Flutter SDK는 자동으로 세션을 저장합니다:

- **Android**: SharedPreferences
- **iOS**: Keychain
- **Web**: LocalStorage

세션은 다음 정보를 포함:

- Access Token (JWT)
- Refresh Token
- User ID
- Expiration time

### 세션 복구 프로세스

1. **Supabase SDK**가 저장된 세션 로드
2. `currentSession`이 유효한지 확인
3. 유효하면 `currentUser` 반환
4. `RealAuthRepository.getCurrentUser()`에서:
   - `auth.currentSession.user`를 통해 유저 ID 획득
   - `public.users` 테이블에서 추가 정보 조회
   - User 엔티티로 매핑하여 반환

### 에러 처리

- **세션이 없는 경우**: `null` 반환 (정상)
- **세션이 만료된 경우**: `null` 반환 (재로그인 필요)
- **네트워크 오류**: `null` 반환 (재로그인 필요)
- **DB 오류**: `null` 반환 (재로그인 필요)

모든 오류는 로그인 화면으로 이동하여 처리합니다.

---

## 보안 고려사항

1. **세션 만료**: Supabase가 자동으로 만료된 세션을 처리
2. **토큰 갱신**: 필요 시 자동으로 refresh token 사용
3. **RLS 정책**: 모든 DB 쿼리는 RLS 정책을 따름
4. **민감 정보**: 세션 정보는 안전하게 저장됨

---

## 다음 단계

이제 **Phase 2의 Database & Auth 섹션이 완전히 완료**되었습니다:

- ✅ Supabase 연동
- ✅ Real Repository 구현
- ✅ **Auth Persistence 및 세션 유지**

남은 작업:

- Background jobs & AI 통합
- Production concerns (Sentry, CI/CD 등)
