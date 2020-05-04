const express = require("express");
const googleTrends = require("google-trends-api");
const router = express.Router();

router.get('/:keyword', (req, res, next) => {
    console.log(req.params.keyword)

    googleTrends.interestOverTime({keyword: req.params.keyword, startTime: new Date('2019-06-01')})
    .then(results => {
        res.send(results)
    })
    .catch((error) => {
        console.log(error)
    })
});

module.exports = router;