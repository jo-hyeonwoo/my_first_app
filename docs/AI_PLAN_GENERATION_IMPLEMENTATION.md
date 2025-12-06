# AI Plan Generation Implementation

## Phase 3 완료: AI 학습 플랜 자동 생성 기능 (Hybrid Architecture)

### 구현 완료 사항

#### 0단계: 환경 설정

**패키지 추가:**

- `pubspec.yaml`에 `http: ^1.1.0` 패키지 추가 (OpenAI용)
- `pubspec.yaml`에 `google_generative_ai: ^0.2.0` 패키지 추가 (Gemini용)

**환경 변수:**

- `.env` 파일에 AI Provider 설정 및 해당 API Key 추가 필요

  ```env
  SUPABASE_URL=https://xxx.supabase.co
  SUPABASE_ANON_KEY=xxx

  # AI Provider 설정 (openai 또는 gemini)
  AI_PROVIDER=openai  # 또는 gemini
  OPENAI_API_KEY=sk-xxx  # OpenAI 사용 시
  GEMINI_API_KEY=xxx  # Gemini 사용 시
  ```

#### 1단계: Domain Layer (Service Interface)

**파일:** `lib/features/plan/domain/services/ai_plan_service.dart`

- `AiPlanService` 인터페이스 정의
- `generatePlan()` 메서드:
  - `studentId`: 학생 ID
  - `focusSubjects`: 중점 과목 리스트
  - `availableMinutes`: 가용 시간 (분)
  - `tenantId`: 테넌트 ID
  - `planDate`: 플랜 날짜
  - 반환: `Future<List<StudentPlan>>`

#### 2단계: Data Layer (다중 구현체)

**Factory 패턴:**

- 파일: `lib/features/plan/data/services/ai_service_factory.dart`
- `.env` 파일의 `AI_PROVIDER` 설정값에 따라 적절한 서비스 생성
- `gemini` → `GeminiPlanService`
- `openai` → `OpenAiPlanService` (기본값)

**구현체 1: Gemini**

- 파일: `lib/features/plan/data/services/gemini_plan_service.dart`
- Google Gemini API (`gemini-1.5-flash` 모델)
- JSON Mode 사용
- 자동 UUID 생성 및 메타데이터 추가

**구현체 2: OpenAI**

- 파일: `lib/features/plan/data/services/openai_plan_service.dart`
- OpenAI Chat Completion API (`gpt-4o-mini` 모델 사용)
- System Prompt: "너는 입시 전문가야..."
- JSON 형식 응답 파싱
- 자동 UUID 생성 및 메타데이터 추가

**주요 기능:**

- 두 구현체 모두 동일한 `AiPlanService` 인터페이스 구현
- UI 코드 변경 없이 AI 모델 전환 가능

#### 3단계: Presentation Layer (UI & Logic)

**AI Plan Provider:**

- 파일: `lib/features/plan/presentation/providers/ai_plan_provider.dart`
- `AiPlanNotifier`: AI 플랜 생성 상태 관리
- `generatePlans()`: 플랜 생성 요청
- `clear()`: 생성된 플랜 초기화

**Plan Generation Screen:**

- 파일: `lib/features/plan/presentation/screens/plan_generation_screen.dart`
- 입력 필드:
  - 중점 과목 (쉼표로 구분)
  - 가용 시간 (분)
- AI 플랜 생성 버튼
- 생성된 플랜 미리보기 (PlanCard 위젯 사용)
- 저장 버튼: DB에 플랜 저장

**PlanRepository 확장:**

- `savePlan(StudentPlan plan)`: 단일 플랜 저장
- `savePlans(List<StudentPlan> plans)`: 일괄 플랜 저장
- `RealPlanRepository` 및 `MockPlanRepository` 모두 구현

#### 4단계: Routing & Integration

**Router 업데이트:**

- `/plan-generation/:studentId` 경로 추가
- 쿼리 파라미터로 날짜 지정 가능

**홈 화면 통합:**

- `StudentHomeScreen`: FloatingActionButton 추가 ("✨ AI 플랜 생성")
- `StudentDetailScreen`: FloatingActionButton 추가 (플랜 탭에서만 표시)
  - 선생님이 학생을 위해 플랜 생성 가능

---

## 사용 방법

### 1. 환경 변수 설정

프로젝트 루트의 `.env` 파일에 AI Provider 설정 및 API Key를 추가하세요:

**OpenAI 사용 시:**

```env
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=xxx

AI_PROVIDER=openai
OPENAI_API_KEY=sk-xxx  # 여기에 OpenAI API Key 입력
```

**Gemini 사용 시:**

```env
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=xxx

AI_PROVIDER=gemini
GEMINI_API_KEY=xxx  # 여기에 Gemini API Key 입력
```

**OpenAI API Key 발급 방법:**

1. [OpenAI Platform](https://platform.openai.com/) 접속
2. 계정 생성 또는 로그인
3. API Keys 섹션으로 이동
4. "Create new secret key" 클릭
5. 생성된 키를 복사하여 `.env` 파일에 추가

**Gemini API Key 발급 방법:**

1. [Google AI Studio](https://makersuite.google.com/app/apikey) 접속
2. Google 계정으로 로그인
3. "Create API Key" 클릭
4. 프로젝트 선택 또는 새 프로젝트 생성
5. 생성된 API Key를 복사하여 `.env` 파일에 추가

> 💡 **참고:** `AI_PROVIDER`를 설정하지 않으면 기본값으로 `openai`가 사용됩니다.  
> 자세한 내용은 `docs/HYBRID_AI_ARCHITECTURE.md`를 참고하세요.

### 2. 앱 실행

```bash
flutter pub get
flutter run
```

### 3. AI 플랜 생성 사용

**학생 홈 화면:**

1. 앱 실행 후 학생으로 로그인
2. 홈 화면 우측 하단의 "✨ AI 플랜 생성" 버튼 클릭
3. 중점 과목 입력 (예: "수학, 영어, 국어")
4. 가용 시간 입력 (예: "120")
5. "✨ AI 플랜 생성하기" 버튼 클릭
6. 생성된 플랜 미리보기 확인
7. "💾 이대로 저장하기" 버튼 클릭하여 저장

**선생님 대시보드:**

1. 선생님으로 로그인
2. 담당 학생 선택
3. 학생 상세 화면의 "플랜" 탭으로 이동
4. 우측 하단의 "✨ AI 플랜 생성" 버튼 클릭
5. 위와 동일한 과정으로 플랜 생성 및 저장

---

## 기술적 세부사항

### OpenAI API 호출

**모델:** `gpt-4o-mini` (비용 효율적인 옵션)

- 필요시 `gpt-3.5-turbo`로 변경 가능

**API 엔드포인트:**

- `https://api.openai.com/v1/chat/completions`

**요청 형식:**

```json
{
  "model": "gpt-4o-mini",
  "messages": [
    {
      "role": "system",
      "content": "너는 입시 전문가야..."
    },
    {
      "role": "user",
      "content": "다음 조건에 맞는 학습 플랜을 JSON 형식으로 만들어줘: ..."
    }
  ],
  "response_format": { "type": "json_object" },
  "temperature": 0.7
}
```

**응답 형식:**

```json
{
  "plans": [
    {
      "subject": "수학",
      "title": "구체적인 학습 제목",
      "expectedMinutes": 60,
      "notes": "학습 내용 설명"
    }
  ]
}
```

### 플랜 저장 프로세스

1. AI가 생성한 플랜을 `StudentPlan` 엔티티로 변환
2. 각 플랜에 UUID, tenantId, studentId 자동 할당
3. 같은 생성 그룹의 플랜들은 같은 `planGroupId` 공유
4. Supabase `student_plans` 테이블에 일괄 저장
5. 저장 후 플랜 리스트 자동 새로고침

### 에러 처리

- **API Key 없음**: 명확한 에러 메시지 표시
- **API 호출 실패**: 네트워크 오류 또는 API 오류 메시지
- **JSON 파싱 실패**: 파싱 오류 메시지 및 빈 리스트 반환
- **저장 실패**: 저장 오류 메시지 표시

---

## 비용 고려사항

OpenAI API는 사용량에 따라 비용이 발생합니다:

- **gpt-4o-mini**: 약 $0.15 / 1M input tokens, $0.60 / 1M output tokens
- **gpt-3.5-turbo**: 약 $0.50 / 1M input tokens, $1.50 / 1M output tokens

한 번의 플랜 생성은 약 1,000-2,000 토큰을 사용하므로 매우 저렴합니다.

**비용 절감 방법:**

1. `gpt-4o-mini` 사용 (현재 설정)
2. 캐싱 전략 구현 (같은 조건의 플랜 재사용)
3. 사용량 모니터링

---

## 다음 단계

- [ ] 플랜 생성 히스토리 저장
- [ ] 플랜 편집 기능 (생성 후 수정)
- [ ] 플랜 템플릿 저장 및 재사용
- [ ] 여러 날짜 일괄 생성
- [ ] 성적 데이터 기반 맞춤 추천

---

## 주의사항

⚠️ **중요:**

- `.env` 파일은 절대 Git에 커밋하지 마세요 (이미 `.gitignore`에 포함됨)
- OpenAI API Key를 안전하게 관리하세요
- 프로덕션 환경에서는 환경 변수 관리 서비스 사용 권장
