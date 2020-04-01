const express = require('express');
const homeRouter = require('./routes/home');
const worldRouter = require('./routes/world');

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.get('/users', function(req, res, next) {
    res.send('respond with a resource');
});

app.get('/api/customers', (req, res) => {
  const customers = [
    {id: 1, firstName: 'John', lastName: 'Doe'},
    {id: 2, firstName: 'Brad', lastName: 'Traversy'},
    {id: 3, firstName: 'Mary', lastName: 'Swanson'},
  ];

  res.json(customers);
});

app.use("/home", homeRouter);
app.use("/world", worldRouter);

const port = 5000;
var listener = app.listen(port, function() {
  console.log("Listening on port " + listener.address().port);
});