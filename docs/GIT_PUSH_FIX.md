# Git 푸시 문제 완전 해결 가이드

## 현재 상황

Git 설정은 완료되었지만, 여전히 `eduatalk23-lgtm` 계정으로 인증을 시도하고 있습니다.

```
remote: Permission to jo-hyeonwoo/my_first_app.git denied to eduatalk23-lgtm.
fatal: unable to access 'https://github.com/jo-hyeonwoo/my_first_app.git/': The requested URL returned error: 403
```

---

## 완전한 해결 방법

### 방법 1: Keychain Access 앱에서 수동 삭제 (가장 확실함)

1. **Spotlight 검색** (`Cmd + Space`)에서 `Keychain Access` 입력 후 실행
2. 검색창(좌측 상단)에 `github` 입력
3. 나오는 모든 항목 확인:
   - `github.com`
   - `GitHub`
   - `eduatalk23-lgtm` (있다면)
   - 기타 GitHub 관련 항목
4. 각 항목을 선택하고 **Delete** 버튼 클릭
5. macOS 비밀번호 입력하여 확인
6. 모든 GitHub 관련 항목이 사라질 때까지 반복

### 방법 2: Personal Access Token 사용 (권장)

Keychain을 삭제한 후, Personal Access Token으로 인증하면 더 안전하고 확실합니다.

#### 1단계: GitHub Personal Access Token 생성

1. 브라우저에서 접속: https://github.com/settings/tokens
2. **Generate new token** > **Generate new token (classic)** 클릭
3. **Note**: `my_first_app_token` (원하는 이름)
4. **Expiration**: `90 days` (또는 원하는 기간)
5. **Select scopes**:
   - ✅ `repo` 체크 (하위 항목 자동 선택됨)
6. 맨 아래 **Generate token** 클릭
7. **생성된 토큰을 복사** (예: `ghp_xxxxxxxxxxxxxxxxxxxx`)
8. **안전한 곳에 저장** (한 번만 표시됨!)

#### 2단계: 토큰으로 푸시

터미널에서:

```bash
git push -u origin main
```

프롬프트가 나타나면:

- **Username**: `jo-hyeonwoo`
- **Password**: 생성한 **Personal Access Token** (토큰 전체 붙여넣기)

### 방법 3: SSH 키 사용 (한 번 설정하면 편함)

#### 1단계: SSH 키 확인 및 생성

```bash
# SSH 키 확인
ls -al ~/.ssh

# SSH 키가 없다면 생성
ssh-keygen -t ed25519 -C "a01058830723@gmail.com"
# Enter를 눌러 기본 경로 사용
# Passphrase는 선택사항 (Enter로 스킵 가능)

# 공개 키 복사
cat ~/.ssh/id_ed25519.pub
# 또는 클립보드에 복사
pbcopy < ~/.ssh/id_ed25519.pub
```

#### 2단계: GitHub에 SSH 키 추가

1. 브라우저에서 접속: https://github.com/settings/keys
2. **New SSH key** 클릭
3. **Title**: `MacBook Pro` (원하는 이름)
4. **Key**: 위에서 복사한 공개 키 붙여넣기
5. **Add SSH key** 클릭

#### 3단계: 원격 저장소 URL을 SSH로 변경

```bash
# HTTPS에서 SSH로 변경
git remote set-url origin git@github.com:jo-hyeonwoo/my_first_app.git

# 확인
git remote -v

# 푸시 (비밀번호 불필요!)
git push -u origin main
```

---

## 즉시 해결: 한 번에 실행할 명령어

터미널에서 다음 명령어들을 순서대로 실행하세요:

```bash
# 1. Keychain Access 앱 열기 (수동으로 github 항목 삭제 필요)
open /Applications/Utilities/Keychain\ Access.app

# 위 앱에서 github 관련 항목을 모두 삭제한 후 아래 명령어 실행:

# 2. Git 설정 확인 (이미 완료되었지만 확인)
git config --global user.name
git config --global user.email

# 3. 원격 저장소 확인
git remote -v

# 4. Personal Access Token 생성 후 푸시
# (토큰 생성: https://github.com/settings/tokens)
git push -u origin main
```

---

## 체크리스트

푸시 전에 확인하세요:

- [x] Git 사용자 이름 설정됨 (`조현우`)
- [x] Git 이메일 설정됨 (`a01058830723@gmail.com`)
- [ ] Keychain Access 앱에서 `github` 관련 항목 모두 삭제됨
- [ ] GitHub Personal Access Token 생성됨 (HTTPS 사용 시)
- [ ] 또는 SSH 키가 GitHub에 추가됨 (SSH 사용 시)

---

## 빠른 참조

### Personal Access Token 생성 링크

- 직접 링크: https://github.com/settings/tokens
- 경로: GitHub > Settings > Developer settings > Personal access tokens > Tokens (classic)

### SSH 키 설정 링크

- 직접 링크: https://github.com/settings/keys
- 경로: GitHub > Settings > SSH and GPG keys

---

## 문제가 계속되면

1. **브라우저에서 GitHub 로그인 확인**:

   - https://github.com 에서 로그아웃 후 다시 로그인
   - 올바른 계정(`jo-hyeonwoo`)으로 로그인되어 있는지 확인

2. **저장소 권한 확인**:

   - 저장소 URL이 올바른지 확인: `jo-hyeonwoo/my_first_app`
   - 저장소에 접근 권한이 있는지 확인

3. **Git 상태 확인**:
   ```bash
   git status
   git log --oneline -5
   ```

---

## 추천 방법

**가장 빠르고 확실한 방법:**

1. Keychain Access 앱에서 `github` 관련 항목 **모두 삭제**
2. Personal Access Token 생성 (2분 소요)
3. 토큰으로 푸시

이 방법이 가장 확실하고 안전합니다!
