# Task Flow

A lightweight and intuitive task management application built with Flutter and Material 3 to help you track daily tasks and visualize productivity.

---

## Features

- **Task Management**: Create, toggle completion, and delete tasks quickly.
- **Task Details & Priorities**: Edit task names, assign priority levels (*Low*, *Medium*, *High*), and toggle status.
- **Productivity Stats**: Track task completion with a live progress bar and summary metrics (Total, Completed, Pending).
- **Clean UI**: Built with Flutter Material 3 design principles for a fast and responsive experience.

---

## Project Structure

```text
lib/
├── main.dart                  # App entry point & theme configuration
└── pages/
    ├── todo_list_page.dart    # Main task list view & model
    ├── add_todo_page.dart     # New task entry screen
    ├── task_details_page.dart # Task editor & priority selector
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
