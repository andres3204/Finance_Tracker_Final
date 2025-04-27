-- Local Instance 3306.session.sql
-- Apr 26, 2025
-- Andres Jimenez
-- Database and table, also has a couple of insert values to try out the database connection if needed.
CREATE DATABASE IF NOT EXISTS finance_tracker;
USE DATABASE finance_tracker;
CREATE TABLE IF NOT EXISTS tracker (
    idtracker INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    salary_num INT NOT NULL,
    income INT NOT NULL,
    expenses INT NOT NULL,
    category VARCHAR(45),
    types VARCHAR(45)
);
INSERT INTO tracker (salary_num, income, expenses, category, types)
VALUES (1, 100, 50, "Housing", "Rent"),
    (1, 100, 50, "Tranport", "Gas");
-- INSERT TABLE IF NOT EXISTS tracker;