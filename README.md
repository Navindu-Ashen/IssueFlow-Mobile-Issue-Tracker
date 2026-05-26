<p align="center">
  <img src="assets/logo-primary.png" alt="IssueFlow Logo" width="200" />
</p>

<h1 align="center">IssueFlow — Mobile Issue Tracker</h1>

<p align="center">
  A premium, offline-first mobile issue tracking application built with Flutter.<br/>
  Designed with Clean Architecture, modern UI aesthetics, and a seamless developer experience.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.41.1-02569B?logo=flutter" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.11.0-0175C2?logo=dart" alt="Dart" />
  <img src="https://img.shields.io/badge/State_Mgmt-Provider-7952B3" alt="Provider" />
  <img src="https://img.shields.io/badge/Storage-Hive-FF8C00" alt="Hive" />
  <img src="https://img.shields.io/badge/Network-Dio-4CAF50" alt="Dio" />
</p>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
- [Screenshots](#-screenshots)
- [Architecture](#-architecture)
- [Tech Stack & Dependencies](#-tech-stack--dependencies)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Code Generation](#code-generation)
  - [Running the App](#running-the-app)
- [Mock Authentication](#-mock-authentication)
- [Offline-First Sync Strategy](#-offline-first-sync-strategy)
- [Theme System](#-theme-system)
- [Reusable UI Components](#-reusable-ui-components)
- [Assumptions & Design Decisions](#-assumptions--design-decisions)

---

## Overview

**IssueFlow** is a fully-featured mobile issue tracker built with Flutter, showcasing modern mobile engineering practices. The app follows a **Clean Architecture** approach with a clear separation of concerns across data, domain/state, and presentation layers. It implements an **offline-first** data strategy using Hive for local persistence and Dio with mock interceptors to simulate a real REST API — no backend setup required.

The UI is crafted with a **premium, Shadcn-inspired** design system featuring dynamic theming (light & dark modes), Google Fonts typography, smooth animations, and a curated purple-accent color palette.

---

## Key Features

### Core Functionality

- **Authentication** — Email & password login with form validation, loading states, and session persistence via Hive
- **Dashboard** — Interactive overview with summary cards (Open / In Progress / Resolved), trend line chart (fl_chart), and recent issues feed
- **Issue CRUD** — Create, read, update, and delete issues with full form validation
- **Search & Filter** — Real-time search by title, filter by status and priority
- **Issue Detail View** — Full issue details with quick-action buttons (Mark as Resolved, Close Issue) and confirmation dialogs
- **User Profile** — Displays authenticated user details with logout capability

### Bonus Features

- **Dark Mode / Light Mode** — Full theme toggle with preference persistence
- **Offline-First Sync Queue** — Issues created/updated/deleted offline are queued and synced automatically on next refresh
- **Reusable Component Library** — `CustomTextField`, `PrimaryButton`, `IssueCard`, `StatusBadge`, `AppDrawer`
- **Native Splash Screen** — Branded startup experience with `flutter_native_splash`
- **Data Visualization** — Trend line chart powered by `fl_chart`
- **Pull-to-Refresh** — Triggers sync of pending changes and fetches fresh data

---

## 🏛 Architecture

The application follows a simplified **Clean Architecture** pattern:

```
┌──────────────────────────────────────────────────┐
│                PRESENTATION LAYER                │
│  Screens (UI) • Widgets (Reusable Components)    │
│  "Dumb" widgets that observe Provider states     │
└────────────────────┬─────────────────────────────┘
                     │ watches / consumes
┌────────────────────▼─────────────────────────────┐
│              DOMAIN / STATE LAYER                │
│      Providers (AuthProvider, IssueProvider,      │
│               ThemeProvider)                      │
│  Business logic, state management, data mapping  │
└────────────────────┬─────────────────────────────┘
                     │ calls
┌────────────────────▼─────────────────────────────┐
│                  DATA LAYER                      │
│  Repository (IssueRepository)                    │
│  ┌─────────────────┐   ┌──────────────────────┐  │
│  │  Local (Hive)   │   │  Remote (Dio Mock)   │  │
│  │  Fast read/write│   │  Simulated REST API  │  │
│  └─────────────────┘   └──────────────────────┘  │
└──────────────────────────────────────────────────┘
```

**Key Principles:**

- **Single Source of Truth** — The `IssueRepository` orchestrates data from Hive (local) and Dio (remote)
- **Offline-First** — Local data is served immediately; remote data updates asynchronously
- **Separation of Concerns** — UI widgets contain zero business logic
- **Reactive State** — Providers use `ChangeNotifier` + `notifyListeners()` for reactive UI updates

---

## 🛠 Tech Stack & Dependencies

### Core Dependencies

| Package                   | Version | Purpose                                     |
| ------------------------- | ------- | ------------------------------------------- |
| **Flutter**               | 3.41.1  | Cross-platform UI framework                 |
| **Dart**                  | 3.11.0  | Programming language                        |
| **provider**              | ^6.1.2  | State management (ChangeNotifier-based)     |
| **dio**                   | ^5.4.3  | HTTP client with interceptor-based mock API |
| **hive**                  | ^2.2.3  | Lightweight, fast NoSQL local database      |
| **hive_flutter**          | ^1.1.0  | Flutter integration for Hive                |
| **uuid**                  | ^4.4.0  | Unique ID generation for issues             |
| **intl**                  | ^0.19.0 | Date formatting and internationalization    |
| **json_annotation**       | ^4.8.1  | JSON serialization annotations              |
| **google_fonts**          | ^8.1.0  | Modern typography (Inter font family)       |
| **flutter_native_splash** | ^2.4.6  | Native splash screen generation             |
| **fl_chart**              | ^1.2.0  | Beautiful, animated charts                  |

### Dev Dependencies

| Package                    | Version | Purpose                            |
| -------------------------- | ------- | ---------------------------------- |
| **build_runner**           | ^2.4.9  | Code generation runner             |
| **json_serializable**      | ^6.7.1  | JSON serialization code generation |
| **hive_generator**         | ^2.0.1  | Hive TypeAdapter code generation   |
| **flutter_launcher_icons** | ^0.14.3 | App launcher icon generation       |
| **flutter_lints**          | ^6.0.0  | Recommended lint rules             |

---

## 📁 Project Structure

```
lib/
│
├── core/                          # App-wide configurations & utilities
│   ├── constants/
│   │   └── app_constants.dart     # App name, Hive box keys, assignee list
│   ├── network/
│   │   └── mock_api_service.dart  # Dio-based mock REST API with interceptors
│   └── theme/
│       └── app_theme.dart         # Light & Dark ThemeData definitions
│
├── data/                          # Data layer implementation
│   ├── datasources/
│   │   └── local_storage_service.dart  # Hive CRUD operations (auth, issues, settings)
│   ├── models/
│   │   ├── issue_model.dart       # Issue, IssueStatus, IssuePriority, SyncStatus
│   │   ├── issue_model.g.dart     # Generated Hive adapters & JSON serialization
│   │   └── user_model.dart        # User data model
│   └── repositories/
│       └── issue_repository.dart  # Single source of truth — bridges local & remote
│
├── providers/                     # State management layer
│   ├── auth_provider.dart         # Authentication state & session management
│   ├── issue_provider.dart        # Issue list, filtering, search, CRUD operations
│   └── theme_provider.dart        # Light/Dark mode toggle & persistence
│
├── screens/                       # Presentation layer — UI screens
│   ├── splash_screen.dart         # Animated branded splash screen
│   ├── auth_screen.dart           # Login form with validation & password toggle
│   ├── dashboard_screen.dart      # Summary cards, trend chart, recent issues
│   ├── all_issues_screen.dart     # Full issue list with search & filters
│   ├── issue_form_screen.dart     # Create/Edit form with interactive controls
│   ├── issue_detail_screen.dart   # Full detail view with quick actions
│   ├── recent_activities_screen.dart  # Activity log view
│   └── profile_screen.dart        # User profile & logout
│
├── widgets/                       # Reusable UI components
│   ├── app_drawer.dart            # Side navigation drawer with branding
│   ├── custom_text_field.dart     # Standardized text input field
│   ├── primary_button.dart        # Loading-aware elevated button
│   ├── issue_card.dart            # Issue list item card
│   └── status_badge.dart          # Color-coded status/priority chips
│
└── main.dart                      # Entry point — Hive init, Provider setup, MaterialApp
```

---

## Getting Started

### Prerequisites

Ensure you have the following installed on your machine:

| Tool                                        | Required Version | Installation Guide                                                                   |
| ------------------------------------------- | ---------------- | ------------------------------------------------------------------------------------ |
| **Flutter SDK**                             | ≥ 3.41.0         | [flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install) |
| **Dart SDK**                                | ≥ 3.11.0         | Bundled with Flutter                                                                 |
| **Android Studio** or **VS Code**           | Latest           | IDE with Flutter/Dart plugins                                                        |
| **Android Emulator** or **Physical Device** | API 21+          | For running the app                                                                  |

Verify your environment:

```bash
flutter doctor
```

### Installation

1. **Clone the repository:**

```bash
git clone https://github.com/Navindu-Ashen/IssueFlow-Mobile-Issue-Tracker.git
cd IssueFlow-Mobile-Issue-Tracker
```

2. **Install dependencies:**

```bash
flutter pub get
```

### Running the App

1. **Start an Android Emulator** or connect a physical device.

2. **Run the application:**

```bash
flutter run
```

3. **For release build:**

```bash
flutter build apk --release
```

The APK will be generated at `build/app/outputs/flutter-apk/app-release.apk`.

---

## Mock Authentication

The app uses a **mock API** powered by Dio interceptors — no backend server is required. Use the following credentials to log in:

| Role     | Email                | Password      |
| -------- | -------------------- | ------------- |
| **User** | `user@issueflow.com` | `password123` |

### Validation Rules

- **Email** — Must match standard email format (`user@domain.com`)
- **Password** — Minimum 6 characters

> All API calls include a simulated **1.5-second network delay** to replicate real-world latency.

---

## Offline-First Sync Strategy

IssueFlow implements a robust offline-first architecture using a **sync queue** pattern:

```
User Action → Save to Hive (PendingCreate/PendingUpdate/PendingDelete)
                    │
                    ├── Online → Push to Mock API → Update Hive (Synced)
                    │
                    └── Offline → Remain in Hive as Pending
                                       │
                              On next refresh / app startup:
                              syncPendingIssues() → Retry push → Synced
```

### Sync Statuses

| Status          | Description                       |
| --------------- | --------------------------------- |
| `Synced`        | Successfully pushed to remote API |
| `PendingCreate` | Created offline, awaiting sync    |
| `PendingUpdate` | Updated offline, awaiting sync    |
| `PendingDelete` | Deleted offline, awaiting sync    |

### How It Works

1. **Create Issue Offline** — Saved locally with `syncStatus: PendingCreate`
2. **Pull-to-Refresh** — Triggers `syncPendingIssues()` which iterates over all pending items
3. **Automatic Retry** — Failed syncs are preserved and retried on the next refresh cycle
4. **Graceful Degradation** — If the remote API is unreachable, cached Hive data is still displayed

---

## Theme System

IssueFlow features a fully dynamic **dual-theme system** with user preference persistence:

| Property           | Light Mode           | Dark Mode                     |
| ------------------ | -------------------- | ----------------------------- |
| **Primary Color**  | `#9D5FD4` (Purple)   | `#9D5FD4` (Purple)            |
| **Background**     | `#FFFFFF` (White)    | `#120022` (Deep Purple-Black) |
| **Surface**        | `#FFFFFF`            | `#18181B` (Zinc 900)          |
| **Text Primary**   | `#09090B` (Zinc 950) | `#FAFAFA` (Zinc 50)           |
| **Text Secondary** | `#3F3F46` (Zinc 700) | `#A1A1AA` (Zinc 400)          |
| **Border**         | `#E4E4E7` (Zinc 200) | `#27272A` (Zinc 800)          |
| **Typography**     | Inter (Google Fonts) | Inter (Google Fonts)          |

Theme preference is persisted via Hive's `settingsBox` and restored on app startup.

---

## Reusable UI Components

The app includes a library of standardized, theme-aware widgets:

| Widget              | File                             | Description                                                                              |
| ------------------- | -------------------------------- | ---------------------------------------------------------------------------------------- |
| **CustomTextField** | `widgets/custom_text_field.dart` | Consistent text input with standardized padding, borders, and error styling              |
| **PrimaryButton**   | `widgets/primary_button.dart`    | Elevated button with built-in loading state (swaps text for `CircularProgressIndicator`) |
| **IssueCard**       | `widgets/issue_card.dart`        | List item card displaying issue title, status badge, priority, and assignee              |
| **StatusBadge**     | `widgets/status_badge.dart`      | Color-coded chip for issue status and priority (factory-based color mapping)             |
| **AppDrawer**       | `widgets/app_drawer.dart`        | Side navigation drawer with branding, route links, theme toggle, and user profile        |

---

## Assumptions & Design Decisions

1. **Mock API via Dio Interceptors** — The entire API layer is simulated through Dio interceptors with artificial delays. No backend server, database, or internet connection is required to run the application.

2. **No Real Authentication** — Authentication is mocked with hardcoded credentials in `MockApiService`. Tokens are stored locally in Hive but are not validated against any server.

3. **Hive over SQLite** — Hive was chosen for its simplicity, speed, and zero-dependency setup. It is ideal for this use case of caching structured issue data and user sessions.

4. **Provider over BLoC/Riverpod** — Provider was selected for its simplicity and low boilerplate, making the codebase easier to understand and maintain while still achieving full reactive state management.

5. **Offline-First by Default** — The app always serves local data first, then silently updates from the mock API. This ensures instant UI rendering regardless of network conditions.

6. **Assignee List is Static** — Assignees are defined in `AppConstants` and are not fetched from any API. This simulates a small team environment.

7. **Code Generation Required** — Hive TypeAdapters and JSON serialization code are auto-generated via `build_runner`. The generated file (`issue_model.g.dart`) is committed to the repository for convenience.
