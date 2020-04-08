const express = require('express');
const request = require('request');
const fs = require('fs');
const router = express.Router();

const YOUR_API_KEY = 'XAQbcrr9huEK61HoDxNqaBv02zvOrFkZ';

/* GET home page. */
router.get('/', function(req, res, next) {
    // use dynamic data for test
    const url = 'https://api.nytimes.com/svc/topstories/v2/home.json?api-key=' + YOUR_API_KEY;
    request(url, function (error, response, body) {
        res.send(body);
    });
});

router.get('/static/', function(req, res, next) {
    // use static data for design
    const data = fs.readFileSync('D:/Project/CSCI571/Homework8/client/src/Components/home/home.json', 'utf8');
    res.send(data);
})

router.post('/detail', function(req, res, next) {
    // request for detailed news
    const url = 'https://api.nytimes.com/svc/search/v2/articlesearch.json?fq=web_url:("' + req.body.url + '")&api-key=' + YOUR_API_KEY;
    console.log(url);
    request(url, function (error, response, body) {
        res.send(body);
    })
});

router.post('/detail/static', function(req, res, next) {
    const data = fs.readFileSync('D:/Project/CSCI571/Homework8/client/src/Components/home/homeDetail.json', 'utf8');
    res.send(data);
})

module.exports = router;