const express = require('express');
const router = express.Router();

/* GET world page. */
router.get('/', function(req, res, next) {
    res.send('world');
});

module.exports = router;