import mysql from "mysql2";
import dotenv from "dotenv";
dotenv.config()

// //CONNECTS TO THE DATABASE
const pool = mysql.createPool({
    host: process.env.MYSQL_HOST,
    user: process.env.MYSQL_USER,
    password: process.env.MYSQL_PASSWORD,
    database: process.env.MYSQL_DATABASE
}).promise();

export async function getData() {
    const [rows] = await pool.query(`SELECT * FROM tracker`);
    return rows;
}

export async function getSingleValue(id) {
    const [rows] = await pool.query(`
        SELECT * 
        FROM tracker
        WHERE idtracker = ?
        `, [id]);
    return rows[0];
}

export async function removeData() {
    await pool.query(`DELETE FROM tracker`);
    await pool.query('ALTER TABLE tracker AUTO_INCREMENT = 1');
}

export async function createEntry(salary_num, income, expenses, category, types) {
    const [result] = await pool.query(`
        INSERT INTO tracker (salary_num, income, expenses, category, types)
        VALUES (?, ?, ?, ?, ?)
        `, [salary_num, income, expenses, category, types]);
    return result;
}

// const trackers = await getData();
// console.log(trackers);

// const tracker = await getSingleValue(1);
// console.log(tracker);

// const result = await createEntry(1, 100, 30, "Housing", "Rent");
// console.log(result);

// module.exports = pool.promise();