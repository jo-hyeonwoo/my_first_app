# 린터 경고 수정

## 작업 개요
Flutter 프로젝트의 `flutter analyze` 명령어에서 발생한 모든 경고와 정보 메시지를 수정했습니다.

## 수정된 문제들

### 1. JsonKey 어노테이션 경고
**문제**: `JsonKey` 어노테이션이 생성자 파라미터에 사용되어 경고 발생
- `lib/features/plan/domain/entities/student_plan.dart`
- `lib/features/score/domain/entities/score.dart`
- `lib/features/timer/domain/entities/study_session.dart`

**해결 방법**: 
- `@freezed`를 `@Freezed(toJson: true, fromJson: true)`로 변경
- `analysis_options.yaml`에 `invalid_annotation_target: ignore` 설정 추가
  - Freezed에서 생성자 파라미터에 `@JsonKey`를 사용하는 것은 정상적인 방법이지만, 최신 json_serializable에서는 경고가 발생할 수 있음

### 2. Deprecated 메서드 수정
**문제**: Deprecated된 메서드 사용
- `withOpacity()` → `withValues(alpha: ...)`로 변경
- `background` → `surface`로 변경
- `onBackground` → `onSurface`로 변경

**수정된 파일**:
- `lib/features/student/presentation/screens/consultant_dashboard_screen.dart`
- `lib/features/student/presentation/screens/student_detail_screen.dart`

### 3. Super Parameter 사용
**문제**: `Key? key` 파라미터를 super parameter로 변경 가능
**수정된 파일**:
- `lib/features/auth/presentation/screens/login_screen.dart`
- `lib/features/home/presentation/home_screen_wrapper.dart`
- `lib/features/student/presentation/screens/consultant_dashboard_screen.dart`
- `lib/features/student/presentation/screens/student_detail_screen.dart`

### 4. 사용되지 않는 Import 및 필드 제거
**수정된 파일**:
- `test/widget_test.dart`: 사용되지 않는 `package:flutter/material.dart` import 제거
- `lib/features/timer/data/repositories/mock_timer_repository.dart`: 사용되지 않는 `_uuid` 필드 제거

### 5. 기타 린터 경고 수정
- `lib/features/score/presentation/score_screen.dart`: 불필요한 언더스코어 제거 (`__` → `_`)
- `lib/features/student/presentation/screens/student_detail_screen.dart`: 불필요한 `toList()` 제거 (spread 연산자 사용)
- `lib/features/timer/presentation/timer_screen.dart`: BuildContext async gap 문제 수정 (`context.mounted` 체크 추가)

## 결과
모든 경고와 정보 메시지가 해결되어 `flutter analyze` 명령어가 성공적으로 완료됩니다.

## 참고사항
- Freezed를 사용할 때 생성자 파라미터에 `@JsonKey`를 사용하는 것은 정상적인 방법입니다
- 최신 json_serializable 버전에서는 경고가 발생할 수 있지만, `analysis_options.yaml`에서 무시하도록 설정할 수 있습니다
- Flutter 3.18 이후 `withOpacity()`는 `withValues(alpha: ...)`로 대체되었습니다
- `background`와 `onBackground`는 `surface`와 `onSurface`로 대체되었습니다

