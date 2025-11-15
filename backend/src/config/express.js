const express = require('express');
const cors = require('cors');
const path = require('path');

module.exports = (app) => {
  app.use(cors())
  app.use(express.json())
  app.use(
    '/files',
    express.static(path.resolve(__dirname, '..', '..', 'uploads'))
  );
}
