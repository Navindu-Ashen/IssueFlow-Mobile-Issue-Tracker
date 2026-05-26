# IssueFlow — Completion Note

> **Date:** May 2026  
> **Author:** Navindu Ashen  
> **Project:** IssueFlow — Mobile Issue Tracker with Offline Persistence

---

## Completed

### Authentication

- Login screen with email/password validation (regex for email, minimum 6-character password).
- Mock API login flow via `MockApiService` with simulated network latency.
- Token-based session persistence using Hive (`authBox`), so users stay logged in across app restarts.
- Logout with session clearing and navigation reset.
- Password visibility toggle on the login form.
- Pre-configured mock users (`admin@test.com` / `user@test.com`) with role-based data.

### Issue CRUD (Create, Read, Update, Delete)

- **Create:** Issue form with title, description, priority selection (chip-based), status (edit-only), and assignee selection (card grid with radio indicators). New issues default to `Open` status.
- **Read:** Issue list screen with all issues and a dashboard showing the 5 most recent issues. Issue detail screen displaying full information (title, description, status, priority, assignee, created date, sync status).
- **Update:** Edit existing issues through the same form screen (pre-populated fields). Mark issue as `Resolved` or `Closed` directly from the detail screen with action buttons.
- **Delete:** Delete issues with confirmation dialog. Soft-delete approach — issues are marked `PendingDelete` locally before attempting remote sync.

### Dashboard & Summary

- Dashboard screen with total issue count, summary cards for Open and In Progress counts.
- Trend chart visualization using `fl_chart` (line chart with gradient area).
- Recent issues section showing the latest 5 issues with a "View All" link.
- Insights/forecast banner for quick navigation to the full issue list.

### Local Persistence (Hive)

- Full Hive integration with typed boxes for authentication, issues, and settings.
- Custom Hive adapters generated via `hive_generator` for `Issue`, `IssueStatus`, `IssuePriority`, and `SyncStatus` enums.
- Issues persist locally across app restarts — all created/edited data survives cold launches.
- Auth tokens and user profiles persist in a separate Hive box.
- Theme preference (dark/light mode) persisted via Hive settings box.

### Search & Filter

- Real-time search by issue title on the All Issues screen.
- Filter support by status and priority in `IssueProvider` (programmatic — `setStatusFilter`, `setPriorityFilter`).
- Combined filter logic: search query + status filter + priority filter applied simultaneously.

### Offline-First Architecture

- Repository pattern (`IssueRepository`) with stream-based data flow — local data is yielded first, then remote data is fetched.
- Sync status tracking per issue: `Synced`, `PendingCreate`, `PendingUpdate`, `PendingDelete`.
- `syncPendingIssues()` method iterates through all locally pending changes and attempts to push them to the mock API.
- Graceful degradation: if the API call fails, the issue remains in its pending state and will retry on next sync/refresh.
- Optimistic UI updates — changes appear instantly in the UI before sync completes.

### Mock API Service

- Simulated RESTful API with Dio interceptors for network latency (1500ms delay).
- Endpoints: `GET /issues`, `POST /issues`, `PUT /issues/:id`, `DELETE /issues/:id`, `POST /auth/login`.
- In-memory mock data store with 3 seed issues.
- Login endpoint with credential validation against a mock user store.

### State Management (Provider)

- `AuthProvider` — manages authentication state, login/logout, and session persistence.
- `IssueProvider` — manages issue list, CRUD operations, loading/error states, search and filters, and status counts.
- `ThemeProvider` — manages dark/light theme toggle with Hive-backed persistence.
- Clean separation: Providers depend on repositories, not directly on data sources.

### Navigation

- Splash screen → Auth screen → Dashboard (main flow).
- Side navigation drawer with links to Dashboard, All Issues, and Recent Activities.
- Profile screen accessible from the drawer footer and header profile icons.
- Navigation between list → detail → edit form with proper back-stack handling.
- `pushAndRemoveUntil` used for logout to clear the navigation stack.

### UI/UX Quality

- Premium design system inspired by Shadcn UI with a curated purple (`#9D5FD4`) primary color.
- Dark mode (`#120022` background) and light mode (pure white background) with full theme support.
- Google Fonts (Inter) for modern, clean typography across all screens.
- Reusable widget components: `IssueCard`, `StatusBadge`, `CustomTextField`, `PrimaryButton`, `AppDrawer`.
- Animated interactive elements: priority chips, assignee cards with radio indicators, and container transitions.
- Pull-to-refresh on both the dashboard and all issues list.
- Loading, empty, and error state handling across all data-driven screens.
- Native splash screen via `flutter_native_splash` with branded colors for both themes.
- Custom launcher icons configured via `flutter_launcher_icons`.

### Clean Folder Structure

```
lib/
├── core/
│   ├── constants/       # App-wide constants and assignee data
│   ├── network/         # MockApiService (Dio-based)
│   └── theme/           # AppTheme with light/dark definitions
├── data/
│   ├── datasources/     # LocalStorageService (Hive)
│   ├── models/          # Issue, User models with Hive & JSON adapters
│   └── repositories/    # IssueRepository (offline-first logic)
├── providers/           # AuthProvider, IssueProvider, ThemeProvider
├── screens/             # All screen widgets
├── widgets/             # Reusable UI components
└── main.dart            # App entry point with DI setup
```

### Dark Mode / Theme Support

- Full dual-theme implementation (light and dark) via `AppTheme`.
- Theme toggle accessible from the navigation drawer.
- Theme preference persisted locally via Hive — survives app restarts.
- All screens and components use `Theme.of(context)` lookups — no hardcoded colors.

---

### Search & Filter UI

- **Search by title** is fully functional with a real-time text field on the All Issues screen.
- **Filter by status**: Interactive filter chips (All, Open, In Progress, Resolved, Closed) on the All Issues screen, connected to `IssueProvider.setStatusFilter()`.
- **Filter by priority**: Interactive filter chips (All, Low, Medium, High) on the All Issues screen, connected to `IssueProvider.setPriorityFilter()`.
- Combined filter logic: search query + status filter + priority filter applied simultaneously.
- "Clear filters" action shown when no issues match the active filters.

### Recent Activities

- Dynamic activity tracking system that logs real user actions (create, update, delete, resolve, close, status change).
- `Activity` model persisted in a dedicated Hive box (`activityBox`) with typed adapters.
- Activities are logged automatically from `IssueProvider` on every CRUD operation.
- `RecentActivitiesScreen` displays live activity data via `Consumer<IssueProvider>`, sorted newest-first.
- Color-coded icons per activity type (green for resolved, red for deleted, blue for updated, etc.).
- Relative time formatting ("Just now", "5m ago", "2h ago", "3d ago").
- Proper empty state when no activities exist.

### CSV / JSON Export

- `ExportService` utility class in `lib/core/services/` with methods for JSON, CSV, and single-issue JSON export.
- **All Issues screen**: Export icon in the header opens a bottom sheet with "Export as JSON" and "Export as CSV" options. Exports the currently filtered issue list.
- **Issue Detail screen**: Share icon in the header exports the individual issue as a JSON file via the native share sheet.
- Uses `share_plus` for the native share sheet and `path_provider` for temporary file storage.
- Proper CSV escaping for values containing commas, quotes, or newlines.

---

## Skipped

### Attachment / Image Support

- No file or image attachment capability was added to issues. The issue model does not include an attachment field.

### Unit & Widget Tests

- No automated tests were written. The `test/` directory does not contain any test files. Form validation logic, provider behavior, and screen flows remain untested.

---

## Known Limitations

| Area                  | Limitation                                                                                                                                                                           |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Backend**           | No real backend — all API calls hit an in-memory mock service (`MockApiService`). Data is not shared across devices or sessions beyond local Hive storage.                           |
| **Sync**              | Offline sync is simulated. `syncPendingIssues()` retries pending operations against the mock API, but there is no real server to reconcile with. Conflict resolution is not handled. |
| **Auth**              | Authentication is entirely mocked. JWT tokens are fake strings. There is no real security, token expiration, or refresh flow.                                                        |
| **Charts**            | The dashboard trend chart displays static placeholder data points — it does not reflect real issue creation trends over time.                                                        |
| **Error Handling**    | Basic error handling is in place (try/catch with error messages), but edge cases such as Hive corruption, concurrent writes, or large dataset performance are not addressed.         |
| **Deep Linking**      | No deep link or URL-based navigation support.                                                                                                                                        |
| **Pagination**        | All issues are loaded at once — no pagination or lazy loading for large datasets.                                                                                                    |

---

## Architecture Decisions

| Decision                          | Rationale                                                                                                                                            |
| --------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Provider** for state management | Lightweight, minimal boilerplate, and well-suited for a project of this scope.                                                                       |
| **Hive** for persistence          | Extremely fast, no native dependencies, supports typed objects with adapters, and works seamlessly with Flutter.                                     |
| **Dio** for networking            | Interceptor support enables easy mock latency simulation and future extensibility (auth headers, retry logic).                                       |
| **Repository pattern**            | Decouples data sources from UI/state, making it straightforward to swap the mock API for a real backend.                                             |
| **Stream-based data loading**     | `IssueRepository.getIssues()` yields local data first, then remote — enabling instant UI rendering while background sync occurs.                     |
| **SyncStatus enum**               | Tracks per-issue sync state (`Synced`, `PendingCreate`, `PendingUpdate`, `PendingDelete`) to support offline-first behavior and future retry queues. |

---

_This completion note reflects the state of the project as of the submission date._
