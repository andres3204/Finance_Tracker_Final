import 'package:flutter/material.dart';
import 'finance_model.dart';

void main() {
  runApp(const FinanceTrackerApp());
}

class FinanceTrackerApp extends StatelessWidget {
  const FinanceTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FinanceTrackerScreen(),
    );
  }
}

class FinanceTrackerScreen extends StatefulWidget {
  const FinanceTrackerScreen({super.key});

  @override
  _FinanceTrackerScreenState createState() => _FinanceTrackerScreenState();
}

class _FinanceTrackerScreenState extends State<FinanceTrackerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _incomeController = TextEditingController();
  final _expensesController = TextEditingController();
  final _typeController = TextEditingController();

  int? _selectedCategory;
  FinanceRecord _currentRecord = FinanceRecord.empty();
  final List<FinanceRecord> _records = [];

  final List<String> _categories = [
    'Housing',
    'Transport',
    'Food',
    'Utilities',
    'Investments',
    'Savings',
    'Gifts',
    'Work',
    'Personal Caring',
    'Entertainment',
  ];

  @override
  void dispose() {
    _incomeController.dispose();
    _expensesController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  void _saveRecord() {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      setState(() {
        _currentRecord = FinanceRecord(
          income: double.tryParse(_incomeController.text) ?? 0,
          expenses: double.tryParse(_expensesController.text) ?? 0,
          category: _selectedCategory!,
          type: _typeController.text,
        );
        _records.add(_currentRecord);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record saved successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and select a category'),
        ),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _incomeController.clear();
    _expensesController.clear();
    _typeController.clear();
    setState(() {
      _selectedCategory = null;
      _currentRecord = FinanceRecord.empty();
    });
  }

  String _getCategoryName(int category) {
    if (category >= 1 && category <= _categories.length) {
      return _categories[category - 1];
    }
    return 'Uncategorized';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetForm,
            tooltip: 'Reset Form',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Income Input
                TextFormField(
                  controller: _incomeController,
                  decoration: const InputDecoration(
                    labelText: 'Income',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter income amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Expenses Input
                TextFormField(
                  controller: _expensesController,
                  decoration: const InputDecoration(
                    labelText: 'Expenses',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter expenses amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Category Selection
                const Text(
                  'Select Category:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children:
                      List<Widget>.generate(_categories.length, (int index) {
                        return ChoiceChip(
                          label: _categories[index],
                          selected: _selectedCategory == index + 1,
                          onSelected: (bool selected) {
                            setState(() {
                              _selectedCategory = selected ? index + 1 : null;
                            });
                          },
                        );
                      }).toList(),
                ),
                const SizedBox(height: 16),

                // Type Input
                TextFormField(
                  controller: _typeController,
                  decoration: const InputDecoration(
                    labelText: 'Type (e.g., Salary, Groceries)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Save Button
                Center(
                  child: ElevatedButton(
                    onPressed: _saveRecord,
                    child: const Text('Save Record'),
                  ),
                ),
                const SizedBox(height: 24),

                // Current Record Display
                const Text(
                  'Current Record:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Income: \$${_currentRecord.income.toStringAsFixed(2)}',
                        ),
                        Text(
                          'Expenses: \$${_currentRecord.expenses.toStringAsFixed(2)}',
                        ),
                        Text(
                          'Category: ${_getCategoryName(_currentRecord.category)}',
                        ),
                        Text('Type: ${_currentRecord.type}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // All Records List
                const Text(
                  'All Records:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _records.isEmpty
                    ? const Text('No records yet')
                    : Column(
                      children:
                          _records.reversed.map((record) {
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                title: Text(
                                  '\$${record.income.toStringAsFixed(2)} Income / \$${record.expenses.toStringAsFixed(2)} Expenses',
                                ),
                                subtitle: Text(
                                  '${_getCategoryName(record.category)} - ${record.type}',
                                ),
                                trailing: Text(
                                  'Net: \$${(record.income - record.expenses).toStringAsFixed(2)}',
                                ),
                              ),
                            );
                          }).toList(),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const ChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(
        color: selected ? Theme.of(context).primaryColor : Colors.black,
      ),
    );
  }
}
