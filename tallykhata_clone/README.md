# TallyKhata Clone

A complete digital business ledger (টালি), daily cashbox (ক্যাশবক্স), and TallyPay (টালিপে) super-app interface built with Flutter, Material 3, and Bangla (*Hind Siliguri*) typography.

---

## Features

- **Splash & Onboarding Experience (`splash_screen.dart`, `auth_screens.dart`)**:
  - 2-second branded splash screen displaying the TallyKhata book emblem, Bangladesh Bank license badge, and green security shield.
  - Auto-advancing 3-slide onboarding carousel highlighting Bangla QR payments, wallet/bank transfers, and 100% secure transactions.
  - 11-digit mobile number validation, dynamic business name registration, 30-day TallyKhata Gold trial welcome screen, and 2-step TallyPay QR introduction.
- **Dynamic Multi-Business & Profile State (`theme.dart`, `business_screens.dart`)**:
  - Reactive `ValueNotifier<String>` state (`businessNameNotifier`, `userPhoneNotifier`, `businessTypeNotifier`) synchronizes the registered business name, phone number, avatar initials, and 18-category business type across the entire app in real time.
  - **User Information (`UserInfoScreen` — আপনার তথ্য সমূহ)**: Accessible directly from the navigation drawer profile header, displaying dynamic avatar initials, business name, phone number, and editable fields (*Name*, *Business Type*, *NID Number*, *Estimated Business Age*, and *Business Address*).
  - **Business Switcher & Settings**: Switch between businesses, create a new business with an 18-category 2-column type picker, set primary business, edit business details, or delete a business.
- **4-Tab Main Shell & Right-Side Menu Drawer (`main_shell.dart`)**:
  - **Tab 1 — টালি (Tally)**: Gold gradient header, promotional Bangla QR banner, 8-feature quick action grid (*Multi-Business*, *Stock*, *Business Notes*, *Group Tagada*, *QR Code*, *Data Backup*, *Tally-Message*, *Cashbox*), customer/supplier counters, merchant illustration, and a red FAB to add customers or suppliers.
  - **Tab 2 — ক্যাশবক্স (Cashbox)**: Daily sales and current cash summary, quick report & cashbox reconciliation buttons, and 5 transaction categories (*ক্যাশ বেচা*, *ক্যাশ কেনা*, *খরচ*, *মালিক দিল*, *মালিক নিল*).
  - **Tab 3 — টালিপে (TallyPay)**: 8 wallet action tiles (*Add Money*, *Send Money*, *Bank Transfer*, *Wallet Transfer*, *Mobile Recharge*, *Payment*, *QR Code*, *Bill Payment*) and Bangla QR account registration CTA.
  - **Tab 4 — মেনু (Right-Side Drawer)**: Opens the right-side navigation drawer without losing active tab state (`IndexedStack`).
- **Business Tools & Reports (`feature_screens.dart`, `report_screens.dart`, `misc_screens.dart`)**:
  - **Stock & Notes**: Product inventory with unit selector (*কেজি*, *গ্রাম*, *লিটার*, *পিস*, *ডজন*) and checklist business notes.
  - **Group Tagada, Cloud Backup & Tally-Message**: Payment reminder screen, cloud backup status checker, and SMS pack store.
  - **Financial Reports**: Reusable day/month filterable `ReportScreen` for *বেচা কেনা হিসাব*, *খরচ*, *বাকি হিসাব*, and *মালিকের রিপোর্ট*, plus a 2-tab `CashHisabScreen` (*ক্যাশবক্স রিপোর্ট* & *ক্যাশ রিপোর্ট*).
  - **Inbox, Support & Settings**: Notification inbox with detail view, FAQ customer support screen with live chat bar, customer/supplier creation screen, and app settings toggles.

---

## Screenshots (`output/`)

All 31 screens are captured across **Android** (`output/android/`), **iPhone** (`output/iphone/`), and **macOS Desktop** (`output/macos/`):

### Splash, Onboarding & Authentication
| Splash Screen | Login & Onboarding | Business Name | TallyPay QR Intro |
| :---: | :---: | :---: | :---: |
| <img src="output/android/01_splash_screen.png" width="190" /> | <img src="output/android/02_login_screen.png" width="190" /> | <img src="output/android/03_business_name_screen.png" width="190" /> | <img src="output/android/05_qr_intro_screen.png" width="190" /> |

### Main Tabs & Navigation Drawer
| টালি (Tally Tab) | ক্যাশবক্স (Cashbox Tab) | টালিপে (TallyPay Tab) | মেনু (Navigation Drawer) |
| :---: | :---: | :---: | :---: |
| <img src="output/android/06_home_tali_tab.png" width="190" /> | <img src="output/android/07_home_cashbox_tab.png" width="190" /> | <img src="output/android/08_home_talipay_tab.png" width="190" /> | <img src="output/android/09_menu_drawer.png" width="190" /> |

### Profile, Business Management & Reports
| আপনার তথ্য সমূহ | নতুন কাস্টমার/সাপ্লায়ার | ক্যাশ হিসাব | সাপোর্ট (Support) |
| :---: | :---: | :---: | :---: |
| <img src="output/android/11_user_info_screen.png" width="190" /> | <img src="output/android/12_add_party_screen.png" width="190" /> | <img src="output/android/23_cash_hisab_screen.png" width="190" /> | <img src="output/android/31_support_screen.png" width="190" /> |

### macOS Desktop Preview
| Tally Dashboard (macOS) | Cashbox Tab (macOS) |
| :---: | :---: |
| <img src="output/macos/06_home_tali_tab.png" width="400" /> | <img src="output/macos/07_home_cashbox_tab.png" width="400" /> |

---

## Project Structure

```text
lib/
├── main.dart                     # App entry point & MaterialApp configuration
├── routes.dart                   # Centralized route names & WidgetBuilder map
├── theme.dart                    # Brand colors, Hind Siliguri theme & global ValueNotifiers
├── widgets/
│   └── common.dart               # PrimaryButton, EmptyState, backBar, HelpChip, redFab, AppField
└── screens/
    ├── splash_screen.dart        # 2-second splash screen with license & security badges
    ├── auth_screens.dart         # Login carousel, BusinessName, Welcome & QrIntro screens
    ├── main_shell.dart           # MainShell, GoldHeader, TaliTab, CashboxTab, TaliPayTab, MenuDrawer
    ├── business_screens.dart     # NewBusiness, BusinessSettings, BusinessEdit & UserInfo screens
    ├── feature_screens.dart      # Stock, AddProduct, Note, AddNote, Tagada, Backup, TaliMessage
    ├── report_screens.dart       # Reusable ReportScreen (Buy/Sell, Expense, Due, Owner) & CashHisab
    └── misc_screens.dart         # Settings, Inbox, InboxDetail, Support & AddParty screens
```

---

## Getting Started

### Prerequisites

Ensure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed on your machine.

### Installation & Run

1. **Clone the repository:**
   ```bash
   git clone git@github.com-public:mutablesea/Flutter-Development.git
   cd tallykhata_clone
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

4. **Build release APK (per-ABI lightweight build):**
   ```bash
   flutter build apk --split-per-abi
   ```

5. **Run tests:**
   ```bash
   flutter test
   ```
