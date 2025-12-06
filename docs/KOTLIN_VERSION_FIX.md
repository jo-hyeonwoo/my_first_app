# Kotlin 언어 버전 문제 해결

## 문제 상황

Android 빌드 중에 다음 오류가 발생했습니다:

```
e: Language version 1.6 is no longer supported; please, use version 1.8 or greater.

FAILURE: Build failed with an exception.
* What went wrong:
Execution failed for task ':sentry_flutter:compileDebugKotlin'.
```

## 원인 분석

- `sentry_flutter` 플러그인이 Kotlin 1.6 언어 버전을 사용하고 있었습니다
- Kotlin 1.6은 더 이상 지원되지 않으며, 최소 1.8 이상이 필요합니다
- 프로젝트 레벨에서 모든 서브프로젝트(플러그인 포함)에 Kotlin 언어 버전을 강제로 설정해야 했습니다

## 해결 방법

`android/build.gradle.kts` 파일에 새로운 `compilerOptions` DSL을 사용하여 모든 서브프로젝트에 Kotlin 언어 버전을 설정했습니다:

```kotlin
subprojects {
    afterEvaluate {
        tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
            compilerOptions {
                languageVersion.set(org.jetbrains.kotlin.gradle.dsl.KotlinVersion.KOTLIN_1_9)
                apiVersion.set(org.jetbrains.kotlin.gradle.dsl.KotlinVersion.KOTLIN_1_9)
            }
        }
    }
}
```

### 주요 변경 사항

1. **새로운 `compilerOptions` DSL 사용**
   - Deprecated된 `kotlinOptions` 대신 새로운 `compilerOptions` DSL을 사용
   - Kotlin 2.0+ 버전과 호환되는 방식

2. **모든 서브프로젝트에 적용**
   - `afterEvaluate` 블록을 사용하여 모든 서브프로젝트가 평가된 후 설정 적용
   - `KotlinCompile` 태스크에 대해 언어 버전과 API 버전을 1.9로 설정
   - 플러그인 포함 모든 서브프로젝트에 일괄 적용

3. **언어 버전 및 API 버전 설정**
   - `languageVersion`: Kotlin 언어 기능 버전 (1.9)
   - `apiVersion`: Kotlin 표준 라이브러리 API 버전 (1.9)

## 결과

- ✅ 빌드 성공: `✓ Built build/app/outputs/flutter-apk/app-debug.apk`
- ✅ 모든 서브프로젝트에 Kotlin 1.9 언어 버전 적용
- ✅ `sentry_flutter` 플러그인의 언어 버전 오류 해결

## 참고 사항

### Kotlin 버전 설정 방법

Kotlin 2.0+ 버전에서는 다음과 같은 방식으로 언어 버전을 설정할 수 있습니다:

1. **프로젝트 레벨 설정** (현재 적용된 방법)
   ```kotlin
   subprojects {
       afterEvaluate {
           tasks.withType<KotlinCompile>().configureEach {
               compilerOptions {
                   languageVersion.set(KotlinVersion.KOTLIN_1_9)
                   apiVersion.set(KotlinVersion.KOTLIN_1_9)
               }
           }
       }
   }
   ```

2. **앱 레벨 설정** (`android/app/build.gradle.kts`)
   ```kotlin
   kotlin {
       compilerOptions {
           languageVersion.set(KotlinVersion.KOTLIN_1_9)
           apiVersion.set(KotlinVersion.KOTLIN_1_9)
       }
   }
   ```

### Deprecated API

다음과 같은 설정은 더 이상 사용되지 않습니다:
- `kotlinOptions { languageVersion = "1.9" }` ❌
- `kotlinOptions { apiVersion = "1.9" }` ❌

대신 `compilerOptions` DSL을 사용해야 합니다:
- `compilerOptions { languageVersion.set(...) }` ✅
- `compilerOptions { apiVersion.set(...) }` ✅

## 관련 커밋

- 커밋: `fix: Add Kotlin compilerOptions DSL for all subprojects`
- 날짜: 2025-01-27
- 변경 파일: `android/build.gradle.kts`

## 추가 리소스

- [Kotlin Gradle Compiler Options 문서](https://kotlinlang.org/docs/gradle-compiler-options.html)
- [Kotlin Version 상수 참조](https://kotlinlang.org/docs/compiler-reference.html)

