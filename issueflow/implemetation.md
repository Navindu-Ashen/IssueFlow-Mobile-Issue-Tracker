## 1. Architectural Strategy

To achieve a clean separation of concerns (a key evaluation metric), we will utilize a simplified **Clean Architecture** tailored for Flutter:

1.  **Data Layer (Repositories & Data Sources):**
    - **Remote Data Source:** `MockApiService` using `Dio`. Handles mock API calls with artificial delays to simulate network latency.
    - **Local Data Source:** `LocalStorageService` using `Hive`. Handles fast read/write operations for offline persistence.
    - **Repository:** `IssueRepository`. Acts as the single source of truth. It dictates whether data comes from Hive or Dio and orchestrates the offline-first synchronization queue.
2.  **Domain/State Layer (Providers):**
    - Uses `Provider` to manage business logic. Providers (`AuthProvider`, `IssueProvider`) listen to Repositories and expose state (Loading, Success, Error) to the UI.
3.  **Presentation Layer (UI):**
    - Widgets are "dumb". They observe Provider states and render accordingly. No business logic resides in UI files.

---

## 2. Tech Stack & Dependencies

Add the following to your `pubspec.yaml`:

````text
[file-tag: flutter_issue_tracker_guide.md]

```yaml
dependencies:
  flutter:
    sdk: flutter
  # State Management
  provider: ^6.1.1

  # Networking
  dio: ^5.4.0

  # Local Persistence
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # Utilities
  uuid: ^4.3.3
  intl: ^0.19.0
  json_annotation: ^4.8.1

dev_dependencies:
  build_runner: ^2.4.8
  json_serializable: ^6.7.1
  hive_generator: ^2.0.1
  flutter_test:
    sdk: flutter

````

---

## 3. Recommended Folder Structure

A clean, scalable directory structure demonstrates engineering maturity.

```text
lib/
│
├── core/                   # App-wide configurations and utilities
│   ├── theme/              # Light and dark mode definitions
│   ├── constants/          # App constants, colors, strings
│   ├── network/            # Dio client and interceptors
│   └── errors/             # Custom exception classes
│
├── data/                   # Data layer implementation
│   ├── models/             # Data models (Issue, User) with Hive/JSON generation
│   ├── datasources/        # Remote (Dio) and Local (Hive) data sources
│   └── repositories/       # Repository implementations bridging local & remote
│
├── providers/              # AuthProvider, IssueProvider
│
├── screens/                # Auth, Dashboard, IssueList, IssueDetail, IssueForm
│
├── widgets/                # Reusable UI components (buttons, badges, inputs)
│
└── main.dart               # Entry point and dependency injection (Provider setup)

```

---

## 4. Step-by-Step Implementation Plan

### Phase 1: Project Setup & Foundation

1. **Initialize Hive:** In `main.dart`, before `runApp()`, initialize Hive and register your custom TypeAdapters.
2. **Theme Configuration:** Create `app_theme.dart` in `core/theme/`. Define both a light and dark `ThemeData`. Utilize `Theme.of(context)` throughout the app instead of hardcoding colors. This instantly secures the "Dark mode or theme support" bonus point.
3. **Dependency Injection:** Wrap your `MaterialApp` with a `MultiProvider` to inject `AuthProvider`, `IssueRepository`, and `IssueProvider`.

### Phase 2: The Data Layer (Offline-First Core)

1. **Models:** Create `issue_model.dart`.

- Fields: `id`, `title`, `description`, `status` (Open, In Progress, Resolved, Closed), `priority` (Low, Medium, High), `createdAt`, `assignee`, `syncStatus` (Synced, PendingCreate, PendingUpdate).
- Annotate with `@HiveType` and `@JsonSerializable`. Run `build_runner`.

2. **Mock Network (Dio):** Create `MockApiService`.

- Set up a `Dio` instance.
- Add an Interceptor that delays responses by 1.5 seconds and returns mocked JSON data for `GET /issues`.

3. **Local Storage (Hive):** Create `LocalStorageService`.

- Open two boxes: `authBox` (for user session) and `issueBox` (for issue caching).

4. **The Repository:** Implement `IssueRepository`.

- `fetchIssues()`: Return data from `issueBox` immediately for instant UI render, then silently call `MockApiService`, update the `issueBox`, and yield the fresh data.

### Phase 3: State Management (Provider)

1. **AuthProvider:**

- Manage a simple boolean state `isAuthenticated`.
- `login(email, password)`: Validate basic regex, simulate a 1-second delay, save a mock token to `authBox`, and update state.

2. **IssueProvider:**

- Manage variables: `List<Issue> issues`, `bool isLoading`, `String? errorMessage`.
- Create getters for the Dashboard: `int get openCount`, `int get inProgressCount`, `int get resolvedCount`.
- Methods: `loadIssues()`, `addIssue()`, `updateIssue()`, `deleteIssue()`.

### Phase 4: UI & Navigation

1. **Auth Screen:** Email/Password fields with validation, loading spinner during mock login.
2. **Dashboard & Issue List Screen:**

- Top section: 3 summary cards (Open, In Progress, Resolved).
- Bottom section: `ListView.builder` of issues.
- Wrap the list in a `RefreshIndicator` calling `provider.loadIssues(forceRefresh: true)`.

3. **Search & Filter:** Add a `TextField` for searching titles and `DropdownButton`s for filtering by Status and Priority. Manage the filtered list dynamically within the `IssueProvider`.
4. **Create/Edit Form:** Use `Form` and `TextFormField` widgets. Enforce validation (e.g., title cannot be empty).
5. **Details Screen:** Display full text. Add a prominent floating action button or bottom bar for "Mark as Resolved" and "Close Issue" with a customized `AlertDialog` for confirmation.

### Phase 5: Bonus Point Execution - Offline Sync Queue

1. When a user creates an issue while "offline", save it to Hive with `syncStatus: SyncStatus.pendingCreate`.
2. In `IssueRepository`, implement a `syncPendingIssues()` method.
3. This method scans Hive for any issues marked as pending, attempts to push them via Dio, and upon success, updates the status to `SyncStatus.synced`.
4. Trigger this sync method upon app startup and whenever a manual pull-to-refresh occurs.

---

## 5. Reusable Component Strategy

To score highly on "UI quality and UX clarity" and "Reusable UI components", construct a library of standardized widgets in `presentation/widgets/`:

- **`CustomTextField`:** Wraps `TextFormField` with consistent padding, border styling, error styling, and standard typography.
- **`PrimaryButton`:** A standard elevated button that accepts an `isLoading` boolean. If true, it replaces the text with a `CircularProgressIndicator`.
- **`IssueCard`:** The UI component used in the list view. Pass an `Issue` object to it.
- **`StatusBadge`:** A highly reusable chip.
- _Strategy:_ Create a factory constructor or helper method that takes an `IssueStatus` enum and returns a chip with specific colors (e.g., Red for Open, Blue for In Progress, Green for Resolved).

- **`EmptyStateWidget`:** A beautifully illustrated (or icon-based) widget to show when the issue list is empty or filtering yields no results.

---

## 6. Testing & Quality Assurance

Provide tests to prove engineering discipline (Rubric point #7):

1. **Unit Tests:** Test the `IssueRepository` offline-merging logic. Test the email validation regex.
2. **Widget Tests:** Test the `LoginForm`. Verify that tapping "Login" with empty fields shows validation errors.
3. **Edge Cases Handled:**

- What if the mock API throws a 500 error? Ensure the Provider catches it and displays a `SnackBar` to the user, while still showing the cached Hive data.

---

## 7. Submission Checklist & README Guide

When preparing the final repository, ensure your `README.md` includes:

- [ ] **Setup Steps:** Instructions on running `flutter pub get` and `flutter pub run build_runner build` (crucial for Hive/JSON generation).
- [ ] **Assumptions:** Explicitly state that the API is mocked via Dio interceptors to simulate a real-world environment without requiring a backend setup.
- [ ] **Features Finished:** List all core requirements met.
- [ ] **Bonus Features Conquered:** Highlight Dark Mode, Reusable Components, Offline Sync Queue, and Testing.
- [ ] **Visual Proof:** Attach a GIF or link to a video recording showing the offline capability (turn off emulator wifi, create issue, restart app, see issue).
      """
