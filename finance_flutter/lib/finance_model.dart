class FinanceRecord {
  final double income;
  final double expenses;
  final int category; // 1-10 corresponding to categories
  final String type;

  const FinanceRecord({
    required this.income,
    required this.expenses,
    required this.category,
    required this.type,
  });

  const FinanceRecord.empty()
    : income = 0,
      expenses = 0,
      category = 0,
      type = '';

  double get net => income - expenses;

  Map<String, dynamic> toJson() => {
    'income': income,
    'expenses': expenses,
    'category': category,
    'type': type,
  };

  factory FinanceRecord.fromJson(Map<String, dynamic> json) => FinanceRecord(
    income: json['income'] as double,
    expenses: json['expenses'] as double,
    category: json['category'] as int,
    type: json['type'] as String,
  );
}
