import 'package:flutter/material.dart';
import 'finance_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<void> addTrackerEntry({
    required int salaryNum,
    required double income,
    required double expenses,
    required String category,
    required String type,
  }) async {
    const url =
        'http://10.0.2.2:3000/tracker'; // use 10.0.2.2 if running on Android emulator

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'salary_num': salaryNum,
        'income': income,
        'expenses': expenses,
        'category': category,
        'type': type,
      }),
    );

    if (response.statusCode == 201) {
      print('Tracker entry added successfully!');
    } else {
      print('Failed to add tracker entry: ${response.body}');
    }
  }

  int _selectedSalarySlot = 0;
  final Map<int, double> _salarySlotIncomes = {
    for (var i = 0; i < 10; i++) i: 0.0,
  };

  String? _selectedCategory;
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

  bool _isIncomeLocked(int slot) {
    return _records.any((r) => r.incomeRange == slot);
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _expensesController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  void _saveRecord() async {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      double income = double.tryParse(_incomeController.text) ?? 0;
      double expenses = double.tryParse(_expensesController.text) ?? 0;

      // First time this salary slot is used: set the base income
      if (_records.where((r) => r.incomeRange == _selectedSalarySlot).isEmpty) {
        _salarySlotIncomes[_selectedSalarySlot] = income;
      } else {
        income = _salarySlotIncomes[_selectedSalarySlot]!;
      }

      // Get previous remaining or set it to the salary income
      double previousRemaining =
          _records
              .where((r) => r.incomeRange == _selectedSalarySlot)
              .lastOrNull
              ?.remaining ??
          income;

      double remaining = previousRemaining - expenses;

      // Warn if overspending
      if (remaining < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Oops, you are spending more than you are supposed to.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return; // Stop saving
      }

      setState(() {
        _currentRecord = FinanceRecord(
          income: income,
          expenses: expenses,
          remaining: remaining,
          category: _categories.indexOf(_selectedCategory!),
          type: _typeController.text,
          date: DateTime.now(),
          incomeRange: _selectedSalarySlot,
        );
        _records.add(_currentRecord);
      });

      // 🧩 ADD THIS: API call to save the record
      await addTrackerEntry(
        salaryNum: _selectedSalarySlot,
        income: income,
        expenses: expenses,
        category: _selectedCategory!,
        type: _typeController.text,
      );

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

  void _addNewCategory() {
    TextEditingController newCategoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Category'),
          content: TextField(
            controller: newCategoryController,
            decoration: const InputDecoration(hintText: 'Enter category'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (newCategoryController.text.isNotEmpty) {
                  setState(() {
                    _categories.add(newCategoryController.text);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _addNewSalarySlot() {
    setState(() {
      int newSlot = _salarySlotIncomes.length;
      _salarySlotIncomes[newSlot] = 0.0;
    });
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
                const Text(
                  'Select Salary Slot:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children:
                      _salarySlotIncomes.keys.map((slot) {
                        return ChoiceChip(
                          label: Text('Salary ${slot + 1}'),
                          selected: _selectedSalarySlot == slot,
                          onSelected: (_) {
                            setState(() {
                              _selectedSalarySlot = slot;
                              _incomeController.text =
                                  _salarySlotIncomes[slot]?.toStringAsFixed(
                                    2,
                                  ) ??
                                  '';
                            });
                          },
                        );
                      }).toList(),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: _addNewSalarySlot,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Salary Slot'),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _incomeController,
                  decoration: const InputDecoration(
                    labelText: 'Income',
                    border: OutlineInputBorder(),
                  ),
                  enabled:
                      !_isIncomeLocked(
                        _selectedSalarySlot,
                      ), // <-- Disable if locked
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

                const Text(
                  'Select Category:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  hint: const Text('Select a Category'),
                  items:
                      _categories
                          .map(
                            (category) => DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

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

                Center(
                  child: ElevatedButton(
                    onPressed: _saveRecord,
                    child: const Text('Save Record'),
                  ),
                ),
                const SizedBox(height: 16),

                Center(
                  child: ElevatedButton(
                    onPressed: _addNewCategory,
                    child: const Text('Add New Category'),
                  ),
                ),
                const SizedBox(height: 16),

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
                        const Text(
                          'Salary Slot Incomes:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              _salarySlotIncomes.entries.map((entry) {
                                return Text(
                                  'Salary ${entry.key + 1}: \$${entry.value.toStringAsFixed(2)}',
                                );
                              }).toList(),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Income: \$${_currentRecord.income.toStringAsFixed(2)}',
                        ),
                        Text(
                          'Expenses: \$${_currentRecord.expenses.toStringAsFixed(2)}',
                        ),
                        Text('Category: ${_currentRecord.category}'),
                        Text('Type: ${_currentRecord.type}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

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
                                  '${record.category} - ${record.type}',
                                ),
                                trailing: Text(
                                  'Remaining: \$${record.remaining.toStringAsFixed(2)}',
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

extension ListExtension<T> on List<T> {
  T? get lastOrNull => isNotEmpty ? last : null;
}
