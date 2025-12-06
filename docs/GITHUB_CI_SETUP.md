# GitHub Actions CI/CD Setup Guide

## 개요

이 가이드는 GitHub Actions를 사용하여 Flutter 앱의 CI/CD 파이프라인을 설정하는 방법을 설명합니다.

---

## CI 워크플로우 구조

### 파일 위치

- `.github/workflows/flutter_ci.yml`

### 트리거

- `main` 브랜치에 `push`될 때
- `main` 브랜치에 대한 `pull_request`가 생성될 때

### 실행 단계

1. **Checkout**: 저장소 체크아웃
2. **Setup Flutter**: 최신 stable Flutter 설치
3. **Install dependencies**: `flutter pub get` 실행
4. **Create .env file**: GitHub Secrets로부터 `.env` 파일 생성
5. **Run code generation**: `build_runner` 실행 (Freezed, json_serializable 등)
6. **Analyze code**: `flutter analyze` 실행
7. **Build APK**: 디버그 APK 빌드 테스트

---

## GitHub Secrets 설정

`.env` 파일은 `.gitignore`에 포함되어 있어 Git에 커밋되지 않습니다. CI 환경에서는 GitHub Secrets를 사용하여 환경 변수를 주입합니다.

### Secrets 설정 방법

1. GitHub 저장소로 이동
2. **Settings** 탭 클릭
3. 좌측 사이드바에서 **Secrets and variables** > **Actions** 선택
4. **New repository secret** 클릭
5. 다음 Secrets를 추가:

#### 필수 Secrets (CI가 통과하려면 필요)

```env
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=your_anon_key
```

#### 선택적 Secrets (앱 기능에 따라)

```env
OPENAI_API_KEY=sk-xxx          # OpenAI 사용 시
GEMINI_API_KEY=xxx              # Gemini 사용 시
AI_PROVIDER=openai              # 또는 gemini (기본값: openai)
SENTRY_DSN=https://xxx@xxx.ingest.sentry.io/xxx
```

### Secret 이름 목록

| Secret 이름         | 설명                        | 필수 여부                |
| ------------------- | --------------------------- | ------------------------ |
| `SUPABASE_URL`      | Supabase 프로젝트 URL       | ✅ 필수                  |
| `SUPABASE_ANON_KEY` | Supabase Anon Key           | ✅ 필수                  |
| `OPENAI_API_KEY`    | OpenAI API Key              | ⚠️ 선택 (OpenAI 사용 시) |
| `GEMINI_API_KEY`    | Google Gemini API Key       | ⚠️ 선택 (Gemini 사용 시) |
| `AI_PROVIDER`       | AI Provider (openai/gemini) | ⚠️ 선택 (기본값: openai) |
| `SENTRY_DSN`        | Sentry DSN                  | ⚠️ 선택                  |

---

## 워크플로우 동작 방식

### .env 파일 생성

CI 워크플로우는 다음 스텝에서 GitHub Secrets를 읽어 `.env` 파일을 동적으로 생성합니다:

```yaml
- name: Create .env file from secrets
  run: |
    echo "SUPABASE_URL=${{ secrets.SUPABASE_URL }}" >> .env
    echo "SUPABASE_ANON_KEY=${{ secrets.SUPABASE_ANON_KEY }}" >> .env
    echo "OPENAI_API_KEY=${{ secrets.OPENAI_API_KEY }}" >> .env
    echo "GEMINI_API_KEY=${{ secrets.GEMINI_API_KEY }}" >> .env
    echo "AI_PROVIDER=${{ secrets.AI_PROVIDER || 'openai' }}" >> .env
    echo "SENTRY_DSN=${{ secrets.SENTRY_DSN }}" >> .env
  continue-on-error: true # Secrets가 없어도 계속 진행
```

**중요:**

- `continue-on-error: true` 옵션으로 Secrets가 설정되지 않아도 빌드가 계속 진행됩니다
- 필수 Secrets만 설정해도 CI가 동작하도록 설계되었습니다

---

## CI 실행 확인

### 로컬에서 테스트

CI 워크플로우를 로컬에서 테스트하려면:

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

## 보안 고려사항

⚠️ **중요:**

1. **Secrets 보안**

   - GitHub Secrets는 암호화되어 저장됩니다
   - Secrets는 CI 환경에서만 접근 가능합니다
   - 로그에 Secrets 값이 노출되지 않도록 주의

2. **최소 권한 원칙**

   - 필수 Secrets만 설정
   - 불필요한 Secrets는 제거

3. **로컬 개발**
   - 로컬에서는 `.env` 파일 사용
   - `.env` 파일은 절대 Git에 커밋하지 마세요

---

## 다음 단계

- [ ] 테스트 자동화 추가
- [ ] 코드 커버리지 리포트 생성
- [ ] 자동 배포 파이프라인 구축 (예: Google Play, App Store)
- [ ] 성능 테스트 추가
