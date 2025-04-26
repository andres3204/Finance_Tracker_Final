const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const dotenv = require('dotenv');
dotenv.config();

const app = express();

const apiRoutes = require('./routes/api_db');

app.use(cors());
app.use(bodyParser.json());

app.use('/api', apiRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running in port ${PORT}`);
});