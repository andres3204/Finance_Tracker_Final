// finance_model.dart
// Apr 26, 2025
// Andres Jimenez
// Model for the project. Specifies variables and stores data locally.
// Converts the data to JSON for saving or sending it to the server.
// Loads data from JSON into usable objects for the app.
// Stores the remaining income after expenses are deducted, which helps in tracking how much is left from the income.

class FinanceRecord {
  double income;
  double expenses;
  int category;
  String types;
  int incomeRange;
  double remaining;

  FinanceRecord({
    required this.income,
    required this.expenses,
    required this.category,
    required this.types,
    required this.incomeRange,
    required this.remaining,
  });

  FinanceRecord.empty()
    : income = 0.0,
      expenses = 0.0,
      category = 0,
      types = '',
      incomeRange = 0,
      remaining = 0.0;

  Map<String, dynamic> toJson() {
    return {
      'income': income,
      'expenses': expenses,
      'category': category,
      'type': types,
      'incomeRange': incomeRange,
      'remaining': remaining,
    };
  }

  factory FinanceRecord.fromJson(Map<String, dynamic> json) {
    return FinanceRecord(
      income: json['income'],
      expenses: json['expenses'],
      category: json['category'],
      types: json['type'],
      incomeRange: json['incomeRange'],
      remaining: json['remaining'],
    );
  }
}
