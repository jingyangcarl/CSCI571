const express = require('express');
const request = require('request');
const fs = require('fs');
const router = express.Router();

const YOUR_API_KEY_NYTIMES = 'XAQbcrr9huEK61HoDxNqaBv02zvOrFkZ';
const YOUR_API_KEY_GUARDIAN = '70e39bf2-86c6-4c5f-a252-ab34d91a4946';

/* GET home page. */
router.post('/', function(req, res, next) {
    // use dynamic data for test
    const url_nytimes = 'https://api.nytimes.com/svc/topstories/v2/home.json?api-key=' + YOUR_API_KEY_NYTIMES;
    const url_guardian = 'https://content.guardianapis.com/search?api-key=' + YOUR_API_KEY_GUARDIAN + '&section=(sport|business|technology|politics)&show-blocks=all'
    request((req.body.source == 'guardian' ? url_guardian : url_nytimes), function (error, response, body) {
        res.send(body);
    });
});

router.post('/detail', function(req, res, next) {
    // request for detailed news
    const url_nytimes = 'https://api.nytimes.com/svc/search/v2/articlesearch.json?fq=web_url:("' + req.body.url + '")&api-key=' + YOUR_API_KEY_NYTIMES;
    const url_guardian = 'https://content.guardianapis.com/' + req.body.url + '?api-key=' + YOUR_API_KEY_GUARDIAN + '&show-blocks=all';
    request((req.body.source == 'guardian' ? url_guardian : url_nytimes), function (error, response, body) {
        if (req.body.source == 'guardian') {
            console.log(url_guardian);
        } else if (req.body.source == 'nytimes') {
            console.log(url_nytimes);
        }
        res.send(body);
    })
});

module.exports = router;