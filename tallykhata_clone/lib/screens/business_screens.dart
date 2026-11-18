import 'package:flutter/material.dart';
import '../routes.dart';
import '../theme.dart';
import '../widgets/common.dart';

const kBusinessTypes = [
  'মুদি বা জেনারেল স্টোর', 'ফ্যাশন বা কাপড়ের ব্যবসা', 'মোবাইল ব্যাংকিং ও রিচার্জ পয়েন্ট', 'বেকারি ও কনফেকশনারি',
  'গৃহস্থালি ও ফার্নিচার', 'লাইব্রেরি ও স্টেশনারি', 'জুতার দোকান', 'ডিলার/ডিস্ট্রিবিউটর বা পাইকারি ব্যবসা',
  'হার্ডওয়্যার', 'ফার্মেসি', 'কসমেটিকস, বিউটি ও জুয়েলারি', 'রেস্টুরেন্ট বা মিষ্টির দোকান',
  'মোবাইল, কম্পিউটার ও ইলেকট্রনিক্স', 'কৃষি পণ্য ও উপকরণ', 'রড-সিমেন্ট/নির্মাণ সামগ্রী', 'গাড়ি ও অটো পার্টস',
  'টেইলার্স', 'অন্যান্য',
];

/// SS 36-ish bottom sheet : ব্যবসার ধরণ (2 column grid). Selected value return kore.
Future<String?> showBusinessTypeSheet(BuildContext context) => showModalBottomSheet<String>(
      context: context, isScrollControlled: true, backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => SizedBox(
        height: MediaQuery.of(ctx).size.height * .85,
        child: Column(children: [
          ListTile(
            title: const Text('আপনার ব্যবসার ধরণ কি?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            trailing: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, childAspectRatio: 2.4, padding: const EdgeInsets.all(12),
              mainAxisSpacing: 10, crossAxisSpacing: 10,
              children: [
                for (final t in kBusinessTypes)
                  InkWell(
                    onTap: () => Navigator.pop(ctx, t), // tap korlei value niye sheet bondho
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                      child: Row(children: [
                        const Icon(Icons.storefront_outlined, color: kRed), const SizedBox(width: 8),
                        Expanded(child: Text(t, style: const TextStyle(fontSize: 13))),
                      ]),
                    ),
                  ),
              ],
            ),
          ),
        ]),
      ),
    );

/// SS 13 : নতুন ব্যবসা  (name + ধরণ picker)
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
          child: Column(children: [
            AppField('ব্যবসা প্রতিষ্ঠানের নাম', icon: Icons.storefront_outlined, onChanged: (v) => setState(() => _name = v.trim())),
            const SizedBox(height: 14),
            _TypeTile(type: _type, onTap: () async {
              final t = await showBusinessTypeSheet(context);
              if (t != null) setState(() => _type = t);
            }),
            const Spacer(),
            PrimaryButton('নিশ্চিত', onPressed: (_name.isNotEmpty && _type != null) ? () => Navigator.pop(context) : null),
          ]),
        ),
      );
}

class _TypeTile extends StatelessWidget {
  final String? type; final VoidCallback onTap;
  const _TypeTile({required this.type, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade400)),
          child: Row(children: [
            const Icon(Icons.storefront_outlined), const SizedBox(width: 10),
            Expanded(child: Text(type ?? 'ব্যবসার ধরণ', style: const TextStyle(fontSize: 16))),
            const CircleAvatar(radius: 12, backgroundColor: Colors.grey, child: Icon(Icons.chevron_right, size: 16, color: Colors.white)),
          ]),
        ),
      );
}

/// SS 31 : ব্যবসার সেটিংস (3 ta option)
class BusinessSettingsScreen extends StatelessWidget {
  const BusinessSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: backBar(context, 'ব্যবসার সেটিংস'),
        body: ListView(children: [
          ListTile(
            title: const Text('প্রাইমারি ব্যবসা সেট করুন'), trailing: const Icon(Icons.chevron_right),
            onTap: () => _primarySheet(context),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('ব্যবসা এডিট করুন'), trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, Routes.businessEdit),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('ব্যবসা ডিলিট করুন'), trailing: const Icon(Icons.chevron_right),
            onTap: () => showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('ব্যবসা ডিলিট করবেন?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('না')),
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('হ্যাঁ', style: TextStyle(color: kRed))),
                ],
              ),
            ),
          ),
        ]),
      );

  // SS 32 : primary business radio sheet
  void _primarySheet(BuildContext context) => showModalBottomSheet(
        context: context, backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        builder: (ctx) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('ব্যবসা সমূহ (১/৩)'),
            RadioListTile(value: 0, groupValue: 0, onChanged: (_) {}, activeColor: kRed,
                title: const Text('Imam Abu Tareq Grocery'), subtitle: const Text('কাস্টমার ০, সাপ্লায়ার ০ | মোট পাবো ০.০০')),
            PrimaryButton('পরবর্তী', onPressed: () => Navigator.pop(ctx)),
          ]),
        ),
      );
}

/// SS 33, 36 : ব্যবসা এডিট
class BusinessEditScreen extends StatefulWidget {
  const BusinessEditScreen({super.key});
  @override
  State<BusinessEditScreen> createState() => _BusinessEditScreenState();
}

class _BusinessEditScreenState extends State<BusinessEditScreen> {
  final _name = TextEditingController(text: 'Imam Abu Tareq Grocery');
  String _type = 'মুদি বা জেনারেল স্টোর';
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: backBar(context, 'ব্যবসা এডিট'),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            AppField('ব্যবসা প্রতিষ্ঠানের নাম', icon: Icons.storefront_outlined, controller: _name),
            const SizedBox(height: 14),
            _TypeTile(type: _type, onTap: () async {
              final t = await showBusinessTypeSheet(context);
              if (t != null) setState(() => _type = t);
            }),
            const Spacer(),
            PrimaryButton('নিশ্চিত', onPressed: () => Navigator.pop(context)),
          ]),
        ),
      );
}
