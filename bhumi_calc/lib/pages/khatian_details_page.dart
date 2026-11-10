import 'dart:io';

import 'package:flutter/material.dart';

import '../database/db_helper.dart';
import '../main.dart';
import '../models/khatian_record.dart';
import 'add_khatian_page.dart';

class KhatianDetailsPage extends StatefulWidget {
  final KhatianRecord record;

  const KhatianDetailsPage({super.key, required this.record});

  @override
  State<KhatianDetailsPage> createState() => _KhatianDetailsPageState();
}

class _KhatianDetailsPageState extends State<KhatianDetailsPage> {
  late KhatianRecord _record;

  @override
  void initState() {
    super.initState();
    _record = widget.record;
  }

  Future<void> _toggleTaxPaid(bool value) async {
    final updated = _record.copyWith(isTaxPaid: value);
    await DatabaseHelper().updateKhatian(updated);
    if (!mounted) return;
    setState(() => _record = updated);
  }

  Future<void> _editRecord() async {
    final updated = await Navigator.of(context).push<KhatianRecord>(
      MaterialPageRoute(
        builder: (_) => AddKhatianPage(existingRecord: _record),
      ),
    );
    if (updated != null && mounted) {
      setState(() => _record = updated);
    }
  }

  Future<void> _deleteRecord() async {
    if (_record.id != null) {
      await DatabaseHelper().deleteKhatian(_record.id!);
    }
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, _, _) {
        final theme = Theme.of(context);
        final dec = _record.totalLandArea;
        final sqFt = dec * 435.6;
        final katha = dec / 1.65;
        final bigha = dec / 33.0;
        final acre = dec / 100.0;
        final kani = dec / 40.0;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              '${_record.khatianType} ${tr('খতিয়ান বিস্তারিত', 'Khatian Details')}',
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: tr('সম্পাদনা', 'Edit'),
                onPressed: _editRecord,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                tooltip: tr('মুছে ফেলুন', 'Delete'),
                onPressed: _deleteRecord,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Land Development Tax (খাজনা) Checkbox Card
                Card(
                  elevation: 1.5,
                  color: _record.isTaxPaid
                      ? Colors.green.shade50
                      : Colors.orange.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: _record.isTaxPaid
                          ? Colors.green.shade400
                          : kSecondarySunsetOrange,
                    ),
                  ),
                  child: CheckboxListTile(
                    activeColor: Colors.green.shade700,
                    value: _record.isTaxPaid,
                    onChanged: (val) {
                      if (val != null) _toggleTaxPaid(val);
                    },
                    secondary: Icon(
                      _record.isTaxPaid
                          ? Icons.verified_rounded
                          : Icons.warning_amber_rounded,
                      color: _record.isTaxPaid
                          ? Colors.green.shade700
                          : kSecondarySunsetOrange,
                      size: 30,
                    ),
                    title: Text(
                      _record.isTaxPaid
                          ? tr(
                              'ভূমি উন্নয়ন কর (খাজনা) পরিশোধিত',
                              'Land Development Tax (Khajna) Paid',
                            )
                          : tr(
                              'ভূমি উন্নয়ন কর (খাজনা) বকেয়া',
                              'Land Development Tax (Khajna) Unpaid',
                            ),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _record.isTaxPaid
                            ? Colors.green.shade800
                            : Colors.deepOrange.shade900,
                      ),
                    ),
                    subtitle: Text(
                      tr(
                        'খাজনা দেওয়া হয়ে থাকলে চেকবক্সে টিক দিন',
                        'Check the box once land tax is paid',
                      ),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Main Khatian Information Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          tr('খতিয়ানের ধরন:', 'Khatian Type:'),
                          _record.khatianType,
                        ),
                        const Divider(),
                        _buildInfoRow(
                          tr('মালিকানার ধরন:', 'Ownership Type:'),
                          _record.ownershipType,
                        ),
                        const Divider(),
                        _buildInfoRow(
                          tr('বিভাগ:', 'Division:'),
                          _record.division,
                        ),
                        if (_record.district.isNotEmpty) ...[
                          const Divider(),
                          _buildInfoRow(
                            tr('জেলা:', 'District:'),
                            _record.district,
                          ),
                        ],
                        if (_record.upazila.isNotEmpty) ...[
                          const Divider(),
                          _buildInfoRow(
                            tr('উপজেলা / সার্কেল:', 'Upazila / Circle:'),
                            _record.upazila,
                          ),
                        ],
                        const Divider(),
                        _buildInfoRow(
                          tr('মৌজা:', 'Mouza:'),
                          _record.mouza,
                        ),
                        const Divider(),
                        _buildInfoRow(
                          tr('খতিয়ান নং:', 'Khatian No:'),
                          _record.khatianNo,
                        ),
                        const Divider(),
                        _buildInfoRow(
                          tr('দাগ নং:', 'Dag No:'),
                          _record.dagNo,
                        ),
                        const Divider(),
                        _buildInfoRow(
                          tr('মোট জমি (শতাংশ):', 'Total Land (Decimal):'),
                          '${_record.totalLandArea} ${tr('শতাংশ', 'Decimal')}',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Smart Unit Breakdown for this specific Khatian
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr(
                            'এই খতিয়ানের জমির বিভিন্ন এককে হিসাব:',
                            'Unit Conversion for this Khatian:',
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: kPrimaryDeepIndigo,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildInfoRow(
                          tr('বর্গফুট (Sq. Ft):', 'Square Feet:'),
                          '${sqFt.toStringAsFixed(1)} Sq. Ft',
                        ),
                        _buildInfoRow(
                          tr('কাঠা (Katha):', 'Katha:'),
                          '${katha.toStringAsFixed(2)} ${tr('কাঠা', 'Katha')}',
                        ),
                        _buildInfoRow(
                          tr('বিঘা (Bigha):', 'Bigha:'),
                          '${bigha.toStringAsFixed(3)} ${tr('বিঘা', 'Bigha')}',
                        ),
                        _buildInfoRow(
                          tr('একর (Acre):', 'Acre:'),
                          '${acre.toStringAsFixed(3)} ${tr('একর', 'Acre')}',
                        ),
                        _buildInfoRow(
                          tr('কানি (৪০ শতক):', 'Kani (40 Shotok):'),
                          '${kani.toStringAsFixed(3)} ${tr('কানি', 'Kani')}',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Text(
                  tr('মূল কাগজের স্ক্যান কপি:', 'Scanned Document Copy:'),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                if (_record.imagePath == 'DEMO_SCAN')
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: kPrimaryDeepIndigo.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.description_rounded,
                          size: 56,
                          color: kPrimaryDeepIndigo,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          tr(
                            'বাংলাদেশ ফরম নং ৫৪৬২ (সংশোধিত) - খতিয়ান দলিল স্ক্যান',
                            'Bangladesh Form No. 5462 - Khatian Document Scan',
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${_record.khatianType} • ${tr('খতিয়ান', 'Khatian')}: ${_record.khatianNo} • ${tr('দাগ', 'Dag')}: ${_record.dagNo} • ${_record.mouza}',
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (_record.imagePath != null &&
                    File(_record.imagePath!).existsSync())
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_record.imagePath!),
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(36),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        tr(
                          'এই খতিয়ানের কোনো ছবি সংযুক্ত করা হয়নি।',
                          'No document image attached to this Khatian.',
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper widget function to display information neatly
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14.5, color: Colors.grey)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
