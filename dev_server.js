var path    = require('path')
var express = require('express')
var http    = require('http')
var webpack = require('webpack')
var config  = require('./webpack.config')

var app      = express()
var compiler = webpack(config)
var host     = 'localhost'
var port     = 4002

app.use(require('webpack-dev-middleware')(compiler, {
  noInfo: true,
  publicPath: config.output.publicPath,
}))

// app.use(require('webpack-hot-middleware')(compiler))

app.get('/', function(req, res) {
  res.sendFile(path.join(__dirname, 'public/index.html'))
})

app.use(express.static('public'));

var server = http.createServer(app)

server.listen(port, function(err) {
  if (err) {
    console.log(err)
    return
  }

  var addr = server.address()

  console.log('Listening at http://%s:%d', addr.address, addr.port)
})
