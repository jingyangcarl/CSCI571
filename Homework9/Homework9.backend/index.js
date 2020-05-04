const express = require('express');

const app = express();

const routerTrending = require("./router/trending");

app.use(express.json());

app.use("/trending", routerTrending);

const port = 5000;
var listener = app.listen(port, function() {
    console.log("Listening on port " + listener.address().port);
});