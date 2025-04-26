// //CONNECTS TO THE DATABASE
// const mysql = require('mysql2');
// const dotenv = require('dotenv');
// dotenv.config();

// const pool = mysql.createPool({
//     host: process.env.DB_HOST,
//     user: process.env.DB_USER,
//     password: process.env.DB_PASSWORD,
//     database: process.env.DB_NAME
// });

// Example: MySQL2 connection
const mysql = require('mysql2/promise');
const db = await mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'password',
    database: 'finance_tracker',
});

module.exports = pool.promise();