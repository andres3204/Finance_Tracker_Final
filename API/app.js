// app.js
// Apr 26, 2025
// Andres Jimenez
// Imports logic from db.js and creates the get, post, and delete request to handle requests and responses with the database. 
// Uses port 8080 and link is under /tracker for easy access and easy to understand.

import express from 'express'
import cors from 'cors'
import { getData, getSingleValue, createEntry, removeData } from './db.js'

const app = express();
app.use(cors());
app.use(express.json());

app.get("/tracker", async (req, res, next) => {
    try {
        const notes = await getData();
        res.send(notes);   // Use res.json instead of res.send for object/array
    } catch (err) {
        console.error(err);
        next(err);  // Pass to Express error handler
    }
});

app.get("/tracker/:idtracker", async (req, res) => {
    try {
        const id = req.params.idtracker;
        const note = await getSingleValue(id);  // Assuming you have a function to get the data
        res.json(note);  // Use res.json to send a JSON response
    } catch (err) {
        console.error(err);
        res.status(500).send("Something went wrong!");
    }
});

app.post("/tracker", async (req, res) => {
    const { salary_num, income, expenses, category, types } = req.body;
    const track = await createEntry(salary_num, income, expenses, category, types);
    res.status(201).send(track);
});

app.delete('/tracker', async (req, res) => {
    try {
        await removeData();
        res.status(200).send('All tracker entries deleted');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error deleting tracker entries');
    }
});

app.use((err, req, res, next) => {
    console.error(err.stack)
    res.status(500).send('Something broke!');
});

app.listen(8080, () => {
    console.log('Server is running on port 8080');
}).on('error', (err) => {
    console.error("Error starting the server: ", err);
});
