# Gemini 모델 이름 수정

## 문제

AI 플랜 생성 시 다음 오류가 발생했습니다:

```
Exception: Failed to generate plans with Gemini:
models/gemini-1.5-flash is not found for API version v1, 
or is not supported for generateContent. Call ListModels 
to see the list of available models and their supported methods.
```

## 원인

`gemini-1.5-flash` 모델이 현재 사용 중인 `google_generative_ai` 패키지 버전(0.2.3)이나 API 버전에서 지원되지 않거나, 모델 이름 형식이 올바르지 않습니다.

## 해결 방법

모델 이름을 `gemini-pro`로 변경했습니다. `gemini-pro`는 더 널리 지원되고 안정적인 기본 모델입니다.

### 변경 사항

**파일:** `lib/features/plan/data/services/gemini_plan_service.dart`

```dart
// 이전
static const String _modelName = 'gemini-1.5-flash';

// 수정 후
static const String _modelName = 'gemini-pro';
```

## 사용 가능한 Gemini 모델

### `gemini-pro` (현재 사용 중)

- **장점:**
  - 가장 널리 지원되는 모델
  - 안정적이고 신뢰할 수 있음
  - 대부분의 API 버전과 호환

- **단점:**
  - `gemini-1.5-flash`보다 약간 느릴 수 있음

### `gemini-1.5-flash` (향후 사용 가능)

- **장점:**
  - 매우 빠른 응답 속도
  - 최신 기능 지원

- **단점:**
  - 일부 API 버전에서 지원되지 않을 수 있음
  - API 키에 접근 권한이 필요할 수 있음

## 대안 모델 이름 (필요시 시도 가능)

만약 `gemini-pro`도 작동하지 않는다면, 다음 모델 이름들을 시도해볼 수 있습니다:

1. `gemini-1.5-pro` - 최신 프로 모델
2. `models/gemini-pro` - 전체 경로 형식
3. 패키지 문서에서 지원되는 모델 목록 확인

## 확인 방법

1. 앱을 재시작하세요:
   ```bash
   flutter run
   ```

2. AI 플랜 생성 기능을 테스트하세요.

3. 오류가 계속 발생하면 `.env` 파일의 `GEMINI_API_KEY`를 확인하세요.

## 참고

- Google Generative AI 패키지 문서: https://pub.dev/packages/google_generative_ai
- Gemini 모델 가이드: https://ai.google.dev/models/gemini

