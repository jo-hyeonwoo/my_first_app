# Phase 4: Production Readiness Implementation

## 개요

Phase 4에서는 앱의 안정성과 모니터링을 위한 Production Readiness 기능을 구현했습니다.

---

## 구현 완료 사항

### 1단계: Robust JSON Parsing (AI 응답 전처리)

**파일:** `lib/core/utils/json_utils.dart`

- `cleanJsonString()` 함수 생성
- LLM 응답에서 마크다운 코드 블록 제거
  - ` ```json ` 제거
  - ` ``` ` 제거
  - 앞뒤 공백 제거

**적용 위치:**

- `GeminiPlanService`: JSON 파싱 전에 `JsonUtils.cleanJsonString()` 사용
- `OpenAiPlanService`: JSON 파싱 전에 `JsonUtils.cleanJsonString()` 사용

**효과:**

- AI가 마크다운 코드 블록으로 응답해도 정상적으로 파싱 가능
- JSON 파싱 에러 감소

---

### 2단계: Error Monitoring (Sentry Integration)

**패키지 추가:**

- `pubspec.yaml`에 `sentry_flutter: ^8.0.0` 추가

**환경 변수:**

- `.env` 파일에 `SENTRY_DSN` 추가 필요

**main.dart 수정:**

- `SentryFlutter.init()`으로 앱 감싸기
- `options.dsn`에 환경변수 값 설정
- `options.tracesSampleRate = 1.0` (개발용, 프로덕션에서는 낮은 값 권장)

---

### 3단계: Global Error Handling

**에러 전송 위치:**

1. **AiPlanProvider** (`lib/features/plan/presentation/providers/ai_plan_provider.dart`)

   - AI 플랜 생성 실패 시 Sentry로 전송
   - 컨텍스트 정보 포함 (studentId, focusSubjects, availableMinutes)

2. **RealAuthRepository** (`lib/features/auth/data/repositories/real_auth_repository.dart`)

   - 로그인 실패 시 Sentry로 전송
   - 로그아웃 실패 시 Sentry로 전송
   - 테넌트 조회 실패 시 Sentry로 전송

3. **RealPlanRepository** (`lib/features/plan/data/repositories/real_plan_repository.dart`)

   - 플랜 저장 실패 시 Sentry로 전송
   - 컨텍스트 정보 포함 (planCount, studentId)

4. **PlanGenerationScreen** (`lib/features/plan/presentation/screens/plan_generation_screen.dart`)
   - UI에서 플랜 저장 실패 시 Sentry로 전송

---

## 환경 변수 설정

프로젝트 루트의 `.env` 파일에 Sentry DSN을 추가하세요:

```env
# Supabase 설정
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=xxx

# AI Provider 설정
AI_PROVIDER=openai  # 또는 gemini
OPENAI_API_KEY=sk-xxx  # OpenAI 사용 시
GEMINI_API_KEY=xxx  # Gemini 사용 시

# Error Monitoring
SENTRY_DSN=https://xxx@xxx.ingest.sentry.io/xxx
```

---

## Sentry DSN 발급 방법

1. [Sentry](https://sentry.io/) 접속
2. 계정 생성 또는 로그인
3. **Projects** > **Create Project** 클릭
4. **Flutter** 선택
5. 프로젝트 이름 입력 후 생성
6. **Client Keys (DSN)** 섹션에서 DSN 복사
7. `.env` 파일에 `SENTRY_DSN`으로 추가

---

## 사용 방법

### 1. Sentry DSN 설정

`.env` 파일에 `SENTRY_DSN` 추가:

```env
SENTRY_DSN=https://your-key@your-org.ingest.sentry.io/your-project-id
```

### 2. 앱 실행

```bash
flutter pub get
flutter run
```

### 3. 에러 모니터링

- 앱에서 에러가 발생하면 자동으로 Sentry로 전송됩니다
- Sentry 대시보드에서 에러를 확인할 수 있습니다
- 에러 발생 시 컨텍스트 정보도 함께 전송됩니다

---

## 기술적 세부사항

### JSON Parsing 개선

**문제:**

- LLM이 JSON 모드로 응답해도 가끔 마크다운 코드 블록으로 감싸서 응답
- 예: ` ```json { ... } ``` `

**해결:**

- `JsonUtils.cleanJsonString()` 함수로 전처리
- 정규표현식으로 마크다운 코드 블록 제거
- 앞뒤 공백 제거

### Sentry 통합

**초기화:**

```dart
await SentryFlutter.init(
  (options) {
    options.dsn = sentryDsn;
    options.tracesSampleRate = 1.0; // 개발용
  },
  appRunner: () async {
    // 앱 초기화 코드
  },
);
```

**에러 전송:**

```dart
await Sentry.captureException(
  e,
  stackTrace: stackTrace,
  hint: Hint.withMap({
    'context': 'Error Context',
    'additionalInfo': 'value',
  }),
);
```

---

## 프로덕션 권장사항

### 1. Traces Sample Rate 조정

개발 환경에서는 `1.0` (100%)으로 설정했지만, 프로덕션에서는 낮은 값 권장:

```dart
options.tracesSampleRate = 0.1; // 10% 샘플링
```

### 2. Debug Mode 비활성화

프로덕션에서는 debug 모드를 비활성화:

```dart
options.debug = false;
```

### 3. 환경별 DSN 분리

- 개발 환경: 개발용 Sentry 프로젝트 DSN
- 프로덕션 환경: 프로덕션용 Sentry 프로젝트 DSN

---

## 모니터링 가능한 에러 유형

1. **AI 플랜 생성 에러**

   - OpenAI/Gemini API 호출 실패
   - JSON 파싱 실패
   - 플랜 변환 실패

2. **인증 에러**

   - 로그인 실패
   - 로그아웃 실패
   - 세션 복구 실패

3. **데이터베이스 에러**
   - 플랜 저장 실패
   - 플랜 조회 실패
   - 네트워크 오류

---

## 다음 단계

- [ ] Sentry Performance Monitoring 설정
- [ ] 사용자 피드백 수집 기능
- [ ] 크래시 리포트 자동 수집
- [ ] 에러 알림 설정 (Slack, Email 등)

---

## 주의사항

⚠️ **중요:**

1. **Sentry DSN 보안**

   - `.env` 파일은 절대 Git에 커밋하지 마세요
   - 프로덕션에서는 환경 변수 관리 서비스 사용 권장

2. **개인정보 보호**

   - Sentry에 전송되는 데이터에 개인정보가 포함되지 않도록 주의
   - 이메일, 비밀번호 등은 제외

3. **비용 관리**
   - Sentry는 무료 티어가 있지만, 사용량에 따라 비용 발생 가능
   - `tracesSampleRate`를 조정하여 비용 절감

---

## 구현 파일 목록

### Core Utilities

- `lib/core/utils/json_utils.dart` - JSON 파싱 유틸리티

### Error Monitoring

- `lib/main.dart` - Sentry 초기화
- `lib/features/plan/presentation/providers/ai_plan_provider.dart` - AI 에러 전송
- `lib/features/auth/data/repositories/real_auth_repository.dart` - 인증 에러 전송
- `lib/features/plan/data/repositories/real_plan_repository.dart` - DB 에러 전송
- `lib/features/plan/presentation/screens/plan_generation_screen.dart` - UI 에러 전송

### 패키지

- `pubspec.yaml` - `sentry_flutter` 패키지 추가
