//API THAT WILL CONNECT TO THE DATABASE (DB.JS)
const express = require('express');
const router = express.Router();
const db = require('../db');

// GET usuarios
router.get('/', async (req, res) => {
    try {
        const [rows, fields] = await db.execute('SELECT * FROM usuarios');
        res.json(rows); // Return users from database
    } catch (err) {
        console.error('Error querying the database:', err);
        res.status(500).json({ error: err.message });
    }
});

app.post('/tracker', async (req, res) => {
    const { salary_num, income, expenses, category, type } = req.body;

    try {
        const result = await db.query(
            `INSERT INTO tracker (salary_num, income, expenses, category, type)
         VALUES (?, ?, ?, ?, ?)`,
            [salary_num, income, expenses, category, type]
        );

        res.status(201).json({ message: 'Tracker created', id: result.insertId });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to insert record' });
    }
});

// Export the router as a module
module.exports = router;