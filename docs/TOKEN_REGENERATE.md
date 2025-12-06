# GitHub Personal Access Token 재생성 가이드

## 문제

현재 토큰에 `workflow` 권한이 없어서 `.github/workflows/flutter_ci.yml` 파일을 푸시할 수 없습니다.

**에러 메시지:**
```
refusing to allow a Personal Access Token to create or update workflow 
`.github/workflows/flutter_ci.yml` without `workflow` scope
```

## 해결 방법

### 1단계: 기존 토큰 삭제 (보안)

토큰이 이미 노출되었으므로 삭제하는 것을 권장합니다.

1. 브라우저에서 접속: https://github.com/settings/tokens
2. 생성했던 토큰(`my_first_app_token`) 찾기
3. 우측의 **Delete** 버튼 클릭
4. 확인

### 2단계: 새 토큰 생성 (workflow 권한 포함)

1. 브라우저에서 접속: https://github.com/settings/tokens
2. **Generate new token** > **Generate new token (classic)** 클릭
3. **Note**: `my_first_app_token_v2` 입력
4. **Expiration**: `90 days` 선택
5. **Select scopes**: 다음 권한들을 체크:
   - ✅ `repo` (모든 저장소 권한 - 하위 항목 자동 선택됨)
   - ✅ `workflow` (GitHub Actions 워크플로우 업데이트)
6. 맨 아래 **Generate token** 클릭
7. **생성된 토큰을 복사** (예: `ghp_xxxxxxxxxxxxxxxxxxxx`)
8. **안전한 곳에 저장** (한 번만 표시됨!)

### 3단계: 새 토큰으로 푸시

터미널에서:

```bash
# 원격 저장소 URL에 새 토큰 포함
git remote set-url origin https://새토큰@github.com/jo-hyeonwoo/my_first_app.git

# 푸시
git push -u origin main
```

또는 더 안전한 방법:

```bash
# 원격 저장소 URL은 그대로 유지
git remote set-url origin https://github.com/jo-hyeonwoo/my_first_app.git

# 푸시 시 토큰 입력
git push -u origin main
# Username: jo-hyeonwoo
# Password: 새로 생성한 토큰
```

## 보안 주의사항

⚠️ **중요:**

1. **토큰을 공개적으로 공유하지 마세요**
   - GitHub에 커밋하지 마세요
   - 채팅방에 붙여넣지 마세요
   - 이메일로 전송하지 마세요

2. **토큰이 노출되었다면 즉시 삭제하고 재생성하세요**

3. **토큰은 비밀번호처럼 취급하세요**

4. **토큰은 안전한 비밀번호 관리자에 저장하세요**

## 권장: SSH 키 사용

Personal Access Token 대신 SSH 키를 사용하면 더 안전하고 편리합니다:

```bash
# SSH 키 생성
ssh-keygen -t ed25519 -C "a01058830723@gmail.com"

# 공개 키 복사
pbcopy < ~/.ssh/id_ed25519.pub

# GitHub에 추가: https://github.com/settings/keys

# 원격 저장소 URL을 SSH로 변경
git remote set-url origin git@github.com:jo-hyeonwoo/my_first_app.git

# 푸시 (비밀번호 불필요!)
git push -u origin main
```

## 토큰 생성 링크

- 직접 링크: https://github.com/settings/tokens
- 경로: GitHub > Settings > Developer settings > Personal access tokens > Tokens (classic)

