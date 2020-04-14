const express = require('express');
const request = require('request');
const fs = require('fs');
const router = express.Router();

const YOUR_API_KEY_NYTIMES = 'XAQbcrr9huEK61HoDxNqaBv02zvOrFkZ';
const YOUR_API_KEY_GUARDIAN = '70e39bf2-86c6-4c5f-a252-ab34d91a4946';

/* GET home page. */
router.post('/', function(req, res, next) {
    // use dynamic data for test
    console.log(req.body.source)
    const url_nytimes = 'https://api.nytimes.com/svc/topstories/v2/home.json?api-key=' + YOUR_API_KEY_NYTIMES;
    const url_guardian = 'https://content.guardianapis.com/search?api-key=' + YOUR_API_KEY_GUARDIAN + '&section=(sport|business|technology|politics)&show-blocks=all'
    request((req.body.source == 'guardian' ? url_guardian : url_nytimes), function (error, response, body) {
        res.send(body);
    });
});

router.post('/static/', function(req, res, next) {
    // use static data for design
    const data = fs.readFileSync('D:/Project/CSCI571/Homework8/client/src/Components/home/home.json', 'utf8');
    res.send(data);
})

router.post('/detail', function(req, res, next) {
    // request for detailed news
    const url = 'https://api.nytimes.com/svc/search/v2/articlesearch.json?fq=web_url:("' + req.body.url + '")&api-key=' + YOUR_API_KEY_NYTIMES;
    request(url, function (error, response, body) {
        res.send(body);
    })
});

router.post('/detail/static', function(req, res, next) {
    const data = fs.readFileSync('D:/Project/CSCI571/Homework8/client/src/Components/home/homeDetail.json', 'utf8');
    res.send(data);
})

module.exports = router;