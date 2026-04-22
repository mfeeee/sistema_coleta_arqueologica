# AI Rules & Project Guidelines: ArqueoData (CLAUDE.md)

You are an expert in Flutter and Dart development. Your goal is to build beautiful, performant, and maintainable applications following modern best practices. This document provides specific guidance for working on the **ArqueoData** repository.

## Project Overview
**ArqueoData** is a Flutter application for offline-first archaeological field data collection. It is an Academic TCC/PIBIC project developed at IFPI Campus Parnaíba. 
*   **Scope:** This repository contains the Flutter client only. The backend is a separate Laravel/PostgreSQL repository.
*   **Target Platforms:** Mobile, Web, and Desktop.

## Core Rules & Interaction Guidelines
*   **Language Constraint:** All code, comments, UI text, API documentation, and variable names MUST be written in **Portuguese**.
*   **Commit Style:** Use Gitmoji prefixes for commits (`:sparkles:` feat, `:bug:` fix, `:gear:` chore, `:lipstick:` style).
*   **Explanations:** When generating code, provide brief explanations for Dart-specific features or complex business logic.
*   **Dependencies:** When suggesting new dependencies from `pub.dev`, explain their benefits. Prioritize built-in or currently installed solutions.
*   **Formatting & Linting:** Adhere strictly to the configured `analysis_options.yaml`. Use `dart_format` and `dart_fix` tools to ensure consistent styling and error resolution.

## Common Commands & Workflow
Pre-commit hooks (via `lefthook.yml`) run `dart format` and `flutter analyze` automatically.
*   **Install dependencies:** `flutter pub get`
*   **Run the app:** `flutter run`
*   **Analyze code:** `flutter analyze`
*   **Format code:** `dart format .`
*   **Check formatting:** `dart format --set-exit-if-changed .`
*   **Run tests:** `flutter test`
*   **Run code generation:** `dart run build_runner build --delete-conflicting-outputs`

## Architecture: Clean Architecture (3 Layers)
The project is organized by feature following Clean Architecture principles. Each feature lives in `lib/features/[feature]/`. Core shared code lives in `lib/core/` (router, theme, navigation, utils, widgets).

*   **Presentation Layer (`presentation/`):**
    *   `pages/`: Full-screen route targets.
    *   `viewmodels/`: State management using `ValueNotifier`. No DI frameworks.
    *   `widgets/`: Feature-specific reusable UI components.
*   **Domain Layer (`domain/`):**
    *   `entities/`: Pure Dart business objects (no serialization).
    *   `repositories/`: Abstract contracts (interfaces).
    *   `services/`: Pure business logic (e.g., Haversine distance calculations).
*   **Data Layer (`data/`):**
    *   `datasources/`: Abstract interfaces + specific implementations (e.g., SQLite).
    *   `models/`: Extend domain entities (`class MyModel extends MyEntity`). Add `fromMap`, `toMap`, `fromJson`. Do not use composition for models.
    *   `repositories/`: Concrete implementations of domain repository contracts. They decide whether to read from the local DB or remote API.

## State Management (Strict constraints)
*   **ValueNotifier Only:** Strictly use `ValueNotifier<T>` for state management. Do NOT use Provider, Riverpod, GetX, or Bloc.
*   **Binding:** ViewModels expose `ValueNotifier` fields. Pages bind them using `ValueListenableBuilder` or `ListenableBuilder`.
*   **Dependency Injection:** Services and ViewModels are instantiated manually, typically in `initState()`. Do not use third-party DI packages.

## Navigation & Routing
*   **GoRouter:** Declarative navigation is handled via `go_router`.
*   **Main Navigation:** Uses `StatefulShellRoute` for a persistent 4-tab `BottomNavigationBar` (Início, Coletas, Sincronizar, Perfil). Each tab maintains its own navigation stack.
*   **Standalone Routes:** Routes like `/login`, `/nova-coleta`, and `/detalhes-coleta` sit outside the shell.
*   **Temporary Views:** Use the built-in `Navigator.push/pop` for short-lived screens like dialogs that do not need deep links.

## Data & Offline-First Strategy
*   **Local Database:** Uses SQLite (`arqueologia_offline.db`) via `sqflite` (mobile) and `sqflite_common_ffi` (desktop/Linux).
*   **Proximity Service:** `ProximidadeService` uses the Haversine formula to detect nearby archaeological sites from the local cache.
*   **Serialization:** Use `json_serializable` and `json_annotation`. When encoding data, use `fieldRename: FieldRename.snake` to convert Dart's camelCase to snake_case for the API.

## Dart & Flutter Best Practices
*   **SOLID & Composition:** Apply SOLID principles. Favor composition over inheritance for widgets.
*   **Immutability:** Use `const` constructors for widgets and in `build()` methods wherever possible. `StatelessWidget` and Entity classes must be immutable.
*   **Private Widgets:** Break down large `build()` methods into small, private `Widget` classes (e.g., `_WelcomeSection`) instead of helper methods that return widgets.
*   **Styling:** Maximum 80 characters per line. No trailing comments.
*   **Functions:** Keep functions concise (ideally under 20 lines). Use arrow syntax for single-line functions.
*   **Null Safety:** Write soundly null-safe code. Avoid the bang operator (`!`) unless absolutely guaranteed.
*   **Logging:** Use `dart:developer` `log()` for structured logging instead of `print()`.

## UI, Theming & Accessibility (A11Y)
*   **Single Source of Truth:** Use `AppColors` in `lib/core/theme/app_colors.dart` for all styling.
*   **Material 3:** Embrace `ThemeData` and `ColorScheme.fromSeed()`. Implement both light and dark mode support.
*   **Responsiveness:** Ensure layouts adapt seamlessly to mobile, web, and desktop using `LayoutBuilder` or `MediaQuery`. Use `ListView.builder` for long lists.
*   **Accessibility:** Semantic labels must be in Portuguese. Ensure dynamic text scaling works and maintain a minimum contrast ratio of 4.5:1 for text.
*   **Typography:** Maintain clear hierarchy. Avoid all-caps for long-form text.

## Testing
*   **Structure:** Follow the Arrange-Act-Assert pattern.
*   **Packages:** Use `test` for unit tests, `flutter_test` for widgets, and `integration_test` for end-to-end. Prefer `checks` for assertions over default matchers.
*   **Mocks:** Prefer fakes or stubs over mocks. Use `mockito` or `mocktail` only if necessary. Avoid code generation for mocks.

## Active TODOs (WIP Areas)
*   **Geolocator:** Integration is currently mocked (returns hardcoded coordinates for Parnaíba).
*   **SQLite:** Datasource implementations currently have placeholder connection code.
*   **Forms:** `ColetaWizard` form fields are not yet bound to the ViewModel.
*   **Spatial Queries:** PostGIS queries are stubbed in the sync feature.