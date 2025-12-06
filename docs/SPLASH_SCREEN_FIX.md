# SplashScreen ref.listen 오류 수정

## 문제 상황

앱 실행 시 다음과 같은 오류가 발생했습니다:

```
The following assertion was thrown during a scheduler callback:
ref.listen can only be used within the build method of a ConsumerWidget
'package:flutter_riverpod/src/consumer.dart':
Failed assertion: line 600 pos 7: 'debugDoingBuild'
```

## 원인

- `SplashScreen`의 `initState` 메서드 내에서 `ref.listen`을 호출하고 있었습니다
- Riverpod의 `ref.listen`은 `build` 메서드 내에서만 사용할 수 있습니다
- `addPostFrameCallback` 내에서도 `ref.listen`을 호출할 수 없습니다

## 해결 방법

### 주요 변경 사항

1. **`initState` 메서드 제거**
   - `initState`에서 `ref.listen` 호출 제거

2. **`ref.listen`을 `build` 메서드로 이동**
   - Riverpod 규칙에 맞게 `build` 메서드 내에서 직접 호출
   - 상태 변경 감지 및 자동 네비게이션

3. **초기 상태 체크 로직 개선**
   - `addPostFrameCallback`을 사용하여 빌드 후 초기 상태 확인
   - `_hasCheckedInitialState` 플래그로 중복 실행 방지

### 수정된 코드 구조

```dart
class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _hasCheckedInitialState = false;

  @override
  Widget build(BuildContext context) {
    // 1. ref.listen으로 상태 변경 감지
    ref.listen<AsyncValue<User?>>(authNotifierProvider, (previous, next) {
      next.when(
        data: (user) {
          if (user != null && mounted) {
            context.go('/home');
          } else if (mounted) {
            context.go('/login');
          }
        },
        loading: () {
          // 로딩 중
        },
        error: (error, stack) {
          if (mounted) {
            context.go('/login');
          }
        },
      );
    });

    // 2. 초기 상태 체크 (한 번만 실행)
    if (!_hasCheckedInitialState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _hasCheckedInitialState = true;
        final authState = ref.read(authNotifierProvider);
        // 초기 상태 확인 및 네비게이션
      });
    }

    return Scaffold(...);
  }
}
```

## 작동 원리

### 1. `ref.listen`의 역할
- `authNotifierProvider`의 상태 변경을 감지
- 상태가 변경될 때마다 리스너 콜백 실행
- 사용자 인증 상태에 따라 자동 네비게이션

### 2. 초기 상태 체크
- 앱 시작 시 세션 복구가 이미 완료된 경우를 대비
- `addPostFrameCallback`으로 빌드 완료 후 한 번만 실행
- `_hasCheckedInitialState` 플래그로 중복 실행 방지

### 3. 네비게이션 흐름

**시나리오 1: 세션이 있는 경우**
```
앱 실행 → SplashScreen → ref.listen 감지 → /home으로 이동
```

**시나리오 2: 세션이 없는 경우**
```
앱 실행 → SplashScreen → ref.listen 감지 → /login으로 이동
```

**시나리오 3: 초기 로딩이 이미 완료된 경우**
```
앱 실행 → SplashScreen → addPostFrameCallback → 초기 상태 확인 → 네비게이션
```

## Riverpod 규칙

### ✅ 올바른 사용
```dart
@override
Widget build(BuildContext context) {
  ref.listen(...);  // build 메서드 내에서 호출
  return Widget(...);
}
```

### ❌ 잘못된 사용
```dart
@override
void initState() {
  ref.listen(...);  // initState에서 호출 불가
}

@override
void initState() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.listen(...);  // addPostFrameCallback 내에서도 불가
  });
}
```

## 관련 파일

- `lib/features/auth/presentation/screens/splash_screen.dart`: SplashScreen 구현
- `lib/features/auth/presentation/providers/auth_provider.dart`: AuthNotifier 구현

## 참고 문서

- [Riverpod ref.listen 문서](https://riverpod.dev/docs/concepts/reading#listening-to-changes)
- [Flutter WidgetsBinding 문서](https://api.flutter.dev/flutter/scheduler/WidgetsBinding-class.html)

