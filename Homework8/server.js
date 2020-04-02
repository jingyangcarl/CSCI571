const express = require('express');

const routerHome = require('./routes/router_home');
const routerWorld = require('./routes/router_world');
const routerTest = require('./routes/router_test');

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.use("/", routerHome);
app.use("/home", routerHome);
app.use("/world", routerWorld);
app.use("/test", routerTest);

const port = 5000;
var listener = app.listen(port, function() {
  console.log("Listening on port " + listener.address().port);
});