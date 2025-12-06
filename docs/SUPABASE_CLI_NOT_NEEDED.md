# Supabase CLI 사용 안내

## 현재 상황

`npx supabase db push` 명령을 실행하면 다음 오류가 발생합니다:

```
Cannot find project ref. Have you run supabase link?
```

## 프로젝트 설정 방식

현재 이 프로젝트는 **Supabase CLI를 사용하지 않습니다**. 대신 다음 방식을 사용합니다:

1. **Supabase 클라우드 대시보드**에서 직접 SQL 실행
2. **SQL Editor**를 통해 스키마 및 데이터 관리
3. **Flutter 앱**은 `.env` 파일의 URL과 API 키로 연결

## 즉시 해결 방법

### 방법 1: SQL Editor에서 직접 실행 (권장)

Supabase 대시보드에서 SQL을 직접 실행하는 것이 가장 빠릅니다:

1. **Supabase 대시보드 접속**
2. 좌측 사이드바 → **SQL Editor** 클릭
3. **New Query** 클릭
4. SQL 복사해서 붙여넣기
5. **Run** 버튼 클릭

### 방법 2: Supabase CLI 설정 (선택사항)

만약 CLI를 사용하고 싶다면:

```bash
# Supabase CLI 설치 (이미 설치됨)
# npx supabase --version

# 프로젝트 초기화
npx supabase init

# Supabase 프로젝트와 링크
npx supabase link --project-ref YOUR_PROJECT_REF

# 프로젝트 REF 확인 방법:
# Supabase 대시보드 → Settings → General → Reference ID
```

하지만 현재는 **SQL Editor 방식이 더 간단**합니다.

---

## RLS 정책 수정 (무한 재귀 해결)

SQL Editor에서 다음 SQL을 실행하세요:

```sql
-- 기존 문제있는 정책 삭제
DROP POLICY IF EXISTS "Allow users to read own record" ON public.users;

-- 단순화된 정책 생성 (무한 재귀 없음)
CREATE POLICY "Allow users to read own record" ON public.users
  FOR SELECT USING (auth.uid() = id);
```

---

## 테스트 계정 생성

### 1단계: 테넌트 생성

SQL Editor에서 실행:

```sql
INSERT INTO public.tenants (name)
VALUES ('Test Academy')
ON CONFLICT DO NOTHING;
```

테넌트 UUID 확인:

```sql
SELECT id FROM public.tenants WHERE name = 'Test Academy';
```

### 2단계: Authentication에서 사용자 생성

1. **Authentication** → **Users** → **Add user**
2. 학생 계정:
   - Email: `student@test.com`
   - Password: `1234`
   - Auto Confirm User: ✅
3. 선생님 계정:
   - Email: `teacher@test.com`
   - Password: `1234`
   - Auto Confirm User: ✅
4. 각 사용자의 **UUID 복사**

### 3단계: users 테이블에 프로필 추가

SQL Editor에서 실행 (UUID들을 실제 값으로 교체):

```sql
-- TENANT_UUID: 1단계에서 확인한 UUID
-- STUDENT_UUID: 2단계에서 복사한 student@test.com의 UUID
-- TEACHER_UUID: 2단계에서 복사한 teacher@test.com의 UUID

INSERT INTO public.users (id, email, name, role, tenant_id)
VALUES 
  ('STUDENT_UUID', 'student@test.com', 'Kim Student', 'student', 'TENANT_UUID'),
  ('TEACHER_UUID', 'teacher@test.com', 'Lee Teacher', 'consultant', 'TENANT_UUID')
ON CONFLICT (id) DO NOTHING;
```

---

## 참고 문서

- `docs/QUICK_FIX_RLS.md`: RLS 정책 빠른 수정 가이드
- `docs/SUPABASE_SETUP_GUIDE.md`: 전체 설정 가이드
- `docs/FIX_RLS_RECURSION.sql`: RLS 수정 SQL 스크립트

