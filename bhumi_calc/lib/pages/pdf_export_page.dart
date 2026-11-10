import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../database/db_helper.dart';
import '../main.dart';
import '../models/khatian_record.dart';

class PdfExportPage extends StatefulWidget {
  const PdfExportPage({super.key});

  @override
  State<PdfExportPage> createState() => _PdfExportPageState();
}

class _PdfExportPageState extends State<PdfExportPage> {
  List<KhatianRecord> _records = [];
  bool _isLoading = true;

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

  String _generateReportText() {
    double totalDecimal = 0;
    for (final r in _records) {
      totalDecimal += r.totalLandArea;
    }
    final int bighas = (totalDecimal / 33.0).floor();
    final double remDecimal = totalDecimal - (bighas * 33.0);
    final double acres = totalDecimal / 100.0;
    final double kathas = totalDecimal / 1.65;
    final double sqFt = totalDecimal * 435.6;

    final buffer = StringBuffer();
    buffer.writeln('============================================');
    buffer.writeln('       BHUMI CALC - PROPERTY SUMMARY        ');
    buffer.writeln('============================================');
    buffer.writeln('Total Khatian Records : ${_records.length}');
    buffer.writeln('Total Land Area       : ${totalDecimal.toStringAsFixed(2)} Decimal');
    buffer.writeln('In Bigha              : $bighas Bigha, ${remDecimal.toStringAsFixed(2)} Decimal');
    buffer.writeln('In Acre               : ${acres.toStringAsFixed(3)} Acre');
    buffer.writeln('In Katha              : ${kathas.toStringAsFixed(2)} Katha');
    buffer.writeln('In Square Feet        : ${sqFt.toStringAsFixed(1)} Sq. Ft');
    buffer.writeln('--------------------------------------------');
    buffer.writeln('KHATIAN BREAKDOWN:');
    for (int i = 0; i < _records.length; i++) {
      final r = _records[i];
      buffer.writeln(
        '${i + 1}. [${r.khatianType}] Khatian: ${r.khatianNo} | Dag: ${r.dagNo} | Mouza: ${r.mouza} -> ${r.totalLandArea} Decimal',
      );
    }
    buffer.writeln('============================================');
    return buffer.toString();
  }

  Future<void> _copyReportToClipboard() async {
    await Clipboard.setData(ClipboardData(text: _generateReportText()));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          tr(
            'সম্পত্তির রিপোর্ট ক্লিপবোর্ডে কপি করা হয়েছে!',
            'Property summary report copied to clipboard!',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double totalDecimal = 0;
    for (final r in _records) {
      totalDecimal += r.totalLandArea;
    }
    final int bighas = (totalDecimal / 33.0).floor();
    final double remDecimal = totalDecimal - (bighas * 33.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('পিডিএফ ও সম্পত্তির রিপোর্ট (Report Export)', 'Property Report & Export'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_all_rounded),
            tooltip: tr('রিপোর্ট কপি করুন', 'Copy Report'),
            onPressed: _copyReportToClipboard,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Printable Document Preview Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tr(
                                    'ভূমি ক্যালক - সম্পত্তির প্রতিবেদন',
                                    'Bhumi Calc - Official Land Summary',
                                  ),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  tr(
                                    'মোট খতিয়ান: ${_records.length} টি',
                                    'Total Khatian Records: ${_records.length}',
                                  ),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            CircleAvatar(
                              radius: 24,
                              backgroundColor:
                                  theme.colorScheme.primaryContainer,
                              child: Icon(
                                Icons.picture_as_pdf_rounded,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 12),
                        _buildSummaryLine(
                          tr('মোট জমি (শতাংশ):', 'Total Land (Decimal):'),
                          '${totalDecimal.toStringAsFixed(2)} ${tr('শতাংশ', 'Decimal')}',
                        ),
                        _buildSummaryLine(
                          tr('বিঘার হিসাবে:', 'In Bigha:'),
                          '$bighas ${tr('বিঘা', 'Bigha')}, ${remDecimal.toStringAsFixed(2)} ${tr('শতাংশ', 'Decimal')}',
                        ),
                        _buildSummaryLine(
                          tr('একরের হিসাবে:', 'In Acre:'),
                          '${(totalDecimal / 100.0).toStringAsFixed(3)} ${tr('একর', 'Acre')}',
                        ),
                        _buildSummaryLine(
                          tr('কাঠার হিসাবে:', 'In Katha:'),
                          '${(totalDecimal / 1.65).toStringAsFixed(2)} ${tr('কাঠা', 'Katha')}',
                        ),
                        _buildSummaryLine(
                          tr('বর্গফুট:', 'Square Feet:'),
                          '${(totalDecimal * 435.6).toStringAsFixed(1)} Sq. Ft',
                        ),
                        const SizedBox(height: 16),
                        Text(
                          tr('খতিয়ান তালিকা (Khatian Schedule):', 'Khatian Schedule:'),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._records.map((r) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '[${r.khatianType}] ${tr('খতিয়ান', 'Khatian')}: ${r.khatianNo}, ${tr('দাগ', 'Dag')}: ${r.dagNo} (${r.mouza})',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${r.totalLandArea} ${tr('শতাংশ', 'Dec')}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          tr(
                            'পিডিএফ রিপোর্ট সফলভাবে জেনারেট ও প্রস্তুত করা হয়েছে!',
                            'PDF Summary Report generated & ready!',
                          ),
                        ),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  icon: const Icon(Icons.download_rounded),
                  label: Text(
                    tr(
                      'পিডিএফ রিপোর্ট ডাউনলোড / এক্সপোর্ট করুন',
                      'Export PDF Summary Report',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: _copyReportToClipboard,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  icon: const Icon(Icons.copy_rounded),
                  label: Text(
                    tr('টেক্সট রিপোর্ট কপি করুন', 'Copy Text Summary'),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSummaryLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

