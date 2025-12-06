# 🔧 빠른 수정: RLS 무한 재귀 오류 해결

## 문제

로그인 시 다음 오류가 발생합니다:
```
PostgrestException(message: infinite recursion detected in policy for relation "users", code: 42P17)
```

## 즉시 해결 방법

### Supabase SQL Editor에서 실행

1. **Supabase 대시보드 접속**
2. 좌측 사이드바 → **SQL Editor** 클릭
3. **New Query** 클릭
4. 다음 SQL을 복사해서 붙여넣기:

```sql
-- 기존 문제있는 정책 삭제
DROP POLICY IF EXISTS "Allow users to read own record" ON public.users;

-- 단순화된 정책 생성 (무한 재귀 없음)
CREATE POLICY "Allow users to read own record" ON public.users
  FOR SELECT USING (auth.uid() = id);
```

5. **Run** 버튼 클릭 (또는 Ctrl+Enter)

### 완료!

이제 앱을 다시 실행하고 로그인을 시도해보세요. 무한 재귀 오류가 해결되어야 합니다.

---

## 상세 설명

**문제 원인:**
- 기존 RLS 정책이 `public.users` 테이블을 읽을 때, 정책 내부에서 다시 `public.users` 테이블을 쿼리
- 이것이 무한 재귀를 일으킴

**해결 방법:**
- 정책을 단순화하여 각 사용자가 자신의 레코드만 읽을 수 있도록 변경
- Admin 체크 로직 제거 (무한 재귀 원인)

---

## 확인

정책이 올바르게 생성되었는지 확인:

```sql
SELECT schemaname, tablename, policyname, qual
FROM pg_policies
WHERE tablename = 'users';
```

결과에 `auth.uid() = id`만 있어야 합니다.

---

## 참고

더 자세한 내용은 `docs/RLS_RECURSION_FIX.md`를 참고하세요.

