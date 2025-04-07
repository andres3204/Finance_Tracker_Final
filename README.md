# Finance Tracker Flutter App - P8

A simple finance tracking application built with Flutter.

## Features
- Track income and expenses
- Categorize transactions
- View current and past records

## UML Diagram

```mermaid
classDiagram
    class FinanceRecord {
        double income
        double expenses
        int category
        String type
        FinanceRecord.empty()
        double get net
        Map<String, dynamic> toJson()
        FinanceRecord.fromJson(Map<String, dynamic> json)
    }

    class FinanceTrackerScreen {
        _formKey
        _incomeController
        _expensesController
        _typeController
        _selectedCategory
        _currentRecord
        _records
        _categories
        _saveRecord()
        _resetForm()
    }

    FinanceTrackerScreen --> FinanceRecord : Uses
```
