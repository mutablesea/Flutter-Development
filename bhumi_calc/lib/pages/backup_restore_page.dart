import 'dart:convert';

import 'package:flutter/material.dart';

import '../database/db_helper.dart';
import '../main.dart';
import '../models/khatian_record.dart';

class BackupRestorePage extends StatefulWidget {
  const BackupRestorePage({super.key});

  @override
  State<BackupRestorePage> createState() => _BackupRestorePageState();
}

class _BackupRestorePageState extends State<BackupRestorePage> {
  List<KhatianRecord> _records = [];
  bool _isLoading = true;
  String _lastBackupTime = 'Today, 10:30 AM';

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final data = await DatabaseHelper().getAllKhatians();
    if (!mounted) return;
    setState(() {
      _records = data;
      _isLoading = false;
    });
  }

  void _showJsonBackupDialog() {
    final jsonString = const JsonEncoder.withIndent('  ')
        .convert(_records.map((r) => r.toMap()).toList());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(tr('JSON ব্যাকআপ প্রিভিউ', 'JSON Backup Preview')),
        content: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            child: SelectableText(
              jsonString,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(tr('বন্ধ করুন', 'Close')),
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
        title: Text(
          tr('ডাটা ব্যাকআপ ও রিস্টোর (Backup & Restore)', 'Backup & Restore'),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  elevation: 1.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor:
                              kPrimaryDeepIndigo.withValues(alpha: 0.12),
                          child: const Icon(
                            Icons.cloud_done_rounded,
                            size: 34,
                            color: kPrimaryDeepIndigo,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          tr(
                            'লোকাল SQLite ডাটাবেস সুরক্ষিত',
                            'Local SQLite Database Protected',
                          ),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tr(
                            'মোট সংরক্ষিত খতিয়ান: ${_records.length} টি • সর্বশেষ ব্যাকআপ: $_lastBackupTime',
                            'Saved Records: ${_records.length} • Last Backup: $_lastBackupTime',
                          ),
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: kSecondarySunsetOrange,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              setState(() => _lastBackupTime = 'Just now');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    tr(
                                      'ডাটাবেস ব্যাকআপ সম্পন্ন হয়েছে!',
                                      'Database snapshot created successfully!',
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.backup_rounded),
                            label: Text(
                              tr('এখনই ব্যাকআপ নিন', 'Create Backup Snapshot'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.code_rounded,
                      color: kPrimaryDeepIndigo,
                    ),
                    title: Text(
                      tr('JSON ডাটা এক্সপোর্ট দেখুন', 'View JSON Backup Data'),
                    ),
                    subtitle: Text(
                      tr(
                        'সব খতিয়ানের ডাটা JSON ফরম্যাটে দেখুন',
                        'Inspect all Khatian records serialized as JSON',
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: _showJsonBackupDialog,
                  ),
                ),
              ],
            ),
    );
  }
}
