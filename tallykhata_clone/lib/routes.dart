import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'screens/auth_screens.dart';
import 'screens/main_shell.dart';
import 'screens/feature_screens.dart';
import 'screens/report_screens.dart';
import 'screens/business_screens.dart';
import 'screens/misc_screens.dart';

class Routes {
  static const splash = '/';
  static const login = '/login';
  static const businessName = '/business-name';
  static const welcome = '/welcome';
  static const qrIntro = '/qr-intro';
  static const home = '/home';
  // grid features
  static const stock = '/stock';
  static const addProduct = '/add-product';
  static const note = '/note';
  static const addNote = '/add-note';
  static const tagada = '/tagada';
  static const backup = '/backup';
  static const taliMessage = '/tali-message';
  static const qrCode = '/qr-code';
  // drawer
  static const buySell = '/buy-sell';
  static const expense = '/expense';
  static const baki = '/baki';
  static const cashHisab = '/cash-hisab';
  static const ownerReport = '/owner-report';
  static const settings = '/settings';
  // business
  static const userInfo = '/user-info';
  static const newBusiness = '/new-business';
  static const businessSettings = '/business-settings';
  static const businessEdit = '/business-edit';
  // others
  static const inbox = '/inbox';
  static const inboxDetail = '/inbox-detail';
  static const support = '/support';
  static const addParty = '/add-party';
}

final Map<String, WidgetBuilder> appRoutes = {
  Routes.splash: (_) => const SplashScreen(),
  Routes.login: (_) => const LoginScreen(),
  Routes.businessName: (_) => const BusinessNameScreen(),
  Routes.welcome: (_) => const WelcomeScreen(),
  Routes.qrIntro: (_) => const QrIntroScreen(),
  Routes.home: (_) => const MainShell(),
  Routes.stock: (_) => const StockScreen(),
  Routes.addProduct: (_) => const AddProductScreen(),
  Routes.note: (_) => const NoteScreen(),
  Routes.addNote: (_) => const AddNoteScreen(),
  Routes.tagada: (_) => const TagadaScreen(),
  Routes.backup: (_) => const BackupScreen(),
  Routes.taliMessage: (_) => const TaliMessageScreen(),
  Routes.qrCode: (_) => const QrIntroScreen(fromHome: true),
  Routes.buySell: (_) => const ReportScreen(
    title: 'বেচা কেনা হিসাব',
    col1: 'বেচা',
    col2: 'কেনা',
    showSummaryCheck: true,
  ),
  Routes.expense: (_) =>
      const ReportScreen(title: 'খরচ', col1: 'দিলাম', col2: null),
  Routes.baki: (_) =>
      const ReportScreen(title: 'বাকি হিসাব', col1: 'দিলাম', col2: 'পেলাম'),
  Routes.ownerReport: (_) => const ReportScreen(
    title: 'মালিকের রিপোর্ট',
    col1: 'মালিক দিল',
    col2: 'মালিক নিল',
    monthMode: true,
  ),
  Routes.cashHisab: (_) => const CashHisabScreen(),
  Routes.settings: (_) => const SettingsScreen(),
  Routes.userInfo: (_) => const UserInfoScreen(),
  Routes.newBusiness: (_) => const NewBusinessScreen(),
  Routes.businessSettings: (_) => const BusinessSettingsScreen(),
  Routes.businessEdit: (_) => const BusinessEditScreen(),
  Routes.inbox: (_) => const InboxScreen(),
  Routes.inboxDetail: (_) => const InboxDetailScreen(),
  Routes.support: (_) => const SupportScreen(),
  Routes.addParty: (_) => const AddPartyScreen(),
};
