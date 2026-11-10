import 'package:flutter/material.dart';

import '../database/db_helper.dart';
import '../main.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback? onDataChanged;

  const SettingsPage({super.key, this.onDataChanged});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _confirmBeforeDelete = true;
  String _defaultKhatianType = 'RS';

  Future<void> _confirmClearDatabase() async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          tr('সব খতিয়ান মুছে ফেলবেন?', 'Clear All Khatian Records?'),
        ),
        content: Text(
          tr(
            'এটি ডাটাবেস থেকে আপনার যোগ করা সব খতিয়ান মুছে ফেলবে।',
            'This will remove all user-added Khatian records from the database.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(tr('বাতিল', 'Cancel')),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await DatabaseHelper().clearAllKhatians();
              widget.onDataChanged?.call();
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    tr('সব খতিয়ান মুছে ফেলা হয়েছে।', 'All records cleared.'),
                  ),
                ),
              );
            },
            child: Text(tr('মুছে ফেলুন', 'Clear All')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('সেটিংস (Settings)', 'Settings')),
      ),
      body: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeModeNotifier,
        builder: (context, currentTheme, _) {
          return ValueListenableBuilder<String>(
            valueListenable: languageNotifier,
            builder: (context, currentLang, _) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 1. Language Switcher Section (Bangla & English)
                  _buildSectionHeader(
                    tr('ভাষা পরিবর্তন (Language Mode)', 'Language Mode'),
                    Icons.translate_rounded,
                  ),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr(
                              'অ্যাপের ভাষা বেছে নিন (বাংলা / English)',
                              'Choose App Language (Bangla / English)',
                            ),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(
                                value: 'bn',
                                icon: Icon(Icons.language_rounded),
                                label: Text('বাংলা (Bangla)'),
                              ),
                              ButtonSegment(
                                value: 'en',
                                icon: Icon(Icons.translate_rounded),
                                label: Text('English'),
                              ),
                            ],
                            selected: {currentLang},
                            onSelectionChanged: (selection) {
                              languageNotifier.value = selection.first;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 2. Theme Mode Section
                  _buildSectionHeader(
                    tr('থিম ও অ্যাপিয়ারেন্স (Appearance)', 'Appearance'),
                    Icons.palette_outlined,
                  ),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr('থিম মোড (Theme Mode)', 'Theme Mode'),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SegmentedButton<ThemeMode>(
                            segments: [
                              ButtonSegment(
                                value: ThemeMode.system,
                                icon: const Icon(Icons.brightness_auto),
                                label: Text(tr('সিস্টেম', 'System')),
                              ),
                              ButtonSegment(
                                value: ThemeMode.light,
                                icon: const Icon(Icons.light_mode),
                                label: Text(tr('লাইট', 'Light')),
                              ),
                              ButtonSegment(
                                value: ThemeMode.dark,
                                icon: const Icon(Icons.dark_mode),
                                label: Text(tr('ডার্ক', 'Dark')),
                              ),
                            ],
                            selected: {currentTheme},
                            onSelectionChanged: (selection) {
                              themeModeNotifier.value = selection.first;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 3. Preferences & Database Section
                  _buildSectionHeader(
                    tr('খতিয়ান ও ডাটাবেস সেটিংস', 'Khatian & Data Management'),
                    Icons.storage_rounded,
                  ),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.folder_outlined),
                          title: Text(
                            tr('ডিফল্ট খতিয়ান ধরন', 'Default Khatian Type'),
                          ),
                          trailing: DropdownButton<String>(
                            value: _defaultKhatianType,
                            underline: const SizedBox.shrink(),
                            items: ['CS', 'RS', 'SA', 'BRS', 'BDS', 'Kharij']
                                .map(
                                  (t) => DropdownMenuItem(
                                    value: t,
                                    child: Text(t),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _defaultKhatianType = val);
                              }
                            },
                          ),
                        ),
                        const Divider(height: 1),
                        SwitchListTile(
                          secondary: const Icon(Icons.delete_sweep_outlined),
                          title: Text(
                            tr(
                              'মুছে ফেলার আগে নিশ্চিত করুন',
                              'Confirm Before Delete',
                            ),
                          ),
                          value: _confirmBeforeDelete,
                          onChanged: (val) {
                            setState(() => _confirmBeforeDelete = val);
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: Icon(
                            Icons.delete_forever_rounded,
                            color: theme.colorScheme.error,
                          ),
                          title: Text(
                            tr('সব খতিয়ান মুছে ফেলুন', 'Clear All Records'),
                          ),
                          onTap: _confirmClearDatabase,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 4. About Section
                  _buildSectionHeader(
                    tr('অ্যাপ সম্পর্কে (About)', 'About'),
                    Icons.info_outline_rounded,
                  ),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            kPrimaryDeepIndigo.withValues(alpha: 0.12),
                        child: const Icon(
                          Icons.landscape_rounded,
                          color: kPrimaryDeepIndigo,
                        ),
                      ),
                      title: const Text('Bhumi Calc'),
                      subtitle: Text(
                        tr(
                          'ভার্সন ১.০.০ • ফ্লাটার এবং SQLite দিয়ে তৈরি',
                          'Version 1.0.0 • Built with Flutter & SQLite',
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: kPrimaryDeepIndigo),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: kPrimaryDeepIndigo,
            ),
          ),
        ],
      ),
    );
  }
}
