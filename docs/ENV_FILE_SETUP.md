# .env 파일 설정 가이드

## 문제 상황

앱을 실행할 때 다음과 같은 오류가 발생했습니다:

```
E/flutter: [ERROR:flutter/runtime/dart_vm_initializer.cc(40)] Unhandled Exception: Instance of 'FileNotFoundError'
E/flutter: #0      DotEnv._getEntriesFromFile (package:flutter_dotenv/src/dotenv.dart:172:7)
```

## 원인

- `.env` 파일이 Flutter 앱 번들에 포함되지 않았습니다
- `pubspec.yaml`의 assets 섹션에 `.env` 파일이 명시되지 않았습니다
- `dotenv.load()` 호출 시 파일명이 명시되지 않았습니다

## 해결 방법

### 1. pubspec.yaml 수정

`pubspec.yaml`의 `flutter` 섹션에 assets를 추가했습니다:

```yaml
flutter:
  uses-material-design: true
  
  # Assets
  assets:
    - .env
```

### 2. lib/main.dart 수정

`dotenv.load()` 호출 시 파일명을 명시적으로 지정했습니다:

```dart
// Load environment variables from .env file
await dotenv.load(fileName: ".env");
```

## .env 파일 구조

프로젝트 루트에 `.env` 파일을 생성하고 다음 내용을 포함하세요:

```env
# Supabase 설정
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_anon_key

# AI Provider 설정
AI_PROVIDER=openai  # 또는 gemini
OPENAI_API_KEY=sk-xxx  # OpenAI 사용 시
GEMINI_API_KEY=xxx  # Gemini 사용 시

# Error Monitoring
SENTRY_DSN=https://your-key@your-org.ingest.sentry.io/your-project-id
```

## 주의사항

### 보안 고려사항

⚠️ **중요**: `.env` 파일은 `.gitignore`에 포함되어 Git에 커밋되지 않습니다. 하지만 앱 번들에 포함되면 누구나 API 키를 볼 수 있습니다.

**개발 환경:**
- ✅ 로컬 개발용으로 `.env` 파일을 assets에 포함하여 사용 가능
- ✅ `.gitignore`에 포함되어 Git에는 커밋되지 않음

**프로덕션 환경:**
- ⚠️ 프로덕션 빌드에서는 환경 변수를 다른 방식으로 관리하는 것을 권장
- ⚠️ 빌드 시 환경 변수를 주입하거나, 서버 측에서 API 키를 관리
- ⚠️ 민감한 정보는 클라이언트 앱에 포함하지 않기

### .gitignore 설정

`.env` 파일은 `.gitignore`에 포함되어 있어 Git에 커밋되지 않습니다:

```
# Environment variables
.env
.env.local
```

## 적용 방법

1. **의존성 업데이트**
   ```bash
   flutter pub get
   ```

2. **앱 재실행**
   ```bash
   flutter run
   ```

3. **빌드 테스트**
   ```bash
   flutter build apk --debug
   ```

## 관련 파일

- `pubspec.yaml`: assets 설정
- `lib/main.dart`: `.env` 파일 로드
- `.env`: 환경 변수 파일 (로컬에만 존재)
- `.gitignore`: `.env` 파일 제외 설정

## 참고 문서

- [flutter_dotenv 패키지 문서](https://pub.dev/packages/flutter_dotenv)
- [Flutter Assets 문서](https://docs.flutter.dev/development/ui/assets-and-images)

