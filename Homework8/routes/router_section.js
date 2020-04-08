const express = require('express');
const request = require('request');
const router = express.Router();

/* GET category page. */

const YOUR_API_KEY = 'XAQbcrr9huEK61HoDxNqaBv02zvOrFkZ';

router.get('/:section', function(req, res, next) {
    const url = 'https://api.nytimes.com/svc/topstories/v2/' + req.params.section + '.json?api-key=' + YOUR_API_KEY;
    request(url, function (error, response, body) {
        //
        json_obj = JSON.parse(body);
        for (index in json_obj.results){
            json_obj.results[index].section = req.params.section;
        }

        res.json(json_obj);
    })
});

module.exports = router;