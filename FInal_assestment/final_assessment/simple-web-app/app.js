// app.js
const express = require('express');
const app = express();
const port = 4000;

app.get('/', (req, res) => {
  res.send('Hello, this is my website');
});

app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});
