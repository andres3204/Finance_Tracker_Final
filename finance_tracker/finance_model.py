from datetime import datetime
import json

class FinanceRecord:
    def __init__(self, income, expenses, category, record_type, date=None, income_range=0):
        self.income = income
        self.expenses = expenses
        self.category = category  # Index of the category
        self.type = record_type  # Type of the record (e.g., Salary, Groceries)
        self.date = date if date else datetime.now()  # If no date is provided, use the current time
        self.income_range = income_range  # Salary slot

    # Empty constructor for initializing an empty record
    @classmethod
    def empty(cls):
        return cls(income=0.0, expenses=0.0, category=0, record_type='', date=datetime.now(), income_range=0)

    # Getter for remaining income after expenses
    @property
    def remaining(self):
        return self.income - self.expenses

    # Convert FinanceRecord to JSON
    def to_json(self):
        return {
            'income': self.income,
            'expenses': self.expenses,
            'category': self.category,
            'type': self.type,
            'date': self.date.isoformat(),  # Convert datetime to ISO string
            'incomeRange': self.income_range,
            'remaining': self.remaining  # Add remaining to the JSON export
        }

    # Convert JSON to FinanceRecord
    @classmethod
    def from_json(cls, json_data):
        date = datetime.fromisoformat(json_data['date'])  # Convert ISO string back to datetime
        return cls(
            income=json_data['income'],
            expenses=json_data['expenses'],
            category=json_data['category'],
            record_type=json_data['type'],
            date=date,
            income_range=json_data['incomeRange']
        )

# Example usage:
# Creating a finance record
record = FinanceRecord(income=1000.0, expenses=200.0, category=2, record_type='Salary', income_range=1)
print(record.to_json())

# Creating an empty finance record
empty_record = FinanceRecord.empty()
print(empty_record.to_json())

# Converting a dictionary (JSON-like) to a FinanceRecord
json_data = {
    'income': 1000.0,
    'expenses': 300.0,
    'category': 1,
    'type': 'Groceries',
    'date': '2025-04-25T14:30:00',
    'incomeRange': 2
}
record_from_json = FinanceRecord.from_json(json_data)
print(record_from_json.to_json())
