var path     = require('path');
var express  = require('express');
var http      = require('http');
var webpack   = require('webpack');
var config    = require('./webpack.config');
var app       = express();
var compiler  = webpack(config);
var host      = 'localhost';
var port      = process.env.APP_PORT || 9000;
var basePath  = process.env.CONFIG_BASEPATH || '';
var hash      = process.env.CONFIG_HASH || '0';

hash = !!+hash;

console.log('Staring dev server');
console.log('hash', hash);
console.log('basePath', basePath);

var appConfig = {
	basePath: basePath,
	hash: hash,
}

app.use(require('webpack-dev-middleware')(compiler, {
	// contentBase: 'src',
	noInfo: true,
	publicPath: config.output.publicPath,
	inline: true,
	stats: { colors: true },
}))

// app.set('view engine', 'mustache')
app.set('view engine', 'ejs');

function respondWithIndex(req, res) {
	// res.sendFile(path.join(__dirname, 'public/index.html'));
	res.render('index.ejs', { config: appConfig});
}

if (basePath === '') {
	app.get('/', respondWithIndex);
	app.get('/*', respondWithIndex);
} else {
	if (basePath[0] !== "/") throw new Error("Expect basePath to start with /")

	app.get(basePath, respondWithIndex);
	app.get(basePath + '/*', respondWithIndex);

	// When hitting / redirect to basePath
	app.get('/', function(req, res) {
		res.redirect(basePath);
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
