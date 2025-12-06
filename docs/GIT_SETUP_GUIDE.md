# Git 설정 및 인증 문제 해결 가이드

## 현재 상황

터미널에서 다음과 같은 문제가 발생했습니다:

1. ✅ Git 저장소는 이미 초기화되어 있음
2. ⚠️ Git 사용자 이름과 이메일이 자동 설정되었지만 확인 필요
3. ❌ 저장된 인증 정보가 `eduatalk23-lgtm` 계정으로 되어 있어 권한 없음
4. ❌ GitHub 푸시 실패 (403 에러)

---

## 단계별 해결 방법

### 1단계: Git 사용자 정보 설정

```bash
# 전역 Git 사용자 이름 설정
git config --global user.name "조현우"

# 전역 Git 이메일 설정 (GitHub 계정 이메일)
git config --global user.email "your_email@example.com"
```

**참고:** 이메일은 GitHub 계정에 등록된 이메일 주소를 사용하세요.

### 2단계: Keychain에서 저장된 GitHub 인증 정보 삭제

#### 방법 A: Keychain Access 앱 사용 (가장 확실함)

1. **Spotlight 검색**에서 `Keychain Access` 입력 후 실행
2. 검색창에 `github.com` 입력
3. 관련 항목 모두 찾기 (여러 개일 수 있음)
4. 각 항목을 선택하고 **Delete** 버튼 클릭
5. 비밀번호 입력하여 확인

#### 방법 B: 터미널 명령어 사용

```bash
# GitHub 관련 모든 키체인 항목 삭제
security delete-internet-password -s github.com 2>/dev/null || true

# 또는 Git credential helper 사용
printf "host=github.com\nprotocol=https\n" | git credential-osxkeychain erase
```

### 3단계: 원격 저장소 확인

```bash
# 현재 원격 저장소 URL 확인
git remote -v

# 올바른 URL인지 확인 (다음과 같이 표시되어야 함)
# origin  https://github.com/jo-hyeonwoo/my_first_app.git (fetch)
# origin  https://github.com/jo-hyeonwoo/my_first_app.git (push)
```

### 4단계: GitHub Personal Access Token 생성

1. **GitHub 접속**: https://github.com
2. 우측 상단 프로필 아이콘 클릭 > **Settings**
3. 좌측 사이드바에서 **Developer settings** 클릭
4. **Personal access tokens** > **Tokens (classic)** 클릭
5. **Generate new token (classic)** 클릭
6. **Note**: `my_first_app_token` (또는 원하는 이름)
7. **Expiration**: 원하는 만료 기간 선택 (예: 90 days)
8. **Select scopes**:
   - ✅ `repo` (모든 체크박스 자동 선택됨)
   - ✅ `workflow` (GitHub Actions 사용 시)
9. 맨 아래 **Generate token** 클릭
10. **토큰 복사** (한 번만 표시되므로 반드시 복사!)
11. 안전한 곳에 저장 (예: 비밀번호 관리자)

### 5단계: 새 토큰으로 푸시

```bash
# 푸시 시도
git push -u origin main
```

**프롬프트가 나타나면:**
- **Username**: `jo-hyeonwoo` (GitHub 사용자명)
- **Password**: 생성한 **Personal Access Token** (토큰 전체를 붙여넣기)

---

## 전체 명령어 요약

터미널에서 다음 명령어들을 순서대로 실행하세요:

```bash
# 1. Git 사용자 정보 설정 (이메일은 본인의 GitHub 이메일로 변경)
git config --global user.name "조현우"
git config --global user.email "your_github_email@example.com"

# 2. Keychain에서 GitHub 인증 정보 삭제
security delete-internet-password -s github.com 2>/dev/null || true

# 3. Git credential helper도 정리
printf "host=github.com\nprotocol=https\n" | git credential-osxkeychain erase

# 4. 설정 확인
git config --global --list | grep user

# 5. 원격 저장소 확인
git remote -v

# 6. 푸시 시도 (토큰 입력 필요)
git push -u origin main
```

---

## 대안: SSH 키 사용 (더 편리함)

한 번 설정하면 비밀번호 입력이 필요 없습니다.

### SSH 키 설정

```bash
# 1. SSH 키 확인 (이미 있으면 생략)
ls -al ~/.ssh

# 2. SSH 키 생성 (없는 경우)
ssh-keygen -t ed25519 -C "your_email@example.com"
# Enter를 눌러 기본 경로 사용
# Passphrase는 선택사항 (안전하게 하려면 입력)

# 3. SSH 키 복사
cat ~/.ssh/id_ed25519.pub
# 또는
pbcopy < ~/.ssh/id_ed25519.pub
```

### GitHub에 SSH 키 추가

1. GitHub 접속 > **Settings** > **SSH and GPG keys**
2. **New SSH key** 클릭
3. **Title**: `MacBook Pro` (원하는 이름)
4. **Key**: 위에서 복사한 공개 키 붙여넣기
5. **Add SSH key** 클릭

### 원격 저장소 URL을 SSH로 변경

```bash
# HTTPS에서 SSH로 변경
git remote set-url origin git@github.com:jo-hyeonwoo/my_first_app.git

# 확인
git remote -v

# 푸시 (비밀번호 불필요!)
git push -u origin main
```

---

## 확인 사항 체크리스트

푸시 전에 다음 사항들을 확인하세요:

- [ ] Git 사용자 이름 설정됨 (`git config user.name` 확인)
- [ ] Git 이메일 설정됨 (`git config user.email` 확인)
- [ ] Keychain에서 오래된 인증 정보 삭제됨
- [ ] GitHub Personal Access Token 생성됨 (HTTPS 사용 시)
- [ ] 또는 SSH 키가 GitHub에 추가됨 (SSH 사용 시)
- [ ] 원격 저장소 URL이 올바름 (`git remote -v` 확인)

---

## 문제가 계속되면

1. **Git 상태 확인**:
   ```bash
   git status
   git log --oneline -5
   ```

2. **원격 저장소 재설정** (필요시):
   ```bash
   git remote remove origin
   git remote add origin https://github.com/jo-hyeonwoo/my_first_app.git
   ```

3. **Git 설정 전체 확인**:
   ```bash
   git config --global --list
   git config --local --list
   ```

---

## 참고 링크

- [GitHub Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- [GitHub SSH Keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [Git 설정 가이드](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup)

