const express = require('express');

const routerHome = require('./routes/router_home');
const routerSection = require('./routes/router_section');
const routerKeyword = require('./routes/router_keyword');

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.use("/", routerHome);
app.use("/home", routerHome);
app.use("/section", routerSection);
app.use("/keyword", routerKeyword);

const port = 5000;
var listener = app.listen(port, function() {
  console.log("Listening on port " + listener.address().port);
});