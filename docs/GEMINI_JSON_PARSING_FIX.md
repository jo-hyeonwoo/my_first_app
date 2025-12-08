# Gemini API JSON 파싱 오류 수정

## 문제
AI 플랜 생성 시 다음과 같은 오류가 발생했습니다:
```
FormatException: Unexpected character (at character 1)
수험생 여러분, 안녕하세요. 입시 전문가입니다. 2025년 12월 8일, 수능이 끝났다면...
```

## 원인
Gemini API가 JSON 형식이 아닌 일반 텍스트 설명을 먼저 반환하여 JSON 파싱이 실패했습니다.

## 해결 방법

### 1. 프롬프트 개선
- JSON만 반환하도록 명확히 지시
- 설명이나 서문 없이 순수 JSON만 반환하도록 요청
- 프롬프트에 "설명 없이 JSON만 반환해야 해" 명시

### 2. JSON 추출 로직 강화 (`JsonUtils.cleanJsonString`)
- 응답에서 첫 번째 `{`와 마지막 `}`를 찾아 JSON 객체만 추출
- 일반 텍스트 설명이 포함된 경우에도 JSON 부분만 추출 가능

### 3. 에러 처리 개선
- `FormatException` 발생 시 더 자세한 에러 메시지 제공
- 응답 텍스트의 일부를 에러 메시지에 포함하여 디버깅 용이

## 수정된 파일

### `lib/features/plan/data/services/gemini_plan_service.dart`
- 프롬프트를 더 명확하게 수정하여 JSON만 반환하도록 지시
- 에러 처리 개선 (FormatException 처리 추가)

### `lib/core/utils/json_utils.dart`
- `cleanJsonString` 메서드 개선
- 응답에서 JSON 객체만 추출하는 로직 추가
- 첫 번째 `{`와 마지막 `}`를 찾아 JSON 부분만 추출

## 테스트
수정 후 AI 플랜 생성이 정상적으로 작동하는지 확인:
1. 앱에서 AI 플랜 생성 버튼 클릭
2. 과목과 시간 입력
3. 플랜이 정상적으로 생성되는지 확인

## 참고사항
- Gemini API는 때때로 요청한 형식과 다른 형식으로 응답할 수 있습니다
- JSON 추출 로직이 강화되어 일반 텍스트가 포함된 경우에도 JSON을 추출할 수 있습니다
- 향후 Gemini API의 `responseMimeType` 파라미터가 지원되면 더 안정적으로 JSON만 받을 수 있습니다

