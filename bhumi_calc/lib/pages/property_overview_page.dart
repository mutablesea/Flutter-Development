import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../database/db_helper.dart';
import '../main.dart';
import '../models/khatian_record.dart';

class PropertyOverviewPage extends StatefulWidget {
  final VoidCallback? onOpenDrawer;

  const PropertyOverviewPage({super.key, this.onOpenDrawer});

  @override
  State<PropertyOverviewPage> createState() => _PropertyOverviewPageState();
}

class _PropertyOverviewPageState extends State<PropertyOverviewPage> {
  List<KhatianRecord> _records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper().getAllKhatians();
    if (!mounted) return;
    setState(() {
      _records = data;
      _isLoading = false;
    });
  }

  Future<void> _toggleTaxPaid(KhatianRecord rec, bool paid) async {
    final updated = rec.copyWith(isTaxPaid: paid);
    await DatabaseHelper().updateKhatian(updated);
    await _loadData();
  }

  // 1. Total Calculation: Use a for loop to sum totalLandArea (in Decimals)
  double _calculateTotalDecimals() {
    double sum = 0.0;
    for (int i = 0; i < _records.length; i++) {
      sum += _records[i].totalLandArea;
    }
    return sum;
  }

  // Group land area by Khatian Type for the Pie Chart
  Map<String, double> _calculateTypeBreakdown() {
    final Map<String, double> map = {};
    for (int i = 0; i < _records.length; i++) {
      final rec = _records[i];
      map[rec.khatianType] = (map[rec.khatianType] ?? 0.0) + rec.totalLandArea;
    }
    return map;
  }

  static Color _colorForType(String type) {
    switch (type) {
      case 'CS':
        return kPrimaryDeepIndigo;
      case 'BRS':
        return kSecondarySunsetOrange;
      case 'Kharij':
        return Colors.teal.shade700;
      case 'RS':
        return Colors.purple;
      case 'SA':
        return Colors.amber.shade800;
      case 'BDS':
        return Colors.cyan.shade700;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, _, _) {
        final theme = Theme.of(context);
        final totalDecimal = _calculateTotalDecimals();

        // 2. Smart Conversion calculations from totalDecimal
        // 1 Bigha = 33 Decimal
        final int fullBighas = (totalDecimal / 33.0).floor();
        final double remainingDecimalsAfterBigha =
            totalDecimal - (fullBighas * 33.0);
        final double exactBighas = totalDecimal / 33.0;

        // 1 Acre = 100 Decimal
        final double totalAcres = totalDecimal / 100.0;

        // 1 Katha = 1.65 Decimal
        final double totalKathas = totalDecimal / 1.65;

        // Additional smart conversions based on Bangladesh official units
        final double totalSqFt = totalDecimal * 435.6;
        final double totalSqMeter = totalDecimal * 40.47;
        final double totalBorgoGaz = totalDecimal * 48.40;
        final double totalBorgoHat = totalDecimal * 193.6;
        final double totalSqLink = totalDecimal * 1000.0;
        final double totalOjutangsho = totalDecimal * 100.0;
        final double totalKani40 = totalDecimal / 40.0;
        final double totalKani120 = totalDecimal / 120.0;
        final double totalGonda = totalDecimal / 2.0;
        final double totalKora = totalDecimal * 2.0;
        final double totalHectare = totalDecimal / 247.105;
        final double totalAyer = totalDecimal / 2.47105;

        final typeBreakdown = _calculateTypeBreakdown();
        final double chartTotal =
            typeBreakdown.values.fold(0.0, (a, b) => a + b);
        final int paidCount = _records.where((r) => r.isTaxPaid).length;

        return Scaffold(
          appBar: AppBar(
            leading: widget.onOpenDrawer != null
                ? IconButton(
                    icon: const Icon(Icons.menu_rounded),
                    tooltip: tr('সাইডবার মেনু', 'Open Menu'),
                    onPressed: widget.onOpenDrawer,
                  )
                : null,
            title: Text(
              tr('সম্পত্তির ওভারভিউ (Property Overview)', 'Property Overview'),
            ),
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // 1. Total Land Hero Banner Card
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              kPrimaryDeepIndigo,
                              Color(0xFF1A237E),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: kPrimaryDeepIndigo.withValues(alpha: 0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    tr(
                                      '১. মোট জমির হিসাব (Total Calculation)',
                                      '1. TOTAL LAND CALCULATION',
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.analytics_outlined,
                                  color: kSecondarySunsetOrange,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              tr('মোট জমি:', 'Total Land Area:'),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_formatClean(totalDecimal)} ${tr('শতাংশ', 'Decimal (Shotok)')}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              tr(
                                'মোট খতিয়ান: ${_records.length} টি • খাজনা পরিশোধিত: $paidCount/${_records.length} টি',
                                'Total Records: ${_records.length} • Tax Paid: $paidCount/${_records.length}',
                              ),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 2. Smart Conversion Section
                      Row(
                        children: [
                          const Icon(
                            Icons.swap_calls_rounded,
                            color: kPrimaryDeepIndigo,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              tr(
                                '২. স্মার্ট কনভার্সন (Smart Conversion)',
                                '2. Smart Conversion Breakdown',
                              ),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Highlighted Primary Conversion Cards (Decimal, Bigha+Decimal, Acre, Katha)
                      _buildPrimaryConversionCard(
                        context,
                        icon: Icons.straighten_rounded,
                        color: kPrimaryDeepIndigo,
                        title: tr(
                          'মোট জমি (শতাংশে):',
                          'Total Land (in Decimal):',
                        ),
                        value:
                            '${_formatClean(totalDecimal)} ${tr('শতাংশ (Shotangsho)', 'Decimal')}',
                        subtitle: tr(
                          '১ শতাংশ = ৪৩৫.৬ বর্গফুট = ১০০ অযুতাংশ',
                          '1 Decimal = 435.6 Sq. Ft = 100 Ojutangsho',
                        ),
                      ),
                      _buildPrimaryConversionCard(
                        context,
                        icon: Icons.grid_view_rounded,
                        color: kSecondarySunsetOrange,
                        title: tr('যা বিঘায় (In Bigha):', 'In Bigha (Paki):'),
                        value: tr(
                          '$fullBighas বিঘা, ${_formatClean(remainingDecimalsAfterBigha)} শতাংশ (${_formatClean(totalDecimal)} / ৩৩)',
                          '$fullBighas Bigha, ${_formatClean(remainingDecimalsAfterBigha)} Decimal (${_formatClean(totalDecimal)} / 33)',
                        ),
                        subtitle: tr(
                          'দশমিক হিসাবে: ${exactBighas.toStringAsFixed(2)} বিঘা (১ বিঘা = ৩৩ শতাংশ)',
                          'Exact: ${exactBighas.toStringAsFixed(2)} Bigha (1 Bigha = 33 Decimal)',
                        ),
                      ),
                      _buildPrimaryConversionCard(
                        context,
                        icon: Icons.landscape_rounded,
                        color: Colors.teal.shade700,
                        title: tr('যা একরে (In Acre):', 'In Acre:'),
                        value:
                            '${_formatClean(totalAcres)} ${tr('একর', 'Acre')}',
                        subtitle: tr(
                          '১ একর = ১০০ শতাংশ = ৪৩,৫৬০ বর্গফুট',
                          '1 Acre = 100 Decimal = 43,560 Sq. Ft',
                        ),
                      ),
                      _buildPrimaryConversionCard(
                        context,
                        icon: Icons.crop_square_rounded,
                        color: Colors.purple,
                        title: tr(
                          'যা কাঠায় (In Katha):',
                          'In Katha (Cottah):',
                        ),
                        value:
                            '${totalKathas.toStringAsFixed(1)} ${tr('কাঠা', 'Katha')}',
                        subtitle: tr(
                          '১ কাঠা = ১.৬৫ শতাংশ = ৭২০ বর্গফুট',
                          '1 Katha = 1.65 Decimal = 720 Sq. Ft',
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Compact 3-Column Grid for Other Bangladesh Standard Units
                      Text(
                        tr(
                          'অন্যান্য আদর্শ এককে রূপান্তর (Other Standard Units)',
                          'Other Bangladesh Standard Units',
                        ),
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1.85,
                        children: [
                          _buildMiniUnitTile(
                            context,
                            tr('বর্গফুট', 'Sq. Ft'),
                            _formatClean(totalSqFt),
                          ),
                          _buildMiniUnitTile(
                            context,
                            tr('অযুতাংশ', 'Ojutangsho'),
                            _formatClean(totalOjutangsho),
                          ),
                          _buildMiniUnitTile(
                            context,
                            tr('কানি (৪০)', 'Kani (40)'),
                            totalKani40.toStringAsFixed(2),
                          ),
                          _buildMiniUnitTile(
                            context,
                            tr('কানি (১২০)', 'Kani (120)'),
                            totalKani120.toStringAsFixed(2),
                          ),
                          _buildMiniUnitTile(
                            context,
                            tr('গণ্ডা', 'Gonda'),
                            totalGonda.toStringAsFixed(2),
                          ),
                          _buildMiniUnitTile(
                            context,
                            tr('কড়া', 'Kora'),
                            totalKora.toStringAsFixed(2),
                          ),
                          _buildMiniUnitTile(
                            context,
                            tr('বর্গমিটার', 'Sq. Meter'),
                            totalSqMeter.toStringAsFixed(1),
                          ),
                          _buildMiniUnitTile(
                            context,
                            tr('বর্গগজ', 'Borgo Gaz'),
                            totalBorgoGaz.toStringAsFixed(1),
                          ),
                          _buildMiniUnitTile(
                            context,
                            tr('বর্গহাত', 'Borgo Hat'),
                            totalBorgoHat.toStringAsFixed(1),
                          ),
                          _buildMiniUnitTile(
                            context,
                            tr('বর্গলিংক', 'Sq. Link'),
                            _formatClean(totalSqLink),
                          ),
                          _buildMiniUnitTile(
                            context,
                            tr('হেক্টর', 'Hectare'),
                            totalHectare.toStringAsFixed(3),
                          ),
                          _buildMiniUnitTile(
                            context,
                            tr('এয়র', 'Ayer'),
                            totalAyer.toStringAsFixed(2),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      // 3. Pie Chart View Section
                      Row(
                        children: [
                          const Icon(
                            Icons.pie_chart_rounded,
                            color: kPrimaryDeepIndigo,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              tr(
                                '৩. খতিয়ানভিত্তিক চার্ট ভিউ (Pie Chart)',
                                '3. Khatian Distribution Pie Chart',
                              ),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Card(
                        elevation: 1.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(
                                tr(
                                  'কোন খতিয়ানে কতটুকু জমি রয়েছে (CS, BRS, RS, নামজারি/Kharij)',
                                  'Land distribution across CS, BRS, RS & Kharij records',
                                ),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 190,
                                width: 190,
                                child: CustomPaint(
                                  painter: _KhatianPieChartPainter(
                                    data: typeBreakdown,
                                    colorResolver: _colorForType,
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          _formatClean(chartTotal),
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(
                                          tr('শতাংশ', 'Decimal'),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: theme
                                                .colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Divider(),
                              const SizedBox(height: 8),
                              if (typeBreakdown.isEmpty)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Text(
                                    tr(
                                      'এখনো কোনো খতিয়ান যোগ করা হয়নি। খতিয়ান যোগ করলে এখানে পাই-চার্ট দেখা যাবে।',
                                      'No Khatian records added yet. Add a Khatian to see the distribution chart.',
                                    ),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                )
                              else
                                ...typeBreakdown.entries.map((entry) {
                                  final pct = chartTotal == 0
                                      ? 0.0
                                      : (entry.value / chartTotal) * 100.0;
                                  final color = _colorForType(entry.key);
                                  final label = entry.key == 'Kharij'
                                      ? tr(
                                          'নামজারি / খারিজ (Kharij)',
                                          'Kharij (Mutation)',
                                        )
                                      : '${entry.key} ${tr('খতিয়ান', 'Record')}';

                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 14,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            color: color,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            label,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '${_formatClean(entry.value)} ${tr('শতাংশ', 'Dec')} (${pct.toStringAsFixed(1)}%)',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: color,
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

                      if (_records.isNotEmpty) ...[
                        const SizedBox(height: 22),
                        // 4. Land Development Tax (খাজনা) Tracker Checklist
                        Row(
                          children: [
                            const Icon(
                              Icons.receipt_long_rounded,
                              color: kPrimaryDeepIndigo,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                tr(
                                  '৪. ভূমি উন্নয়ন কর / খাজনা পরিশোধ স্ট্যাটাস',
                                  '4. Land Tax (Khajna) Payment Tracker',
                                ),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: _records.map((rec) {
                              return CheckboxListTile(
                                activeColor: Colors.green.shade700,
                                value: rec.isTaxPaid,
                                onChanged: (val) {
                                  if (val != null) _toggleTaxPaid(rec, val);
                                },
                                secondary: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: rec.isTaxPaid
                                      ? Colors.green.withValues(alpha: 0.14)
                                      : kSecondarySunsetOrange.withValues(
                                          alpha: 0.14,
                                        ),
                                  child: Icon(
                                    rec.isTaxPaid
                                        ? Icons.verified_rounded
                                        : Icons.pending_actions_rounded,
                                    size: 18,
                                    color: rec.isTaxPaid
                                        ? Colors.green.shade700
                                        : kSecondarySunsetOrange,
                                  ),
                                ),
                                title: Text(
                                  '[${rec.khatianType}] ${tr('খতিয়ান', 'Khatian')}: ${rec.khatianNo} • ${tr('দাগ', 'Dag')}: ${rec.dagNo}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.5,
                                  ),
                                ),
                                subtitle: Text(
                                  rec.isTaxPaid
                                      ? tr(
                                          'খাজনা পরিশোধ করা হয়েছে (${rec.mouza})',
                                          'Land Tax Paid (${rec.mouza})',
                                        )
                                      : tr(
                                          'খাজনা বকেয়া আছে - পরিশোধ হলে টিক দিন',
                                          'Tax Pending - Check when paid',
                                        ),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: rec.isTaxPaid
                                        ? Colors.green.shade700
                                        : kSecondarySunsetOrange,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
        );
      },
    );
  }

  String _formatClean(double val) {
    if (val == val.roundToDouble()) {
      return val.toInt().toString();
    }
    return val
        .toStringAsFixed(2)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }

  Widget _buildPrimaryConversionCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String value,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withValues(alpha: 0.25)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: color.withValues(alpha: 0.14),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          '⚬ $title',
          style: TextStyle(
            fontSize: 13,
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniUnitTile(
    BuildContext context,
    String unitLabel,
    String val,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            unitLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.5,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            val,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: kPrimaryDeepIndigo,
            ),
          ),
        ],
      ),
    );
  }
}

class _KhatianPieChartPainter extends CustomPainter {
  final Map<String, double> data;
  final Color Function(String) colorResolver;

  _KhatianPieChartPainter({
    required this.data,
    required this.colorResolver,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = data.values.fold(0.0, (a, b) => a + b);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    const strokeWidth = 34.0;
    final rect = Rect.fromCircle(
      center: center,
      radius: radius - strokeWidth / 2,
    );

    if (total <= 0) {
      final emptyPaint = Paint()
        ..color = Colors.grey.shade300
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawArc(rect, 0, 2 * math.pi, false, emptyPaint);
      return;
    }

    double startAngle = -math.pi / 2;
    for (final entry in data.entries) {
      final sweepAngle = (entry.value / total) * 2 * math.pi;
      final paint = Paint()
        ..color = colorResolver(entry.key)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(rect, startAngle, sweepAngle - 0.03, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _KhatianPieChartPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}
