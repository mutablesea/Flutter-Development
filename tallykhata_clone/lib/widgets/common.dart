import 'package:flutter/material.dart';
import '../theme.dart';

/// Primary full-width red action button; appears faded when [onPressed] is null.
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

/// Placeholder widget for empty states showing a large icon and a message.
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

/// Standard AppBar with a back button, title, and optional active business name subtitle.
PreferredSizeWidget backBar(
  BuildContext c,
  String title, {
  List<Widget>? actions,
  bool showBusinessName = false,
}) =>
    AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(c),
      ),
      title: showBusinessName
          ? ValueListenableBuilder<String>(
              valueListenable: businessNameNotifier,
              builder: (_, businessName, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    businessName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            )
          : Text(title, style: const TextStyle(fontSize: 18)),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: Color(0xFFEEEEEE)),
      ),
      actions: actions,
    );

/// Help chip button displayed in AppBar actions.
class HelpChip extends StatelessWidget {
  const HelpChip({super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Chip(
          avatar: const Icon(Icons.help_outline, size: 18, color: Colors.black87),
          label: const Text('হেল্প', style: TextStyle(fontSize: 13)),
          backgroundColor: const Color(0xFFF3F4F6),
          shape: const StadiumBorder(),
          side: BorderSide.none,
        ),
      );
}

/// Red extended FloatingActionButton used for primary creation actions.
Widget redFab(String text, IconData icon, VoidCallback onTap) => FloatingActionButton.extended(
      onPressed: onTap, backgroundColor: kRed, foregroundColor: Colors.white,
      icon: Icon(icon), label: Text(text, style: const TextStyle(fontSize: 16)),
    );

/// Styled text input field with optional leading icon.
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
