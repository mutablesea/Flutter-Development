import 'package:flutter/material.dart';
import '../routes.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Stock management screen showing products and an action button to add a product.
class StockScreen extends StatelessWidget {
  const StockScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: backBar(context, 'স্টক হিসাব', actions: const [HelpChip()]),
        body: const EmptyState('প্রোডাক্ট যোগ করে স্টকের হিসাব রাখুন।', icon: Icons.inventory_2_outlined),
        floatingActionButton: redFab('নতুন প্রোডাক্ট', Icons.add, () => Navigator.pushNamed(context, Routes.addProduct)),
      );
}

/// Screen to add a new product with product name and unit selector.
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String _name = '';
  String? _unit;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: backBar(context, 'নতুন প্রোডাক্ট'),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            AppField('প্রোডাক্ট এর নাম', icon: Icons.inventory_2_outlined, onChanged: (v) => setState(() => _name = v.trim())),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _unit, decoration: const InputDecoration(hintText: 'প্রোডাক্ট এর ইউনিট', prefixIcon: Icon(Icons.straighten)),
              items: const ['কেজি', 'গ্রাম', 'লিটার', 'পিস', 'ডজন'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _unit = v),
            ),
            const Spacer(),
            PrimaryButton('নিশ্চিত', onPressed: (_name.isNotEmpty && _unit != null) ? () => Navigator.pop(context) : null),
          ]),
        ),
      );
}

/// Business notes list screen.
class NoteScreen extends StatelessWidget {
  const NoteScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: backBar(context, 'ব্যবসার নোট', actions: const [HelpChip()]),
        body: const EmptyState('পণ্য তালিকা বা প্রয়োজনীয় নোট লিখে রাখুন ও শেয়ার করুন।'),
        floatingActionButton: redFab('নোট যোগ করি', Icons.add, () => Navigator.pushNamed(context, Routes.addNote)),
      );
}

/// Screen to compose a new business note with checkbox and auto-focused text field.
class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: backBar(context, 'ব্যবসার নোট', actions: const [HelpChip()]),
        body: Container(
          color: Colors.grey.shade100, padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(children: [
            Checkbox(value: false, onChanged: (_) {}),
            const Expanded(child: TextField(autofocus: true, decoration: InputDecoration(border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none))),
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey, onPressed: () => Navigator.pop(context), child: const Icon(Icons.check, color: Colors.white)),
      );
}

/// Group payment reminder (Tagada) screen.
class TagadaScreen extends StatelessWidget {
  const TagadaScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: backBar(context, 'তাগাদা পাঠাই', actions: const [HelpChip()]),
        body: const EmptyState('কোনো কাস্টমার পাওয়া যায়নি।', icon: Icons.chat_bubble_outline),
      );
}

/// Data backup status and manual backup trigger screen.
class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: backBar(context, 'ডাটা ব্যাকআপ'),
        body: Column(children: [
          const SizedBox(height: 40),
          const CircleAvatar(radius: 40, backgroundColor: kGreen, child: Icon(Icons.cloud_done, size: 44, color: Colors.white)),
          const SizedBox(height: 12),
          const Text('সব ডাটা ব্যাকআপ নেয়া আছে।'),
          const Divider(height: 40),
          const Align(alignment: Alignment.centerLeft, child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('সর্বশেষ ব্যাকআপঃ'),
              Text('১৬ নভেম্বর, ০৮:০০ PM', style: TextStyle(color: kGreen, fontWeight: FontWeight.bold, fontSize: 16)),
            ]),
          )),
          const Spacer(),
          Padding(padding: const EdgeInsets.all(16), child: PrimaryButton('ডাটা ব্যাকআপ করুন', onPressed: null)),
        ]),
      );
}

/// Screen to view SMS balance and purchase Tally-Message packs.
class TaliMessageScreen extends StatelessWidget {
  const TaliMessageScreen({super.key});
  @override
  Widget build(BuildContext context) {
    const packs = [
      ('৬৫০ টালি-মেসেজ', '৳ ৩৫০.০', 'অধিক সাশ্রয়ী'),
      ('৩৫০ টালি-মেসেজ', '৳ ২০০.০', 'সাশ্রয়ী'),
      ('২০০ টালি-মেসেজ', '৳ ১২০.০', null),
      ('১০০ টালি-মেসেজ', '৳ ৭০.০', null),
      ('২৫ টালি-মেসেজ', '৳ ২০.০', null),
    ];
    return Scaffold(
      appBar: backBar(context, 'টালি-মেসেজ কিনি', actions: [
        Padding(padding: const EdgeInsets.only(right: 12), child: FilledButton.tonal(onPressed: () {}, child: const Text('রিপোর্ট'))),
      ]),
      body: ListView(padding: const EdgeInsets.all(12), children: [
        Container(color: Colors.grey.shade100, padding: const EdgeInsets.all(12),
            child: const Row(children: [Text('টালি-মেসেজ ব্যালেন্স'), Spacer(), Text('১০', style: TextStyle(fontWeight: FontWeight.bold))])),
        const SizedBox(height: 12),
        const Text('টালি-মেসেজ প্যাক সিলেক্ট করি'),
        for (final p in packs)
          Card(
            color: Colors.grey.shade100, elevation: 0, margin: const EdgeInsets.only(top: 10),
            child: ListTile(
              leading: const Icon(Icons.sms, color: kRed),
              title: Text(p.$1, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: p.$3 == null ? null : Text(p.$3!, style: const TextStyle(color: Color(0xFFB8860B))),
              trailing: Chip(label: Text(p.$2, style: const TextStyle(color: Colors.white)), backgroundColor: kRed, side: BorderSide.none),
              onTap: () {/* buy flow */},
            ),
          ),
      ]),
    );
  }
}
