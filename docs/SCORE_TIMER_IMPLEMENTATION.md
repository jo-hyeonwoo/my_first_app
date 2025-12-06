# Score & Timer Repository Real Implementation

## Phase 2 완료: Score 조회 및 Timer 저장 기능

### 구현 완료 사항

#### 1. SQL Schema 확장 (`docs/SUPABASE_SETUP.sql`)

**Scores 테이블 (9. Create Scores Table):**

- `id`, `tenant_id`, `student_id`, `exam_name`, `exam_date`, `subject`, `raw_score`, `standard_score`, `grade`
- 인덱스: `student_id`, `exam_date`, `tenant_id`

**Student Study Sessions 테이블 (10. Create Student Study Sessions Table):**

- `id`, `tenant_id`, `student_id`, `plan_id`, `start_time`, `end_time`, `duration_seconds`, `status`
- 인덱스: `student_id`, `plan_id`, `start_time`, `tenant_id`

**RLS 정책 (11. Enable RLS for Scores & Study Sessions):**

- Scores:
  - Students can read own scores
  - Consultants can read managed student scores
- Study Sessions:
  - Students can read own sessions
  - Consultants can read managed student sessions
  - Students can insert own sessions

**테스트 데이터 (12. Insert Test Data):**

- 김철수 학생의 성적 9건 (3월, 6월, 9월 모의고사 × 3과목)
- 김철수 학생의 타이머 학습 기록 2건

#### 2. RealScoreRepository 구현 (`lib/features/score/data/repositories/real_score_repository.dart`)

**주요 기능:**

- `getScores(studentId)`: Supabase에서 학생의 성적 목록 조회
- `student_id`로 필터링
- `exam_date` 내림차순 정렬 (최신순)

**JSON 매핑:**

- DB의 snake_case → 엔티티의 camelCase 변환:
  - `exam_name` → `examName`
  - `exam_date` → `date` (DATE 타입을 DateTime으로 파싱)
  - `raw_score` → `rawScore`
  - `standard_score` → `standardScore`
  - `grade` → `grade`

#### 3. RealTimerRepository 구현 (`lib/features/timer/data/repositories/real_timer_repository.dart`)

**주요 기능:**

- `saveSession(StudySession session, String tenantId, String studentId)`: 학습 세션을 DB에 저장
- **첫 번째 Insert 작업** - 앱에서 DB에 데이터를 저장하는 첫 사례

**JSON 매핑:**

- 엔티티의 camelCase → DB의 snake_case 변환:
  - `planId` → `plan_id`
  - `startTime` → `start_time` (DateTime을 ISO8601 문자열로 변환)
  - `endTime` → `end_time`
  - `durationSeconds` → `duration_seconds`
  - `status` → `status` (enum 값을 문자열로 변환)

**tenantId/studentId 처리:**

- TimerRepository 인터페이스에 `tenantId`와 `studentId` 파라미터 추가
- TimerProvider에서 `plan_id`로 플랜을 조회하여 `student_id`와 `tenant_id` 가져오기

#### 4. Dependency Injection 업데이트

**ScoreRepository:**

- `lib/features/score/presentation/providers/score_providers.dart`
  - ✅ `MockScoreRepository` → `RealScoreRepository`로 변경 완료

**TimerRepository:**

- `lib/features/timer/presentation/providers/timer_provider.dart`
  - ✅ `MockTimerRepository` → `RealTimerRepository`로 변경 완료
  - ✅ `stop()` 메서드에서 `plan_id`로 `student_id`와 `tenant_id` 조회 후 저장

**TimerRepository 인터페이스 변경:**

- `saveSession(StudySession session)` → `saveSession(StudySession session, String tenantId, String studentId)`
- `MockTimerRepository`도 함께 업데이트

---

## 다음 단계: Supabase SQL Editor에서 실행할 작업

### 1. 테이블 생성 (9-10 섹션)

`docs/SUPABASE_SETUP.sql` 파일의 9-11 섹션을 Supabase SQL Editor에서 실행:

- Scores 테이블 생성
- Student Study Sessions 테이블 생성
- RLS 정책 설정

### 2. 테스트 데이터 삽입

**2-1. 학생 UUID 확인 (이미 삽입했다면):**

```sql
SELECT id, name FROM public.students WHERE name = '김철수';
```

→ 결과의 UUID를 복사 (`STUDENT_1_UUID`로 사용)

**2-2. Tenant UUID 확인:**

```sql
SELECT id FROM public.tenants WHERE name = 'Test Academy';
```

→ 결과의 UUID를 복사 (`TENANT_UUID`로 사용)

**2-3. 성적 데이터 삽입 (Student 1 - 김철수: 3월, 6월, 9월 모의고사):**

```sql
INSERT INTO public.scores (tenant_id, student_id, exam_name, exam_date, subject, raw_score, standard_score, grade)
VALUES
  -- 3월 모의고사
  ('TENANT_UUID', 'STUDENT_1_UUID', '3월 모의고사', '2025-03-20', '국어', 85, 112, '3'),
  ('TENANT_UUID', 'STUDENT_1_UUID', '3월 모의고사', '2025-03-20', '영어', 78, 105, '4'),
  ('TENANT_UUID', 'STUDENT_1_UUID', '3월 모의고사', '2025-03-20', '수학', 92, 118, '2'),
  -- 6월 모의고사
  ('TENANT_UUID', 'STUDENT_1_UUID', '6월 모의고사', '2025-06-18', '국어', 88, 115, '2'),
  ('TENANT_UUID', 'STUDENT_1_UUID', '6월 모의고사', '2025-06-18', '영어', 82, 110, '3'),
  ('TENANT_UUID', 'STUDENT_1_UUID', '6월 모의고사', '2025-06-18', '수학', 95, 122, '1'),
  -- 9월 모의고사
  ('TENANT_UUID', 'STUDENT_1_UUID', '9월 모의고사', '2025-09-17', '국어', 90, 118, '2'),
  ('TENANT_UUID', 'STUDENT_1_UUID', '9월 모의고사', '2025-09-17', '영어', 86, 114, '2'),
  ('TENANT_UUID', 'STUDENT_1_UUID', '9월 모의고사', '2025-09-17', '수학', 98, 125, '1')
ON CONFLICT DO NOTHING;
```

**2-4. 플랜 UUID 확인 (타이머 테스트용):**

```sql
SELECT id FROM public.student_plans WHERE student_id = 'STUDENT_1_UUID' LIMIT 1;
```

→ 결과의 UUID를 복사 (`PLAN_UUID`로 사용)

**2-5. 타이머 학습 기록 삽입 (Student 1 - 김철수: 2 sessions):**

```sql
INSERT INTO public.student_study_sessions (tenant_id, student_id, plan_id, start_time, end_time, duration_seconds, status)
VALUES
  ('TENANT_UUID', 'STUDENT_1_UUID', 'PLAN_UUID', NOW() - INTERVAL '2 hours', NOW() - INTERVAL '1 hour 50 minutes', 600, 'completed'),
  ('TENANT_UUID', 'STUDENT_1_UUID', 'PLAN_UUID', NOW() - INTERVAL '1 hour', NOW() - INTERVAL '30 minutes', 1800, 'completed')
ON CONFLICT DO NOTHING;
```

---

## 테스트 방법

### 1. 앱 실행

```bash
flutter run
```

### 2. 로그인

- Consultant 계정으로 로그인: `teacher@test.com` / `1234`

### 3. 성적 확인

- 학생 상세 화면에서 "성적" 탭 클릭
- Supabase DB에 삽입한 성적 데이터가 표시되어야 함
- 3월, 6월, 9월 모의고사 데이터가 날짜 내림차순으로 표시되어야 함

### 4. 타이머 테스트

- 학생 상세 화면에서 플랜 카드 클릭 → 타이머 시작
- 타이머를 시작하고 "Stop" 버튼 클릭
- Supabase DB의 `student_study_sessions` 테이블에 데이터가 저장되어야 함
- SQL로 확인:
  ```sql
  SELECT * FROM public.student_study_sessions ORDER BY start_time DESC LIMIT 5;
  ```

---

## 주요 구현 사항

### 1. TimerRepository 인터페이스 확장

기존 인터페이스를 변경하여 `tenantId`와 `studentId`를 받도록 확장:

```dart
// 변경 전
Future<void> saveSession(StudySession session);

// 변경 후
Future<void> saveSession(
  StudySession session,
  String tenantId,
  String studentId,
);
```

이로 인해:

- `MockTimerRepository`도 함께 업데이트 필요
- `TimerProvider`에서 `plan_id`로 `student_id`와 `tenant_id` 조회 후 전달

### 2. plan_id로 student_id 조회

TimerProvider의 `stop()` 메서드에서:

1. `plan_id`로 `student_plans` 테이블에서 플랜 조회
2. 플랜의 `student_id`와 `tenant_id` 추출
3. Repository에 전달하여 저장

### 3. 첫 번째 Insert 작업

Timer 저장이 앱에서 DB에 데이터를 저장하는 첫 번째 사례:

- Supabase의 `insert()` 메서드 사용
- RLS 정책에 의해 학생만 자신의 세션을 저장할 수 있음

---

## 파일 변경 사항

### 수정된 파일:

1. `docs/SUPABASE_SETUP.sql` - Scores 및 Study Sessions 테이블 추가
2. `lib/features/timer/domain/repositories/timer_repository.dart` - 인터페이스 확장
3. `lib/features/timer/data/repositories/mock_timer_repository.dart` - 인터페이스 변경에 맞춰 업데이트
4. `lib/features/score/presentation/providers/score_providers.dart` - RealScoreRepository 사용
5. `lib/features/timer/presentation/providers/timer_provider.dart` - RealTimerRepository 사용 + plan_id로 조회

### 새로 생성된 파일:

1. `lib/features/score/data/repositories/real_score_repository.dart` - RealScoreRepository 구현
2. `lib/features/timer/data/repositories/real_timer_repository.dart` - RealTimerRepository 구현

---

## 주의사항

### 1. TimerRepository 인터페이스 변경

- 인터페이스를 변경했으므로 모든 구현체가 업데이트되어야 함
- Mock과 Real 모두 동일한 시그니처를 가짐

### 2. plan_id로 student_id 조회

- TimerProvider에서 매번 DB 조회가 발생
- 향후 최적화 가능: plan 객체를 전달하거나 캐싱

### 3. RLS 정책

- Students can insert own sessions 정책으로 학생만 자신의 세션을 저장 가능
- Consultant는 읽기만 가능 (현재 구현)

---

## 다음 단계

1. **Supabase SQL Editor에서 테스트 데이터 삽입** (위 섹션 참고)
2. **앱 실행 및 테스트**
3. **추가 기능 구현:**
   - 성적 생성/수정 기능
   - 학습 기록 조회 기능
   - 통계 및 분석 기능
