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

app.post('/saving', (req, res) => {
    const { salary_num, income, expenses, category, type } = req.body;

    // SQL para insertar los datos en la tabla `tracker`
    const sql = `
      INSERT INTO tracker (salary_num, income, expenses, category, type)
      VALUES (?, ?, ?, ?, ?)
    `;

    db.query(sql, [salary_num, income, expenses, category, type], (err, results) => {
        if (err) {
            console.error('Error al guardar los datos:', err);
            return res.status(500).send('Error al guardar los datos');
        }
        res.status(200).send('Datos guardados correctamente en tracker');
    });
});

// Export the router as a module
module.exports = router;