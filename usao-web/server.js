const path = require('path');
const express = require('express');
const app = express();

// Serve static files
app.use(express.static(__dirname + '/dist/usao-web'));

// Send all requests to index.html
app.get('/*', (req, res) => 
     res.sendFile('index.html', {root: 'dist/usao-web/'}), 
 ); 
  
 // Start the app by listening on the default Heroku port 
 app.listen(process.env.PORT || 8080);