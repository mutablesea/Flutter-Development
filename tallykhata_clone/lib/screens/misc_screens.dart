import 'package:flutter/material.dart';
import '../routes.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// App settings screen with toggle switches and profile/security options.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _decimal = true, _sound = true, _voice = true;

  Widget _head(String t) => Container(
        width: double.infinity, color: Colors.grey.shade100, padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
        child: Text(t, style: const TextStyle(color: Colors.black54)));

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: backBar(context, 'সেটিংস'),
        body: ListView(children: [
          _head('সাধারণ সেটিংস'),
          SwitchListTile(activeColor: kGreen, value: _decimal, onChanged: (v) => setState(() => _decimal = v),
              title: const Text('টাকার অংকে দশমিক'), subtitle: const Text('উদাহরণঃ ১২,০০০.০০')),
          SwitchListTile(activeColor: kGreen, value: _sound, onChanged: (v) => setState(() => _sound = v),
              title: const Text('নোটিফিকেশন সাউন্ড'), subtitle: const Text('টালিখাতা নোটিফিকেশনে সাউন্ড এলার্ট')),
          SwitchListTile(activeColor: kGreen, value: _voice, onChanged: (v) => setState(() => _voice = v),
              title: const Text('ভয়েস নোটিফিকেশন'), subtitle: const Text('ভয়েসের মাধ্যমে পেমেন্ট এলার্ট')),
          _head('প্রোফাইল সেটিংস'),
          ListTile(leading: const Icon(Icons.phone_outlined), title: const Text('মোবাইল নম্বর পরিবর্তন'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
          _head('অ্যাপ সিকিউরিটি'),
          ListTile(leading: const Icon(Icons.key), title: const Text('PIN সেট করুন'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
        ]),
      );
}

/// Inbox screen listing notifications; tapping an item opens the detail screen.
class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});
  @override
  Widget build(BuildContext context) {
    const msgs = [
      ('বাংলা QR নিন মাত্র ২ মিনিটেই।', 'ট্যালিপে QR পেমেন্টে চার্জ একদম ফ্রি!', '১ মিনিট আগে'),
      ('৫০ লাখ ব্যবসায়ীর আস্থা!', 'দেশজুড়ে ব্যবসায়ীদের সবচেয়ে বড় নেটওয়ার্ক টালিখাতা অ্যাপ।', '১ মিনিট আগে'),
      ('বাংলা QR নিন মাত্র ২ মিনিটেই।', 'ট্যালিপে QR পেমেন্টে চার্জ একদম ফ্রি!', '১৫ ঘন্টা আগে'),
    ];
    return Scaffold(
      appBar: backBar(context, 'ইনবক্স'),
      body: ListView.separated(
        padding: const EdgeInsets.all(12), itemCount: msgs.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (_, i) => ListTile(
          leading: Image.asset('assets/images/tallykhata_logo.png', width: 44, height: 44),
          title: Text(msgs[i].$1, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text('${msgs[i].$2}\n${msgs[i].$3}', style: const TextStyle(fontSize: 12)),
          isThreeLine: true,
          onTap: () => Navigator.pushNamed(context, Routes.inboxDetail, arguments: msgs[i].$1),
        ),
      ),
    );
  }
}

/// Inbox notification detail screen with banner, message body, and action button.
class InboxDetailScreen extends StatelessWidget {
  const InboxDetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final title = ModalRoute.of(context)?.settings.arguments as String? ?? 'বিস্তারিত';
    return Scaffold(
      appBar: backBar(context, 'বিস্তারিত'),
      body: Column(children: [
        Expanded(
          child: ListView(padding: const EdgeInsets.all(16), children: [
            Container(height: 150, decoration: BoxDecoration(color: const Color(0xFFFBE4E8), borderRadius: BorderRadius.circular(8)),
                alignment: Alignment.center, child: const Text('মার্চেন্টের কোন খরচ নেই!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('১৭ নভেম্বর ২০২৬ | ১১:০২ AM', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            const Text('টালিখাতা ও টালিপে সার্ভিসে স্বাগতম! ২,০০০ পর্যন্ত বাংলা QR পেমেন্টে চার্জ একদম ফ্রি।'),
          ]),
        ),
        Padding(padding: const EdgeInsets.all(16), child: PrimaryButton('বাংলা QR পেতে ট্যাপ করুন ➜', onPressed: () => Navigator.pushNamed(context, Routes.qrCode))),
      ]),
    );
  }
}

/// Customer support screen with FAQ quick-action cards and bottom chat input.
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});
  @override
  Widget build(BuildContext context) {
    const faq = ['টালিপে QR-এ চার্জ কত?', 'ফ্রি পেতে কত টাকা ট্রান্সফার করতে হবে?', 'অক্টোবর এর আগের ব্যালেন্স এর চার্জ কত?', 'নগদ থেকে টালিপে বাংলা QR-এ পেমেন্ট হচ্ছে না কেন?'];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: const Text('সাপোর্ট', style: TextStyle(fontSize: 18)),
        actions: [
          TextButton.icon(onPressed: () {}, icon: const Icon(Icons.headset_mic_outlined, size: 18), label: const Text('হেল্পলাইন')),
          TextButton.icon(onPressed: () {}, icon: const Icon(Icons.history, size: 18), label: const Text('হিস্ট্রি')),
        ],
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Icon(Icons.chat, size: 60, color: Colors.orange),
        const Center(child: Text('স্বাগতম আপনাকে', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        const SizedBox(height: 6),
        const Text('কীভাবে সাহায্য করতে পারি? প্রশ্ন বেছে নিন অথবা নিজে লিখুন।', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5, mainAxisSpacing: 10, crossAxisSpacing: 10,
          children: [for (final q in faq) OutlinedButton(
            style: OutlinedButton.styleFrom(foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () {}, child: Text(q, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)))],
        ),
        const SizedBox(height: 16),
        Center(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.play_arrow), label: const Text('FAQ ভিডিও'))),
      ]),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 12, right: 12, bottom: MediaQuery.of(context).viewInsets.bottom + 8, top: 4),
          child: Row(children: [
            const Expanded(child: TextField(decoration: InputDecoration(hintText: 'আপনি কি জানতে চান এখানে লিখুন'))),
            IconButton(onPressed: () {}, icon: const Icon(Icons.send, color: kRed)),
          ]),
        ),
      ),
    );
  }
}

/// Screen to add a new customer or supplier with role toggle, name, and phone fields.
class AddPartyScreen extends StatefulWidget {
  const AddPartyScreen({super.key});
  @override
  State<AddPartyScreen> createState() => _AddPartyScreenState();
}

class _AddPartyScreenState extends State<AddPartyScreen> {
  String _type = 'customer';
  String _name = '';
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: backBar(context, 'নতুন কাস্টমার/সাপ্লায়ার'),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Row(children: [
              const CircleAvatar(radius: 28, backgroundColor: Colors.grey, child: Icon(Icons.camera_alt, color: Colors.white)),
              const SizedBox(width: 12),
              Expanded(child: _radio('customer', 'কাস্টমার')), const SizedBox(width: 8), Expanded(child: _radio('supplier', 'সাপ্লায়ার')),
            ]),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              onPressed: () {}, icon: const Icon(Icons.contacts_outlined), label: const Text('ফোনবুক থেকে যোগ করি')),
            const SizedBox(height: 14),
            AppField('নাম', icon: Icons.person_outline, onChanged: (v) => setState(() => _name = v.trim())),
            const SizedBox(height: 14),
            AppField('মোবাইল নম্বর', icon: Icons.phone_outlined, keyboard: TextInputType.phone),
            const Spacer(),
            PrimaryButton('নিশ্চিত', onPressed: _name.isEmpty ? null : () => Navigator.pop(context)),
          ]),
        ),
      );

  Widget _radio(String v, String label) => InkWell(
        onTap: () => setState(() => _type = v),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: _type == v ? kRed : Colors.grey.shade400)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(_type == v ? Icons.radio_button_checked : Icons.radio_button_off, color: _type == v ? kRed : Colors.grey, size: 20),
            const SizedBox(width: 4), Text(label),
          ]),
        ),
      );
}
