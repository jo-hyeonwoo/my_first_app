# 로그아웃 화면 구현

## 작업 개요
사용자 로그아웃을 위한 전용 화면을 구현했습니다. 프로필 화면에서 로그아웃 화면으로 이동할 수 있으며, 로그아웃 확인 후 로그인 화면으로 이동합니다.

## 구현 내용

### 1. 로그아웃 화면 (`LogoutScreen`)
**위치**: `lib/features/auth/presentation/screens/logout_screen.dart`

**주요 기능**:
- 사용자 정보 표시 (이름, 이메일, 역할)
- 로그아웃 확인 다이얼로그
- 로그아웃 처리 및 로그인 화면으로 이동
- 로딩 상태 표시
- 에러 처리

**UI 구성**:
- 사용자 아바타 및 정보 카드
- 로그아웃 버튼 (빨간색 강조)
- 취소 버튼

### 2. 프로필 화면 업데이트 (`ProfileScreen`)
**위치**: `lib/src/presentation/screens/profile_screen.dart`

**주요 변경사항**:
- 사용자 정보 표시 (이름, 이메일, 역할)
- 설정, 도움말, 앱 정보 메뉴 추가
- 로그아웃 화면으로 이동하는 버튼 추가

**UI 구성**:
- 사용자 정보 카드
- 설정 메뉴 리스트
- 로그아웃 버튼

### 3. 라우터 설정
**위치**: `lib/routes/app_router.dart`

**추가된 경로**:
- `/logout`: 로그아웃 화면

## 사용 방법

1. **프로필 화면에서 로그아웃**:
   - 하단 네비게이션 바에서 "Profile" 탭 선택
   - 화면 하단의 "로그아웃" 버튼 클릭
   - 로그아웃 화면으로 이동

2. **로그아웃 확인**:
   - 로그아웃 화면에서 "로그아웃" 버튼 클릭
   - 확인 다이얼로그에서 "로그아웃" 선택
   - 로그인 화면으로 자동 이동

3. **취소**:
   - 로그아웃 화면에서 "취소" 버튼 클릭
   - 이전 화면(프로필)으로 돌아감

## 기술적 세부사항

### 상태 관리
- `AuthNotifier`를 사용하여 로그아웃 처리
- `AsyncValue`를 사용하여 로딩/에러 상태 관리

### 에러 처리
- 로그아웃 실패 시 에러 메시지 표시
- 네트워크 오류 등 예외 상황 처리

### UI/UX
- Material Design 3 스타일 적용
- 로딩 인디케이터 표시
- 확인 다이얼로그로 실수 방지
- 직관적인 버튼 배치

## 향후 개선 사항

1. **설정 화면**: 설정 메뉴에서 실제 설정 화면으로 이동
2. **도움말 화면**: 도움말 메뉴에서 도움말 화면으로 이동
3. **계정 관리**: 비밀번호 변경, 계정 삭제 등 기능 추가
4. **다크 모드**: 테마 설정 기능 추가

## 관련 파일

- `lib/features/auth/presentation/screens/logout_screen.dart`
- `lib/src/presentation/screens/profile_screen.dart`
- `lib/routes/app_router.dart`
- `lib/features/auth/presentation/providers/auth_provider.dart`

