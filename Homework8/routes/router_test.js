const express = require('express');
const router = express.Router();

/* GET test page. */
router.get('/:key', function(req, res, next) {
  console.log(req.params.key);
  const test = [
    {id: 1, firstName: 'John', lastName: 'Doe'},
    {id: 2, firstName: 'Brad', lastName: 'Traversy'},
    {id: 3, firstName: 'Mary', lastName: 'Swanson'},
  ];

  res.json(test);
});

module.exports = router;