import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final TextEditingController _inputCtrl = TextEditingController();

  // Standard land measurement units in Bangladesh (how many sq. ft per 1 unit)
  final Map<String, double> _unitToSqFt = {
    'বর্গফুট (Sq. Ft)': 1.0,
    'শতাংশ (Decimal)': 435.6,
    'কড়া (Kora)': 217.8, // 1 Kora = 0.5 Decimal
    'গণ্ডা (Ganda)': 871.2, // 1 Ganda = 4 Kora = 2 Decimal
    'কাঠা (Katha)': 720.0, // 1 Katha = 1.65 Decimal
    'বিঘা (Bigha)': 14400.0, // 1 Bigha = 33 Decimal = 20 Katha
    'একর (Acre)': 43560.0, // 1 Acre = 100 Decimal
  };

  String _selectedUnit = 'শতাংশ (Decimal)';
  double _baseSqFt = 0.0;

  // Update all calculations whenever the user changes the input
  void _calculate() {
    double inputVal = double.tryParse(_inputCtrl.text) ?? 0.0;
    setState(() {
      // First convert the user's input into square feet (base unit)
      _baseSqFt = inputVal * _unitToSqFt[_selectedUnit]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('জমি পরিমাপ ক্যালকুলেটর'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input section
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _inputCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'পরিমাণ লিখুন',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => _calculate(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: DropdownButtonFormField<String>(
                        value: _selectedUnit,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: _unitToSqFt.keys.map((unit) {
                          return DropdownMenuItem(
                            value: unit,
                            child: Text(
                              unit,
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedUnit = val!;
                            _calculate();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Result section
            Expanded(
              child: ListView(
                children: _unitToSqFt.keys.map((unit) {
                  // Convert from base square feet to other units
                  double result = _baseSqFt / _unitToSqFt[unit]!;
                  return Card(
                    color: unit == _selectedUnit
                        ? Colors.teal.shade50
                        : Colors.white,
                    child: ListTile(
                      title: Text(
                        unit,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        result.toStringAsFixed(4), // Show up to 4 decimal places
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
