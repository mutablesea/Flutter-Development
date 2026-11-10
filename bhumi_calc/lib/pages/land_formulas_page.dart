import 'package:flutter/material.dart';

import '../main.dart';

class FormulaSection {
  final String category; // 'bigha', 'kani', 'acre', 'hectare'
  final String titleEn;
  final String titleBn;
  final IconData icon;
  final Color color;
  final List<String> formulas;

  const FormulaSection({
    required this.category,
    required this.titleEn,
    required this.titleBn,
    required this.icon,
    required this.color,
    required this.formulas,
  });
}

class LandFormulasPage extends StatefulWidget {
  final VoidCallback? onOpenDrawer;

  const LandFormulasPage({super.key, this.onOpenDrawer});

  // Complete list of all 34 formula groups from the official Bangladesh Land Measurement reference
  static const List<FormulaSection> allFormulaSections = [
    FormulaSection(
      category: 'bigha',
      titleEn: 'Formula of Paki, Bigha and Decimal',
      titleBn: 'পাখি, বিঘা এবং শতাংশের সূত্রাবলী',
      icon: Icons.straighten_rounded,
      color: kPrimaryDeepIndigo,
      formulas: [
        '1 Paki = 1 Bigha = 33 Decimal',
        '1 Decimal = 1 Shotangsho (Shotok) = 435.6 Sq Feet (approx)',
        '1 Kattah (or Cottah) = 1.65 Shotangsho (approx)',
        '1 Katha = 165 Ojutangsho (approx)',
        '1 Shotangsho = 100 Ojutangsho',
        '1 Katha = 720 Sq Feet (approx)',
        '20 Katha = 1 Bigha',
        '3 Bighas = 1 Acre approx. (1600 square yards)',
        '4 Kora = 1 Gonda',
        '20 G = 1 Kani (20 G 1 Kani)',
        '80 Kora = 1 Kani',
        '120 Decimal = 1 Kani',
      ],
    ),
    FormulaSection(
      category: 'kani',
      titleEn: 'Formula of Square Feet and Kani',
      titleBn: 'বর্গফুট এবং কানির সূত্রাবলী',
      icon: Icons.square_foot_rounded,
      color: Colors.indigo,
      formulas: [
        '17280 Square Feet = 1 Kani',
        '1619 Square Meter = 1 Kani',
        '40000 Square Links = 1 Kani',
        '7680 Square Hat = 1 Kani',
        '1936 Bargogoz = 1 Kani',
        '40 Acore (Shotok) = 1 Kani',
      ],
    ),
    FormulaSection(
      category: 'kani',
      titleEn: 'Formula of 8 Hat Nol',
      titleBn: '৮ হাত নলের সূত্র',
      icon: Icons.architecture_rounded,
      color: kSecondarySunsetOrange,
      formulas: [
        '12 Nol * 10 Nol = 120 Bargonol',
      ],
    ),
    FormulaSection(
      category: 'kani',
      titleEn: 'Kani and Gonda as Square Feet',
      titleBn: 'বর্গফুটে কানি ও গণ্ডার হিসাব (৮ হাত নল)',
      icon: Icons.grid_on_rounded,
      color: Colors.purple,
      formulas: [
        '17280 Square Feet = 1 Kani = 20 Gonda (Measurement of 8 Hat nol)',
        '864 Square Feet = 1 G = 4 Kora',
        '216 Square Feet = 1 Kora = 3 Kransti/Kontho',
        '72 Square Feet = 1 Kransti = 20 Til',
        '3.6 Square Feet = 1 Til',
      ],
    ),
    FormulaSection(
      category: 'acre',
      titleEn: 'Formula of Square Feet and Acore',
      titleBn: 'বর্গফুট, চেইন এবং একরের সূত্র',
      icon: Icons.landscape_rounded,
      color: Colors.teal,
      formulas: [
        '1 Chain = 66 Feet',
        '10 Square Chain = (66 * 660) or 1 Acore = 43560 Square Feet',
        '1 Acore or 100 Shotok = 43200 Square Feet',
      ],
    ),
    FormulaSection(
      category: 'acre',
      titleEn: 'Formula of Square Link, Acore and Shotok',
      titleBn: 'বর্গলিংক, একর এবং শতকের সূত্র',
      icon: Icons.link_rounded,
      color: Colors.blue,
      formulas: [
        '1 Chain = 100 Link, So 1 Square Chain = 100 * 1000 = 100,000 Square Link = 1 Acore',
        '1 Acore Or 100 Shotok = 1,00,000 Square Link',
        '1 Shotok = 1,000 Square Link',
        '100 Link = 66 Feet',
      ],
    ),
    FormulaSection(
      category: 'kani',
      titleEn: 'Formula of Kani and Gonda as Square Link',
      titleBn: 'বর্গলিংকে কানি ও গণ্ডার সূত্র',
      icon: Icons.dataset_linked_rounded,
      color: Colors.indigo,
      formulas: [
        '1 Kani Or 20 G = 40,000 Square Link',
        '1 Gonda Or 4 Kora = 2000 Square Link',
        '1 Kora Or 3 Kanti = 500 Square Link',
        '1 Kranti Or 20 Til = 160.66 Square Link',
        '1 Til = 8.33 Square Link',
      ],
    ),
    FormulaSection(
      category: 'kani',
      titleEn: 'Formula of 8 Hat Nol as Square Hat (Bargo Hat)',
      titleBn: 'বর্গহাতে ৮ হাত নলের কানি-গণ্ডার সূত্র',
      icon: Icons.pan_tool_alt_rounded,
      color: Colors.brown,
      formulas: [
        '1 Kani Or 20 Gaz/Yard = 7680 Bargo Hat',
        '1 Gonda Or 4 Kora = 384 Bargo Hat',
        '1 Kora Or 3 Kanti = 96 Bargo Hat',
        '1 Kranti Or 20 Til = 32 Bargo Hat',
        '1 Til = 1.6 Bargo Hat',
      ],
    ),
    FormulaSection(
      category: 'kani',
      titleEn: 'Formula of Kani and Gonda for 8 Hat Nol as Square Feet',
      titleBn: '৮ হাত নলে কানি, গণ্ডা, দণ্ড, ধুল ও রেণুর বর্গফুট হিসাব',
      icon: Icons.calculate_outlined,
      color: Colors.deepPurple,
      formulas: [
        '1 Kani Or 20 G = 17280 Square Feet',
        '1 Gonda Or 4 Kora = 864 Square Feet',
        '1 Kora Or 3 Kontho/Kranti = 216 Square Feet',
        '1 Kontho Or 6 D = 72 Square Feet',
        '1 Dondho Or 7 Dhul = 12 Square Feet',
        '1 Dhul Or 30 Renu = 1.71 Square Feet',
        '1 Renu = 0.057 Square Feet',
      ],
    ),
    FormulaSection(
      category: 'kani',
      titleEn: 'Formula of Kani and Gondar as Bargo Gaz/Yard',
      titleBn: 'বর্গগজে (Square Yard) কানি ও গণ্ডার সূত্র',
      icon: Icons.border_outer_rounded,
      color: Colors.green,
      formulas: [
        '1 Kani Or 20 G = 1936 Bargo Gaz (Square Yard)',
        '1 Gonda Or 4 Kora = 96.8 Bargo Gaz (Square Yard)',
        '1 Kora Or 3 Kranti = 24.2 Bargo Gaz (Square Yard)',
        '1 Kranti Or 20 Til = 8.06 Bargo Gaz (Square Yard)',
        '1 Til = 0.40 Bargo Gaz (Square Yard)',
      ],
    ),
    FormulaSection(
      category: 'kani',
      titleEn: 'Formula of Kani and Gondar as Square Meter',
      titleBn: 'বর্গমিটারে কানি ও গণ্ডার সূত্র',
      icon: Icons.aspect_ratio_rounded,
      color: Colors.cyan,
      formulas: [
        '(40.47 * Meter * 39.67 = 1605 Square Meter)',
        '1 Kani Or 20 G = 1605 Square Meter',
        '1 Gonda Or 4 Kora = 80.25 Square Meter',
        '1 Kora Or 3 Kranti = 20.06 Square Meter',
        '1 Kranti Or 20 Til = 6.68 Square Meter',
        '1 Til = .334 Square Meter',
      ],
    ),
    FormulaSection(
      category: 'acre',
      titleEn: 'Formula of Acore and Shotok',
      titleBn: 'একর এবং শতকের বিস্তারিত সূত্রাবলী',
      icon: Icons.public_rounded,
      color: kPrimaryDeepIndigo,
      formulas: [
        'Length 10 Chain * Width 1 Chain = 10 Square Chain = 1 Acore',
        '1 Chain = 66 Feet = 44 Hat = 22 Gaz/Yard = 20.12 Meter = 792 Inchi = 100 Link',
        '1 Acore = 10 Square Chain',
        '1 Acore = 100 Shotok',
        '1 Acore = 43560 Square Feet',
        '1 Acore = 19360 Square Hat',
        '1 Acore = 4840 Borgo Gaz (Square Yard)',
        '1 Acore = 4047 Square Meter',
        '1 Acore = 1,00,000 Square Link',
        '1 Acore = 3 Bigha 8 Chotak',
        '1 Acore = 60.5 Kattah',
        '1 Acore = 2 Kani 10 Gonda (According to 40 Shotok Kani)',
        '1 Acore = 432.6 Square Feet',
        '1 Acore = 1 Gonda',
      ],
    ),
    FormulaSection(
      category: 'acre',
      titleEn: 'Formula of Acore and Shotok as Square Link',
      titleBn: 'বর্গলিংকে একর ও শতক',
      icon: Icons.insert_link_rounded,
      color: Colors.indigo,
      formulas: [
        '1 Chain = 100 Link',
        '1 Square Chain = 100 * 1000 = 1,00,000 Square Link = 1 Acore',
        '1 Acore Or 100 Shotok = 1,00,000 Square Link',
      ],
    ),
    FormulaSection(
      category: 'acre',
      titleEn: 'Formula of Acore and Shotok as Square Feet',
      titleBn: 'বর্গফুটে একর ও শতক',
      icon: Icons.crop_free_rounded,
      color: kSecondarySunsetOrange,
      formulas: [
        '1 Chain = 66 Feet',
        '10 Square Chain = 66 * 660',
        'Or 1 Acore Or 100 Shotok = 43569 (43560) Square Feet',
        '1 Shotok = 435.6 Square Feet',
      ],
    ),
    FormulaSection(
      category: 'kani',
      titleEn: 'Formula of Kani and Gonda as Acore and Shotok',
      titleBn: '৪০ শতকের কানিতে কানি-গণ্ডা ও বর্গফুটের সূত্র',
      icon: Icons.grid_4x4_rounded,
      color: Colors.purple,
      formulas: [
        '1 Shotok = 435.6 Square Feet',
        '1 Kani Or 40 Shotok = 435.6 * 40 = 17424 Square Feet',
        '1 Kani Or 20 G = 17424 Square Feet',
        '1 Gonda Or 4 Kora = 871.2 Square Feet',
        '1 Kora Or 3 Kranti = 217.8 Square Feet',
        '1 Kranti Or 20 Til = 72.6 Square Feet',
        '1 Til = 3.63 Square Feet',
      ],
    ),
    FormulaSection(
      category: 'acre',
      titleEn: 'Formula of Acore and Shotok as Borgo Hat',
      titleBn: 'বর্গহাতে একর, শতক ও কানির সূত্র',
      icon: Icons.front_hand_outlined,
      color: Colors.brown,
      formulas: [
        '1 Chain = 88 Hat',
        '10 Square chain = 44 * 440 = 19360 Borgo Hat (1 Acre)',
        '1 Acre Or 100 Shotok = 19360 Borgo Hat',
        '1 Shotok = 193.6 Borgo Hat',
        '40 Shotok Or Kani = 193.6 * 40 = 7744 Square Hat',
      ],
    ),
    FormulaSection(
      category: 'acre',
      titleEn: 'Formula of Acore and Shotok as Borgo Gaz/Yard',
      titleBn: 'বর্গগজে একর, শতক ও কানির সূত্র',
      icon: Icons.space_dashboard_outlined,
      color: Colors.teal,
      formulas: [
        '1 Chain = 22 Gaz/Yard',
        '10 Square Chain Or 1 Acre = 220 * 22 = 4840 Borgo Gaz (Square Yard)',
        '1 Acre Or 100 Shotok = 4840 Square Gaz',
        '1 Shotok = 48.40 Barogo Gaz',
        '1 Kani Or 40 Borgo Gaz/ Square Yard = 48.40 * 40 = 1936 Bargo Gaz (Square Yard)',
      ],
    ),
    FormulaSection(
      category: 'acre',
      titleEn: 'Formula of Acore and Shotok as Square Meter',
      titleBn: 'বর্গমিটারে একর ও শতকের সূত্র',
      icon: Icons.square_outlined,
      color: Colors.blue,
      formulas: [
        '1 Chain = 2012 cm (20.12 Meter)',
        '10 Square Chain Or 1 Acre = 201.2 * 20.12 = 4047 Square Meter',
        '1 Acre Or 100 Shotok = 4047 Square Meter',
        '1 Shotok = 40.47 Square Meter',
      ],
    ),
    FormulaSection(
      category: 'bigha',
      titleEn: 'Formula of Bigha and Kattah',
      titleBn: 'বিঘা এবং কাঠার পূর্ণাঙ্গ সূত্রাবলী',
      icon: Icons.view_module_rounded,
      color: kPrimaryDeepIndigo,
      formulas: [
        '1 Bigha = 80 Hat',
        '1 Bigha = 80 * 80 = 6400 Square Hat',
        '1 Bigha = 20 Kattah',
        '1 Bigha = 33 Shotok',
        '1 Bigha = 33000 Square Link',
        '1 Bigha = 6400 Square Hat',
        '1 Bigha = 1600 Borgo Gaz (Square Yard)',
        '1 Bigha = 14400 Square Feet',
        '1 Bigha = 1338 Square Meter',
        '1 Bigha = 16 Gonda 2 Kora 2 Kranti',
      ],
    ),
    FormulaSection(
      category: 'bigha',
      titleEn: 'Formula of Bargohat and Bigha',
      titleBn: 'বর্গহাত, বিঘা, কাঠা ও ছটাকের সূত্র',
      icon: Icons.grid_goldenratio_rounded,
      color: kSecondarySunsetOrange,
      formulas: [
        '1 Bigha or 20 Kattah = 6400 Bargohat (Square Hat)',
        '1 Kattah or 16 Chotak = 320 Bargohat (Square Hat)',
        '1 Chotak = 320 Bargohat (Square Hat) [20 Bargohat standard]',
      ],
    ),
    FormulaSection(
      category: 'bigha',
      titleEn: 'Formula of Bigha and Kattah (Kak, Kora, Gonda, Chotak)',
      titleBn: 'কাক, কড়া, গণ্ডা, ছটাক, কাঠা ও বিঘার সম্পর্ক',
      icon: Icons.account_tree_outlined,
      color: Colors.purple,
      formulas: [
        '4 Kak = 1 Kora',
        '4 Kora = 1 Gonda',
        '16 Chotak = 1 Kattah',
        '20 Kattah = 1 Bigha',
        '20 G = 1 Chotak (20 G 1 Chotak)',
        '6 Bigha = 1 Gonda',
      ],
    ),
    FormulaSection(
      category: 'bigha',
      titleEn: 'Formula of Bigha, Kattah and Hat',
      titleBn: 'বিঘা, কাঠা, ছটাক ও হাতের রৈখিক পরিমাপ',
      icon: Icons.linear_scale_rounded,
      color: Colors.teal,
      formulas: [
        '1 Bigha or 20 Kattah = 80 Hat',
        '1 Kattah or 16 Chotak = 4 Hat',
        '1 Chotak or 20 G = .25 Hat',
        '1 Gonda or 4 Kora = .0125 Hat',
        '1 Kora or 4 Kak = .0031 Hat',
        '1 Kak = .0007 Hat',
      ],
    ),
    FormulaSection(
      category: 'bigha',
      titleEn: 'Formula of Bargolink/Square Link, Bigha',
      titleBn: 'বর্গলিংক ও বিঘা-কাঠা-ছটাকের সূত্র',
      icon: Icons.link,
      color: Colors.indigo,
      formulas: [
        '1 Bigha or 20 Kattah = 33000 Bargolink/Square link',
        '1 Kattah or 16 Chotak = 1650 Bargolink/Square link',
        '1 Chotak = 103.125 Bargolink/Square link',
      ],
    ),
    FormulaSection(
      category: 'bigha',
      titleEn: 'Formula of Bargofut/Square Feet and Bigha',
      titleBn: 'বর্গফুট ও বিঘা-কাঠা-ছটাকের সূত্র',
      icon: Icons.square_foot,
      color: kSecondarySunsetOrange,
      formulas: [
        '1 Bigha or 20 Kattah = 14,400 Bargofut/Square feet',
        '1 Kattah or 16 Chotak = 720 Bargofut/Square feet',
        '1 Chotak = 45 Bargofut/Square feet',
      ],
    ),
    FormulaSection(
      category: 'bigha',
      titleEn: 'Formula of Bargogaz/Square Yard and Bigha',
      titleBn: 'বর্গগজ ও বিঘা-কাঠা-ছটাকের সূত্র',
      icon: Icons.crop_din_rounded,
      color: Colors.green,
      formulas: [
        '1 Bigha or 20 Kattah = 1600 Bargogaz/Square yard',
        '1 Kattah or 16 Chotak = 80 Bargogaz/Square yard',
        '1 Chotak = 5 Bargogaz/Square yard',
      ],
    ),
    FormulaSection(
      category: 'bigha',
      titleEn: 'Formula of Bargometer/Square Meter and Bigha',
      titleBn: 'বর্গমিটার ও বিঘা-কাঠা-ছটাকের সূত্র',
      icon: Icons.aspect_ratio,
      color: Colors.blue,
      formulas: [
        '1 Bigha or 20 Kattah = 1338 Bargometer/Square meter',
        '1 Kattah or 16 Chotak = 66.9 Bargometer/Square meter',
        '1 Chotak = 4.18 Bargometer/Square meter',
      ],
    ),
    FormulaSection(
      category: 'hectare',
      titleEn: 'Formula of Ayer/Ayor and Hector',
      titleBn: 'এয়র এবং হেক্টরের সূত্র',
      icon: Icons.terrain_rounded,
      color: Colors.purple,
      formulas: [
        '1 Hector = 10,000 Bargometer/Square meter',
        '1 Hector = 11960 Bargogaz/Square yard',
        '1 Hector = 2.47 Acre',
        '1 Hector = 100 Ayer',
        '1 Ayer = 28.9 Bigha (Approx)',
      ],
    ),
    FormulaSection(
      category: 'hectare',
      titleEn: 'Formula of Bargometer/Square Meter, Ayer and Hector',
      titleBn: 'বর্গমিটার, এয়র ও হেক্টরের সূত্র',
      icon: Icons.layers_outlined,
      color: Colors.cyan,
      formulas: [
        '1 Hector or 100 Ayer = 10,000 Bargometer/Square meter',
        '1 Ayer = 100 Bargometer/Square meter',
      ],
    ),
    FormulaSection(
      category: 'hectare',
      titleEn: 'Formula of Shotok, Ayer and Hector',
      titleBn: 'শতক, এয়র ও হেক্টরের সূত্র',
      icon: Icons.compare_arrows_rounded,
      color: Colors.brown,
      formulas: [
        '147.105 (247.105) Shotok = 1 Hector or 100 Ayer',
        '247.105 Shotok = 1 Hector (2.47105 Shotok = 1 Ayer)',
      ],
    ),
    FormulaSection(
      category: 'hectare',
      titleEn: 'Formula of Bargohat, Ayer and Hector',
      titleBn: 'বর্গহাত, এয়র ও হেক্টরের সূত্র',
      icon: Icons.pan_tool_outlined,
      color: Colors.teal,
      formulas: [
        '4789.528 (47839.528) Bargohat/Square Hat = 1 Hector',
        '478.39528 Borgohat = 1 Ayer',
      ],
    ),
    FormulaSection(
      category: 'hectare',
      titleEn: 'Formula of Bargofut, Ayer and Hector',
      titleBn: 'বর্গফুট, এয়র ও হেক্টরের সূত্র',
      icon: Icons.fullscreen_rounded,
      color: kPrimaryDeepIndigo,
      formulas: [
        '107639 Bargofut/Square feet = 1 Hector or 100 Ayer',
        '1076.39 Bargofut/Square feet = 1 Ayer',
      ],
    ),
    FormulaSection(
      category: 'hectare',
      titleEn: 'Formula of Square Yard/Bargogaz, Ayer and Hector',
      titleBn: 'বর্গগজ, এয়র ও হেক্টরের সূত্র',
      icon: Icons.select_all_rounded,
      color: kSecondarySunsetOrange,
      formulas: [
        '11959.882 Gaz/Yard = 1 Hector or 100 Ayer',
        '119.59882 Gaz/Yard = 1 Ayer',
      ],
    ),
    FormulaSection(
      category: 'hectare',
      titleEn: 'Formula of Bigha, Kattah, Ayer and Hector',
      titleBn: 'বিঘা, কাঠা, এয়র ও হেক্টরের সূত্র',
      icon: Icons.auto_awesome_mosaic_rounded,
      color: Colors.purple,
      formulas: [
        '7.47494 Bigha = 1 Hector or 100 Ayer',
        '0.0747494 Bigha = 1 Ayer',
      ],
    ),
    FormulaSection(
      category: 'bigha',
      titleEn: 'More Measurement Units',
      titleBn: 'অতিরিক্ত পরিমাপ এককসমূহ',
      icon: Icons.menu_book_rounded,
      color: Colors.green,
      formulas: [
        '1 Kattah = 1.65 Shotangsho (approx)',
        '1 Kattah = 165 Ojutangsho (approx)',
        '1 Bigha = 33 Shotangsho',
      ],
    ),
  ];

  @override
  State<LandFormulasPage> createState() => _LandFormulasPageState();
}

class _LandFormulasPageState extends State<LandFormulasPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _selectedCategory = 'all';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<FormulaSection> get _filteredSections {
    final query = _searchCtrl.text.trim().toLowerCase();
    return LandFormulasPage.allFormulaSections.where((sec) {
      final matchesCat =
          _selectedCategory == 'all' || sec.category == _selectedCategory;
      if (!matchesCat) return false;
      if (query.isEmpty) return true;
      final inTitle = sec.titleEn.toLowerCase().contains(query) ||
          sec.titleBn.toLowerCase().contains(query);
      final inFormulas =
          sec.formulas.any((f) => f.toLowerCase().contains(query));
      return inTitle || inFormulas;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, _, _) {
        final theme = Theme.of(context);
        final sections = _filteredSections;

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
              tr(
                'বাংলাদেশ ভূমি পরিমাপের আদর্শ এককসমূহ',
                'Bangladesh Land Measurement Formulas',
              ),
            ),
          ),
          body: Column(
            children: [
              // Search & Topic Filter Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchCtrl,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: tr(
                          'সূত্র খুঁজুন (যেমন: Kani, Bigha, Chain, Hector, Renu)...',
                          'Search formulas (e.g. Kani, Bigha, Chain, Hector, Renu)...',
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
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildTopicChip(
                            'all',
                            tr('সব সূত্রাবলী', 'All Formulas'),
                          ),
                          _buildTopicChip(
                            'bigha',
                            tr('বিঘা, কাঠা ও শতক', 'Bigha, Katha & Decimal'),
                          ),
                          _buildTopicChip(
                            'kani',
                            tr('কানি, গণ্ডা ও ৮ হাত নল', 'Kani, Gonda & Nol'),
                          ),
                          _buildTopicChip(
                            'acre',
                            tr('একর, চেইন ও লিংক', 'Acre, Chain & Link'),
                          ),
                          _buildTopicChip(
                            'hectare',
                            tr('হেক্টর ও এয়র', 'Hectare & Ayer'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Formula Sections List
              Expanded(
                child: sections.isEmpty
                    ? Center(
                        child: Text(
                          tr(
                            'কোনো সূত্র পাওয়া যায়নি।',
                            'No matching formulas found.',
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount: sections.length,
                        itemBuilder: (context, index) {
                          final sec = sections[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: BorderSide(
                                color: sec.color.withValues(alpha: 0.25),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor:
                                            sec.color.withValues(alpha: 0.14),
                                      child: Icon(
                                        sec.icon,
                                        color: sec.color,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tr(sec.titleBn, sec.titleEn),
                                            style: const TextStyle(
                                              fontSize: 15.5,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            tr(sec.titleEn, sec.titleBn),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: theme.colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Divider(height: 1),
                                const SizedBox(height: 10),
                                ...sec.formulas.map((line) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.check_circle_outline_rounded,
                                          size: 16,
                                          color: sec.color,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: SelectableText(
                                            line,
                                            style: const TextStyle(
                                              fontSize: 13.8,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopicChip(String catKey, String label) {
    final isSelected = _selectedCategory == catKey;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() => _selectedCategory = catKey);
        },
      ),
    );
  }
}
