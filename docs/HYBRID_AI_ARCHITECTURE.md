# Hybrid AI Architecture Implementation

## Phase 3 업그레이드: OpenAI & Gemini 지원

### 개요

이제 TimeLevelUp은 **하나의 AI 모델에만 의존하지 않고**, OpenAI와 Google Gemini를 모두 지원하는 **Hybrid AI Architecture**를 갖추고 있습니다. 환경 변수 설정만으로 AI 제공자를 쉽게 전환할 수 있습니다.

---

## 아키텍처 구조

### 1단계: Abstract Domain Layer

**파일:** `lib/features/plan/domain/services/ai_plan_service.dart`

- `AiPlanService` 추상 클래스 (인터페이스)
- 어떤 AI 제공자를 사용하든 동일한 인터페이스
- `generatePlan()` 메서드로 통일된 API 제공

### 2단계: Data Layer (다중 구현체)

**구현체 1: Gemini**
- 파일: `lib/features/plan/data/services/gemini_plan_service.dart`
- 모델: `gemini-1.5-flash`
- JSON Mode 사용

**구현체 2: OpenAI**
- 파일: `lib/features/plan/data/services/openai_plan_service.dart`
- 모델: `gpt-4o-mini` (또는 `gpt-3.5-turbo`)
- System Prompt로 JSON 응답 유도

### 3단계: Service Locator (Factory 패턴)

**파일:** `lib/features/plan/data/services/ai_service_factory.dart`

- `.env` 파일의 `AI_PROVIDER` 설정값 읽기
- `gemini` → `GeminiPlanService` 반환
- `openai` → `OpenAiPlanService` 반환 (기본값)
- API Key 유효성 검증

### 4단계: Presentation Layer

- `AiPlanProvider`는 Factory를 통해 서비스 생성
- UI 코드 변경 없이 AI 모델 전환 가능

---

## 환경 변수 설정

프로젝트 루트의 `.env` 파일에 다음 설정을 추가하세요:

### OpenAI 사용 시

```env
# Supabase 설정
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=xxx

# AI Provider 설정
AI_PROVIDER=openai
OPENAI_API_KEY=sk-xxx
```

### Gemini 사용 시

```env
# Supabase 설정
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=xxx

# AI Provider 설정
AI_PROVIDER=gemini
GEMINI_API_KEY=xxx
```

### AI_PROVIDER 설정값

- `openai`: OpenAI 사용 (기본값)
- `gemini`: Google Gemini 사용
- 설정하지 않으면 `openai`가 기본값

---

## API Key 발급 방법

### OpenAI API Key

1. [OpenAI Platform](https://platform.openai.com/) 접속
2. 계정 생성 또는 로그인
3. **API Keys** 섹션으로 이동
4. **"Create new secret key"** 클릭
5. 생성된 키를 복사하여 `.env` 파일에 추가

### Gemini API Key

1. [Google AI Studio](https://makersuite.google.com/app/apikey) 접속
2. Google 계정으로 로그인
3. **"Create API Key"** 클릭
4. 프로젝트 선택 또는 새 프로젝트 생성
5. 생성된 API Key를 복사하여 `.env` 파일에 추가

---

## 사용 방법

### 1. AI Provider 전환

`.env` 파일에서 `AI_PROVIDER` 값을 변경:

```env
# Gemini로 전환
AI_PROVIDER=gemini
GEMINI_API_KEY=your_gemini_key_here

# 또는 OpenAI로 전환
AI_PROVIDER=openai
OPENAI_API_KEY=your_openai_key_here
```

### 2. 앱 재시작

```bash
flutter pub get
flutter run
```

### 3. 플랜 생성 테스트

앱에서 AI 플랜 생성 기능을 사용하면, 설정한 Provider로 플랜이 생성됩니다.

---

## 기술적 세부사항

### Factory 패턴 구현

```dart
// Factory가 환경 변수를 읽어 적절한 서비스를 생성
AiPlanService service = AiServiceFactory.create();
```

### Provider 주입

```dart
@riverpod
AiPlanService aiPlanService(AiPlanServiceRef ref) {
  return AiServiceFactory.create(); // Factory를 통해 생성
}
```

### 에러 처리

- API Key가 없으면 명확한 에러 메시지 표시
- 잘못된 Provider 이름은 기본값(OpenAI) 사용 및 경고 메시지

---

## 모델 비교

### OpenAI (gpt-4o-mini)

**장점:**
- 높은 품질의 응답
- 빠른 응답 속도
- 안정적인 JSON 출력

**단점:**
- 상대적으로 높은 비용

**비용:** 약 $0.15 / 1M input tokens, $0.60 / 1M output tokens

### Gemini (gemini-1.5-flash)

**장점:**
- 무료 티어 제공 (일일 할당량)
- 매우 빠른 응답 속도
- 저렴한 가격

**단점:**
- 일부 상황에서 OpenAI보다 낮은 품질 가능

**비용:** 무료 티어 또는 매우 저렴한 유료 플랜

---

## 주의사항

⚠️ **중요:**

1. **API Key 보안**
   - `.env` 파일은 절대 Git에 커밋하지 마세요 (이미 `.gitignore`에 포함됨)
   - 프로덕션 환경에서는 환경 변수 관리 서비스 사용 권장

2. **API Key 설정**
   - 선택한 Provider에 맞는 API Key만 설정하면 됩니다
   - 예: `AI_PROVIDER=gemini`이면 `GEMINI_API_KEY`만 필요

3. **Provider 변경 시**
   - Provider를 변경하면 앱을 재시작해야 합니다
   - 환경 변수는 앱 시작 시 로드됩니다

---

## 확장 가능성

이 아키텍처는 새로운 AI 제공자를 쉽게 추가할 수 있도록 설계되었습니다:

1. `AiPlanService` 인터페이스 구현
2. `AiServiceFactory`에 새로운 Provider 추가
3. `.env` 설정만 변경하면 바로 사용 가능

예: Claude, Llama 등 다른 AI 모델도 동일한 방식으로 추가 가능

---

## 트러블슈팅

### "GEMINI_API_KEY not found" 오류

**해결:**
- `.env` 파일에 `GEMINI_API_KEY`가 있는지 확인
- `AI_PROVIDER=gemini`로 설정했는지 확인

### "OPENAI_API_KEY not found" 오류

**해결:**
- `.env` 파일에 `OPENAI_API_KEY`가 있는지 확인
- `AI_PROVIDER=openai` 또는 설정하지 않았는지 확인

### Provider 전환이 안 됨

**해결:**
- `.env` 파일 수정 후 앱을 완전히 재시작
- 환경 변수는 앱 시작 시 한 번만 로드됩니다

---

## 구현 파일 목록

### Domain Layer
- `lib/features/plan/domain/services/ai_plan_service.dart` - 추상 인터페이스

### Data Layer
- `lib/features/plan/data/services/gemini_plan_service.dart` - Gemini 구현
- `lib/features/plan/data/services/openai_plan_service.dart` - OpenAI 구현
- `lib/features/plan/data/services/ai_service_factory.dart` - Factory 패턴

### Presentation Layer
- `lib/features/plan/presentation/providers/ai_plan_provider.dart` - Factory 사용

### 패키지
- `pubspec.yaml` - `google_generative_ai` 패키지 추가

---

## 다음 단계

- [ ] AI Provider 런타임 전환 (앱 재시작 없이)
- [ ] AI Provider 성능 비교 대시보드
- [ ] 자동 Fallback (한 Provider 실패 시 다른 Provider 시도)
- [ ] 비용 모니터링 및 최적화

