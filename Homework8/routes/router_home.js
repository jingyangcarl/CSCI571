var express = require('express');
var request = require('request');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {

    const YOUR_API_KEY = 'XAQbcrr9huEK61HoDxNqaBv02zvOrFkZ';
    var url = 'https://api.nytimes.com/svc/topstories/v2/home.json?api-key=' + YOUR_API_KEY;
    request(url, function (error, response, body) {
        res.send(body);
    });
});

module.exports = router;