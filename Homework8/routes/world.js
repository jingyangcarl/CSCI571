var express = require('express');
var router = express.Router();

/* GET world page. */
router.get('/', function(req, res, next) {
    res.send('world');
});

module.exports = router;