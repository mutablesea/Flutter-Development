import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../database/db_helper.dart';
import '../models/khatian_record.dart';

class AddKhatianPage extends StatefulWidget {
  const AddKhatianPage({super.key});

  @override
  State<AddKhatianPage> createState() => _AddKhatianPageState();
}

class _AddKhatianPageState extends State<AddKhatianPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _khatianNoCtrl = TextEditingController();
  final _dagNoCtrl = TextEditingController();
  final _mouzaCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();

  String _selectedType = 'RS';
  final List<String> _types = ['CS', 'RS', 'SA', 'BRS', 'BDS', 'Kharij'];
  String? _savedImagePath;

  // Logic to pick an image and save it to a local folder
  Future<void> _pickAndSaveImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      // Find the app's private documents directory
      final directory = await getApplicationDocumentsDirectory();
      // Get the original file name (e.g., image_123.jpg)
      final fileName = p.basename(pickedFile.path);
      // Copy the image from the temporary folder to the permanent folder
      final savedImage = await File(pickedFile.path)
          .copy('${directory.path}/$fileName');

      setState(() {
        _savedImagePath = savedImage.path;
      });
    }
  }

  // Logic to save the record to the database
  Future<void> _saveRecord() async {
    if (_formKey.currentState!.validate()) {
      final newRecord = KhatianRecord(
        khatianType: _selectedType,
        khatianNo: _khatianNoCtrl.text,
        dagNo: _dagNoCtrl.text,
        mouza: _mouzaCtrl.text,
        totalLandArea: double.parse(_areaCtrl.text),
        imagePath: _savedImagePath,
      );

      await DatabaseHelper().insertKhatian(newRecord);
      if (mounted) Navigator.pop(context); // Go back to the home page after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('নতুন খতিয়ান যোগ করুন')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'খতিয়ানের ধরন',
                  border: OutlineInputBorder(),
                ),
                items: _types
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedType = val!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _khatianNoCtrl,
                decoration: const InputDecoration(
                  labelText: 'খতিয়ান নং',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'খতিয়ান নং দিন' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dagNoCtrl,
                decoration: const InputDecoration(
                  labelText: 'দাগ নং',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'দাগ নং দিন' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _mouzaCtrl,
                decoration: const InputDecoration(
                  labelText: 'মৌজা',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'মৌজা দিন' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _areaCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'জমির পরিমাণ (শতাংশ)',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'পরিমাণ দিন' : null,
              ),
              const SizedBox(height: 20),

              // Image preview area
              _savedImagePath != null
                  ? Image.file(
                      File(_savedImagePath!),
                      height: 150,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 150,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Text('কোনো ডকুমেন্ট যোগ করা হয়নি'),
                      ),
                    ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () => _pickAndSaveImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('ক্যামেরা'),
                  ),
                  TextButton.icon(
                    onPressed: () => _pickAndSaveImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo),
                    label: const Text('গ্যালারি'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveRecord,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text(
                  'তথ্য সেভ করুন',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
