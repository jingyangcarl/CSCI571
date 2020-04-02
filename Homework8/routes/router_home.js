const express = require('express');
const request = require('request');
const fs = require('fs');
const router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
    // use dynamic data for test
    const YOUR_API_KEY = 'XAQbcrr9huEK61HoDxNqaBv02zvOrFkZ';
    const url = 'https://api.nytimes.com/svc/topstories/v2/home.json?api-key=' + YOUR_API_KEY;
    request(url, function (error, response, body) {
        res.send(body);
    });
});

router.get('/static', function(req, res, next) {
    // use static data for design
    const data = fs.readFileSync('D:/Project/CSCI571/Homework8/client/src/Components/home/home.json', 'utf8');
    res.send(data);
})

module.exports = router;