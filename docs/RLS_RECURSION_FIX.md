# RLS 정책 무한 재귀 문제 해결

## 문제 상황

로그인 시 다음 오류가 발생했습니다:

```
PostgrestException(message: infinite recursion detected in policy for relation "users", code: 42P17)
```

## 원인

`docs/SUPABASE_SETUP.sql` 파일의 `users` 테이블 RLS 정책에서 무한 재귀가 발생하고 있습니다:

```sql
CREATE POLICY "Allow users to read own record" ON public.users
  FOR SELECT USING (
    auth.uid() = id OR
    auth.uid()::text IN (SELECT id::text FROM public.users WHERE tenant_id = users.tenant_id AND role = 'admin')
  );
```

**문제점:**
- `public.users` 테이블을 읽을 때 RLS 정책이 평가됨
- 정책 내부에서 다시 `SELECT id::text FROM public.users`를 쿼리
- 이 쿼리가 다시 RLS 정책을 평가하려고 하면서 무한 재귀 발생

## 해결 방법

RLS 정책을 단순화하여 자기 자신의 레코드만 읽을 수 있도록 변경합니다.

### 수정된 SQL 스크립트

Supabase SQL Editor에서 다음 SQL을 실행하세요:

```sql
-- 기존 정책 삭제
DROP POLICY IF EXISTS "Allow users to read own record" ON public.users;

-- 단순화된 정책 생성 (무한 재귀 없음)
CREATE POLICY "Allow users to read own record" ON public.users
  FOR SELECT USING (auth.uid() = id);
```

### 변경 사항

**이전 (문제 있음):**
```sql
CREATE POLICY "Allow users to read own record" ON public.users
  FOR SELECT USING (
    auth.uid() = id OR
    auth.uid()::text IN (SELECT id::text FROM public.users WHERE ...)  -- ❌ 무한 재귀
  );
```

**수정 후 (올바름):**
```sql
CREATE POLICY "Allow users to read own record" ON public.users
  FOR SELECT USING (auth.uid() = id);  -- ✅ 단순하고 안전
```

## 적용 방법

### 1. Supabase SQL Editor에서 실행

1. Supabase 대시보드 접속
2. 좌측 사이드바에서 **SQL Editor** 클릭
3. **New Query** 클릭
4. 다음 SQL 실행:

```sql
-- 기존 정책 삭제
DROP POLICY IF EXISTS "Allow users to read own record" ON public.users;

-- 단순화된 정책 생성
CREATE POLICY "Allow users to read own record" ON public.users
  FOR SELECT USING (auth.uid() = id);
```

5. **Run** 클릭

### 2. 확인

정책이 제대로 생성되었는지 확인:

```sql
-- RLS 정책 확인
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE tablename = 'users';
```

## 추가 고려사항

### Admin 사용자가 모든 사용자를 읽어야 하는 경우

현재 정책은 각 사용자가 자신의 레코드만 읽을 수 있습니다. Admin 사용자가 테넌트 내의 모든 사용자를 읽어야 한다면, 다음 접근 방식을 사용할 수 있습니다:

1. **별도의 함수 사용**: RLS 재귀를 피하기 위해 SECURITY DEFINER 함수 사용
2. **별도의 정책 추가**: Admin 전용 정책을 별도로 생성
3. **클라이언트 측 필터링**: Admin 권한은 애플리케이션 레벨에서 처리

현재는 로그인 기능만 필요하므로, 단순한 정책으로 충분합니다.

## 관련 파일

- `docs/SUPABASE_SETUP.sql`: 원본 SQL 설정 파일 (수정 필요)
- `docs/FIX_RLS_RECURSION.sql`: 수정된 SQL 스크립트
- `lib/features/auth/data/repositories/real_auth_repository.dart`: 로그인 로직

## 다음 단계

1. ✅ SQL Editor에서 수정된 정책 실행
2. ✅ 앱 재실행 및 로그인 테스트
3. ✅ 무한 재귀 오류 해결 확인

## 참고

- [PostgreSQL RLS 문서](https://www.postgresql.org/docs/current/ddl-rowsecurity.html)
- [Supabase RLS 가이드](https://supabase.com/docs/guides/auth/row-level-security)

