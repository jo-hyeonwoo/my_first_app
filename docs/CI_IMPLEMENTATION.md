# CI/CD Implementation Guide

## 개요

GitHub Actions를 사용하여 Flutter 앱의 CI/CD 파이프라인을 구현했습니다.

---

## 구현 완료 사항

### 1. CI Workflow Definition

**파일:** `.github/workflows/flutter_ci.yml`

**트리거:**
- `main` 브랜치에 `push`될 때
- `main` 브랜치에 대한 `pull_request`가 생성될 때

**실행 단계:**
1. **Checkout**: 저장소 체크아웃
2. **Setup Flutter**: 최신 stable Flutter 설치
3. **Install dependencies**: `flutter pub get` 실행
4. **Create .env file**: GitHub Secrets로부터 `.env` 파일 생성
5. **Run code generation**: `build_runner` 실행 (Freezed, json_serializable 등)
6. **Analyze code**: `flutter analyze` 실행
7. **Build APK**: 디버그 APK 빌드 테스트

---

### 2. Secret Management Strategy

**문서:** `docs/GITHUB_CI_SETUP.md`

CI 환경에서는 `.env` 파일이 없으므로 GitHub Secrets를 사용하여 환경 변수를 주입합니다.

**필수 Secrets:**
- `SUPABASE_URL`: Supabase 프로젝트 URL
- `SUPABASE_ANON_KEY`: Supabase Anon Key

**선택적 Secrets:**
- `OPENAI_API_KEY`: OpenAI API Key (OpenAI 사용 시)
- `GEMINI_API_KEY`: Google Gemini API Key (Gemini 사용 시)
- `AI_PROVIDER`: AI Provider (openai/gemini)
- `SENTRY_DSN`: Sentry DSN

**설정 방법:**
1. GitHub 저장소 > **Settings** > **Secrets and variables** > **Actions**
2. **New repository secret** 클릭
3. Secrets 추가

---

### 3. Linter 경고 정리

**수정 사항:**
- ✅ Import 충돌 해결 (User, AuthException)
- ✅ Deprecated 경고 수정 (background/onBackground → surface/onSurface)
- ✅ Unused imports 제거
- ✅ 불필요한 문자열 보간 중괄호 제거

**참고:**
- 일부 에러는 `build_runner`로 생성되는 파일들이 없어서 발생하는 것으로, CI 워크플로우에서 자동으로 해결됩니다.
- Deprecated 경고 중 일부는 패키지 업데이트로 해결될 예정입니다.

---

## GitHub Secrets 설정 가이드

### 필수 단계

1. **GitHub 저장소로 이동**
   ```
   https://github.com/your-username/your-repo
   ```

2. **Settings 탭 클릭**

3. **좌측 사이드바에서 Secrets and variables > Actions 선택**

4. **New repository secret 클릭**

5. **필수 Secrets 추가:**

   | Secret 이름 | 설명 | 예시 |
   |------------|------|------|
   | `SUPABASE_URL` | Supabase 프로젝트 URL | `https://xxx.supabase.co` |
   | `SUPABASE_ANON_KEY` | Supabase Anon Key | `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` |

6. **선택적 Secrets 추가 (필요 시):**

   | Secret 이름 | 설명 | 예시 |
   |------------|------|------|
   | `OPENAI_API_KEY` | OpenAI API Key | `sk-xxx...` |
   | `GEMINI_API_KEY` | Google Gemini API Key | `xxx...` |
   | `AI_PROVIDER` | AI Provider | `openai` 또는 `gemini` |
   | `SENTRY_DSN` | Sentry DSN | `https://xxx@xxx.ingest.sentry.io/xxx` |

---

## CI 실행 확인

### 로컬에서 테스트

```bash
# 1. 의존성 설치
flutter pub get

# 2. 코드 생성 (중요!)
flutter pub run build_runner build --delete-conflicting-outputs

# 3. 코드 분석
flutter analyze

# 4. 빌드 테스트
flutter build apk --debug --no-pub
```

### GitHub에서 확인

1. 저장소의 **Actions** 탭으로 이동
2. 최근 워크플로우 실행 결과 확인
3. ✅ 성공 또는 ❌ 실패 표시 확인

---

## 워크플로우 파일 구조

```yaml
name: Flutter CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout repository
      - name: Setup Flutter
      - name: Install dependencies
      - name: Create .env file from secrets
      - name: Run code generation
      - name: Analyze code
      - name: Build APK (debug)
```

---

## 트러블슈팅

### Issue: "Secrets not found" 경고

**원인:** GitHub Secrets가 설정되지 않음

**해결:**
- Secrets가 필수인 경우: Settings > Secrets에서 추가
- Secrets가 선택인 경우: 경고 무시 가능 (워크플로우가 계속 진행됨)

### Issue: "Code generation failed"

**원인:** `build_runner` 실행 전에 코드 생성이 필요

**해결:**
- CI 워크플로우에 "Run code generation" 스텝이 포함되어 있는지 확인
- 로컬에서 `flutter pub run build_runner build --delete-conflicting-outputs` 실행

### Issue: "Analyze failed"

**원인:** 코드 분석에서 에러 또는 경고 발견

**해결:**
- 로컬에서 `flutter analyze` 실행하여 문제 확인
- 경고를 수정하거나 `analysis_options.yaml`에서 무시 규칙 추가

### Issue: "Build failed"

**원인:** APK 빌드 중 에러 발생

**해결:**
- 로컬에서 `flutter build apk --debug` 실행하여 문제 확인
- 에러 메시지 확인 및 수정

---

## 다음 단계

- [ ] 테스트 자동화 추가
- [ ] 코드 커버리지 리포트 생성
- [ ] 자동 배포 파이프라인 구축 (예: Google Play, App Store)
- [ ] 성능 테스트 추가

---

## 참고 문서

- [GitHub Actions 문서](https://docs.github.com/en/actions)
- [Flutter CI/CD 가이드](https://docs.flutter.dev/deployment/cd)
- [GitHub Secrets 가이드](https://docs.github.com/en/actions/security-guides/encrypted-secrets)

