# Finance Tracker Flutter App - Final Project

A simple finance tracking application built with Flutter.
- Files for the app are under finance_flutter/lib/.
- Files for the API logic in charge of communicating with the database are under the API folder.
- The database folder with the queries creates the table and has two generic INSERTs to try the database connection.
- A Python project is doing the same, but it was not continued as tkinter is not as good as Dart for displaying UIs (under finance_tracker_python_not_using).

## Features
- Track income and expenses.
- Categorize transactions.
- View current records.
- Delete records from the UI & Database.
- Separate income slots for each of the months.
- Ability to insert more income if needed.
- Ability to add a category if not displayed already.
- Block income after the first record entry.

## Future Fixes
- Edit the button for the income slot to change the income if it is entered incorrectly.
- Edit button to change Salary slot names.
- Button to remove Salary Slots.
- Create different tables for each of the salaries.
- The project only connects to Dart when running in Chrome or when an IP address and port number are used. It does not work with the #1 macOS version as it does not assign a port or IP address.

## UML Diagram

```mermaid
erDiagram
    finance_tracker {
        string name "Finance Tracker Database"
    }

    finance_tracker ||--o| tracker : has_table

    tracker {
        int idtracker PK AI "ID"
        INT salary_num NN "Salary Number"
        INT income NN"Income"
        INT expenses NN "Expenses"
        string category VARCHAR(45) "Category"
        string types VARCHAR(45) "Types"
    }

```
