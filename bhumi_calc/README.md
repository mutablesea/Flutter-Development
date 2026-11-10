# Bhumi Calc

A comprehensive land record (Khatian) management, property portfolio analyzer, and official Bangladesh land measurement calculator built with Flutter, SQLite, and Material 3.

---

## Features

- **Splash & Onboarding Experience**: Animated 2-second splash screen (`Bhumi Calc`) and an interactive 3-step onboarding walkthrough.
- **User Profiles & Authentication**: Built-in default profiles (**Mutant Freeman** – `mutant` / `mutant1234` and **Neon Saab** – `neon` / `neon1234`), custom account sign-up, and quick profile switching.
- **Khatian Record Management**: Create, edit, and delete Khatian records (*CS*, *RS*, *SA*, *BRS*, *BDS*, *Kharij*) with Khatian No., Dag No., Mouza, land area in Decimals, and local scanned document images.
- **Property Overview & Pie Chart (`property_overview_page.dart`)**:
  - **Total Land Calculation**: Automatically sums `totalLandArea` across all saved Khatian records.
  - **Smart Conversion Breakdown**: Displays total land broken down into *Decimal (শতাংশ)*, *Bigha + Decimal (বিঘা ও শতাংশ)*, *Acre (একর)*, *Katha (কাঠা)*, *Sq. Ft*, *Kani*, *Gonda*, *Kora*, *Hectare*, and *Ayer*.
  - **Interactive Pie Chart**: Visualizes land distribution across *CS*, *BRS*, *RS*, *SA*, *BDS*, and *Kharij (নামজারি)* records.
- **Multi-Tab Smart Land Calculator (`calculator_page.dart`)**:
  - **27-Unit Area Converter**: Converts across Decimal, Sq. Ft, Katha, Bigha/Paki, Acre, Kani (40 Shotok, 8 Hat Nol, & 120 Decimal), Gonda, Kora, Kranti/Kontho, Til, Dondho, Dhul, Renu, Ojutangsho, Chotak, Kak, Square Meter, Borgo Gaz, Borgo Hat, Square Link, Square Chain, Ayer, and Hectare.
  - **Plot Length × Width Calculator**: Calculates plot area from 4 side measurements in Feet, Hat, Gaz/Yard, Meter, Link, or Chain.
  - **Linear & Gunter Chain Converter**: Converts between Chain, Link, Feet, Hat, Gaz, Meter, Inch, and 8-Hat Nol.
- **Complete Bangladesh Land Formulas Reference (`land_formulas_page.dart`)**: Searchable 6-page official reference covering all 34 formula groups without omission.
- **Bilingual Support (বাংলা & English) & Theme Control**: Instant live switching between Bangla and English languages and System/Light/Dark themes from the AppBar, Sidebar, or Settings.
- **Search, PDF Report & Backup**: Filter records by type/keyword, generate printable property summary reports, and inspect/export SQLite JSON backups.

---

## Project Structure

```text
lib/
├── main.dart                      # App entry point, ThemeMode & Bangla/English language notifiers
├── database/
│   └── db_helper.dart             # SQLite singleton helper, CRUD operations & sample seeder
├── models/
│   └── khatian_record.dart        # Khatian record data model & Map serialization
└── pages/
    ├── splash_page.dart           # 2-second animated splash screen
    ├── onboarding_page.dart       # 3-slide feature walkthrough
    ├── login_page.dart            # Login screen with Mutant Freeman & Neon Saab default profiles
    ├── signup_page.dart           # Account creation screen
    ├── home_page.dart             # User dashboard, sidebar drawer & 4-tab bottom navigation
    ├── property_overview_page.dart# Total land calculation, smart conversion cards & Pie Chart
    ├── calculator_page.dart       # 3-tab unit converter, plot area & linear/chain calculator
    ├── land_formulas_page.dart    # Complete 6-page Bangladesh land measurement formulas
    ├── add_khatian_page.dart      # Add/edit Khatian record & attach document scan
    ├── khatian_details_page.dart  # Detailed Khatian view with unit conversions & scan preview
    ├── search_filter_page.dart    # Keyword search, Khatian type filter chips & sorting
    ├── pdf_export_page.dart       # Printable property portfolio report & clipboard export
    ├── backup_restore_page.dart   # SQLite JSON backup preview & sample data seeding
    ├── profile_page.dart          # User profile editor, quick account switch & portfolio stats
    └── settings_page.dart         # Language (Bangla/English), theme mode & database settings
```

---

## Getting Started

### Prerequisites

Ensure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed on your machine.

### Installation & Run

1. **Clone the repository:**
   ```bash
   git clone git@github.com-public:mutablesea/Flutter-Development.git
   cd bhumi_calc
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
