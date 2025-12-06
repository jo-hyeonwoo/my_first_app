# Student & Plan Repository Real Implementation

## Phase 2: Real Repository Implementation Summary

### 구현 완료 사항

#### 1. SQL Schema 개선 (`docs/SUPABASE_SETUP.sql`)

- **Students 테이블**: 이미 정의되어 있음
  - `id`, `tenant_id`, `name`, `school_name`, `grade`, `status`, `primary_consultant_id`, `last_login_at`
  
- **Student Plans 테이블**: 이미 정의되어 있음
  - `id`, `tenant_id`, `student_id`, `plan_date`, `title`, `type`, `expected_minutes`, `status`

- **RLS 정책**: 이미 구현되어 있음
  - Consultants can read managed students
  - Students can read self
  - Consultants can read managed student plans

- **테스트 데이터**: 개선된 INSERT 쿼리 추가
  - 학생 2명 (김철수, 이영희)
  - 각 학생별 플랜 3개씩 (총 6개)

#### 2. RealStudentRepository 구현 (`lib/features/student/data/repositories/real_student_repository.dart`)

**주요 기능:**
- `getManagedStudents(consultantId)`: Supabase에서 학생 목록 조회
- `primary_consultant_id`로 필터링
- 정렬: status (active first), last_login_at (최신순)

**JSON 매핑:**
- DB의 snake_case → 엔티티의 camelCase 변환
  - `school_name` → `schoolName`
  - `last_login_at` → `lastLoginAt`
  - `tenant_id` → `tenantId`
- Nullable 필드 처리:
  - `school_name`: null이면 빈 문자열
  - `grade`: null이면 0
  - `last_login_at`: null이면 현재 시간

#### 3. RealPlanRepository 구현 (`lib/features/plan/data/repositories/real_plan_repository.dart`)

**주요 기능:**
- `getTodayPlans(studentId, date)`: 특정 날짜의 플랜 조회
- `student_id`와 `plan_date`로 필터링
- `created_at` 기준 정렬

**JSON 매핑:**
- DB 스키마는 단순하지만, 엔티티는 더 많은 필드를 가짐
- DB에 없는 필드들은 기본값/빈 값으로 처리:
  - `planGroupId`: plan ID를 사용 (필수 필드)
  - `subjectId`, `masterBookId` 등: null
  - `notes`: null
  - `meta`: 빈 Map
- Status 변환: DB의 `in_progress` → 엔티티의 `inProgress`
- Date 형식 변환: DATE 타입을 DateTime으로 파싱

#### 4. Dependency Injection 업데이트

**StudentRepository:**
- `lib/features/student/presentation/providers/student_list_provider.dart`
  - ✅ 이미 `RealStudentRepository` 사용 중

**PlanRepository:**
- `lib/features/plan/presentation/providers/plan_providers.dart`
  - ✅ `MockPlanRepository` → `RealPlanRepository`로 변경 완료

---

## 다음 단계: Supabase SQL Editor에서 실행할 작업

### 1. 테이블 생성 (이미 완료된 경우 스킵)

`docs/SUPABASE_SETUP.sql` 파일의 1-7 섹션을 Supabase SQL Editor에서 실행:
- Tenants 테이블 생성
- Users 테이블 생성
- Students 테이블 생성
- Student Plans 테이블 생성
- RLS 정책 설정

### 2. 테스트 데이터 삽입

**2-1. Tenant ID 확인:**
```sql
SELECT id FROM public.tenants WHERE name = 'Test Academy';
```
→ 결과의 UUID를 복사 (`TENANT_UUID`로 사용)

**2-2. Consultant ID 확인:**
```sql
SELECT id FROM public.users WHERE email = 'teacher@test.com';
```
→ 결과의 UUID를 복사 (`CONSULTANT_UUID`로 사용)

**2-3. 학생 데이터 삽입:**
```sql
INSERT INTO public.students (tenant_id, name, school_name, grade, status, primary_consultant_id, last_login_at)
VALUES
  ('TENANT_UUID', '김철수', '서울고등학교', 2, 'active', 'CONSULTANT_UUID', NOW() - INTERVAL '2 hours'),
  ('TENANT_UUID', '이영희', '서울고등학교', 3, 'active', 'CONSULTANT_UUID', NOW() - INTERVAL '1 day')
ON CONFLICT DO NOTHING;
```
→ `TENANT_UUID`와 `CONSULTANT_UUID`를 실제 값으로 교체

**2-4. 학생 UUID 확인:**
```sql
SELECT id, name FROM public.students WHERE name IN ('김철수', '이영희');
```
→ 결과의 UUID를 복사 (`STUDENT_1_UUID`, `STUDENT_2_UUID`로 사용)

**2-5. 플랜 데이터 삽입 (학생 1 - 김철수):**
```sql
INSERT INTO public.student_plans (tenant_id, student_id, plan_date, title, type, expected_minutes, status)
VALUES
  ('TENANT_UUID', 'STUDENT_1_UUID', CURRENT_DATE, '수학 예제 풀기', 'study', 60, 'completed'),
  ('TENANT_UUID', 'STUDENT_1_UUID', CURRENT_DATE, '영어 단어 암기', 'study', 30, 'in_progress'),
  ('TENANT_UUID', 'STUDENT_1_UUID', CURRENT_DATE, '국어 복습', 'review', 45, 'pending')
ON CONFLICT DO NOTHING;
```

**2-6. 플랜 데이터 삽입 (학생 2 - 이영희):**
```sql
INSERT INTO public.student_plans (tenant_id, student_id, plan_date, title, type, expected_minutes, status)
VALUES
  ('TENANT_UUID', 'STUDENT_2_UUID', CURRENT_DATE, '수학 모의고사', 'study', 120, 'completed'),
  ('TENANT_UUID', 'STUDENT_2_UUID', CURRENT_DATE, '영어 독해', 'study', 60, 'pending'),
  ('TENANT_UUID', 'STUDENT_2_UUID', CURRENT_DATE, '과학 정리', 'review', 45, 'pending')
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

### 3. 학생 목록 확인
- 홈 화면에서 관리하는 학생 목록이 표시되어야 함
- Supabase DB에 삽입한 학생 2명이 표시되어야 함

### 4. 플랜 확인
- 학생 상세 화면에서 오늘 날짜의 플랜이 표시되어야 함
- 각 학생당 3개의 플랜이 표시되어야 함

---

## 주의사항

### 1. JSON 키 매핑
- Supabase는 snake_case를 사용하지만, Dart 엔티티는 camelCase를 사용
- 모든 Repository에서 변환 로직 구현 완료

### 2. Nullable 필드 처리
- DB에서 nullable인 필드들 (`school_name`, `grade`, `last_login_at`)은 기본값 제공
- 엔티티의 required 필드와의 불일치 해결

### 3. StudentPlan 엔티티와 DB 스키마 불일치
- 엔티티는 많은 필드를 가지고 있지만, DB 스키마는 단순함
- DB에 없는 필드들은 null 또는 기본값으로 처리
- 향후 DB 스키마 확장 시 매핑 로직 업데이트 필요

### 4. Status Enum 변환
- DB: `in_progress` (snake_case)
- 엔티티: `inProgress` (camelCase)
- 변환 로직 구현 완료

---

## 파일 변경 사항

### 수정된 파일:
1. `docs/SUPABASE_SETUP.sql` - 테스트 데이터 INSERT 쿼리 개선
2. `lib/features/student/data/repositories/real_student_repository.dart` - JSON 매핑 구현
3. `lib/features/plan/data/repositories/real_plan_repository.dart` - JSON 매핑 구현 및 DB 스키마 맞춤
4. `lib/features/plan/presentation/providers/plan_providers.dart` - RealPlanRepository 사용

### 확인 완료:
- ✅ Student 엔티티의 JSON 매핑 (`@JsonKey` 불필요, 수동 변환 사용)
- ✅ StudentPlan 엔티티의 JSON 매핑 (DB 스키마에 맞게 변환)
- ✅ RLS 정책 (이미 SQL 파일에 정의되어 있음)
- ✅ Provider DI 설정 (Mock → Real 교체 완료)

---

## 다음 단계

1. **Supabase SQL Editor에서 테스트 데이터 삽입** (위 섹션 참고)
2. **앱 실행 및 테스트**
3. **추가 기능 구현:**
   - Score Repository (Real Implementation)
   - Timer Repository (Real Implementation)
   - 플랜 생성/수정 기능

