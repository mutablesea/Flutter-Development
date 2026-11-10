import 'package:flutter/material.dart';

import '../main.dart';
import 'land_formulas_page.dart';

class LandUnitDef {
  final String key;
  final String labelBn;
  final String labelEn;
  final double sqFtFactor; // 1 unit = how many Square Feet
  final String category; // 'common', 'kani', 'metric', 'sub'
  final String formulaHint;

  const LandUnitDef({
    required this.key,
    required this.labelBn,
    required this.labelEn,
    required this.sqFtFactor,
    required this.category,
    required this.formulaHint,
  });
}

class CalculatorPage extends StatefulWidget {
  final VoidCallback? onOpenDrawer;

  const CalculatorPage({super.key, this.onOpenDrawer});

  // Complete list of Bangladesh land measurement units from the official PDF
  static const List<LandUnitDef> allAreaUnits = [
    LandUnitDef(
      key: 'decimal',
      labelBn: 'শতাংশ / শতক (Decimal)',
      labelEn: 'Decimal / Shotok (শতাংশ)',
      sqFtFactor: 435.6,
      category: 'common',
      formulaHint: '1 Decimal = 435.6 Sq. Ft = 100 Ojutangsho',
    ),
    LandUnitDef(
      key: 'sqft',
      labelBn: 'বর্গফুট (Sq. Feet / Bargofut)',
      labelEn: 'Square Feet (বর্গফুট)',
      sqFtFactor: 1.0,
      category: 'common',
      formulaHint: 'Base unit (1 Sq. Ft)',
    ),
    LandUnitDef(
      key: 'katha',
      labelBn: 'কাঠা (Katha / Cottah)',
      labelEn: 'Katha / Cottah (কাঠা)',
      sqFtFactor: 720.0,
      category: 'common',
      formulaHint: '1 Katha = 720 Sq. Ft = 1.65 Decimal = 16 Chotak',
    ),
    LandUnitDef(
      key: 'bigha',
      labelBn: 'বিঘা / পাখি (Bigha / Paki)',
      labelEn: 'Bigha / Paki (বিঘা / পাখি)',
      sqFtFactor: 14400.0,
      category: 'common',
      formulaHint: '1 Bigha = 33 Decimal = 20 Katha = 14,400 Sq. Ft',
    ),
    LandUnitDef(
      key: 'acre',
      labelBn: 'একর (Acre)',
      labelEn: 'Acre (একর)',
      sqFtFactor: 43560.0,
      category: 'common',
      formulaHint: '1 Acre = 100 Shotok = 43,560 Sq. Ft = 10 Sq. Chain',
    ),
    LandUnitDef(
      key: 'ojutangsho',
      labelBn: 'অযুতাংশ (Ojutangsho)',
      labelEn: 'Ojutangsho (অযুতাংশ)',
      sqFtFactor: 4.356,
      category: 'sub',
      formulaHint: '100 Ojutangsho = 1 Shotangsho (4.356 Sq. Ft)',
    ),
    LandUnitDef(
      key: 'chotak',
      labelBn: 'ছটাক (Chotak)',
      labelEn: 'Chotak (ছটাক)',
      sqFtFactor: 45.0,
      category: 'sub',
      formulaHint: '16 Chotak = 1 Katha (1 Chotak = 45 Sq. Ft)',
    ),
    LandUnitDef(
      key: 'kani_40',
      labelBn: 'কানি - ৪০ শতক (Kani 40 Shotok)',
      labelEn: 'Kani - 40 Shotok (১৭,৪২৪ বর্গফুট)',
      sqFtFactor: 17424.0,
      category: 'kani',
      formulaHint: '1 Kani = 40 Shotok = 20 Gonda = 17,424 Sq. Ft',
    ),
    LandUnitDef(
      key: 'kani_8hat',
      labelBn: 'কানি - ৮ হাত নল (Kani 8 Hat Nol)',
      labelEn: 'Kani - 8 Hat Nol (১৭,২৮০ বর্গফুট)',
      sqFtFactor: 17280.0,
      category: 'kani',
      formulaHint: '1 Kani (8 Hat Nol) = 20 Gonda = 17,280 Sq. Ft',
    ),
    LandUnitDef(
      key: 'kani_120',
      labelBn: 'কানি - ১২০ শতক (Kani 120 Decimal)',
      labelEn: 'Kani - 120 Decimal (শাহী কানি)',
      sqFtFactor: 52272.0,
      category: 'kani',
      formulaHint: '1 Kani = 120 Decimal = 80 Kora',
    ),
    LandUnitDef(
      key: 'gonda_std',
      labelBn: 'গণ্ডা - ২ শতক (Gonda Standard)',
      labelEn: 'Gonda - 2 Shotok (৮৭১.২ বর্গফুট)',
      sqFtFactor: 871.2,
      category: 'kani',
      formulaHint: '1 Gonda = 4 Kora = 2 Shotok = 871.2 Sq. Ft',
    ),
    LandUnitDef(
      key: 'gonda_8hat',
      labelBn: 'গণ্ডা - ৮ হাত নল (Gonda 8 Hat Nol)',
      labelEn: 'Gonda - 8 Hat Nol (৮৬৪ বর্গফুট)',
      sqFtFactor: 864.0,
      category: 'kani',
      formulaHint: '1 Gonda (8 Hat Nol) = 4 Kora = 864 Sq. Ft',
    ),
    LandUnitDef(
      key: 'kora_std',
      labelBn: 'কড়া - ০.৫ শতক (Kora Standard)',
      labelEn: 'Kora - 0.5 Shotok (২১৭.৮ বর্গফুট)',
      sqFtFactor: 217.8,
      category: 'kani',
      formulaHint: '1 Kora = 3 Kranti = 217.8 Sq. Ft',
    ),
    LandUnitDef(
      key: 'kora_8hat',
      labelBn: 'কড়া - ৮ হাত নল (Kora 8 Hat Nol)',
      labelEn: 'Kora - 8 Hat Nol (২১৬ বর্গফুট)',
      sqFtFactor: 216.0,
      category: 'kani',
      formulaHint: '1 Kora (8 Hat Nol) = 3 Kontho/Kranti = 216 Sq. Ft',
    ),
    LandUnitDef(
      key: 'kranti_std',
      labelBn: 'ক্রান্তি / কণ্ঠ (Kranti / Kontho)',
      labelEn: 'Kranti / Kontho (৭২.৬ বর্গফুট)',
      sqFtFactor: 72.6,
      category: 'kani',
      formulaHint: '1 Kranti = 20 Til = 72.6 Sq. Ft (72 Sq. Ft in 8 Hat Nol)',
    ),
    LandUnitDef(
      key: 'til_std',
      labelBn: 'তিল (Til)',
      labelEn: 'Til (৩.৬৩ / ৩.৬ বর্গফুট)',
      sqFtFactor: 3.63,
      category: 'kani',
      formulaHint: '20 Til = 1 Kranti (1 Til = 3.63 Sq. Ft / 3.6 Sq. Ft)',
    ),
    LandUnitDef(
      key: 'dondho',
      labelBn: 'দণ্ড (Dondho)',
      labelEn: 'Dondho (১২ বর্গফুট)',
      sqFtFactor: 12.0,
      category: 'sub',
      formulaHint: '1 Kontho = 6 Dondho; 1 Dondho = 7 Dhul = 12 Sq. Ft',
    ),
    LandUnitDef(
      key: 'dhul',
      labelBn: 'ধুল (Dhul)',
      labelEn: 'Dhul (১.৭১ বর্গফুট)',
      sqFtFactor: 1.71,
      category: 'sub',
      formulaHint: '1 Dhul = 30 Renu = 1.71 Sq. Ft',
    ),
    LandUnitDef(
      key: 'renu',
      labelBn: 'রেণু (Renu)',
      labelEn: 'Renu (০.০৫৭ বর্গফুট)',
      sqFtFactor: 0.057,
      category: 'sub',
      formulaHint: '1 Renu = 0.057 Sq. Ft',
    ),
    LandUnitDef(
      key: 'kak',
      labelBn: 'কাক (Kak)',
      labelEn: 'Kak (কাক)',
      sqFtFactor: 54.45,
      category: 'sub',
      formulaHint: '4 Kak = 1 Kora',
    ),
    LandUnitDef(
      key: 'sq_meter',
      labelBn: 'বর্গমিটার (Square Meter / Bargometer)',
      labelEn: 'Square Meter (বর্গমিটার)',
      sqFtFactor: 10.7639,
      category: 'metric',
      formulaHint: '1 Shotok = 40.47 Sq. Meter; 1 Acre = 4047 Sq. Meter',
    ),
    LandUnitDef(
      key: 'borgo_gaz',
      labelBn: 'বর্গগজ (Borgo Gaz / Square Yard)',
      labelEn: 'Square Yard / Borgo Gaz (বর্গগজ)',
      sqFtFactor: 9.0,
      category: 'metric',
      formulaHint: '1 Shotok = 48.40 Borgo Gaz; 1 Acre = 4840 Borgo Gaz',
    ),
    LandUnitDef(
      key: 'borgo_hat',
      labelBn: 'বর্গহাত (Borgo Hat / Square Hat)',
      labelEn: 'Square Hat / Bargohat (বর্গহাত)',
      sqFtFactor: 2.25,
      category: 'metric',
      formulaHint: '1 Shotok = 193.6 Borgo Hat; 1 Bigha = 6400 Borgo Hat',
    ),
    LandUnitDef(
      key: 'sq_link',
      labelBn: 'বর্গলিংক (Square Link / Bargolink)',
      labelEn: 'Square Link (বর্গলিংক)',
      sqFtFactor: 0.4356,
      category: 'metric',
      formulaHint: '1 Shotok = 1,000 Sq. Link; 1 Acre = 1,00,000 Sq. Link',
    ),
    LandUnitDef(
      key: 'sq_chain',
      labelBn: 'বর্গচেইন (Square Chain)',
      labelEn: 'Square Chain (বর্গচেইন)',
      sqFtFactor: 4356.0,
      category: 'metric',
      formulaHint: '10 Square Chain = 1 Acre = 43,560 Sq. Ft',
    ),
    LandUnitDef(
      key: 'ayer',
      labelBn: 'এয়র (Ayer / Are)',
      labelEn: 'Ayer / Are (এয়র)',
      sqFtFactor: 1076.39,
      category: 'metric',
      formulaHint: '1 Ayer = 100 Sq. Meter = 1076.39 Sq. Ft = 2.47105 Shotok',
    ),
    LandUnitDef(
      key: 'hectare',
      labelBn: 'হেক্টর (Hector / Hectare)',
      labelEn: 'Hectare / Hector (হেক্টর)',
      sqFtFactor: 107639.0,
      category: 'metric',
      formulaHint: '1 Hector = 100 Ayer = 10,000 Sq. Meter = 247.105 Shotok',
    ),
  ];

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  // Unit converter state
  final TextEditingController _inputCtrl = TextEditingController(text: '1');
  String _selectedUnitKey = 'decimal';
  String _selectedCategory = 'all'; // 'all', 'common', 'kani', 'metric', 'sub'
  double _baseSqFt = 435.6;

  // Plot length x width calculator state
  final TextEditingController _len1Ctrl = TextEditingController(text: '66');
  final TextEditingController _len2Ctrl = TextEditingController(text: '66');
  final TextEditingController _wid1Ctrl = TextEditingController(text: '66');
  final TextEditingController _wid2Ctrl = TextEditingController(text: '66');
  String _linearUnit = 'feet'; // 'feet', 'hat', 'gaz', 'meter', 'link', 'chain'

  // Linear unit converter state
  final TextEditingController _linearInputCtrl =
      TextEditingController(text: '1');
  String _selectedLinearKey = 'chain';

  static const Map<String, double> _linearToFeet = {
    'feet': 1.0,
    'hat': 1.5, // 1 Chain = 66 Feet = 44 Hat -> 1 Hat = 1.5 Feet
    'gaz': 3.0, // 1 Gaz/Yard = 3 Feet
    'meter': 3.28084, // 1 Meter = 3.28084 Feet
    'inchi': 1.0 / 12.0, // 12 Inchi = 1 Foot
    'link': 0.66, // 100 Link = 66 Feet -> 1 Link = 0.66 Feet
    'chain': 66.0, // 1 Chain = 66 Feet
    'nol_8hat': 12.0, // 8 Hat Nol = 8 * 1.5 = 12 Feet
  };

  @override
  void initState() {
    super.initState();
    _calculateAreaConversion();
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _len1Ctrl.dispose();
    _len2Ctrl.dispose();
    _wid1Ctrl.dispose();
    _wid2Ctrl.dispose();
    _linearInputCtrl.dispose();
    super.dispose();
  }

  LandUnitDef get _currentUnitDef {
    return CalculatorPage.allAreaUnits.firstWhere(
      (u) => u.key == _selectedUnitKey,
      orElse: () => CalculatorPage.allAreaUnits.first,
    );
  }

  void _calculateAreaConversion() {
    final inputVal = double.tryParse(_inputCtrl.text.trim()) ?? 0.0;
    setState(() {
      _baseSqFt = inputVal * _currentUnitDef.sqFtFactor;
    });
  }

  void _applyPresetValue(double value) {
    _inputCtrl.text = value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
    _calculateAreaConversion();
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild instantly when the language changes
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, _, _) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: widget.onOpenDrawer != null
              ? IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  tooltip: tr('সাইডবার মেনু', 'Open Menu'),
                  onPressed: widget.onOpenDrawer,
                )
              : null,
          title: Text(
            tr('জমি পরিমাপ ক্যালকুলেটর', 'Smart Land Calculator'),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu_book_rounded),
              tooltip: tr('ভূমি পরিমাপের সূত্রাবলী', 'Land Formulas'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const LandFormulasPage(),
                  ),
                );
              },
            ),
          ],
          bottom: TabBar(
            isScrollable: false,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: kSecondarySunsetOrange,
            indicatorWeight: 3,
            tabs: [
              Tab(
                icon: const Icon(Icons.swap_horiz_rounded, size: 20),
                text: tr('একক রূপান্তর', 'Unit Converter'),
              ),
              Tab(
                icon: const Icon(Icons.crop_free_rounded, size: 20),
                text: tr('দৈর্ঘ্য × প্রস্থ', 'Plot Area'),
              ),
              Tab(
                icon: const Icon(Icons.straighten_rounded, size: 20),
                text: tr('চেইন ও রৈখিক', 'Linear / Chain'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUnitConverterTab(context),
            _buildPlotAreaCalculatorTab(context),
            _buildLinearConverterTab(context),
          ],
        ),
      ),
    );
  }

  // ---------------- TAB 1: All-Unit Area Converter ----------------
  Widget _buildUnitConverterTab(BuildContext context) {
    final theme = Theme.of(context);
    final selectedDef = _currentUnitDef;

    final filteredUnits = CalculatorPage.allAreaUnits.where((u) {
      if (_selectedCategory == 'all') return true;
      return u.category == _selectedCategory;
    }).toList();

    final totalDecimals = _baseSqFt / 435.6;
    final bighaFloor = (totalDecimals / 33.0).floor();
    final remDecimals = totalDecimals - (bighaFloor * 33.0);

    return Column(
      children: [
        // Top Input & Quick Presets Card
        Container(
          margin: const EdgeInsets.fromLTRB(14, 12, 14, 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.55,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.25),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _inputCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: tr('পরিমাণ লিখুন', 'Enter Value'),
                        prefixIcon: const Icon(Icons.edit_note_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        isDense: true,
                      ),
                      onChanged: (_) => _calculateAreaConversion(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedUnitKey,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: tr('একক নির্বাচন', 'Select Unit'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        isDense: true,
                      ),
                      items: CalculatorPage.allAreaUnits.map((unit) {
                        return DropdownMenuItem<String>(
                          value: unit.key,
                          child: Text(
                            tr(unit.labelBn, unit.labelEn),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val == null) return;
                        setState(() {
                          _selectedUnitKey = val;
                          _calculateAreaConversion();
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Quick preset chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text(
                      tr('দ্রুত মান:', 'Quick:'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 8),
                    for (final preset in [1.0, 5.0, 10.0, 20.0, 33.0, 40.0, 100.0, 150.0])
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ActionChip(
                          visualDensity: VisualDensity.compact,
                          label: Text(preset.toInt().toString()),
                          onPressed: () => _applyPresetValue(preset),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Live Summary Pill
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(
                    alpha: 0.65,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tr(
                          'স্মার্ট হিসাব: ${totalDecimals.toStringAsFixed(2)} শতাংশ = $bighaFloor বিঘা ${remDecimals.toStringAsFixed(2)} শতাংশ = ${(totalDecimals / 1.65).toStringAsFixed(2)} কাঠা',
                          'Smart Breakdown: ${totalDecimals.toStringAsFixed(2)} Decimal = $bighaFloor Bigha ${remDecimals.toStringAsFixed(2)} Decimal = ${(totalDecimals / 1.65).toStringAsFixed(2)} Katha',
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'সূত্র / Formula: ${selectedDef.formulaHint}',
                style: TextStyle(
                  fontSize: 11,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // Category Filter Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip('all', tr('সব একক (২৭টি)', 'All (27)')),
                _buildCategoryChip(
                  'common',
                  tr('প্রচলিত (শতক/বিঘা/কাঠা)', 'Common'),
                ),
                _buildCategoryChip(
                  'kani',
                  tr('কানি-গণ্ডা-কড়া-তিল', 'Kani & Gonda'),
                ),
                _buildCategoryChip(
                  'metric',
                  tr('বর্গহাত/গজ/লিংক/হেক্টর', 'Metric & Survey'),
                ),
                _buildCategoryChip(
                  'sub',
                  tr('ছটাক/দণ্ড/ধুল/রেণু', 'Sub-units'),
                ),
              ],
            ),
          ),
        ),

        // Results List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 20),
            itemCount: filteredUnits.length,
            itemBuilder: (context, index) {
              final unit = filteredUnits[index];
              final result = _baseSqFt / unit.sqFtFactor;
              final isSelected = unit.key == _selectedUnitKey;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                elevation: isSelected ? 2 : 0.5,
                color: isSelected
                    ? theme.colorScheme.primaryContainer.withValues(alpha: 0.45)
                    : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.dividerColor.withValues(alpha: 0.2),
                  ),
                ),
                child: ListTile(
                  dense: true,
                  onTap: () {
                    setState(() {
                      _selectedUnitKey = unit.key;
                      _calculateAreaConversion();
                    });
                  },
                  title: Text(
                    tr(unit.labelBn, unit.labelEn),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    unit.formulaHint,
                    style: const TextStyle(fontSize: 11),
                  ),
                  trailing: Text(
                    _formatResult(result),
                    style: TextStyle(
                      fontSize: 16.5,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ---------------- TAB 2: Plot Length × Width Area Calculator ----------------
  Widget _buildPlotAreaCalculatorTab(BuildContext context) {
    final theme = Theme.of(context);
    final l1 = double.tryParse(_len1Ctrl.text.trim()) ?? 0.0;
    final l2 = double.tryParse(_len2Ctrl.text.trim()) ?? 0.0;
    final w1 = double.tryParse(_wid1Ctrl.text.trim()) ?? 0.0;
    final w2 = double.tryParse(_wid2Ctrl.text.trim()) ?? 0.0;

    final avgLen = (l1 + l2) / 2.0;
    final avgWid = (w1 + w2) / 2.0;
    final feetFactor = _linearToFeet[_linearUnit] ?? 1.0;

    final avgLenFeet = avgLen * feetFactor;
    final avgWidFeet = avgWid * feetFactor;
    final areaSqFt = avgLenFeet * avgWidFeet;

    final areaDecimal = areaSqFt / 435.6;
    final areaKatha = areaSqFt / 720.0;
    final areaBigha = areaSqFt / 14400.0;
    final areaAcre = areaSqFt / 43560.0;
    final areaKani40 = areaSqFt / 17424.0;
    final areaKani8Hat = areaSqFt / 17280.0;
    final areaGonda = areaSqFt / 871.2;
    final areaBorgoHat = areaSqFt / 2.25;
    final areaBorgoGaz = areaSqFt / 9.0;
    final areaSqMeter = areaSqFt / 10.7639;
    final areaSqLink = areaSqFt / 0.4356;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
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
                    'জমির চারপাশের মাপ দিন (দৈর্ঘ্য ও প্রস্থ)',
                    'Enter Plot Side Measurements (Length & Width)',
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _linearUnit,
                  decoration: InputDecoration(
                    labelText: tr('মাপার একক (Measurement Unit)', 'Linear Unit'),
                    prefixIcon: const Icon(Icons.straighten_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'feet',
                      child: Text(tr('ফুট (Feet)', 'Feet (ফুট)')),
                    ),
                    DropdownMenuItem(
                      value: 'hat',
                      child: Text(
                        tr('হাত (Hat = ১.৫ ফুট)', 'Hat (1 Hat = 1.5 Feet)'),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'gaz',
                      child: Text(
                        tr('গজ (Gaz/Yard = ৩ ফুট)', 'Yard / Gaz (3 Feet)'),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'meter',
                      child: Text(
                        tr('মিটার (Meter = ৩.২৮ ফুট)', 'Meter (3.28 Feet)'),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'link',
                      child: Text(
                        tr('লিংক (Link = ০.৬৬ ফুট)', 'Link (0.66 Feet)'),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'chain',
                      child: Text(
                        tr('চেইন (Chain = ৬৬ ফুট)', 'Chain (66 Feet)'),
                      ),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _linearUnit = val);
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _len1Ctrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: tr('১ম দৈর্ঘ্য (Length 1)', 'Length 1'),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _len2Ctrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: tr('২য় দৈর্ঘ্য (Length 2)', 'Length 2'),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _wid1Ctrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: tr('১ম প্রস্থ (Width 1)', 'Width 1'),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _wid2Ctrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: tr('২য় প্রস্থ (Width 2)', 'Width 2'),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  tr(
                    'গড় দৈর্ঘ্য: ${avgLenFeet.toStringAsFixed(2)} ফুট × গড় প্রস্থ: ${avgWidFeet.toStringAsFixed(2)} ফুট',
                    'Average Length: ${avgLenFeet.toStringAsFixed(2)} ft × Average Width: ${avgWidFeet.toStringAsFixed(2)} ft',
                  ),
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        // Highlighted Area Result Banner
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              Text(
                tr('মোট জমির পরিমাণ (শতাংশে)', 'Calculated Land Area'),
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                '${areaDecimal.toStringAsFixed(3)} ${tr('শতাংশ (Decimal)', 'Decimal')}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${areaSqFt.toStringAsFixed(2)} ${tr('বর্গফুট (Sq. Ft)', 'Sq. Ft')} • ${areaKatha.toStringAsFixed(2)} ${tr('কাঠা', 'Katha')}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _buildPlotResultRow(
          tr('বিঘা / পাখি (Bigha)', 'Bigha / Paki'),
          areaBigha.toStringAsFixed(4),
        ),
        _buildPlotResultRow(
          tr('কাঠা (Katha)', 'Katha'),
          areaKatha.toStringAsFixed(4),
        ),
        _buildPlotResultRow(
          tr('একর (Acre)', 'Acre'),
          areaAcre.toStringAsFixed(4),
        ),
        _buildPlotResultRow(
          tr('কানি (৪০ শতক)', 'Kani (40 Shotok)'),
          areaKani40.toStringAsFixed(4),
        ),
        _buildPlotResultRow(
          tr('কানি (৮ হাত নল)', 'Kani (8 Hat Nol)'),
          areaKani8Hat.toStringAsFixed(4),
        ),
        _buildPlotResultRow(
          tr('গণ্ডা (Gonda)', 'Gonda'),
          areaGonda.toStringAsFixed(4),
        ),
        _buildPlotResultRow(
          tr('বর্গহাত (Borgo Hat)', 'Borgo Hat'),
          areaBorgoHat.toStringAsFixed(2),
        ),
        _buildPlotResultRow(
          tr('বর্গগজ (Borgo Gaz)', 'Borgo Gaz (Sq. Yard)'),
          areaBorgoGaz.toStringAsFixed(2),
        ),
        _buildPlotResultRow(
          tr('বর্গমিটার (Sq. Meter)', 'Square Meter'),
          areaSqMeter.toStringAsFixed(2),
        ),
        _buildPlotResultRow(
          tr('বর্গলিংক (Sq. Link)', 'Square Link'),
          areaSqLink.toStringAsFixed(1),
        ),
      ],
    );
  }

  // ---------------- TAB 3: Linear / Chain Converter ----------------
  Widget _buildLinearConverterTab(BuildContext context) {
    final theme = Theme.of(context);
    final inputVal = double.tryParse(_linearInputCtrl.text.trim()) ?? 0.0;
    final baseFeet = inputVal * (_linearToFeet[_selectedLinearKey] ?? 1.0);

    final linearLabels = <String, String>{
      'chain': tr('চেইন (1 Chain = 66 Feet = 100 Link)', 'Chain (66 Feet)'),
      'feet': tr('ফুট (Feet)', 'Feet'),
      'hat': tr('হাত (1 Hat = 1.5 Feet / 18 Inchi)', 'Hat (1.5 Feet)'),
      'gaz': tr('গজ (1 Gaz/Yard = 3 Feet = 2 Hat)', 'Gaz / Yard (3 Feet)'),
      'meter': tr('মিটার (1 Chain = 20.12 Meter)', 'Meter'),
      'inchi': tr('ইঞ্চি (1 Chain = 792 Inchi)', 'Inch (Inchi)'),
      'link': tr('লিংক (100 Link = 66 Feet = 1 Chain)', 'Link (0.66 Feet)'),
      'nol_8hat': tr('৮ হাত নল (1 Nol = 8 Hat = 12 Feet)', '8 Hat Nol (12 Feet)'),
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
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
                    'রৈখিক ও গান্টার চেইন রূপান্তর (1 Chain = 66 Feet = 44 Hat = 22 Gaz = 20.12m = 792 Inchi = 100 Link)',
                    'Linear & Gunter Chain Converter (1 Chain = 66 Feet = 44 Hat = 22 Gaz = 20.12m = 792 Inchi = 100 Link)',
                  ),
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _linearInputCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: tr('মান', 'Value'),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedLinearKey,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: tr('রৈখিক একক', 'Linear Unit'),
                          border: const OutlineInputBorder(),
                        ),
                        items: linearLabels.entries.map((e) {
                          return DropdownMenuItem(
                            value: e.key,
                            child: Text(
                              e.value,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedLinearKey = val);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...linearLabels.entries.map((entry) {
          final res = baseFeet / (_linearToFeet[entry.key] ?? 1.0);
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: Icon(
                Icons.straighten_rounded,
                color: theme.colorScheme.primary,
              ),
              title: Text(
                entry.value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                ),
              ),
              trailing: Text(
                _formatResult(res),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCategoryChip(String catKey, String label) {
    final isSelected = _selectedCategory == catKey;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        selected: isSelected,
        onSelected: (_) {
          setState(() => _selectedCategory = catKey);
        },
      ),
    );
  }

  Widget _buildPlotResultRow(String label, String val) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        dense: true,
        title: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: Text(
          val,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  String _formatResult(double val) {
    if (val == 0) return '0';
    if (val >= 1000) return val.toStringAsFixed(2);
    return val.toStringAsFixed(4);
  }
}
