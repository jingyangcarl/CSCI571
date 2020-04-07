const express = require('express');
const router = express.Router();

/* GET world page. */
router.get('/', function(req, res, next) {
    console.log("here")
    res.send('world');
});

module.exports = router;