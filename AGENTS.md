# CalWatch — Agent & Contributor Guide

This file helps AI agents and developers navigate the repo, follow conventions, and run builds/tests.

## Repo overview

- **App**: CalWatch — Flutter mobile (Android/iOS) + macOS desktop. Users photograph food, get AI calorie analysis (Gemini/OpenAI/Claude), track daily calories, and optionally backup to Google Drive.
- **Architecture**: Local-first. No backend; SQLite (Drift), local image storage, per-provider API keys in secure storage, optional Drive sync via compressed archives.

## Key paths

| Purpose | Path |
|--------|------|
| Entry point | `lib/main.dart` |
| App & router | `lib/app.dart`, `lib/core/router.dart` |
| Theme / design | `lib/core/theme/`, `lib/core/constants.dart` |
| Database (schema + generated) | `lib/data/database/app_database.dart`, `app_database.g.dart` |
| Data models | `lib/data/models/` (`food_analysis.dart`, `ai_provider.dart`) |
| Repositories | `lib/data/repositories/` (`meal_repository.dart`, `settings_repository.dart`) |
| AI (interface + impls + factory) | `lib/services/ai/` |
| Other services | `lib/services/` (image, backup, drive_sync) |
| UI screens | `lib/ui/` (dashboard, capture, analysis, history, settings) |
| Shared widgets | `lib/ui/widgets/` |

## Conventions

- **State management**: `flutter_riverpod`; use `ConsumerWidget` / `ConsumerStatefulWidget` and `ref.watch` / `ref.read` as appropriate. Generated providers live in `*.g.dart` (Riverpod codegen).
- **Navigation**: `go_router` in `lib/core/router.dart`. Shell route for bottom nav (Dashboard, History, Settings); separate routes for Food Capture and Analysis Results.
- **Database**: Drift. Tables in `app_database.dart`; run `dart run build_runner build` after changing tables. Access via `AppDatabase` (singleton in `main.dart`) and repositories.
- **API keys**: Stored with `flutter_secure_storage`; keys in `AppConstants` (`geminiApiKeyStorageKey`, etc.). Never log or commit keys.
- **Styling**: Use `AppTheme.light` / `AppTheme.dark`, `AppColors` from `lib/core/theme/`. Inter font, primary green `#3BCE45`.
- **Async + context**: Avoid using `BuildContext` after `async` gaps without checking `mounted`.

## Commands

```bash
# Dependencies
flutter pub get

# Code generation (Drift, Riverpod, json_serializable)
dart run build_runner build --delete-conflicting-outputs

# Analyze
flutter analyze

# Run
flutter run -d <device-id>   # e.g. android, ios, macos

# Tests
flutter test

# Release builds
flutter build apk --release
flutter build ipa --release --no-codesign   # or with signing
```

## AI / vision

- **Interface**: `lib/services/ai/ai_vision_service.dart` — `analyzeFood(Uint8List imageBytes)` returns `FoodAnalysis`; `testConnection()` for settings.
- **Implementations**: `gemini_vision_service.dart` (Google SDK), `openai_vision_service.dart`, `claude_vision_service.dart` (HTTP).
- **Factory**: `AiServiceFactory` builds the active provider instance using `SettingsRepository` (active provider + secure storage keys). Use the factory (or its provider) in the app; don’t instantiate services with raw keys in UI.
- **Prompt**: `AppConstants.foodAnalysisPrompt` — model must return the specified JSON shape; parsing in each implementation (and `FoodAnalysis` / `FoodItem` in `lib/data/models/food_analysis.dart`).

## Database

- **Tables**: `Meals` (image path, calories, foods JSON, health feedback, meal type, AI provider, created_at), `DailyGoals`, `AppSettings`.
- **Generated**: `app_database.g.dart` — data classes, companions, DAOs. Regenerate after schema changes.
- **Repositories**: `MealRepository`, `SettingsRepository` wrap DB and secure storage; use them from UI/controllers instead of raw DB.

## Google Drive backup

- **Service**: `lib/services/drive_sync_service.dart` — sign-in, find/create app folder “CalWatch Backups”, upload/download.
- **Format**: `lib/services/backup_service.dart` — SQLite exported to JSON + images, packed into `.tar.gz` (`AppConstants.driveBackupFileName`).
- **Config**: Sync frequency and last sync in settings/DB; background scheduling via `workmanager` (platform-specific).

## Platform notes

- **iOS**: Min deployment 14.0 (e.g. `workmanager_apple`). CocoaPods: run from project root or `ios/` with `LANG=en_US.UTF-8` if needed. IPA requires Xcode and (for distribution) proper code signing.
- **Android**: Min SDK 23. Camera and internet permissions in `AndroidManifest.xml`.
- **macOS**: Added via `flutter create . --platforms=macos`. Camera/photo behavior may differ from mobile.

## Testing

- Widget test for app load: `test/widget_test.dart` (CalWatchApp with ProviderScope).
- Prefer testing repositories and services with mocks; avoid hardcoding API keys or real Drive credentials in tests.

## Plan reference

High-level plan and completed todos: see `.cursor/plans/calwatch_flutter_mvp_8058d123.plan.md` (if present). Do not edit the plan file when implementing; use it for context only.

## Quick edits

- **New screen**: Add route in `lib/core/router.dart`, create screen under `lib/ui/<feature>/`, use bottom nav or navigation actions as in existing screens.
- **New AI provider**: Add enum value in `lib/data/models/ai_provider.dart`, implement `AiVisionService` in `lib/services/ai/`, register in `AiServiceFactory`, add key constant and UI in Settings.
- **New DB table**: Define in `app_database.dart`, run build_runner, add repository methods and any migrations.
- **Theme/constants**: Prefer `AppTheme` and `AppColors`; add new constants in `lib/core/constants.dart` or theme files.
