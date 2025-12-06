# 빠른 해결 가이드

## 현재 상황

- ✅ Git 사용자 정보 설정 완료
- ✅ Keychain 명령어 실행 완료
- ❌ 여전히 `eduatalk23-lgtm` 계정으로 인증 시도

## 즉시 해결 방법

### 방법 1: Keychain Access 앱에서 수동 삭제 (가장 확실함)

Keychain Access 앱이 열렸습니다. 다음 단계를 따르세요:

1. **검색창** (좌측 상단)에 `github` 입력
2. 나오는 **모든 항목** 확인:
   - `github.com`
   - `GitHub`
   - `eduatalk23-lgtm` (있다면)
3. 각 항목을 선택하고 **Delete** 버튼 클릭
4. macOS 비밀번호 입력하여 확인
5. 모든 GitHub 관련 항목이 사라질 때까지 반복

### 방법 2: Personal Access Token 사용 (권장)

Keychain을 삭제한 후, Personal Access Token으로 인증하세요.

#### 1단계: GitHub Personal Access Token 생성

브라우저에서 접속:
👉 https://github.com/settings/tokens

1. **Generate new token** > **Generate new token (classic)** 클릭
2. **Note**: `my_first_app_token` 입력
3. **Expiration**: `90 days` 선택
4. **Select scopes**: ✅ `repo` 체크
5. **Generate token** 클릭
6. **생성된 토큰을 복사** (예: `ghp_xxxxxxxxxxxxxxxxxxxx`)
7. **안전한 곳에 저장** (한 번만 표시됨!)

#### 2단계: 토큰으로 푸시

터미널에서:

```bash
git push -u origin main
```

프롬프트가 나타나면:

- **Username**: `jo-hyeonwoo`
- **Password**: 위에서 생성한 **Personal Access Token** (토큰 전체 붙여넣기)

---

## 전체 프로세스 요약

```bash
# 1. Keychain Access 앱에서 github 관련 항목 모두 삭제 (수동)

# 2. Personal Access Token 생성 (브라우저)
#    https://github.com/settings/tokens

# 3. 푸시
git push -u origin main
# Username: jo-hyeonwoo
# Password: 생성한 토큰
```

---

## 대안: SSH 키 사용 (더 편리함)

한 번 설정하면 비밀번호 입력이 필요 없습니다.

### SSH 키 설정

```bash
# SSH 키 확인
ls -al ~/.ssh

# SSH 키 생성 (없는 경우)
ssh-keygen -t ed25519 -C "a01058830723@gmail.com"
# Enter를 눌러 기본 경로 사용
# Passphrase는 Enter로 스킵 가능

# 공개 키 복사
pbcopy < ~/.ssh/id_ed25519.pub
```

### GitHub에 SSH 키 추가

1. 브라우저에서 접속: https://github.com/settings/keys
2. **New SSH key** 클릭
3. **Title**: `MacBook Pro`
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

## 현재 Git 설정 확인

✅ **Git 사용자**: 조현우
✅ **Git 이메일**: a01058830723@gmail.com
✅ **원격 저장소**: https://github.com/jo-hyeonwoo/my_first_app.git

다음 단계만 진행하시면 됩니다!
