const express = require('express');
const request = require('request');
const router = express.Router();

/* GET keyword page. */

const YOUR_API_KEY_NYTIMES = 'XAQbcrr9huEK61HoDxNqaBv02zvOrFkZ';
const YOUR_API_KEY_GUARDIAN = '70e39bf2-86c6-4c5f-a252-ab34d91a4946';

router.post('/:keyword', function (req, res, next) {

  if (req.body.source == 'nytimes') {
    const url = 'https://api.nytimes.com/svc/search/v2/articlesearch.json?q=' + req.params.keyword + '&api-key=' + YOUR_API_KEY_NYTIMES;
    console.log(url);
    request(url, function (error, response, body) {
      res.send(body);
    });
  } else if (req.body.source == 'guardian') {
    const url = 'https://content.guardianapis.com/search?q=' + req.params.keyword + '&api-key=' + YOUR_API_KEY_GUARDIAN + '&show-blocks=all';
    console.log(url);
    request(url, function (error, response, body) {
      res.send(body);
    })
  } else {

  }

});

module.exports = router;