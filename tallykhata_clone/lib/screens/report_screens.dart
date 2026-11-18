import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Ekta reusable page : SS 26 (মালিকের রিপোর্ট), 28 (বাকি হিসাব), 29 (খরচ), 30 (বেচা কেনা হিসাব)
/// Shobgula te: filter dropdown (দিন/মাস) + date picker + table header + empty state.
class ReportScreen extends StatefulWidget {
  final String title;
  final String col1;
  final String? col2;
  final bool monthMode;          // true hole default filter "মাস"
  final bool showSummaryCheck;   // "সংক্ষিপ্ত" checkbox (SS 30)
  const ReportScreen({super.key, required this.title, required this.col1, this.col2, this.monthMode = false, this.showSummaryCheck = false});
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late String _filter = widget.monthMode ? 'মাস' : 'দিন';
  DateTime _date = DateTime.now();
  bool _short = false;

  static const _months = ['জানুয়ারি','ফেব্রুয়ারি','মার্চ','এপ্রিল','মে','জুন','জুলাই','আগস্ট','সেপ্টেম্বর','অক্টোবর','নভেম্বর','ডিসেম্বর'];
  String get _dateText => _filter == 'মাস' ? _months[_date.month - 1] : '${_date.day} ${_months[_date.month - 1]}';

  void _shift(int d) => setState(() => _date = _filter == 'মাস'
      ? DateTime(_date.year, _date.month + d, 1)
      : _date.add(Duration(days: d)));

  Future<void> _pick() async {
    final p = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2020), lastDate: DateTime(2100));
    if (p != null) setState(() => _date = p);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: backBar(context, widget.title),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(children: [
              DropdownButton<String>(
                value: _filter, underline: const SizedBox(),
                items: const ['দিন', 'মাস'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => _filter = v!),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(20)),
                  child: Row(children: [
                    TextButton.icon(onPressed: _pick, icon: const Icon(Icons.calendar_today, size: 16), label: Text(_dateText)),
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.chevron_left), onPressed: () => _shift(-1)),
                    IconButton(icon: const Icon(Icons.chevron_right), onPressed: () => _shift(1)),
                  ]),
                ),
              ),
              if (widget.showSummaryCheck) ...[
                const SizedBox(width: 6),
                const Text('সংক্ষিপ্ত'),
                Checkbox(value: _short, onChanged: (v) => setState(() => _short = v!)),
              ],
            ]),
          ),
          // table header
          Container(
            color: Colors.grey.shade200, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(children: [
              const Text('বিবরণ'), const Icon(Icons.download, size: 16),
              const Spacer(),
              Text(widget.col1), if (widget.col2 != null) ...[const SizedBox(width: 40), Text(widget.col2!)],
            ]),
          ),
          const Expanded(child: EmptyState('কোন লেনদেন নেই।')),
        ]),
      );
}

/// SS 27 : ক্যাশ হিসাব — 2 ta tab (ক্যাশবক্স রিপোর্ট / ক্যাশ রিপোর্ট)
class CashHisabScreen extends StatelessWidget {
  const CashHisabScreen({super.key});

  static const _rows = [
    ('দিনের শুরুতে ক্যাশ', true), ('ক্যাশ বেচা', true), ('বাকি আদায়', true), ('মালিক দিল', true),
    ('ক্যাশ কেনা', false), ('পেমেন্ট দেয়া', false), ('খরচ', false), ('মালিক নিল', false),
  ];

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
            title: const Text('ক্যাশ হিসাব', style: TextStyle(fontSize: 18)),
            bottom: const TabBar(
              labelColor: kRed, indicatorColor: kRed,
              tabs: [Tab(text: 'ক্যাশবক্স রিপোর্ট'), Tab(text: 'ক্যাশ রিপোর্ট')],
            ),
          ),
          body: TabBarView(children: [
            Column(children: [
              Container(color: Colors.grey.shade200, padding: const EdgeInsets.all(8),
                  child: const Row(children: [Text('বিবরণ'), Spacer(), Text('পেলাম', style: TextStyle(color: kGreen)), SizedBox(width: 40), Text('দিলাম', style: TextStyle(color: kRed))])),
              Expanded(child: ListView(children: [
                for (final r in _rows)
                  ListTile(dense: true, title: Text(r.$1),
                      trailing: Text('0.00', style: TextStyle(color: r.$2 ? kGreen : kRed))),
              ])),
              const Divider(),
              const Padding(padding: EdgeInsets.all(12), child: Row(children: [Text('ব্যালেন্স'), Spacer(), Text('0.00')])),
              Padding(padding: const EdgeInsets.all(12), child: PrimaryButton('ক্যাশবক্স মিলাই', onPressed: () {})),
            ]),
            const EmptyState('কোন লেনদেন নেই।'),
          ]),
        ),
      );
}
