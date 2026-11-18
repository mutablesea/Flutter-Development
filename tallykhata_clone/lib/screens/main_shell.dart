import 'package:flutter/material.dart';
import '../routes.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// SS 10,11,14,15,16,41,42 : Main shell = Bottom Navigation (4 tab) + right-side Drawer (মেনু)
class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final _key = GlobalKey<ScaffoldState>();
  int _index = 0;

  void selectTab(int i) => setState(() => _index = i);

  // IndexedStack = tab bodol korle state hariye jabe na
  final _tabs = const [TaliTab(), CashboxTab(), TaliPayTab()];

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _key,
        endDrawer: const MenuDrawer(), // SS 16 : dan dik theke ashe
        body: IndexedStack(index: _index, children: _tabs),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          backgroundColor: Colors.white,
          indicatorColor: kRedLight,
          onDestinationSelected: (i) {
            if (i == 3) {
              _key.currentState?.openEndDrawer(); // মেনু tab = drawer khule, tab bodlay na
            } else {
              setState(() => _index = i);
            }
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book, color: kRed), label: 'টালি'),
            NavigationDestination(icon: Icon(Icons.inbox_outlined), selectedIcon: Icon(Icons.inbox, color: kRed), label: 'ক্যাশবক্স'),
            NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet, color: kRed), label: 'টালিপে'),
            NavigationDestination(icon: Icon(Icons.menu), label: 'মেনু'),
          ],
        ),
      );
}

/// Shob tab er upor-er sonali header: business name dropdown + ইনবক্স + সাপোর্ট
class GoldHeader extends StatelessWidget {
  final Widget? child; // header er niche extra content (grid / summary)
  const GoldHeader({super.key, this.child});

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [kGoldTop, kGoldBottom]),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: Row(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  InkWell(
                    onTap: () => showBusinessSheet(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(20)),
                      child: const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.workspace_premium, size: 18, color: Color(0xFFB8860B)),
                        SizedBox(width: 6),
                        Text('Abu Tareq Grocery', style: TextStyle(fontWeight: FontWeight.w600)),
                        Icon(Icons.keyboard_arrow_down),
                      ]),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 6, top: 2), child: Text('গোল্ড (ট্রায়াল)', style: TextStyle(fontSize: 12))),
                ]),
                const Spacer(),
                _HeaderIcon(Icons.mark_email_unread_outlined, 'ইনবক্স', () => Navigator.pushNamed(context, Routes.inbox)),
                _HeaderIcon(Icons.chat_outlined, 'সাপোর্ট', () => Navigator.pushNamed(context, Routes.support)),
              ]),
            ),
            ?child,
          ]),
        ),
      );
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  const _HeaderIcon(this.icon, this.label, this.onTap);
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(children: [Icon(icon, size: 22), Text(label, style: const TextStyle(fontSize: 11))]),
        ),
      );
}

/// SS 12 : business list bottom sheet
void showBusinessSheet(BuildContext context) {
  showModalBottomSheet(
    context: context, isScrollControlled: true, backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (ctx) => Padding(
      padding: const EdgeInsets.all(16),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('ব্যবসা সমূহ (১/৩)'),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: () { Navigator.pop(ctx); Navigator.pushNamed(context, Routes.businessSettings); },
            icon: const Icon(Icons.settings_outlined, size: 16), label: const Text('সেটিংস')),
        ]),
        const ListTile(
          title: Text('Imam Abu Tareq Grocery'),
          subtitle: Text('কাস্টমার ০, সাপ্লায়ার ০ | মোট পাবো ০.০০'),
          trailing: Icon(Icons.check_circle, color: kGreen),
        ),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50), foregroundColor: kRed, side: const BorderSide(color: kRed)),
          onPressed: () { Navigator.pop(ctx); Navigator.pushNamed(context, Routes.newBusiness); },
          icon: const Icon(Icons.add), label: const Text('নতুন ব্যবসা'),
        ),
      ]),
    ),
  );
}

// ---------------------------------------------------------------- Tab 1: টালি (SS 10,11,41,42)
class TaliTab extends StatelessWidget {
  const TaliTab({super.key});

  @override
  Widget build(BuildContext context) {
    // icon, label, route
    final items = <(IconData, String, String?)>[
      (Icons.menu_book_outlined, 'মাল্টি ব্যবসা', null),
      (Icons.inventory_2_outlined, 'স্টক হিসাব', Routes.stock),
      (Icons.checklist, 'ব্যবসার নোট', Routes.note),
      (Icons.notifications_none, 'গ্রুপ তাগাদা', Routes.tagada),
      (Icons.qr_code_2, 'QR কোড', Routes.qrCode),
      (Icons.cloud_upload_outlined, 'ডাটা ব্যাকআপ', Routes.backup),
      (Icons.sms_outlined, 'টালি-মেসেজ', Routes.taliMessage),
      (Icons.inbox_outlined, 'ক্যাশবক্স', 'cashbox'), // special : tab 1 e jabe
    ];
    return Scaffold(
      body: Column(children: [
        GoldHeader(
          child: Column(children: [
            // Optional banner (SS 42)
            Container(
              margin: const EdgeInsets.fromLTRB(12, 8, 12, 4), height: 64,
              decoration: BoxDecoration(color: const Color(0xFFFBE4E8), borderRadius: BorderRadius.circular(8)),
              alignment: Alignment.center,
              child: const Text('বাংলা QR পেতে এখানে ট্যাপ করুন  ➜', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            GridView.count(
              crossAxisCount: 4, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8), childAspectRatio: 1.05,
              children: [
                for (final it in items)
                  InkWell(
                    onTap: () {
                      if (it.$3 == null) return;
                      if (it.$3 == 'cashbox') {
                        context.findAncestorStateOfType<_MainShellState>()?.selectTab(1); // ক্যাশবক্স tab
                      } else {
                        Navigator.pushNamed(context, it.$3!);
                      }
                    },
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(it.$1, size: 30, color: kRed),
                      const SizedBox(height: 6),
                      Text(it.$2, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
                    ]),
                  ),
              ],
            ),
          ]),
        ),
        const Padding(
          padding: EdgeInsets.all(12),
          child: Align(alignment: Alignment.centerLeft, child: Text('কাস্টমার ০ / সাপ্লায়ার ০')),
        ),
        const Expanded(child: EmptyState('ব্যবহার শুরু করতে কাস্টমার/সাপ্লায়ার যোগ করুন।', icon: Icons.person_outline)),
      ]),
      floatingActionButton: redFab('নতুন কাস্টমার/সাপ্লায়ার', Icons.person_add_alt, () => Navigator.pushNamed(context, Routes.addParty)),
    );
  }
}

// ---------------------------------------------------------------- Tab 2: ক্যাশবক্স (SS 14)
class CashboxTab extends StatelessWidget {
  const CashboxTab({super.key});
  @override
  Widget build(BuildContext context) {
    final rows = <(String, Color, IconData)>[
      ('ক্যাশ বেচা', kGreen, Icons.trending_up),
      ('ক্যাশ কেনা', kRed, Icons.trending_down),
      ('খরচ', kRed, Icons.trending_down),
      ('মালিক দিল', kGreen, Icons.trending_up),
      ('মালিক নিল', kRed, Icons.trending_down),
    ];
    return Column(children: [
      GoldHeader(
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Row(children: [
              Expanded(child: Column(children: [Text('০', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), Text('আজকের বেচা')])),
              Expanded(child: Column(children: [Text('০', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), Text('বর্তমান ক্যাশ')])),
            ]),
          ),
          Container(
            color: Colors.white, padding: const EdgeInsets.all(12),
            child: Row(children: [
              FilledButton.tonal(onPressed: () => Navigator.pushNamed(context, Routes.cashHisab), child: const Text('রিপোর্ট')),
              const Spacer(),
              OutlinedButton(onPressed: () => Navigator.pushNamed(context, Routes.cashHisab), child: const Text('ক্যাশবক্স মিলাই')),
            ]),
          ),
        ]),
      ),
      Expanded(
        child: ListView(children: [
          for (final r in rows)
            ListTile(
              leading: CircleAvatar(backgroundColor: r.$2.withValues(alpha: .12), child: Icon(r.$3, color: r.$2)),
              title: Text(r.$1, style: const TextStyle(fontSize: 17)),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                Text('0.00', style: TextStyle(color: r.$2, fontWeight: FontWeight.w600)),
                const Icon(Icons.chevron_right),
              ]),
              onTap: () {/* TODO: entry form page */},
            ),
        ]),
      ),
    ]);
  }
}

// ---------------------------------------------------------------- Tab 3: টালিপে (SS 15)
class TaliPayTab extends StatelessWidget {
  const TaliPayTab({super.key});
  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.add_card, 'অ্যাড মানি'), (Icons.send, 'সেন্ড মানি'), (Icons.account_balance, 'ব্যাংকে ট্রান্সফার'), (Icons.wallet, 'ওয়ালেট ট্রান্সফার'),
      (Icons.phone_android, 'মোবাইল রিচার্জ'), (Icons.shopping_bag_outlined, 'পেমেন্ট'), (Icons.qr_code_2, 'QR কোড'), (Icons.lightbulb_outline, 'বিল পেমেন্ট'),
    ];
    return Column(children: [
      GoldHeader(
        child: GridView.count(
          crossAxisCount: 4, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          children: [
            for (final it in items)
              Opacity(opacity: .4, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(it.$1, size: 28), const SizedBox(height: 6),
                Text(it.$2, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
              ])),
          ],
        ),
      ),
      const Expanded(child: EmptyState('টালিপে QR-এ পেমেন্ট নিন বিকাশ, রকেট সহ যেকোন ব্যাংকে বা মোবাইল ওয়ালেট থেকে।', icon: Icons.qr_code_scanner)),
      Padding(
        padding: const EdgeInsets.all(16),
        child: PrimaryButton('টালিপে QR একাউন্ট খুলুন', onPressed: () => Navigator.pushNamed(context, Routes.qrCode)),
      ),
    ]);
  }
}

// ---------------------------------------------------------------- Drawer (SS 16)
class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  Widget _item(BuildContext c, IconData icon, String text, String route) => ListTile(
        dense: true, leading: Icon(icon, size: 20), title: Text(text),
        onTap: () { Navigator.pop(c); Navigator.pushNamed(c, route); }, // age drawer bondho, tarpor page
      );

  @override
  Widget build(BuildContext context) => Drawer(
        child: SafeArea(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const ListTile(
              leading: CircleAvatar(backgroundColor: Color(0xFFF2C94C), child: Text('IA')),
              title: Text('Imam Abu Tar...', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('+8801862274810'),
              trailing: Icon(Icons.chevron_right),
            ),
            Container(
              color: kGoldTop.withValues(alpha: .6),
              child: const ListTile(
                leading: Icon(Icons.workspace_premium, color: Color(0xFFB8860B)),
                title: Text('টালিখাতা গোল্ড (ট্রায়াল)'), subtitle: Text('অবশিষ্ট: ৩০ দিন'),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
            const Padding(padding: EdgeInsets.fromLTRB(16, 12, 16, 0), child: Text('টালিখাতা', style: TextStyle(color: kRed))),
            _item(context, Icons.sell_outlined, 'বেচা কেনা হিসাব', Routes.buySell),
            _item(context, Icons.north_east, 'খরচ', Routes.expense),
            _item(context, Icons.receipt_long_outlined, 'বাকি হিসাব', Routes.baki),
            _item(context, Icons.payments_outlined, 'ক্যাশ হিসাব', Routes.cashHisab),
            _item(context, Icons.person_outline, 'মালিকের রিপোর্ট', Routes.ownerReport),
            const Padding(padding: EdgeInsets.fromLTRB(16, 12, 16, 0), child: Text('অন্যান্য', style: TextStyle(color: kRed))),
            _item(context, Icons.settings_outlined, 'সেটিংস', Routes.settings),
            const Spacer(),
            const Padding(padding: EdgeInsets.all(16), child: Text('টালিখাতা        ভার্সন - ৭.১৮.১')),
          ]),
        ),
      );
}
