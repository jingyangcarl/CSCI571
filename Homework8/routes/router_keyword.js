const express = require('express');
const request = require('request');
const router = express.Router();

/* GET keyword page. */

const YOUR_API_KEY = 'XAQbcrr9huEK61HoDxNqaBv02zvOrFkZ';

router.get('/:keyword', function (req, res, next) {
  const url = 'https://api.nytimes.com/svc/search/v2/articlesearch.json?q=' + req.params.keyword + '&api-key=' + YOUR_API_KEY;
  request(url, function (error, response, body) {
    res.send(body);
  });
});

module.exports = router;