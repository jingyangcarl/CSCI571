const express = require("express");
const googleTrends = require("google-trends-api");
const router = express.Router();

router.get('/:keyword', (req, res, next) => {
    googleTrends.interestOverTime({keyword: req.params.keyword})
    .then(results => {
        res.send(results)
    })
    .catch((error) => {
        console.log(error)
    })
});

module.exports = router;