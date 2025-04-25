class FinanceRecord {
  double income;
  double expenses;
  int category; // Index of the category
  String type;
  DateTime date;
  int incomeRange; // Salary slot

  FinanceRecord({
    required this.income,
    required this.expenses,
    required this.category,
    required this.type,
    required this.date,
    required this.incomeRange,
  });

  // Empty constructor for initializing an empty record
  FinanceRecord.empty()
    : income = 0.0,
      expenses = 0.0,
      category = 0,
      type = '',
      date = DateTime.now(),
      incomeRange = 0;

  // Getter for remaining income after expenses
  double get remaining => income - expenses;

  // Convert FinanceRecord to JSON
  Map<String, dynamic> toJson() {
    return {
      'income': income,
      'expenses': expenses,
      'category': category,
      'type': type,
      'date': date.toIso8601String(), // Convert DateTime to ISO string
      'incomeRange': incomeRange,
    };
  }

  // Convert JSON to FinanceRecord
  factory FinanceRecord.fromJson(Map<String, dynamic> json) {
    return FinanceRecord(
      income: json['income'],
      expenses: json['expenses'],
      category: json['category'],
      type: json['type'],
      date: DateTime.parse(json['date']), // Convert ISO string back to DateTime
      incomeRange: json['incomeRange'],
    );
  }
}
