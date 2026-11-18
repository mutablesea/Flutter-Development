import 'package:flutter/material.dart';
import '../theme.dart';

/// Niche-er lal "নিশ্চিত / পরবর্তী" button. onPressed null hole faded dekhabe.
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  const PrimaryButton(this.text, {super.key, this.onPressed});
  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity, height: 52,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: kRed, foregroundColor: Colors.white,
            disabledBackgroundColor: kRedLight, disabledForegroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ),
      );
}

/// Khali obostha: icon + text (e.g. "কোন লেনদেন নেই।")
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String text;
  const EmptyState(this.text, {super.key, this.icon = Icons.description_outlined});
  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 90, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
        ]),
      );
}

/// Back arrow + title wala AppBar (prai shob page e lage)
PreferredSizeWidget backBar(BuildContext c, String title, {List<Widget>? actions}) => AppBar(
      leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(c)),
      title: Text(title, style: const TextStyle(fontSize: 18)),
      actions: actions,
    );

/// "হেল্প" pill button
class HelpChip extends StatelessWidget {
  const HelpChip({super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Chip(
          avatar: const Icon(Icons.help_outline, size: 16),
          label: const Text('হেল্প'),
          backgroundColor: Colors.grey.shade200, side: BorderSide.none,
        ),
      );
}

/// Bottom-e lal pill FAB: "নতুন কাস্টমার/সাপ্লায়ার" ba "নোট যোগ করি"
Widget redFab(String text, IconData icon, VoidCallback onTap) => FloatingActionButton.extended(
      onPressed: onTap, backgroundColor: kRed, foregroundColor: Colors.white,
      icon: Icon(icon), label: Text(text, style: const TextStyle(fontSize: 16)),
    );

/// Label-soho input field (screenshot er rounded border field)
class AppField extends StatelessWidget {
  final String hint;
  final IconData? icon;
  final TextInputType? keyboard;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  const AppField(this.hint, {super.key, this.icon, this.keyboard, this.onChanged, this.controller});
  @override
  Widget build(BuildContext context) => TextField(
        controller: controller, keyboardType: keyboard, onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint, prefixIcon: icon == null ? null : Icon(icon),
          hintStyle: TextStyle(color: Colors.grey.shade500),
        ),
      );
}
