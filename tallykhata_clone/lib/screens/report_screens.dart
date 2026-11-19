import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';

const _kBanglaMonths = [
  'জানুয়ারি',
  'ফেব্রুয়ারি',
  'মার্চ',
  'এপ্রিল',
  'মে',
  'জুন',
  'জুলাই',
  'আগস্ট',
  'সেপ্টেম্বর',
  'অক্টোবর',
  'নভেম্বর',
  'ডিসেম্বর',
];

String _toBanglaDigits(int number) {
  const digits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
  return number
      .toString()
      .split('')
      .map((c) => int.tryParse(c) != null ? digits[int.parse(c)] : c)
      .join();
}

/// Reusable report screen used for Owner Report, Due Report, Expense Report, and Buy-Sell Report.
/// Includes a day/month filter dropdown, date selector, table header, and empty state.
class ReportScreen extends StatefulWidget {
  final String title;
  final String col1;
  final String? col2;
  final bool monthMode; // Defaults the filter to monthly mode when true
  final bool showSummaryCheck; // Displays the summary checkbox when true
  const ReportScreen({
    super.key,
    required this.title,
    required this.col1,
    this.col2,
    this.monthMode = false,
    this.showSummaryCheck = false,
  });
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late String _filter = widget.monthMode ? 'মাস' : 'দিন';
  DateTime _date = DateTime.now();
  bool _short = false;

  String get _dateText => _filter == 'মাস'
      ? _kBanglaMonths[_date.month - 1]
      : '${_toBanglaDigits(_date.day)} ${_kBanglaMonths[_date.month - 1]}';

  void _shift(int d) => setState(
        () => _date = _filter == 'মাস'
            ? DateTime(_date.year, _date.month + d, 1)
            : _date.add(Duration(days: d)),
      );

  Future<void> _pick() async {
    final p = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (p != null) setState(() => _date = p);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: backBar(context, widget.title),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  DropdownButton<String>(
                    value: _filter,
                    underline: const SizedBox(),
                    items: const ['দিন', 'মাস']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => _filter = v!),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          TextButton.icon(
                            onPressed: _pick,
                            icon: const Icon(
                              Icons.calendar_today_outlined,
                              size: 16,
                              color: Colors.black87,
                            ),
                            label: Text(
                              _dateText,
                              style: const TextStyle(color: Colors.black87),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.chevron_left, size: 20),
                            onPressed: () => _shift(-1),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right, size: 20),
                            onPressed: () => _shift(1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (widget.showSummaryCheck) ...[
                    const SizedBox(width: 6),
                    const Text('সংক্ষিপ্ত'),
                    Checkbox(
                      value: _short,
                      onChanged: (v) => setState(() => _short = v!),
                    ),
                  ],
                ],
              ),
            ),
            // Table header
            Container(
              color: const Color(0xFFF3F4F6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  const Text('বিবরণ'),
                  const SizedBox(width: 8),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE5E7EB),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.download_outlined,
                      size: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const Spacer(),
                  Text(widget.col1),
                  if (widget.col2 != null) ...[
                    const SizedBox(width: 40),
                    Text(widget.col2!),
                  ],
                ],
              ),
            ),
            const Expanded(child: EmptyState('কোন লেনদেন নেই।')),
          ],
        ),
      );
}

/// Cash report screen with two tabs: Cashbox Report and Cash Report.
class CashHisabScreen extends StatefulWidget {
  const CashHisabScreen({super.key});

  @override
  State<CashHisabScreen> createState() => _CashHisabScreenState();
}

class _CashHisabScreenState extends State<CashHisabScreen> {
  DateTime _date = DateTime.now();
  bool _detailed = false;

  static const _rows = [
    ('দিনের শুরুতে ক্যাশ', true),
    ('ক্যাশ বেচা', true),
    ('বাকি আদায়', true),
    ('মালিক দিল', true),
    ('ক্যাশ কেনা', false),
    ('পেমেন্ট দেয়া', false),
    ('খরচ', false),
    ('মালিক নিল', false),
  ];

  String get _dateText =>
      '${_toBanglaDigits(_date.day)} ${_kBanglaMonths[_date.month - 1]}';

  void _shift(int d) =>
      setState(() => _date = _date.add(Duration(days: d)));

  Future<void> _pick() async {
    final p = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (p != null) setState(() => _date = p);
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('ক্যাশ হিসাব', style: TextStyle(fontSize: 18)),
            bottom: const TabBar(
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.black45,
              indicatorColor: kRed,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(text: 'ক্যাশবক্স রিপোর্ট'),
                Tab(text: 'ক্যাশ রিপোর্ট'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Column(
                children: [
                  // Date selector and "বিস্তারিত" checkbox bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 38,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: _pick,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 16,
                                      color: Colors.black54,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _dateText,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () => _shift(-1),
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.chevron_left,
                                    size: 18,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              InkWell(
                                onTap: () => _shift(1),
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.chevron_right,
                                    size: 18,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          'বিস্তারিত',
                          style: TextStyle(fontSize: 15),
                        ),
                        Checkbox(
                          value: _detailed,
                          onChanged: (v) =>
                              setState(() => _detailed = v ?? false),
                        ),
                      ],
                    ),
                  ),
                  // Table Header: বিবরণ + download icon | পেলাম | দিলাম
                  Container(
                    color: const Color(0xFFF3F4F6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Row(
                            children: [
                              const Text(
                                'বিবরণ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE5E7EB),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.download_outlined,
                                  size: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Text(
                              'পেলাম',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'দিলাম',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Table Rows with separate পেলাম and দিলাম columns
                  Expanded(
                    child: ListView(
                      children: [
                        for (final r in _rows)
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 11,
                                    ),
                                    child: Text(
                                      r.$1,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    color: const Color(0xFFF3F4F6),
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 11,
                                    ),
                                    child: Text(
                                      r.$2 ? '০.০০' : '',
                                      style: const TextStyle(
                                        color: kGreen,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 11,
                                    ),
                                    child: Text(
                                      r.$2 ? '' : '০.০০',
                                      style: const TextStyle(
                                        color: kRed,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  // মোট row
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 5,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            child: Text(
                              'মোট',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            color: const Color(0xFFF3F4F6),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            child: const Text(
                              '০.০০',
                              style: TextStyle(color: kGreen, fontSize: 16),
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            child: Text(
                              '০.০০',
                              textAlign: TextAlign.right,
                              style: TextStyle(color: kRed, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  // ব্যালেন্স row
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        Text('ব্যালেন্স', style: TextStyle(fontSize: 16)),
                        Spacer(),
                        Text('০.০০', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  // Bottom rounded red button
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kRed,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: const Text(
                            'ক্যাশবক্স মিলাই',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const EmptyState('কোন লেনদেন নেই।'),
            ],
          ),
        ),
      );
}
