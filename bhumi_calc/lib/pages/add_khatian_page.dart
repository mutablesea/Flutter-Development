import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../database/db_helper.dart';
import '../main.dart';
import '../models/khatian_record.dart';

class AddKhatianPage extends StatefulWidget {
  final KhatianRecord? existingRecord;

  const AddKhatianPage({super.key, this.existingRecord});

  @override
  State<AddKhatianPage> createState() => _AddKhatianPageState();
}

class _AddKhatianPageState extends State<AddKhatianPage> {
  final _formKey = GlobalKey<FormState>();

  // Text editing controllers
  late final TextEditingController _districtCtrl;
  late final TextEditingController _upazilaCtrl;
  late final TextEditingController _mouzaCtrl;
  late final TextEditingController _khatianNoCtrl;
  late final TextEditingController _dagNoCtrl;
  late final TextEditingController _areaCtrl;

  String _selectedDivision = 'ঢাকা (Dhaka)';
  String _selectedType = 'RS';
  String _selectedOwnership = 'নিজস্ব মালিকানা';
  String? _savedImagePath;

  static const List<String> _divisions = [
    'ঢাকা (Dhaka)',
    'চট্টগ্রাম (Chattogram)',
    'রাজশাহী (Rajshahi)',
    'খুলনা (Khulna)',
    'বরিশাল (Barishal)',
    'সিলেট (Sylhet)',
    'রংপুর (Rangpur)',
    'ময়মনসিংহ (Mymensingh)',
  ];

  static const List<String> _types = ['CS', 'RS', 'SA', 'BRS', 'BDS', 'Kharij'];

  @override
  void initState() {
    super.initState();
    final existing = widget.existingRecord;
    _districtCtrl = TextEditingController(text: existing?.district ?? '');
    _upazilaCtrl = TextEditingController(text: existing?.upazila ?? '');
    _mouzaCtrl = TextEditingController(text: existing?.mouza ?? '');
    _khatianNoCtrl = TextEditingController(text: existing?.khatianNo ?? '');
    _dagNoCtrl = TextEditingController(text: existing?.dagNo ?? '');
    _areaCtrl = TextEditingController(
      text: existing != null ? existing.totalLandArea.toString() : '',
    );

    if (existing != null) {
      if (_divisions.contains(existing.division)) {
        _selectedDivision = existing.division;
      }
      if (_types.contains(existing.khatianType)) {
        _selectedType = existing.khatianType;
      }
      if (existing.ownershipType.isNotEmpty) {
        _selectedOwnership = existing.ownershipType;
      }
      _savedImagePath = existing.imagePath;
    }
  }

  @override
  void dispose() {
    _districtCtrl.dispose();
    _upazilaCtrl.dispose();
    _mouzaCtrl.dispose();
    _khatianNoCtrl.dispose();
    _dagNoCtrl.dispose();
    _areaCtrl.dispose();
    super.dispose();
  }

  // Pick an image from Camera or Gallery with safe emulator error handling
  Future<void> _pickAndSaveImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final directory = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final ext = p.extension(pickedFile.path).isNotEmpty
            ? p.extension(pickedFile.path)
            : '.jpg';
        final targetPath = '${directory.path}/khatian_scan_$timestamp$ext';
        final savedImage = await File(pickedFile.path).copy(targetPath);

        if (!mounted) return;
        setState(() {
          _savedImagePath = savedImage.path;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              tr(
                'দলিলের ছবি সফলভাবে সংযুক্ত হয়েছে!',
                'Document scan attached successfully!',
              ),
            ),
          ),
        );
      }
    } on PlatformException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 4),
          content: Text(
            tr(
              'ইমুলেটরে ক্যামেরা/গ্যালারি পাওয়া যায়নি (${e.code})। নিচে "নমুনা দলিল যুক্ত করুন" বাটন ব্যবহার করতে পারেন।',
              'Camera/Gallery unavailable on this simulator (${e.code}). You can use the "Attach Demo Scan" button below.',
            ),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            tr(
              'ছবি লোড করা যায়নি। ইমুলেটর হলে "নমুনা দলিল" বাটন ব্যবহার করুন।',
              'Could not pick image on emulator. Try "Attach Demo Scan".',
            ),
          ),
        ),
      );
    }
  }

  // Save or update the record in the SQLite database
  Future<void> _saveRecord() async {
    if (_formKey.currentState!.validate()) {
      final area = double.tryParse(_areaCtrl.text.trim()) ?? 0.0;
      final record = KhatianRecord(
        id: widget.existingRecord?.id,
        khatianType: _selectedType,
        khatianNo: _khatianNoCtrl.text.trim(),
        dagNo: _dagNoCtrl.text.trim(),
        division: _selectedDivision,
        district: _districtCtrl.text.trim(),
        upazila: _upazilaCtrl.text.trim(),
        mouza: _mouzaCtrl.text.trim(),
        ownershipType: _selectedOwnership,
        totalLandArea: area,
        imagePath: _savedImagePath,
        isTaxPaid: widget.existingRecord?.isTaxPaid ?? false,
      );

      if (widget.existingRecord != null && widget.existingRecord!.id != null) {
        await DatabaseHelper().updateKhatian(record);
      } else {
        await DatabaseHelper().insertKhatian(record);
      }
      if (mounted) Navigator.pop(context, record);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, _, _) {
        final theme = Theme.of(context);
        final isEditing = widget.existingRecord != null;
        final enteredDecimal = double.tryParse(_areaCtrl.text.trim()) ?? 0.0;
        final previewKatha = enteredDecimal / 1.65;
        final previewBigha = enteredDecimal / 33.0;
        final previewSqFt = enteredDecimal * 435.6;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              isEditing
                  ? tr('খতিয়ান সম্পাদনা করুন', 'Edit Khatian Record')
                  : tr('নতুন খতিয়ান যোগ করুন', 'Add New Khatian'),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ================= SECTION 1: LOCATION INFO =================
                  _buildSectionCard(
                    title: tr(
                      '১. জমির অবস্থান ও প্রশাসনিক তথ্য',
                      '1. Administrative Location Details',
                    ),
                    icon: Icons.location_on_rounded,
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: _selectedDivision,
                        decoration: InputDecoration(
                          labelText: tr('বিভাগ (Division)', 'Division'),
                          prefixIcon: const Icon(Icons.map_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: _divisions
                            .map(
                              (div) => DropdownMenuItem(
                                value: div,
                                child: Text(div),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedDivision = val);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _districtCtrl,
                              decoration: InputDecoration(
                                labelText: tr('জেলা (District)', 'District'),
                                hintText: tr('যেমন: ঢাকা', 'e.g. Dhaka'),
                                prefixIcon:
                                    const Icon(Icons.location_city_rounded),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (v) =>
                                  v == null || v.trim().isEmpty
                                      ? tr('জেলার নাম দিন', 'Enter District')
                                      : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _upazilaCtrl,
                              decoration: InputDecoration(
                                labelText: tr(
                                  'উপজেলা / সার্কেল',
                                  'Upazila / Circle',
                                ),
                                hintText: tr('যেমন: সাভার', 'e.g. Savar'),
                                prefixIcon:
                                    const Icon(Icons.account_balance_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? tr(
                                      'উপজেলা/সার্কেল দিন',
                                      'Enter Upazila/Circle',
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _mouzaCtrl,
                        decoration: InputDecoration(
                          labelText: tr(
                            'মৌজা ও জে.এল নং (Mouza)',
                            'Mouza Name / J.L. No.',
                          ),
                          hintText: tr(
                            'যেমন: উত্তরা মডেল জে.এল ১২',
                            'e.g. Uttara Model JL 12',
                          ),
                          prefixIcon: const Icon(Icons.holiday_village_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? tr('মৌজার নাম দিন', 'Enter Mouza name')
                            : null,
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ================= SECTION 2: OWNERSHIP & KHATIAN =================
                  _buildSectionCard(
                    title: tr(
                      '২. মালিকানার ধরন ও খতিয়ানের বিবরণ',
                      '2. Ownership Type & Khatian Info',
                    ),
                    icon: Icons.verified_user_rounded,
                    children: [
                      Text(
                        tr(
                          'মালিকানার ধরন নির্বাচন করুন (Ownership Type):',
                          'Select Ownership Type:',
                        ),
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildOwnershipOption(
                              value: 'নিজস্ব মালিকানা',
                              title: tr('নিজস্ব মালিকানা', 'Own Purchase / Self'),
                              subtitle: tr(
                                'ক্রয় বা দলিল সূত্রে',
                                'Direct Deed / Purchase',
                              ),
                              icon: Icons.person_pin_rounded,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildOwnershipOption(
                              value: 'উত্তরাধিকার সূত্রে',
                              title: tr(
                                'উত্তরাধিকার মালিকানা',
                                'Inheritance',
                              ),
                              subtitle: tr(
                                'পৈতৃক বা ওয়ারিশ সূত্রে',
                                'Ancestral / Heir',
                              ),
                              icon: Icons.family_restroom_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedType,
                        decoration: InputDecoration(
                          labelText: tr(
                            'খতিয়ানের ধরন (Khatian Type)',
                            'Khatian Type',
                          ),
                          prefixIcon: const Icon(Icons.folder_special_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: _types
                            .map(
                              (t) => DropdownMenuItem(
                                value: t,
                                child: Text(
                                  t == 'Kharij'
                                      ? 'Kharij (নামজারি / খারিজ খতিয়ান)'
                                      : '$t ${tr('খতিয়ান', 'Record')}',
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) =>
                            setState(() => _selectedType = val!),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _khatianNoCtrl,
                              decoration: InputDecoration(
                                labelText: tr('খতিয়ান নং', 'Khatian No.'),
                                prefixIcon: const Icon(Icons.numbers_rounded),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? tr('খতিয়ান নং দিন', 'Enter Khatian No.')
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _dagNoCtrl,
                              decoration: InputDecoration(
                                labelText: tr('দাগ নং (Dag No.)', 'Dag No.'),
                                prefixIcon: const Icon(Icons.pin_drop_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? tr('দাগ নং দিন', 'Enter Dag No.')
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _areaCtrl,
                        onChanged: (_) => setState(() {}),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: tr(
                            'জমির পরিমাণ - শতাংশে (Land Area in Decimal)',
                            'Land Area (in Decimal / শতাংশ)',
                          ),
                          prefixIcon: const Icon(Icons.square_foot_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return tr('পরিমাণ দিন', 'Enter land area');
                          }
                          if (double.tryParse(v.trim()) == null) {
                            return tr(
                              'সঠিক সংখ্যা লিখুন',
                              'Enter a valid number',
                            );
                          }
                          return null;
                        },
                      ),
                      if (enteredDecimal > 0) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: kPrimaryDeepIndigo.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            tr(
                              'তাৎক্ষণিক হিসাব: ${previewKatha.toStringAsFixed(2)} কাঠা • ${previewBigha.toStringAsFixed(2)} বিঘা • ${previewSqFt.toStringAsFixed(0)} বর্গফুট',
                              'Live Preview: ${previewKatha.toStringAsFixed(2)} Katha • ${previewBigha.toStringAsFixed(2)} Bigha • ${previewSqFt.toStringAsFixed(0)} Sq. Ft',
                            ),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryDeepIndigo,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ================= SECTION 3: DOCUMENT SCAN =================
                  _buildSectionCard(
                    title: tr(
                      '৩. মূল খতিয়ান / দলিলের স্ক্যান কপি',
                      '3. Document Scan Attachment',
                    ),
                    icon: Icons.document_scanner_rounded,
                    children: [
                      if (_savedImagePath == 'DEMO_SCAN')
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.teal.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.teal),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.verified_rounded,
                                color: Colors.teal,
                                size: 32,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  tr(
                                    'নমুনা খতিয়ান দলিল স্ক্যান সংযুক্ত করা হয়েছে',
                                    'Verified Sample Khatian Document Attached',
                                  ),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () =>
                                    setState(() => _savedImagePath = null),
                              ),
                            ],
                          ),
                        )
                      else if (_savedImagePath != null &&
                          File(_savedImagePath!).existsSync())
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(_savedImagePath!),
                                height: 170,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            IconButton.filled(
                              onPressed: () =>
                                  setState(() => _savedImagePath = null),
                              icon: const Icon(Icons.close, size: 18),
                            ),
                          ],
                        )
                      else
                        Container(
                          height: 110,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.dividerColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 32,
                                  color: kPrimaryDeepIndigo,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  tr(
                                    'ক্যামেরা বা গ্যালারি থেকে খতিয়ানের ছবি যুক্ত করুন',
                                    'Attach Khatian scan from Camera or Gallery',
                                  ),
                                  style: const TextStyle(fontSize: 12.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  _pickAndSaveImage(ImageSource.camera),
                              icon: const Icon(Icons.camera_alt_outlined),
                              label: Text(tr('ক্যামেরা', 'Camera')),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  _pickAndSaveImage(ImageSource.gallery),
                              icon: const Icon(Icons.photo_library_outlined),
                              label: Text(tr('গ্যালারি', 'Gallery')),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Center(
                        child: TextButton.icon(
                          onPressed: () {
                            setState(() => _savedImagePath = 'DEMO_SCAN');
                          },
                          icon: const Icon(
                            Icons.description_outlined,
                            size: 16,
                          ),
                          label: Text(
                            tr(
                              'ইমুলেটরের জন্য নমুনা দলিল সংযুক্ত করুন',
                              'Attach Sample Scan (For Emulator)',
                            ),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Save Button
                  SizedBox(
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: _saveRecord,
                      style: FilledButton.styleFrom(
                        backgroundColor: kSecondarySunsetOrange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.save_rounded),
                      label: Text(
                        isEditing
                            ? tr('পরিবর্তন সেভ করুন', 'Update Khatian Record')
                            : tr('খতিয়ান সেভ করুন', 'Save Khatian Record'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: kPrimaryDeepIndigo, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryDeepIndigo,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildOwnershipOption({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedOwnership == value;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => setState(() => _selectedOwnership = value),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? kPrimaryDeepIndigo.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? kPrimaryDeepIndigo
                : Colors.grey.withValues(alpha: 0.35),
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isSelected ? kPrimaryDeepIndigo : Colors.grey.shade700,
                ),
                const Spacer(),
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  size: 18,
                  color: isSelected ? kSecondarySunsetOrange : Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isSelected ? kPrimaryDeepIndigo : null,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
