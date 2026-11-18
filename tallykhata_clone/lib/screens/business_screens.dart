import 'package:flutter/material.dart';

import '../routes.dart';
import '../theme.dart';
import '../widgets/common.dart';

const kBusinessTypes = [
  'মুদি বা জেনারেল স্টোর',
  'ফ্যাশন বা কাপড়ের ব্যবসা',
  'মোবাইল ব্যাংকিং ও রিচার্জ পয়েন্ট',
  'বেকারি ও কনফেকশনারি',
  'গৃহস্থালি ও ফার্নিচার',
  'লাইব্রেরি ও স্টেশনারি',
  'জুতার দোকান',
  'ডিলার/ডিস্ট্রিবিউটর বা পাইকারি ব্যবসা',
  'হার্ডওয়্যার',
  'ফার্মেসি',
  'কসমেটিকস, বিউটি ও জুয়েলারি',
  'রেস্টুরেন্ট বা মিষ্টির দোকান',
  'মোবাইল, কম্পিউটার ও ইলেকট্রনিক্স',
  'কৃষি পণ্য ও উপকরণ',
  'রড-সিমেন্ট/নির্মাণ সামগ্রী',
  'গাড়ি ও অটো পার্টস',
  'টেইলার্স',
  'অন্যান্য',
];

/// Bottom sheet displaying a 2-column grid of business types; returns the selected type.
Future<String?> showBusinessTypeSheet(BuildContext context) =>
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SizedBox(
        height: MediaQuery.of(ctx).size.height * .85,
        child: Column(
          children: [
            ListTile(
              title: const Text(
                'আপনার ব্যবসার ধরণ কি?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(ctx),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 2.4,
                padding: const EdgeInsets.all(12),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  for (final t in kBusinessTypes)
                    InkWell(
                      onTap: () => Navigator.pop(
                        ctx,
                        t,
                      ), // Return selected value and close bottom sheet
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.storefront_outlined, color: kRed),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                t,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

/// Screen to create a new business with business name and type selector.
class NewBusinessScreen extends StatefulWidget {
  const NewBusinessScreen({super.key});
  @override
  State<NewBusinessScreen> createState() => _NewBusinessScreenState();
}

class _NewBusinessScreenState extends State<NewBusinessScreen> {
  String _name = '';
  String? _type;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: backBar(context, 'নতুন ব্যবসা'),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AppField(
            'ব্যবসা প্রতিষ্ঠানের নাম',
            icon: Icons.storefront_outlined,
            onChanged: (v) => setState(() => _name = v.trim()),
          ),
          const SizedBox(height: 14),
          _TypeTile(
            type: _type,
            onTap: () async {
              final t = await showBusinessTypeSheet(context);
              if (t != null) setState(() => _type = t);
            },
          ),
          const Spacer(),
          PrimaryButton(
            'নিশ্চিত',
            onPressed: (_name.isNotEmpty && _type != null)
                ? () => Navigator.pop(context)
                : null,
          ),
        ],
      ),
    ),
  );
}

class _TypeTile extends StatelessWidget {
  final String? type;
  final VoidCallback onTap;
  const _TypeTile({required this.type, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Row(
        children: [
          const Icon(Icons.storefront_outlined),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              type ?? 'ব্যবসার ধরণ',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const CircleAvatar(
            radius: 12,
            backgroundColor: Colors.grey,
            child: Icon(Icons.chevron_right, size: 16, color: Colors.white),
          ),
        ],
      ),
    ),
  );
}

/// Business settings screen with options to set primary business, edit, or delete business.
class BusinessSettingsScreen extends StatelessWidget {
  const BusinessSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: backBar(context, 'ব্যবসার সেটিংস'),
    body: ListView(
      children: [
        ListTile(
          title: const Text('প্রাইমারি ব্যবসা সেট করুন'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _primarySheet(context),
        ),
        const Divider(height: 1),
        ListTile(
          title: const Text('ব্যবসা এডিট করুন'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.pushNamed(context, Routes.businessEdit),
        ),
        const Divider(height: 1),
        ListTile(
          title: const Text('ব্যবসা ডিলিট করুন'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('ব্যবসা ডিলিট করবেন?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('না'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('হ্যাঁ', style: TextStyle(color: kRed)),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  // Bottom sheet to select the primary business
  void _primarySheet(BuildContext context) => showModalBottomSheet(
    context: context,
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
          const Text('ব্যবসা সমূহ (১/৫)'),
          ValueListenableBuilder<String>(
            valueListenable: businessNameNotifier,
            builder: (_, name, _) => RadioListTile(
              value: 0,
              groupValue: 0,
              onChanged: (_) {},
              activeColor: kRed,
              title: Text(name),
              subtitle: const Text('কাস্টমার ০, সাপ্লায়ার ০ | মোট পাবো ০.০০'),
            ),
          ),
          PrimaryButton('পরবর্তী', onPressed: () => Navigator.pop(ctx)),
        ],
      ),
    ),
  );
}

/// Screen to edit the current business name and business type.
class BusinessEditScreen extends StatefulWidget {
  const BusinessEditScreen({super.key});
  @override
  State<BusinessEditScreen> createState() => _BusinessEditScreenState();
}

class _BusinessEditScreenState extends State<BusinessEditScreen> {
  late final TextEditingController _name = TextEditingController(
    text: businessNameNotifier.value,
  );
  String _type = businessTypeNotifier.value;
  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: backBar(context, 'ব্যবসা এডিট'),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AppField(
            'ব্যবসা প্রতিষ্ঠানের নাম',
            icon: Icons.storefront_outlined,
            controller: _name,
          ),
          const SizedBox(height: 14),
          _TypeTile(
            type: _type,
            onTap: () async {
              final t = await showBusinessTypeSheet(context);
              if (t != null) setState(() => _type = t);
            },
          ),
          const Spacer(),
          PrimaryButton(
            'নিশ্চিত',
            onPressed: () {
              final updated = _name.text.trim();
              if (updated.isNotEmpty) {
                businessNameNotifier.value = updated;
              }
              businessTypeNotifier.value = _type;
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ),
  );
}

/// User and business profile information screen opened from the navigation drawer.
class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});
  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  String _ownerName = '';
  String _nid = '';
  String _businessAge = '';
  String _address = '';

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'ট';
    if (parts.length == 1) {
      return parts.first.characters.take(2).toString().toUpperCase();
    }
    return '${parts[0].characters.first}${parts[1].characters.first}'
        .toUpperCase();
  }

  Widget _infoField(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 26),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 15, color: Colors.black54),
        ),
        if (value.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 18, color: Colors.black87),
          ),
        ] else
          const SizedBox(height: 18),
      ],
    ),
  );

  Future<void> _showEditSheet() async {
    final ownerCtrl = TextEditingController(text: _ownerName);
    final nidCtrl = TextEditingController(text: _nid);
    final ageCtrl = TextEditingController(text: _businessAge);
    final addrCtrl = TextEditingController(text: _address);
    String selectedType = businessTypeNotifier.value;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'তথ্য আপডেট করুন',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 14),
                AppField('নাম', controller: ownerCtrl),
                const SizedBox(height: 12),
                _TypeTile(
                  type: selectedType,
                  onTap: () async {
                    final t = await showBusinessTypeSheet(ctx);
                    if (t != null) setSheetState(() => selectedType = t);
                  },
                ),
                const SizedBox(height: 12),
                AppField(
                  'NID নম্বর',
                  controller: nidCtrl,
                  keyboard: TextInputType.number,
                ),
                const SizedBox(height: 12),
                AppField(
                  'ব্যবসা প্রতিষ্ঠানের আনুমানিক বয়স (বছর)',
                  controller: ageCtrl,
                  keyboard: TextInputType.number,
                ),
                const SizedBox(height: 12),
                AppField('ব্যবসা প্রতিষ্ঠানের ঠিকানা', controller: addrCtrl),
                const SizedBox(height: 16),
                PrimaryButton(
                  'নিশ্চিত',
                  onPressed: () {
                    setState(() {
                      _ownerName = ownerCtrl.text.trim();
                      _nid = nidCtrl.text.trim();
                      _businessAge = ageCtrl.text.trim();
                      _address = addrCtrl.text.trim();
                    });
                    businessTypeNotifier.value = selectedType;
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backBar(context, 'আপনার তথ্য সমূহ'),
      body: ValueListenableBuilder<String>(
        valueListenable: businessNameNotifier,
        builder: (_, businessName, _) {
          final phone = userPhoneNotifier.value;
          return ValueListenableBuilder<String>(
            valueListenable: businessTypeNotifier,
            builder: (_, businessType, _) => ListView(
              children: [
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 27,
                        backgroundColor: const Color(0xFFF2C94C),
                        child: Text(
                          _initials(businessName),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              businessName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              phone.isNotEmpty ? phone : '01862274810',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 6, color: const Color(0xFFF3F4F6)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'অন্যান্য তথ্য',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: _showEditSheet,
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF3F4F6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.drive_file_rename_outline,
                                size: 20,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _infoField('নাম', _ownerName),
                      _infoField('ব্যবসার ধরণ', businessType),
                      _infoField('NID নম্বর', _nid),
                      _infoField(
                        'ব্যবসা প্রতিষ্ঠানের আনুমানিক বয়স (বছর)',
                        _businessAge,
                      ),
                      _infoField('ব্যবসা প্রতিষ্ঠানের ঠিকানা', _address),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
