var path    = require('path');
var express = require('express');
var http    = require('http');
var webpack = require('webpack');
var config  = require('./webpack.config');

var app      = express();
var compiler = webpack(config);
var host     = 'localhost';
var port     = 3000;

app.use(require('webpack-dev-middleware')(compiler, {
  // contentBase: 'src',
  noInfo: true,
  publicPath: config.output.publicPath,
  inline: true,
  stats: { colors: true },
}))

app.get('/app', function(req, res) {
  res.sendFile(path.join(__dirname, 'public/index.html'));
});

app.get('/app/*', function(req, res) {
  res.sendFile(path.join(__dirname, 'public/index.html'));
});

// When hitting / redirect to app
app.get('/', function(req, res) {
  res.redirect('/app');
});

// Server images
app.use(express.static('public'));

var server = http.createServer(app);

server.listen(port, function(err) {
  if (err) {
    console.log(err);
    return;
  }

  var addr = server.address();

  console.log('Listening at http://%s:%d', addr.address, addr.port);
})
