import 'dart:io';

import 'package:flutter/material.dart';

import '../models/khatian_record.dart';

class KhatianDetailsPage extends StatelessWidget {
  final KhatianRecord record;

  const KhatianDetailsPage({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${record.khatianType} খতিয়ান বিস্তারিত')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow('খতিয়ানের ধরন:', record.khatianType),
                    const Divider(),
                    _buildInfoRow('খতিয়ান নং:', record.khatianNo),
                    const Divider(),
                    _buildInfoRow('দাগ নং:', record.dagNo),
                    const Divider(),
                    _buildInfoRow('মৌজা:', record.mouza),
                    const Divider(),
                    _buildInfoRow('মোট জমি:', '${record.totalLandArea} শতাংশ'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'মূল কাগজের স্ক্যান কপি:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Show the image if available, otherwise show a message
            record.imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(record.imagePath!),
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  )
                : Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('এই খতিয়ানের কোনো ছবি সংযুক্ত করা হয়নি।'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  // Helper widget function to display information neatly
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
