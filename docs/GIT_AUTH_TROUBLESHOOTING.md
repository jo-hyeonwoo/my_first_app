# Git 인증 문제 해결 가이드

## 문제: Permission denied (403)

GitHub에 푸시할 때 다음과 같은 에러가 발생하는 경우:

```
remote: Permission to jo-hyeonwoo/my_first_app.git denied to eduatalk23-lgtm.
fatal: unable to access 'https://github.com/jo-hyeonwoo/my_first_app.git/': The requested URL returned error: 403
```

---

## 해결 방법

### 방법 1: Personal Access Token 사용 (권장)

#### 1단계: GitHub Personal Access Token 생성

1. GitHub 접속 > **Settings** > **Developer settings**
2. **Personal access tokens** > **Tokens (classic)**
3. **Generate new token (classic)** 클릭
4. 토큰 이름 입력 (예: `my_first_app_token`)
5. 권한 선택:
   - ✅ `repo` (모든 저장소 접근)
   - ✅ `workflow` (GitHub Actions 사용 시)
6. **Generate token** 클릭
7. **토큰을 복사해 안전한 곳에 보관** (한 번만 표시됨!)

#### 2단계: 저장된 인증 정보 삭제

```bash
# macOS Keychain에서 저장된 GitHub 인증 정보 삭제
git credential-osxkeychain erase
host=github.com
protocol=https
```

또는 Keychain Access 앱에서 직접 삭제:

1. **Keychain Access** 앱 실행
2. 검색창에 `github.com` 입력
3. 관련 항목 모두 삭제

#### 3단계: 새 토큰으로 푸시

```bash
git push
# Username: jo-hyeonwoo (또는 GitHub 사용자명)
# Password: <Personal Access Token> (토큰 붙여넣기)
```

---

### 방법 2: SSH 키 사용

#### 1단계: SSH 키 생성 (이미 있는 경우 생략)

```bash
# SSH 키 생성
ssh-keygen -t ed25519 -C "your_email@example.com"

# SSH 키 복사
cat ~/.ssh/id_ed25519.pub
```

#### 2단계: GitHub에 SSH 키 추가

1. GitHub 접속 > **Settings** > **SSH and GPG keys**
2. **New SSH key** 클릭
3. Title 입력 (예: `MacBook Pro`)
4. Key에 위에서 복사한 공개 키 붙여넣기
5. **Add SSH key** 클릭

#### 3단계: 원격 저장소 URL을 SSH로 변경

```bash
# HTTPS에서 SSH로 변경
git remote set-url origin git@github.com:jo-hyeonwoo/my_first_app.git

# 확인
git remote -v
```

#### 4단계: 푸시 테스트

```bash
git push
```

---

### 방법 3: Credential Helper 재설정

#### macOS에서:

```bash
# 저장된 인증 정보 제거
git credential-osxkeychain erase <<EOF
host=github.com
protocol=https
EOF

# 또는 Keychain Access에서 수동으로 삭제
open /Applications/Utilities/Keychain\ Access.app
```

---

## 확인 사항

### 현재 Git 설정 확인

```bash
# 사용자 이름 확인
git config user.name

# 이메일 확인
git config user.email

# 원격 저장소 확인
git remote -v

# Credential helper 확인
git config credential.helper
```

### 올바른 설정 예시

```bash
# 사용자 이름 설정 (GitHub 사용자명과 동일할 필요 없음)
git config --global user.name "Your Name"

# 이메일 설정 (GitHub 계정과 연결된 이메일)
git config --global user.email "your_email@example.com"
```

---

## 예방 방법

### 1. Personal Access Token 사용

HTTPS로 푸시할 때는 Personal Access Token을 사용하세요:

- 더 안전함
- 만료일 설정 가능
- 특정 권한만 부여 가능

### 2. SSH 키 사용

SSH 키를 사용하면 더 편리합니다:

- 한 번 설정하면 비밀번호 입력 불필요
- 더 안전함

### 3. Git Credential Manager 사용

```bash
# Git Credential Manager 설치 (macOS)
brew install git-credential-manager

# 설정
git config --global credential.credentialStore osxkeychain
```

---

## 빠른 해결 (요약)

1. **Personal Access Token 생성** (GitHub > Settings > Developer settings)
2. **저장된 인증 정보 삭제**:
   ```bash
   git credential-osxkeychain erase
   host=github.com
   protocol=https
   ```
   (빈 줄 입력 후 Enter)
3. **푸시 재시도**:
   ```bash
   git push
   ```
   - Username: GitHub 사용자명
   - Password: Personal Access Token

---

## 참고 링크

- [GitHub Personal Access Tokens 가이드](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- [GitHub SSH Keys 가이드](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [Git Credential Helper 가이드](https://git-scm.com/docs/git-credential)
