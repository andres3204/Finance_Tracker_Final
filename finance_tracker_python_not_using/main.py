import tkinter as tk
from tkinter import messagebox
from tkinter import simpledialog
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

    @classmethod
    def empty(cls):
        return cls(income=0.0, expenses=0.0, category=0, record_type='', date=datetime.now(), income_range=0)

    @property
    def remaining(self):
        return self.income - self.expenses

    def to_json(self):
        return {
            'income': self.income,
            'expenses': self.expenses,
            'category': self.category,
            'type': self.type,
            'date': self.date.isoformat(),  # Convert datetime to ISO string
            'incomeRange': self.income_range
        }

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

class FinanceTrackerApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Finance Tracker")
        self.root.geometry("600x700")

        self.records = []
        self.salary_slot_incomes = {i: 0.0 for i in range(10)}
        self.selected_category = None
        self.categories = ['Housing', 'Transport', 'Food', 'Utilities', 'Investments', 'Savings', 'Gifts', 'Work', 'Personal Caring', 'Entertainment']

        self.selected_salary_slot = 0

        self.setup_ui()

    def setup_ui(self):
        # Menu bar
        menubar = tk.Menu(self.root)

        # File menu
        file_menu = tk.Menu(menubar, tearoff=0)
        file_menu.add_command(label="Exit", command=self.root.quit)
        menubar.add_cascade(label="File", menu=file_menu)

        # Edit menu
        edit_menu = tk.Menu(menubar, tearoff=0)
        edit_menu.add_command(label="Clear All", command=self.clear_all)
        edit_menu.add_command(label="Save Data", command=self.save_data)
        edit_menu.add_command(label="Load Data", command=self.load_data)
        menubar.add_cascade(label="Edit", menu=edit_menu)

        self.root.config(menu=menubar)
        padx_value = 10  # Horizontal padding for all widgets
        pady_value = 5   # Vertical padding for all widgets

        # Adding the income, expenses, category, and other fields as before
        self.income_label = tk.Label(self.root, text="Income")
        self.income_label.grid(row=0, column=0, padx=padx_value, pady=pady_value)
        self.income_entry = tk.Entry(self.root)
        self.income_entry.grid(row=0, column=1, padx=padx_value, pady=pady_value)

        self.expenses_label = tk.Label(self.root, text="Expenses")
        self.expenses_label.grid(row=1, column=0, padx=padx_value, pady=pady_value)
        self.expenses_entry = tk.Entry(self.root)
        self.expenses_entry.grid(row=1, column=1, padx=padx_value, pady=pady_value)

        self.category_label = tk.Label(self.root, text="Category")
        self.category_label.grid(row=2, column=0, padx=padx_value, pady=pady_value)
        self.category_var = tk.StringVar()
        self.category_menu = tk.OptionMenu(self.root, self.category_var, *self.categories)
        self.category_menu.grid(row=2, column=1, padx=padx_value, pady=pady_value)

        self.type_label = tk.Label(self.root, text="Type (e.g., Salary, Groceries)")
        self.type_label.grid(row=3, column=0, padx=padx_value, pady=pady_value)
        self.type_entry = tk.Entry(self.root)
        self.type_entry.grid(row=3, column=1, padx=padx_value, pady=pady_value)

        self.save_button = tk.Button(self.root, text="Save Record", command=self.save_record)
        self.save_button.grid(row=4, column=0, columnspan=2, padx=padx_value, pady=pady_value)

        self.add_category_button = tk.Button(self.root, text="Add New Category", command=self.add_new_category)
        self.add_category_button.grid(row=5, column=0, columnspan=2, padx=padx_value, pady=pady_value)

        self.salary_slot_var = tk.StringVar()
        self.salary_slot_var.set("Salary 1")  # Default selection

        self.salary_slot_menu = tk.OptionMenu(self.root, self.salary_slot_var, *[f"Salary {i+1}" for i in self.salary_slot_incomes])
        self.salary_slot_menu.grid(row=6, column=0, padx=10, pady=5)

        self.salary_slot_button = tk.Button(self.root, text="Add Salary Slot", command=self.add_new_salary_slot)
        self.salary_slot_button.grid(row=6, column=1, columnspan=2, padx=padx_value, pady=pady_value)

        self.records_label = tk.Label(self.root, text="All Records")
        self.records_label.grid(row=7, column=0, columnspan=2, padx=padx_value, pady=pady_value)

        self.records_listbox = tk.Listbox(self.root, height=20, width=60)
        self.records_listbox.grid(row=8, column=0, columnspan=2, padx=padx_value, pady=pady_value)

        # Adding the "Save Data" button
        self.save_data_button = tk.Button(self.root, text="Save Data", command=self.save_data)
        self.save_data_button.grid(row=9, column=0, padx=padx_value, pady=pady_value)

        # Adding the "Load Data" button
        self.load_data_button = tk.Button(self.root, text="Load Data", command=self.load_data)
        self.load_data_button.grid(row=9, column=1, padx=padx_value, pady=pady_value)

        #self.load_data()

    def save_record(self):
        try:
            income = float(self.income_entry.get())
            expenses = float(self.expenses_entry.get())
            category = self.category_var.get()
            record_type = self.type_entry.get()
        except ValueError:
            messagebox.showerror("Invalid Input", "Please enter valid numbers for income and expenses.")
            return

        if not category or not record_type:
            messagebox.showerror("Missing Data", "Please fill all fields.")
            return
        
        # Find records in the same salary slot
        slot_records = [r for r in self.records if r.income_range == self.selected_salary_slot]

        if not slot_records:
            # First record — save initial income and lock income entry
            self.salary_slot_incomes[self.selected_salary_slot] = income
            self.income_entry.config(state='disabled')
            remaining = income  # For the first record, remaining is just the income
        else:
            # Subsequent records — use the previous record's remaining balance
            previous_record = slot_records[-1]
            remaining = previous_record.remaining - expenses  # Corrected line

        # Ensure that remaining does not go below zero
        if remaining < 0:
            messagebox.showwarning("Overspending", "Oops, you are spending more than you are supposed to.")
            return

        # Add the new record
        new_record = FinanceRecord(income, expenses, self.categories.index(category), record_type, datetime.now(), self.selected_salary_slot)
        self.records.append(new_record)

        # Update the listbox with new records
        self.update_record_listbox()

        # Show success message
        messagebox.showinfo("Success", "Record saved successfully!")

    def add_new_category(self):
        new_category = simpledialog.askstring("Add New Category", "Enter category name:")
        if new_category:
            self.categories.append(new_category)
            self.category_menu['menu'].add_command(label=new_category, command=tk._setit(self.category_var, new_category))

    def add_new_salary_slot(self):
        new_slot = len(self.salary_slot_incomes)
        self.salary_slot_incomes[new_slot] = 0.0

        # Update the OptionMenu with the new slot
        menu = self.salary_slot_menu['menu']
        menu.delete(0, 'end')  # Clear current menu items

        for i in self.salary_slot_incomes:
            label = f"Salary {i + 1}"
            menu.add_command(label=label, command=tk._setit(self.salary_slot_var, label))

        # Set the newly added slot as the current selection
        self.salary_slot_var.set(f"Salary {new_slot + 1}")

        messagebox.showinfo("New Salary Slot", f"New salary slot added: Salary {new_slot + 1}")

    def load_data(self):
        try:
            with open('finance_records.json', 'r') as f:
                records_json = json.load(f)
                self.records = [FinanceRecord.from_json(record) for record in records_json]
                self.update_record_listbox()
            messagebox.showinfo("Success", "Data loaded successfully!")
        except FileNotFoundError:
            messagebox.showerror("Error", "No saved data found.")

    def save_data(self):
        records_json = [record.to_json() for record in self.records]
        with open('finance_records.json', 'w') as f:
            json.dump(records_json, f)
        messagebox.showinfo("Success", "Data saved successfully!")

    def update_record_listbox(self):
        self.records_listbox.delete(0, tk.END)
        for record in self.records:
            self.records_listbox.insert(tk.END, f"Income: ${record.income} | Expenses: ${record.expenses} | Remaining: ${record.remaining} | Category: {self.categories[record.category]}")

    def clear_all(self):
        if messagebox.askyesno("Confirm", "Are you sure you want to clear all records?"):
            self.records.clear()
            self.records_listbox.delete(0, tk.END)
            messagebox.showinfo("Cleared", "All records have been cleared.")

if __name__ == "__main__":
    root = tk.Tk()
    app = FinanceTrackerApp(root)
    root.mainloop()
