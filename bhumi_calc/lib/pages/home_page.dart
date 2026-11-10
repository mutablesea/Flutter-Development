import 'package:flutter/material.dart';

import '../database/db_helper.dart';
import '../models/khatian_record.dart';
import 'add_khatian_page.dart';
import 'khatian_details_page.dart';
import 'calculator_page.dart'; // Import the calculator page

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Track the selected navigation bar tab index

  @override
  Widget build(BuildContext context) {
    // Keep the two separate pages in a list
    final List<Widget> pages = [
      const KhatianListView(),
      const CalculatorPage(),
    ];

    return Scaffold(
      body: pages[_currentIndex], // Show the page for the selected tab

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_shared),
            label: 'আমার খতিয়ান',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'ক্যালকুলেটর',
          ),
        ],
      ),
    );
  }
}

// Separate widget for the khatian list view
class KhatianListView extends StatefulWidget {
  const KhatianListView({super.key});

  @override
  State<KhatianListView> createState() => _KhatianListViewState();
}

class _KhatianListViewState extends State<KhatianListView> {
  List<KhatianRecord> _khatianList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadKhatians();
  }

  Future<void> _loadKhatians() async {
    final data = await DatabaseHelper().getAllKhatians();
    setState(() {
      _khatianList = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('আমার খতিয়ান (Bhumi Calc)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _khatianList.isEmpty
          ? const Center(child: Text('কোনো খতিয়ান পাওয়া যায়নি। নতুন যোগ করুন।'))
          : ListView.builder(
              itemCount: _khatianList.length,
              itemBuilder: (context, index) {
                final record = _khatianList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(child: Text(record.khatianType)),
                    title: Text(
                      'দাগ নং: ${record.dagNo} | খতিয়ান: ${record.khatianNo}',
                    ),
                    subtitle: Text('মৌজা: ${record.mouza}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              KhatianDetailsPage(record: record),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddKhatianPage()),
          );
          _loadKhatians(); // Refresh the list after adding new data
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
