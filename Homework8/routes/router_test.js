const express = require('express');
const router = express.Router();

/* GET world page. */
router.get('/', function(req, res, next) {
  const customers = [
    {id: 1, firstName: 'John', lastName: 'Doe'},
    {id: 2, firstName: 'Brad', lastName: 'Traversy'},
    {id: 3, firstName: 'Mary', lastName: 'Swanson'},
  ];

  res.json(customers);
});

module.exports = router;