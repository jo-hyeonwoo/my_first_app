<!-- .github/copilot-instructions.md
Purpose: provide concise, project-specific guidance for AI coding agents working
on this Flutter workspace. Keep instructions actionable and reference concrete
files/paths. Update by merging any future agent docs found in the repo. -->

# Copilot / Agent Instructions for my_first_app

1. Purpose: This is a minimal Flutter app (multi-platform scaffold). The entry
   point is `lib/main.dart`. Agents should focus changes in `lib/` and `test/`.

2. Big picture
- **App type**: Cross-platform Flutter app (Android / iOS / macOS / web / linux / windows).
- **Entry point**: `lib/main.dart` (root `MyApp` and `MyHomePage` stateful counter).
- **Platform code**: platform-specific code lives under `android/`, `ios/`, `macos/`, `windows/`, `linux/` — avoid editing generated/project files unless necessary.

3. Build, run, test (exact commands)
- **Install deps**: `flutter pub get`
- **Run on connected device**: `flutter run` (use `-d <device-id>` to target a device)
- **Hot reload**: while `flutter run` is active press `r` (hot reload) or `R` (full restart)
- **Run tests**: `flutter test`
- **Static analysis**: `flutter analyze` and follow `analysis_options.yaml` rules
- **Build APK**: `flutter build apk`

4. Conventions and patterns (project-discoverable)
- **Null-safety**: SDK in `pubspec.yaml` uses Dart >=3 (null-safety enforced). Follow null-safe APIs.
- **Lints**: `flutter_lints` enabled; prefer the existing lint set in `analysis_options.yaml`.
- **UI changes**: Keep visual feature work in `lib/` and add/update widget tests in `test/`.
- **Generated files**: Do NOT edit `GeneratedPluginRegistrant.*`, Gradle wrapper files, or Xcode/Proj auto-generated files — modify upstream sources instead.

5. Integration & dependencies
- This repo currently has no external backend or special plugin configuration in `pubspec.yaml` beyond `cupertino_icons`.
- Check `ios/Runner/` and `android/app/` for platform-specific plugin wiring if adding native plugins.

6. Debugging notes
- For verbose logs: `flutter run --verbose` or inspect device logs with `adb logcat` (Android) / Console (macOS) / Xcode device logs (iOS).
- When changing theme/colors, start from `lib/main.dart` — the `MaterialApp`'s `theme` and `colorScheme` are centralized.

7. PR and change guidance for agents
- Make focused commits that change at most one concern (UI, business logic, tests). Update `test/widget_test.dart` when behavior changes.
- Run `flutter analyze` and `flutter test` locally before proposing changes.
- Don't change package version in `pubspec.yaml` unless asked.

8. Examples (real places to edit)
- Add a new screen: create `lib/screens/your_screen.dart`, register a route in `MaterialApp` inside `lib/main.dart`, add tests in `test/`.
- Add assets: declare them under `flutter.assets` in `pubspec.yaml` and place files in `assets/`.

9. Model / agent preference
- Preference: Enable Claude Haiku 4.5 for all clients — when selecting a default completion model for client-facing suggestions, prefer `Claude Haiku 4.5` if available.

10. Where to look first (quick triage)
- `lib/main.dart` — app entry and primary UI example
- `pubspec.yaml` — SDK, deps, and build hints
- `test/widget_test.dart` — how widget tests are structured
- `analysis_options.yaml` — lint rules to follow

If any section is unclear or you'd like expanded examples (routing, state management, adding native plugins), say which area and I'll expand this document.
