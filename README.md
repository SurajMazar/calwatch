# CalWatch

**AI-powered calorie tracker** — snap your food, get instant analysis from Gemini, OpenAI, or Claude, and track daily calories with local data and optional Google Drive backup.

## Features

- **Food photo analysis** — Capture or pick a photo; AI identifies items, estimates portions, and returns calories and macros (protein, carbs, fat).
- **Multiple AI providers** — Choose **Gemini**, **OpenAI (GPT-4o Vision)**, or **Anthropic (Claude 3)** and store your API key securely in the app.
- **Daily tracking** — Dashboard with circular calorie progress, macro cards, and recent meals.
- **Meal history** — Week view, daily summaries, and a scrollable log with thumbnails; swipe to delete.
- **Local-first** — All data in SQLite on device; no account required except for optional backup.
- **Google Drive backup** — Compressed backup (data + images) to a dedicated folder; backup/restore and configurable sync frequency.

## Screenshots

| Dashboard | Capture | Analysis | History | Settings |
|-----------|---------|----------|--------|----------|
| Calorie ring, macros, recent meals | Camera + gallery, scan frame | AI results, confirm & log | Week selector, daily log | AI provider, API keys, Drive |

## Requirements

- **Flutter** 3.11+ (Dart 3.11+)
- **Android** SDK 23+ (for APK)
- **iOS** 14.0+ (for IPA; Xcode + iOS platform required)
- **macOS** 10.13+ (for desktop run)

## Getting started

### 1. Clone and install

```bash
git clone <repo-url>
cd calwatch
flutter pub get
```

### 2. Run the app

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# macOS (desktop)
flutter run -d macos

# List devices
flutter devices
```

### 3. Configure AI (required for analysis)

1. Open **Settings** in the app.
2. Select an **AI provider** (Gemini, OpenAI, or Claude).
3. Enter your **API key** and tap **Save** (keys are stored in secure storage).
4. Tap **Test connection** to verify.

Get API keys from:

- [Google AI Studio](https://aistudio.google.com/) (Gemini)
- [OpenAI API](https://platform.openai.com/) (GPT-4o)
- [Anthropic Console](https://console.anthropic.com/) (Claude)

### 4. Optional: Google Drive backup

1. In Settings, tap **Connect Google account** and sign in.
2. Choose **Sync frequency** (Daily, Weekly, or Manual).
3. Use **Backup now** / **Restore** as needed.

Backups are stored in a folder named **CalWatch Backups** in your Google Drive as compressed `.tar.gz` archives (data + images).

## Build release binaries

```bash
# Android APK
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

# iOS IPA (requires Xcode + Apple Developer setup)
flutter build ipa --release --no-codesign
# Output: build/ios/ipa/
```

For signed iOS distribution, configure signing in Xcode and run `flutter build ipa --release` (omit `--no-codesign`).

## Project structure

```
lib/
  main.dart              # Entry point, DB init, ProviderScope
  app.dart               # MaterialApp.router, theme
  core/                  # Theme, colors, router, constants
  data/                  # Drift DB, models, repositories
  services/              # AI (Gemini/OpenAI/Claude), image, backup, Drive sync
  ui/                    # Screens and shared widgets
```

## Tech stack

| Area        | Choice |
|------------|--------|
| Framework  | Flutter |
| State      | Riverpod |
| Navigation | go_router |
| Database   | Drift (SQLite) |
| AI         | google_generative_ai (Gemini), http (OpenAI, Claude) |
| Secure storage | flutter_secure_storage |
| Drive      | google_sign_in, googleapis, archive (compression) |

## Design

- **Primary**: `#3BCE45` (green)
- **Font**: Inter
- **Icons**: Material Symbols Outlined

## License

Proprietary / All rights reserved.
