# Gemini 모델 이름 업데이트

## 문제

AI 플랜 생성 시 다음 오류가 계속 발생했습니다:

```
Exception: Failed to generate plans with Gemini:
models/gemini-1.5-flash is not found for API version v1, 
or is not supported for generateContent.
```

## 해결 방법

Google Gemini API 공식 문서([링크](https://ai.google.dev/gemini-api/docs/models?hl=ko))와 Context7을 참고하여 지원되는 최신 모델 이름으로 업데이트했습니다.

### 변경 사항

**파일:** `lib/features/plan/data/services/gemini_plan_service.dart`

```dart
// 이전 (작동하지 않음)
static const String _modelName = 'gemini-pro';
// 또는
static const String _modelName = 'gemini-1.5-flash';

// 수정 후 (Google 문서 기준)
static const String _modelName = 'gemini-2.5-flash';
```

## 지원되는 모델 목록

Google 공식 문서에 따르면 다음 모델들이 지원됩니다:

### 안정 버전 (Stable) - 프로덕션 권장

- **`gemini-2.5-flash`** ⭐ (현재 사용 중)
  - 최신 안정 버전
  - 프로덕션 사용 권장
  - 빠른 응답 속도

- **`gemini-2.5-flash-lite`**
  - 경량화 버전
  - 더 빠른 응답, 더 낮은 비용

### 최신 버전 (Latest)

- **`gemini-2.0-flash`**
  - 최신 기능 포함
  - 자동 업데이트됨

### 미리보기 버전 (Preview)

- **`gemini-3-pro-preview`**
  - 최신 기능 테스트용
  - 프로덕션 사용 가능하나 주의 필요

### 더 이상 권장되지 않음

- `gemini-1.5-flash` - 일부 API 버전에서 지원되지 않을 수 있음
- `gemini-pro` - 구버전 모델

## 참고 자료

- [Google Gemini API 모델 문서](https://ai.google.dev/gemini-api/docs/models?hl=ko)
- [Context7 - Gemini API 문서](https://ai.google.dev/gemini-api)

## 다음 단계

1. 앱을 재시작하세요:
   ```bash
   flutter run
   ```

2. AI 플랜 생성 기능을 테스트하세요.

3. 여전히 오류가 발생하면 `.env` 파일의 `GEMINI_API_KEY`가 유효한지 확인하세요.

## 대안 모델

만약 `gemini-2.5-flash`도 작동하지 않는다면, 다음 모델들을 시도해볼 수 있습니다:

```dart
// 옵션 1: 최신 버전
static const String _modelName = 'gemini-2.0-flash';

// 옵션 2: 경량 버전
static const String _modelName = 'gemini-2.5-flash-lite';

// 옵션 3: 프로 미리보기
static const String _modelName = 'gemini-3-pro-preview';
```

