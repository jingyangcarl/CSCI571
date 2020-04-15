const express = require('express');
const request = require('request');
const router = express.Router();

/* GET category page. */

const YOUR_API_KEY_NYTIMES = 'XAQbcrr9huEK61HoDxNqaBv02zvOrFkZ';
const YOUR_API_KEY_GUARDIAN = '70e39bf2-86c6-4c5f-a252-ab34d91a4946';

router.post('/:section', function(req, res, next) {

    if (req.body.source == 'nytimes') {
        const url = 'https://api.nytimes.com/svc/topstories/v2/' + req.params.section + '.json?api-key=' + YOUR_API_KEY_NYTIMES;
        request(url, function (error, response, body) {
            json_obj = JSON.parse(body);
            for (index in json_obj.results){
                json_obj.results[index].section = req.params.section;
            }
    
            res.json(json_obj);
        });
    } else if (req.body.source == 'guardian') {
        const url = 'https://content.guardianapis.com/' + req.params.section + '?api-key=' + YOUR_API_KEY_GUARDIAN + '&show-blocks=all';
        console.log(url);
        request(url, function (error, response, body) {
            res.send(body);
        })
    } else {

    }
});

module.exports = router;