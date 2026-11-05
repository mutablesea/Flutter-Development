# Task Flow

A lightweight and intuitive task management application built with Flutter and Material 3 to help you track daily tasks and visualize productivity.

---

## Features

- **Task Management**: Create, toggle completion, and delete tasks quickly.
- **Task Details & Priorities**: Assign priority levels (*Low*, *Medium*, *High*), view visual priority tags, and edit task details.
- **Search & Filter**: Real-time keyword search combined with Status and Priority filter chips.
- **Settings & Theme Control**: Live switching between System default, Light mode, and Dark mode, plus task preferences and data management.
- **Productivity Stats**: Track task completion with a live progress bar and summary metrics (Total, Completed, Pending).
- **Rounded Card UI**: Beautiful Material 3 cards with rounded corners, swipe-to-delete, and quick action menus.

---

## Project Structure

```text
lib/
├── main.dart                  # App entry point & dynamic theme configuration
├── models/
│   └── todo_item.dart         # Task data model
└── pages/
    ├── todo_list_page.dart    # Home page with rounded task cards & filters
    ├── add_todo_page.dart     # New task entry screen with priority selector
    ├── task_details_page.dart # Task editor & priority selector
    ├── search_page.dart       # Search page with filter chips
    ├── settings_page.dart     # Settings page (System/Light/Dark mode & prefs)
    └── stats_page.dart        # Productivity metrics & progress bar
```

---

## Getting Started

### Prerequisites

Ensure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed on your machine.

### Installation & Run

1. **Clone the repository:**
   ```bash
   git clone git@github.com-public:mutablesea/Flutter-Development.git
   cd task_flow
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

4. **Run tests:**
   ```bash
   flutter test
   ```
