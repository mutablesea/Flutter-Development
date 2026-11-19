import 'package:flutter/material.dart';

import '../routes.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Main shell containing the 4-tab bottom navigation bar and right-side menu drawer.
class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final _key = GlobalKey<ScaffoldState>();
  int _index = 0;

  void selectTab(int i) => setState(() => _index = i);

  // IndexedStack preserves each tab's state when switching tabs
  final _tabs = const [TaliTab(), CashboxTab(), TaliPayTab()];

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _key,
    endDrawer: const MenuDrawer(), // Opens from the right side
    body: IndexedStack(index: _index, children: _tabs),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _index,
      backgroundColor: Colors.white,
      indicatorColor: kRedLight,
      onDestinationSelected: (i) {
        if (i == 3) {
          _key.currentState?.openEndDrawer(); // Menu tab opens the right drawer without switching tabs
        } else {
          setState(() => _index = i);
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.menu_book_outlined),
          selectedIcon: Icon(Icons.menu_book, color: kRed),
          label: 'টালি',
        ),
        NavigationDestination(
          icon: Icon(Icons.inbox_outlined),
          selectedIcon: Icon(Icons.inbox, color: kRed),
          label: 'ক্যাশবক্স',
        ),
        NavigationDestination(
          icon: Icon(Icons.account_balance_wallet_outlined),
          selectedIcon: Icon(Icons.account_balance_wallet, color: kRed),
          label: 'টালিপে',
        ),
        NavigationDestination(icon: Icon(Icons.menu), label: 'মেনু'),
      ],
    ),
  );
}

/// Shared gold gradient header at the top of each tab with business selector, Inbox, and Support.
class GoldHeader extends StatelessWidget {
  final Widget? child; // Optional extra content below the header row (feature grid or summary)
  const GoldHeader({super.key, this.child});

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [kGoldTop, kGoldBottom],
      ),
    ),
    child: SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => showBusinessSheet(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.workspace_premium,
                              size: 18,
                              color: Color(0xFFB8860B),
                            ),
                            const SizedBox(width: 6),
                            ValueListenableBuilder<String>(
                              valueListenable: businessNameNotifier,
                              builder: (_, name, _) => Text(
                                name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 6, top: 2),
                      child: Text(
                        'গোল্ড (ট্রায়াল)',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                _HeaderIcon(
                  Icons.mark_email_unread_outlined,
                  'ইনবক্স',
                  () => Navigator.pushNamed(context, Routes.inbox),
                ),
                _HeaderIcon(
                  Icons.chat_outlined,
                  'সাপোর্ট',
                  () => Navigator.pushNamed(context, Routes.support),
                ),
              ],
            ),
          ),
          ?child,
        ],
      ),
    ),
  );
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _HeaderIcon(this.icon, this.label, this.onTap);
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Icon(icon, size: 22),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    ),
  );
}

/// Displays the business switcher bottom sheet.
void showBusinessSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('ব্যবসা সমূহ (১/৫)'),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushNamed(context, Routes.businessSettings);
                },
                icon: const Icon(Icons.settings_outlined, size: 16),
                label: const Text('সেটিংস'),
              ),
            ],
          ),
          ValueListenableBuilder<String>(
            valueListenable: businessNameNotifier,
            builder: (_, name, _) => ListTile(
              title: Text(name),
              subtitle: const Text('কাস্টমার ০, সাপ্লায়ার ০ | মোট পাবো ০.০০'),
              trailing: const Icon(Icons.check_circle, color: kGreen),
            ),
          ),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              foregroundColor: kRed,
              side: const BorderSide(color: kRed),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(context, Routes.newBusiness);
            },
            icon: const Icon(Icons.add),
            label: const Text('নতুন ব্যবসা'),
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------- Tab 1: Tally
class TaliTab extends StatelessWidget {
  const TaliTab({super.key});

  @override
  Widget build(BuildContext context) {
    // (icon, label, route)
    final items = <(IconData, String, String?)>[
      (Icons.menu_book_outlined, 'মাল্টি ব্যবসা', null),
      (Icons.inventory_2_outlined, 'স্টক হিসাব', Routes.stock),
      (Icons.checklist, 'ব্যবসার নোট', Routes.note),
      (Icons.notifications_none, 'গ্রুপ তাগাদা', Routes.tagada),
      (Icons.qr_code_2, 'QR কোড', Routes.qrCode),
      (Icons.cloud_upload_outlined, 'ডাটা ব্যাকআপ', Routes.backup),
      (Icons.sms_outlined, 'টালি-মেসেজ', Routes.taliMessage),
      (
        Icons.inbox_outlined,
        'ক্যাশবক্স',
        'cashbox',
      ), // Switches to the Cashbox tab
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFF7F2E2),
      body: Column(
        children: [
          GoldHeader(
            child: Container(
              margin: const EdgeInsets.only(top: 6),
              decoration: const BoxDecoration(
                color: Color(0xFFF7F2E2),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Promotional QR banner
                  Container(
                    margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBE4E8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'বাংলা QR পেতে এখানে ট্যাপ করুন  ➜',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(8),
                    childAspectRatio: 1.05,
                    children: [
                      for (final it in items)
                        InkWell(
                          onTap: () {
                            if (it.$3 == null) return;
                            if (it.$3 == 'cashbox') {
                              context
                                  .findAncestorStateOfType<_MainShellState>()
                                  ?.selectTab(1); // Switch to Cashbox tab
                            } else {
                              Navigator.pushNamed(context, it.$3!);
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(it.$1, size: 30, color: kRed),
                              const SizedBox(height: 6),
                              Text(
                                it.$2,
                                style: const TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(14, 14, 14, 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'কাস্টমার ০ / সাপ্লায়ার ০',
                        style: TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: const Alignment(0, -0.35),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/tallykhata_logo9.jpg',
                              width: 170,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'ব্যবহার শুরু করতে কাস্টমার/সাপ্লায়ার যোগ করুন।',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: redFab(
        'নতুন কাস্টমার/সাপ্লায়ার',
        Icons.person_add_alt,
        () => Navigator.pushNamed(context, Routes.addParty),
      ),
    );
  }
}

// ---------------------------------------------------------------- Tab 2: Cashbox
class CashboxTab extends StatefulWidget {
  const CashboxTab({super.key});
  @override
  State<CashboxTab> createState() => _CashboxTabState();
}

class _CashboxTabState extends State<CashboxTab> {
  bool _hideNumbers = false;

  String _num(String value) => _hideNumbers ? '- - -' : value;

  @override
  Widget build(BuildContext context) {
    final rows = <(String, Color, IconData)>[
      ('ক্যাশ বেচা', kGreen, Icons.trending_up),
      ('ক্যাশ কেনা', kRed, Icons.trending_down),
      ('খরচ', kRed, Icons.trending_down),
      ('মালিক দিল', kGreen, Icons.trending_up),
      ('মালিক নিল', kRed, Icons.trending_down),
    ];
    return Container(
      color: const Color(0xFFFAF6E9),
      child: Column(
        children: [
          GoldHeader(
            child: Container(
              margin: const EdgeInsets.only(top: 6),
              decoration: const BoxDecoration(
                color: Color(0xFFF2E8CC),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  _num('০'),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'আজকের বেচা',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(width: 1, color: const Color(0xFFE0D0A6)),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  _num('০'),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'বর্তমান ক্যাশ',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFAF6E9),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'আজ পেলাম ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  _num('০'),
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: kGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(width: 1, color: const Color(0xFFE8DFC5)),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'আজ দিলাম ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  _num('০'),
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: kRed,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                    child: Row(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () =>
                              Navigator.pushNamed(context, Routes.cashHisab),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAD9AD),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.description_outlined, size: 18),
                                SizedBox(width: 6),
                                Text(
                                  'রিপোর্ট',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () =>
                              Navigator.pushNamed(context, Routes.cashHisab),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.swap_horiz, size: 18),
                                SizedBox(width: 6),
                                Text(
                                  'ক্যাশবক্স মিলাই',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () =>
                              setState(() => _hideNumbers = !_hideNumbers),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF3F4F6),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _hideNumbers
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                    child: Row(
                      children: [
                        const Text(
                          'বাকি আদায়  ',
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                        Text(
                          _num('০'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: kGreen,
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          'পেমেন্ট দেয়া  ',
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                        Text(
                          _num('০'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: kRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 4, color: const Color(0xFFF3F4F6)),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(top: 6),
                      children: [
                        for (final r in rows)
                          ListTile(
                            leading: CircleAvatar(
                              radius: 22,
                              backgroundColor: r.$2.withValues(alpha: .12),
                              child: Icon(r.$3, color: r.$2),
                            ),
                            title: Text(
                              r.$1,
                              style: const TextStyle(fontSize: 17),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _num('০.০০'),
                                  style: TextStyle(
                                    color: r.$2,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                            onTap: () {},
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- Tab 3: TallyPay
class TaliPayTab extends StatelessWidget {
  const TaliPayTab({super.key});
  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.add_card, 'অ্যাড মানি'),
      (Icons.send, 'সেন্ড মানি'),
      (Icons.account_balance, 'ব্যাংকে ট্রান্সফার'),
      (Icons.wallet, 'ওয়ালেট ট্রান্সফার'),
      (Icons.phone_android, 'মোবাইল রিচার্জ'),
      (Icons.shopping_bag_outlined, 'পেমেন্ট'),
      (Icons.qr_code_2, 'QR কোড'),
      (Icons.lightbulb_outline, 'বিল পেমেন্ট'),
    ];
    return Column(
      children: [
        GoldHeader(
          child: GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8),
            children: [
              for (final it in items)
                Opacity(
                  opacity: .4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(it.$1, size: 28),
                      const SizedBox(height: 6),
                      Text(
                        it.$2,
                        style: const TextStyle(fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const Expanded(
          child: EmptyState(
            'টালিপে QR-এ পেমেন্ট নিন বিকাশ, রকেট সহ যেকোন ব্যাংকে বা মোবাইল ওয়ালেট থেকে।',
            icon: Icons.qr_code_scanner,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: PrimaryButton(
            'টালিপে QR একাউন্ট খুলুন',
            onPressed: () => Navigator.pushNamed(context, Routes.qrCode),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------- Navigation Drawer
class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  Widget _item(BuildContext c, IconData icon, String text, String route) =>
      ListTile(
        dense: true,
        leading: Icon(icon, size: 20),
        title: Text(text),
        onTap: () {
          Navigator.pop(c);
          Navigator.pushNamed(c, route);
        }, // Close the drawer first, then navigate to the route
      );

  @override
  Widget build(BuildContext context) => Drawer(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
    child: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder<String>(
            valueListenable: businessNameNotifier,
            builder: (_, name, _) {
              final parts = name
                  .trim()
                  .split(RegExp(r'\s+'))
                  .where((s) => s.isNotEmpty)
                  .toList();
              final initials = parts.isEmpty
                  ? 'ট'
                  : parts.length == 1
                  ? parts.first.characters.take(2).toString().toUpperCase()
                  : '${parts[0].characters.first}${parts[1].characters.first}'
                        .toUpperCase();
              final phone = userPhoneNotifier.value;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFF2C94C),
                  child: Text(initials),
                ),
                title: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  phone.isNotEmpty ? '+88$phone' : '+8801XXXXXXXXX',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, Routes.userInfo);
                },
              );
            },
          ),
          Container(
            color: kGoldTop.withValues(alpha: .6),
            child: const ListTile(
              leading: Icon(Icons.workspace_premium, color: Color(0xFFB8860B)),
              title: Text('টালিখাতা গোল্ড (ট্রায়াল)'),
              subtitle: Text('অবশিষ্ট: ৩০ দিন'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text('টালিখাতা', style: TextStyle(color: kRed)),
          ),
          _item(
            context,
            Icons.sell_outlined,
            'বেচা কেনা হিসাব',
            Routes.buySell,
          ),
          _item(context, Icons.north_east, 'খরচ', Routes.expense),
          _item(
            context,
            Icons.receipt_long_outlined,
            'বাকি হিসাব',
            Routes.baki,
          ),
          _item(
            context,
            Icons.payments_outlined,
            'ক্যাশ হিসাব',
            Routes.cashHisab,
          ),
          _item(
            context,
            Icons.person_outline,
            'মালিকের রিপোর্ট',
            Routes.ownerReport,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text('অন্যান্য', style: TextStyle(color: kRed)),
          ),
          _item(context, Icons.settings_outlined, 'সেটিংস', Routes.settings),
          ListTile(
            dense: true,
            leading: const Icon(Icons.share_outlined, size: 20),
            title: const Text('টালিখাতা গোল্ড রেফার করুন'),
            onTap: () => Navigator.pop(context),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 36),
            child: Row(
              children: [
                Image.asset('assets/images/tallykhata_logo8.png', height: 30),
                const Spacer(),
                const Text(
                  'ভার্সন - ৭.১৮.১',
                  style: TextStyle(color: Colors.black45, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
