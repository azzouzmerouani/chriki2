---
description: Describe when these instructions should be loaded
applyTo: "**" # when provided, instructions will automatically be added to the request context when the pattern matches an attached file
---

# Flutter Development Guidelines (Updated Sept 2025)

These rules are intended for the development team to keep our Flutter projects clean, maintainable, and scalable.

## 🏗 Architecture & Project Structure

**Single Responsibility Principle:** Each class should do one thing only.

- Don't mix UI, business logic, and data in the same class.

**Follow MVVM:**

- **View** → Flutter UI widgets only.
- **ViewModel** → handles business logic, calls repositories, and transforms data for UI.
- **Model** → domain/data entities or DTOs.

**Dependency Injection:**

- Use `get_it` for registering and accessing services, repositories, and cubits.
- Keep DI setup centralized in `lib/core/di/injector.dart`.

**Feature Folder Structure:**

- Only two layers inside features:
  - `data/` → repositories, data sources, DTOs.
  - `presentation/` → pages, widgets, cubits, viewmodels.
- No `domain/` folder inside features.

**Repositories:**

- Define abstract repositories and their implementations inside `data/`.
- Abstracts = what it does, implementation = how it does it.

**Error Handling:**

- Use `Either<L, R>` (`dartz` or `fpdart`) to return failures or successes.
- No unhandled exceptions. Failures should extend `Failure` class in `core/error/`.

**States & Models:**

- Don't use `freezed` or code generators like `freezed_annotation`.
- Write models and states manually. Use `equatable` for equality checks.

**State Management:**

- Use `Cubit` (from `flutter_bloc`), not BLoC with events.
- Each screen/feature has its own Cubit.
- Cubit = lightweight, manages state only. Business logic stays in ViewModels/services.

---

## 🌐 Localization & Internationalization

**Package:** - Use `easy_localization` for multi-language support.

**Translation Files:**

- Path: `assets/translations/`
- Supported locales: **English (`en.json`)**, **French (`fr.json`)**, and **Arabic (`ar.json`)**.
- JSON keys must be identical across all language files.

**Key Management (`StringsConst`):**

- **Strict Rule:** No hardcoded string keys in UI or ViewModels.
- All translation keys must be defined as `static const String` in:
  `lib/core/constants/strings_const.dart`
- Usage in UI: `StringsConst.yourKey.tr()`.

---

## 📂 Project Layout & Core

**Core Folder Structure:**

- `constants/` → global constants and `strings_const.dart`.
- `theme/` → dynamic theme manager.
- `utils/` → extensions & helpers.
- `error/` → failure classes.
- `di/` → dependency injection setup (`injector.dart`).
- `router/` → `go_router` setup and route definitions.

**Folder Structure Example:**

```text
lib/
 ├── core/
 │   ├── constants/
 │   │   └── strings_const.dart
 │   ├── di/
 │   └── router/
 ├── features/
 │   └── feature_x/
 │       ├── data/
 │       │   ├── models/
 │       │   └── repositories/
 │       └── presentation/
 │           ├── cubit/
 │           ├── viewmodels/
 │           ├── pages/
 │           └── widgets/
assets/
 └── translations/
     ├── en.json
     ├── fr.json
     └── ar.json
```

**Navigation:**

- Use `go_router` for routing.
- Define routes in `core/router/app_router.dart`.
- Use typed routes, not random string paths.

---

## 🎨 UI & Performance

**Responsive Design:**

- Use `LayoutBuilder`, `MediaQuery`, or `flutter_screenutil`.
- Support multiple screen sizes and orientations.

**Separation of Concerns:**

- UI Widgets should not contain business logic.
- UI communicates with ViewModel/Cubit only.

**Themes:**

- Provide both light and dark themes.
- Allow switching dynamically (via `ThemeCubit`).

**Performance Best Practices (from Flutter docs):**

- Avoid heavy work inside `build()`.
- Use `const` constructors where possible.
- Reduce rebuilds — extract widgets.
- Be careful with `Opacity`, `Clip`, or `saveLayer()` (expensive).
- Use `StringBuffer` for building large strings.

---

## 🧠 Logic, Error Handling & State

**Unidirectional Data Flow:**

- Data flows one way → from repository → ViewModel → Cubit → UI.

**ViewModels:**

- Contain all business logic and validation.
- Widgets should only delegate actions to ViewModels.

**Immutable Models:**

- Keep models and states immutable.

**Error States:**

- Cubit states must always represent one of: Loading, Success, or Error.

**Repositories:**

- Handle merging of remote + local data.
- Apply caching strategies when possible.

---

## 🧪 Testing & Code Quality

**Unit Tests:**

- Write tests for Cubits, ViewModels, and Repositories.

**Widget Tests:**

- Cover critical UI flows.

**Mocking:**

- Use mocks/fakes for dependencies in tests.

**Code Quality:**

- Avoid `print()` in production — use a logger package (e.g., `logger`).
- Add Dartdoc comments for public classes and methods.
- Use **very_good_analysis** for strict lint rules.
- Follow DRY (Don't Repeat Yourself).

**Clean Widgets:**

- Extract reusable parts into `presentation/widgets`.
- Avoid overly complex widget trees.

**Linting Setup:**

Add `very_good_analysis` to your `pubspec.yaml`:

```yaml
dev_dependencies:
  very_good_analysis: ^5.1.0
```

Create or update `analysis_options.yaml`:

```yaml
include: package:very_good_analysis/analysis_options.yaml

linter:
  rules:
    # Add custom overrides if needed
    # public_member_api_docs: false  # Example override
```

---

## 📝 Naming Conventions

**General Rules:**

- Use **descriptive, meaningful names**.
- Avoid abbreviations unless universally understood (e.g., `id`, `url`).
- Follow Dart's official naming conventions.

### Files & Folders

- Use **snake_case** for file and folder names.
  - ✅ `user_profile_page.dart`
  - ❌ `UserProfilePage.dart` or `userProfilePage.dart`

### Classes

- Use **PascalCase** for class names.
  - ✅ `UserRepository`, `ProfileCubit`, `LoginViewModel`
  - ❌ `userRepository`, `profile_cubit`

### Variables & Functions

- Use **camelCase** for variables, functions, and parameters.
  - ✅ `userName`, `fetchUserData()`, `isLoading`
  - ❌ `UserName`, `fetch_user_data()`

### Constants

- Use **lowerCamelCase** for constants (following Dart guidelines).
  - ✅ `const maxRetryCount = 3;`
  - ✅ `const apiBaseUrl = 'https://api.example.com';`
  - ❌ `const MAX_RETRY_COUNT = 3;` (avoid SCREAMING_SNAKE_CASE in Dart)

### Enums

- Use **PascalCase** for enum names.
- Use **camelCase** for enum values.

  ```dart
  // ✅ Correct
  enum UserStatus {
    active,
    inactive,
    suspended,
  }

  // ❌ Incorrect
  enum user_status {
    Active,
    INACTIVE,
  }
  ```

### Private Members

- Prefix with underscore `_`.
  - ✅ `_apiClient`, `_loadData()`
  - ❌ `apiClient` (if it should be private)

### Booleans

- Use prefixes like `is`, `has`, `can`, `should`.
  - ✅ `isLoading`, `hasError`, `canSubmit`, `shouldRefresh`
  - ❌ `loading`, `error`, `submit`

### Widgets

- Suffix UI widgets with their type for clarity.
  - ✅ `LoginPage`, `UserProfileWidget`, `CustomButton`
  - ❌ `Login`, `Profile`, `Button`

### Cubits

- Suffix with `Cubit`.
  - ✅ `AuthCubit`, `ProfileCubit`, `ThemeCubit`
  - ❌ `Auth`, `ProfileBloc`

### ViewModels

- Suffix with `ViewModel`.
  - ✅ `LoginViewModel`, `DashboardViewModel`
  - ❌ `LoginVM`, `DashboardLogic`

### Repositories

- Suffix with `Repository`.
  - ✅ `UserRepository`, `AuthRepository`
  - ❌ `UserRepo`, `AuthData`

### Models/DTOs

- Use clear, descriptive names without suffixes like `Model` or `DTO` unless necessary for disambiguation.
  - ✅ `User`, `LoginRequest`, `UserResponse`
  - ⚠️ `UserModel` (acceptable if you need to distinguish from domain entities)

### Extensions

- Suffix with `Extension` or `X`.
  - ✅ `StringExtension`, `DateTimeX`
  - ❌ `StringUtils`, `DateHelpers`

### Test Files

- Mirror the file being tested with `_test.dart` suffix.
  - ✅ `user_repository_test.dart` for `user_repository.dart`

---

## 🌐 Git, Workflow & Team Practices

**Branching:**

- Feature branches follow `feature/<ticket-id>-short-description`.
- Bugfix branches follow `fix/<ticket-id>-short-description`.
- No direct commits to `main`—PRs only.

**Commits:**

- Conventional commits: `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`.
- Max 72-char first line, meaningful body if needed.
- Examples:
  ```
  feat: add user authentication flow
  fix: resolve null pointer in profile cubit
  chore: update dependencies
  docs: add API documentation
  refactor: simplify login viewmodel logic
  test: add unit tests for auth repository
  ```

**Pull Requests:**

- Must reference an issue or ticket.
- Must pass all lint, tests, and type checks.
- Use descriptive PR titles and descriptions.

**Small Changes:**

- Prefer smaller, frequent commits instead of huge ones.
- Each commit should represent a logical unit of work.

**Feature Independence:**

- Each feature should be self-contained and not depend directly on other features.
- Use dependency injection to share services between features.

---

## ✅ Summary

- **MVVM + Cubit + get_it + go_router** are our foundation.
- **Core folder** centralizes shared code, constants, DI, theme, and routing.
- **Features are isolated**: only `data/` and `presentation/`.
- **Business logic = ViewModel**, **State = Cubit**, **UI = Widgets**.
- Use **very_good_analysis** for strict linting.
- Follow **Dart naming conventions** strictly (camelCase, PascalCase, snake_case for files).
- **Responsive, testable, and scalable code** is the goal.

---

## 📚 Recommended Packages

### Core Dependencies

- `flutter_bloc` - State management
- `get_it` - Dependency injection
- `go_router` - Navigation
- `dartz` - Functional programming (Either type)
- `equatable` - Value equality

### Additional Utilities

- `logger` - Logging
- `flutter_screenutil` - Responsive design
- `dio` - HTTP client
- `shared_preferences` - Local storage

### Development

- `very_good_analysis` - Linting
- `mockito` or `mocktail` - Mocking for tests
- `build_runner` - Code generation (if needed)

---

**Last Updated:** September 2025
