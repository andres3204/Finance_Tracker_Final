class FinanceRecord {
  double income;
  double expenses;
  int category;
  String types;
  DateTime date;
  int incomeRange;
  double remaining; // Add this

  FinanceRecord({
    required this.income,
    required this.expenses,
    required this.category,
    required this.types,
    required this.date,
    required this.incomeRange,
    required this.remaining, // Add to constructor
  });

  FinanceRecord.empty()
    : income = 0.0,
      expenses = 0.0,
      category = 0,
      types = '',
      date = DateTime.now(),
      incomeRange = 0,
      remaining = 0.0;

  Map<String, dynamic> toJson() {
    return {
      'income': income,
      'expenses': expenses,
      'category': category,
      'type': types,
      'date': date.toIso8601String(),
      'incomeRange': incomeRange,
      'remaining': remaining, // Save remaining
    };
  }

  factory FinanceRecord.fromJson(Map<String, dynamic> json) {
    return FinanceRecord(
      income: json['income'],
      expenses: json['expenses'],
      category: json['category'],
      types: json['type'],
      date: DateTime.parse(json['date']),
      incomeRange: json['incomeRange'],
      remaining: json['remaining'], // Load remaining
    );
  }
}
