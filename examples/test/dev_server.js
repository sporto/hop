var path     = require('path');
var express  = require('express');
var http     = require('http');
var webpack  = require('webpack');
var config   = require('./webpack.config');
var app      = express();
var compiler = webpack(config);
var host     = 'localhost';
var port     = 9000;
var hash     = process.env.CONFIG_HASH || false;
var basePath = process.env.CONFIG_BASEPATH || '';

app.use(require('webpack-dev-middleware')(compiler, {
	// contentBase: 'src',
	noInfo: true,
	publicPath: config.output.publicPath,
	inline: true,
	stats: { colors: true },
}))

function respondWithIndex(req, res) {
	res.sendFile(path.join(__dirname, 'public/index.html'));
}

app.get('/' + basePath, respondWithIndex);

if (basePath === '') {
	app.get('/*', respondWithIndex);
} else {
	app.get('/' + basePath + '/*', respondWithIndex);

	// When hitting / redirect to basePath
	app.get('/', function(req, res) {
		res.redirect('/' + basePath);
	});
}

// Serve images
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
