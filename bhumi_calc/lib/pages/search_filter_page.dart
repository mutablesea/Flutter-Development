import 'package:flutter/material.dart';

import '../database/db_helper.dart';
import '../main.dart';
import '../models/khatian_record.dart';
import 'khatian_details_page.dart';

class SearchFilterPage extends StatefulWidget {
  const SearchFilterPage({super.key});

  @override
  State<SearchFilterPage> createState() => _SearchFilterPageState();
}

class _SearchFilterPageState extends State<SearchFilterPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<KhatianRecord> _allRecords = [];
  bool _isLoading = true;
  String _selectedType = 'All';
  String _sortBy = 'newest'; // 'newest', 'area_desc', 'area_asc'

  static const List<String> _types = [
    'All',
    'CS',
    'RS',
    'SA',
    'BRS',
    'BDS',
    'Kharij',
  ];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadRecords() async {
    final data = await DatabaseHelper().getAllKhatians();
    if (!mounted) return;
    setState(() {
      _allRecords = data;
      _isLoading = false;
    });
  }

  List<KhatianRecord> get _filteredRecords {
    final q = _searchCtrl.text.trim().toLowerCase();
    final filtered = _allRecords.where((rec) {
      final matchesType =
          _selectedType == 'All' || rec.khatianType == _selectedType;
      if (!matchesType) return false;
      if (q.isEmpty) return true;
      return rec.khatianNo.toLowerCase().contains(q) ||
          rec.dagNo.toLowerCase().contains(q) ||
          rec.mouza.toLowerCase().contains(q) ||
          rec.khatianType.toLowerCase().contains(q);
    }).toList();

    if (_sortBy == 'area_desc') {
      filtered.sort((a, b) => b.totalLandArea.compareTo(a.totalLandArea));
    } else if (_sortBy == 'area_asc') {
      filtered.sort((a, b) => a.totalLandArea.compareTo(b.totalLandArea));
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final results = _filteredRecords;
    final totalFilteredArea =
        results.fold<double>(0.0, (sum, r) => sum + r.totalLandArea);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('খতিয়ান অনুসন্ধান ও ফিল্টার', 'Search & Filter Khatians')),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchCtrl,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: tr(
                            'দাগ নং, খতিয়ান নং বা মৌজার নাম লিখুন...',
                            'Search by Dag No, Khatian No, or Mouza...',
                          ),
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: _searchCtrl.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchCtrl.clear();
                                    setState(() {});
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _types.map((type) {
                            final isSelected = _selectedType == type;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(
                                  type == 'All'
                                      ? tr('সব খতিয়ান', 'All Types')
                                      : type,
                                ),
                                selected: isSelected,
                                onSelected: (_) {
                                  setState(() => _selectedType = type);
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tr(
                              'ফলাফল: ${results.length}টি • মোট: ${totalFilteredArea.toStringAsFixed(2)} শতাংশ',
                              'Found: ${results.length} • Total: ${totalFilteredArea.toStringAsFixed(2)} Decimal',
                            ),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          DropdownButton<String>(
                            value: _sortBy,
                            underline: const SizedBox.shrink(),
                            items: [
                              DropdownMenuItem(
                                value: 'newest',
                                child: Text(tr('সর্বশেষ', 'Newest')),
                              ),
                              DropdownMenuItem(
                                value: 'area_desc',
                                child: Text(tr('বেশি জমি আগে', 'Largest Area')),
                              ),
                              DropdownMenuItem(
                                value: 'area_asc',
                                child: Text(tr('কম জমি আগে', 'Smallest Area')),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _sortBy = val);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: results.isEmpty
                      ? Center(
                          child: Text(
                            tr(
                              'কোনো খতিয়ান খুঁজে পাওয়া যায়নি।',
                              'No matching Khatian records found.',
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final rec = results[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      theme.colorScheme.primaryContainer,
                                  child: Text(
                                    rec.khatianType,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  '${tr('দাগ নং', 'Dag')}: ${rec.dagNo} | ${tr('খতিয়ান', 'Khatian')}: ${rec.khatianNo}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  '${tr('মৌজা', 'Mouza')}: ${rec.mouza} • ${rec.totalLandArea} ${tr('শতাংশ', 'Decimal')}',
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                ),
                                onTap: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          KhatianDetailsPage(record: rec),
                                    ),
                                  );
                                  _loadRecords();
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

